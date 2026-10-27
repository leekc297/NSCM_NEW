PROCEDURE PR_SCP_ANL_PSI_INTEGRATION_SMALL
(
      P_DIVISION_ID          IN VARCHAR2
    , P_PLAN_START_YYYYMMDD  IN VARCHAR2
)
/********************************************************************************************************************************************
 * Program ID   : PR_SCP_ANL_PSI_INTEGRATION_Small
 * Description  : 재료비 TASK(소형).  PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화
 * OutTable     : SCP_ANL_PSI_INTEGRATION
 * Execute      :
                  EXEC PR_SCP_ANL_PSI_INTEGRATION_Small @p_division_id         = '40'
                     , @p_plan_start_yyyymmdd = '20240923'

 * Program History
 *===========================================================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================================================
 * 2024.10.25     lgjjg        Initial. PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화.
 * 2025.02.03     kimcd        	E20250123-001112  소형 schedule 추가에 따른 로직 보완
 * 2025.02.12     hrkim        cell/전극 plant 매핑 로직 수정
 *								- 1순위 : division, company, plant 정보로 매핑
 *								- 2순위 : division, company, city, country 정보로 매핑
 *								- 3순위 : division, company 정보로 매핑
 *								- 4순위 : company 정보로 매핑
 * 2025.02.28     hrkim        PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선
 *								1. SEOWON_NJ-CELL vendor plant_id NERP 신코드로 변경 전환
 *								 - 변경전 : KR004004
 *								 - 변경후 : KR02149300
 *							    2. NJ plant NERP대응 - lookup 참조 변수 적용 (G182 -> @NJ_PLANT)
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
 * 2025.06.11	hrkim			PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *								재고 - 최종 plant 매핑 안된 데이터에 대해 Project Route 기준 매핑 로직
 * 2025.07.09	hrkim			PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *								- RTF/기초재고 외주 packer plant 매핑 로직 수정 (logistic_plant_id -> plant_id)
 *								- 기초재고 project route 기준 매핑 우선 순위 변경
 *								  (RTF에 plant 매핑 로직 적용전에 Project Route 기준 매핑 로직 적용 -> 해당 아이템의 가장 빠른 생산계획이 있는 Plant로 매핑 후)
 * 2025.08.29	YMH				CSR E20250829-001508 실행계획개선 (속도개선)
 * 2026.07.06   ZIONEX  [PJ202650304]  NextSCM Migration
 * 2026.10.27    ZIONEX      [PJ202650304] 티라엔진 제거 - SCP_PLN_SALES_ONHAND -> 통합 Dataset 기반 뷰(SCP_PLN_SALES_ONHAND_V) 교체
 ********************************************************************************************************************************************/
/* exec PR_SCP_ANL_PSI_INTEGRATION_Small '40', '20241125' */
/* exec PR_SCP_ANL_PSI_INTEGRATION_Small '40', '20240923' */
/* ============================================================================================
 *   3. ANSI 유지 1개 블록 : 1.Ship. Plan(RTF) 입력(SCP_PLN_RTF_ALLOCATION_ALL_V A 구동)
 *      - 26ai 실측 근거 : SCM_MST_SITE B 의 아우터 조인 술어가 스칼라 서브쿼리를 담은 CASE 식이라
 * ============================================================================================ */
AS
    /* LOG 용 변수 설정 */
    V_BATCH_USER   VARCHAR2(150 CHAR) := 'scp_batch';
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'PR_SCP_ANL_PSI_INTEGRATION_Small';
    V_LOG_TYPE     VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT    NUMBER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    V_TABLE_ID     VARCHAR2(150 CHAR) := 'SCP_ANL_PSI_INTEGRATION';
    D_EVENT_DATE   DATE;

    V_STATUS_DESC  VARCHAR2(1000 CHAR) := 'START';

    /* 임시 실행시간 확인용 */
    V_START_TIME   DATE;
    V_EXEC_TIME    VARCHAR2(10 CHAR) := '';  /* '00:00'; */

    /* SCP 계힉 참조를 위한 변수 */
    V_DIVISION_ID           VARCHAR2(10 CHAR)  := NVL(P_DIVISION_ID, '40');
    V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR)   := NULL;
    V_PLAN_START_DATE       DATE               := NULL;
    V_PLAN_TYPE             VARCHAR2(100 CHAR) := 'FN';
    V_PLAN_SEQ              NUMBER             := 1;
    V_HORIZON_END_YYYYMMDD  VARCHAR2(8 CHAR)   := NULL;
    V_PLAN_START_YYYYMM     VARCHAR2(6 CHAR)   := NULL;   /* 계획 구간 시작월 */
    V_MASTER_ID             VARCHAR2(100 CHAR) := NULL;
    V_ENG_PLAN_ID           VARCHAR2(100 CHAR) := NULL;

    /* 전극용 구하기 */
    V_EE_DIVISION_ID          VARCHAR2(10 CHAR)  := 'EE';
    V_EE_PLAN_START_YYYYMMDD  VARCHAR2(8 CHAR)   := NULL;
    V_EE_PLAN_TYPE            VARCHAR2(100 CHAR) := 'FN';
    V_EE_PLAN_SEQ             NUMBER             := 1;
    V_EE_MASTER_ID            VARCHAR2(100 CHAR) := NULL;
    V_EE_ENG_PLAN_ID          VARCHAR2(100 CHAR) := NULL;

    /* 2025.02.28 NJ plant NERP대응 */
    V_NJ_PLANT                VARCHAR2(50 CHAR)  := 'G182';

    /* 월_INVentory 생성용 (원본 중간흐름 DECLARE → 값 대입은 원 위치에서 수행) */
    V_MIN_YYYYMM   VARCHAR2(6 CHAR);
    V_MAX_YYYYMM   VARCHAR2(6 CHAR);
    V_PRE_YYYYMM   VARCHAR2(6 CHAR);
    V_PROC_YYYYMM  VARCHAR2(6 CHAR);
    V_PROC_YYYYMMDD VARCHAR2(8 CHAR);
    V_I            NUMBER;


    V_FILL_0_TARGET_PERIOD            NUMBER;
    V_FILL_0_TARGET_PERIOD_END_YYYYMM VARCHAR2(6 CHAR);


    V_JJGV_LOG_MESSAGE  VARCHAR2(1000 CHAR);
BEGIN


    /* ------------------------------------------------------------------------------------------------- */

    /* ------------------------------------------------------------------------------------------------- */
    DELETE FROM GT_PIS_ELEC_PLANT;
    DELETE FROM GT_PIS_CELL_ELEC_MAP;
    DELETE FROM GT_PIS_SITE_ITEM_PRIO;
    DELETE FROM GT_PIS_SITE_ITEM_PRIO_INV;
    DELETE FROM GT_PIS_YIELD_A;
    DELETE FROM GT_PIS_ITEM_BOM;
    DELETE FROM GT_PIS_MM_LIST;
    DELETE FROM GT_PIS_TARGET_MM_0;
    DELETE FROM GT_PIS_ULS_LKUP_CELL;
    DELETE FROM GT_PIS_ULS_LKUP_TCO;
    DELETE FROM GT_PIS_INV;
    DELETE FROM GT_PIS_220_240;
    DELETE FROM GT_PIS_320_340;
    DELETE FROM GT_PIS_230_ITEM;
    DELETE FROM GT_PIS_350;
    DELETE FROM GT_PIS_350_750_430;
    DELETE FROM GT_PIS_750;
    DELETE FROM GT_PIS_450;
    DELETE FROM GT_PIS_430;
    DELETE FROM GT_PIS_MAIN;
    DELETE FROM GT_PIS_650_330;
    DELETE FROM GT_PIS_GRP;
    DELETE FROM GT_PIS_GRP2;

    /* 2025.02.28 NJ plant NERP대응 (원본 SELECT @NJ_PLANT = SEGMENT2 : 0행이면 직전값 'G182' 유지) */
    BEGIN
        SELECT SEGMENT2
          INTO V_NJ_PLANT
          FROM ( SELECT SEGMENT2
                   FROM SCM_CODE_LOOKUP_VALUE
                  WHERE LOOKUP_TYPE_CODE = 'PR_SCP_ANL_PSI_INTEGRATION_Small'
                    AND SEGMENT1         = 'NJ_PLANT' )
         WHERE ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

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
    V_EXEC_TIME  := '';  /* '00:00'; */

    BEGIN
        BEGIN

            /* ------------------------------------------------------------------------------------------------- */
            /* SCP PLAN 버전 정보 (PRODUCTION) */
            /* ------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := 'Plan seq';

            BEGIN
                SELECT PLAN_SEQ, PLAN_NAME, PLAN_START_DATE, PLAN_START_YYYYMM, HORIZON_END_YYYYMMDD, MASTER_ID, ENG_PLAN_ID, PLAN_TYPE
                  INTO V_PLAN_SEQ, V_PLAN_START_YYYYMMDD, V_PLAN_START_DATE, V_PLAN_START_YYYYMM, V_HORIZON_END_YYYYMMDD, V_MASTER_ID, V_ENG_PLAN_ID, V_PLAN_TYPE
                  FROM ( SELECT D.PLAN_SEQ                                                       AS PLAN_SEQ        /* 1 */
                              , P.PLAN_NAME                                                      AS PLAN_NAME       /* 20240527 */
                              , TO_DATE(P.PLAN_NAME, 'YYYYMMDD')                                 AS PLAN_START_DATE
                              , SUBSTR(P.PLAN_NAME, 1, 6)                                        AS PLAN_START_YYYYMM     /* 202405 */
                              , SUBSTR(P.HORIZON_END_DATE, 1, 8)                                 AS HORIZON_END_YYYYMMDD  /* 20250525 */
                              , P.DIVISION_ID || '::' || P.PLAN_CYCLE                            AS MASTER_ID       /* 81::WEEKLY */
                              , P.PLAN_ID || '::' || D.PLAN_TYPE || '::' || TO_CHAR(D.PLAN_SEQ)  AS ENG_PLAN_ID     /* 1341::FN::1 */
                              , D.PLAN_TYPE                                                      AS PLAN_TYPE       /* 2025-02-03 kimcd 조회 결과로 변경. */
                           FROM SCM_MST_PLAN        P
                              , SCM_MST_PLAN_DETAIL D
                          WHERE D.DIVISION_ID  = P.DIVISION_ID
                            AND D.PLAN_ID      = P.PLAN_ID
                            /* AND D.PLAN_TYPE = V_PLAN_TYPE -- FN 2025-02-03 kimcd 조회 조건 제거 */
                            AND D.PLAN_STATUS  = '1'   /* 정상 완료 */
                            AND D.CONFIRM_FLAG = 'Y'   /* 최종 Confirm */
                            AND 1 = 1
                            AND P.DIVISION_ID = V_DIVISION_ID
                            AND P.PLAN_NAME   = P_PLAN_START_YYYYMMDD
                            AND P.PLAN_CYCLE  = 'WEEKLY'
                          ORDER BY P.PLAN_NAME DESC
                                 , CASE WHEN D.PLAN_TYPE = 'FN' THEN 1
                                        WHEN D.PLAN_TYPE = 'SE' THEN 2
                                        WHEN D.PLAN_TYPE = 'MA' THEN 3
                                        WHEN D.PLAN_TYPE = 'PR' THEN 4
                                        ELSE 5
                                        END   /* 2025-02-03 kimcd 정렬 순서 지정. 최종 계획 우선 사용 */
                                 , D.PLAN_SEQ DESC )
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
                              , SCM_MST_DIVISION B
                          WHERE B.ATTRIBUTE4 = A.ATTRIBUTE4
                            AND B.ATTRIBUTE3 = 'EE'
                            AND A.DIVISION_ID = V_DIVISION_ID )   /* '81_HM' */
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
                           FROM SCM_MST_PLAN        P
                              , SCM_MST_PLAN_DETAIL D
                          WHERE D.DIVISION_ID  = P.DIVISION_ID
                            AND D.PLAN_ID      = P.PLAN_ID
                            AND D.PLAN_TYPE    = V_PLAN_TYPE  /* FN */
                            AND D.PLAN_STATUS  = '1'   /* 정상 완료 */
                            AND D.CONFIRM_FLAG = 'Y'   /* 최종 Confirm */
                            AND 1 = 1
                            AND P.DIVISION_ID = V_EE_DIVISION_ID
                            AND P.PLAN_NAME   = P_PLAN_START_YYYYMMDD
                            AND P.PLAN_CYCLE  = 'WEEKLY'
                          ORDER BY P.PLAN_NAME DESC
                                 , D.PLAN_SEQ )
                 WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_PLAN_START_YYYYMMDD  : ' || V_PLAN_START_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_PLAN_TYPE            : ' || V_PLAN_TYPE);
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_PLAN_SEQ             : ' || TO_CHAR(V_PLAN_SEQ));
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_HORIZON_END_YYYYMMDD : ' || V_HORIZON_END_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_MASTER_ID            : ' || V_MASTER_ID);
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_ENG_PLAN_ID          : ' || V_ENG_PLAN_ID);
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_EE_DIVISION_ID       : ' || V_EE_DIVISION_ID);
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_EE_ENG_PLAN_ID       : ' || V_EE_ENG_PLAN_ID);

            /* ---------------------------------------------------------------------------------------------------------------- */
            /* 전극 plant 사이트 정보 추출 - #elec_plant */
            /* 2025.02.12 cell/전극 plant 매핑 로직 수정 (1~4순위) */
            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' 전극 plant 사이트 정보 추출 - #elec_plant');
            /* 원본: if object_id('tempdb..#elec_plant') is not null drop table #elec_plant  → 진입부 DELETE 로 대체 */
            DELETE FROM GT_PIS_ELEC_PLANT;

            INSERT INTO GT_PIS_ELEC_PLANT
            SELECT ES.COMPANY_ID
                 , ES.DIVISION_ID
                 , NVL(ES.CITY,    'Z') AS CITY
                 , NVL(ES.COUNTRY, 'Z') AS COUNTRY
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
                                                 , NVL(ES.CITY,    'Z')
                                                 , NVL(ES.COUNTRY, 'Z')
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
            /* Cell/전극 plant 매핑 - #cell_elec_plant_mapping */
            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' Cell/전극 plant 매핑 - #cell_elec_plant_mapping');
            /* 원본: if object_id('tempdb..#cell_elec_plant_mapping') is not null drop table #cell_elec_plant_mapping  → DELETE 로 대체 */
            DELETE FROM GT_PIS_CELL_ELEC_MAP;

            INSERT INTO GT_PIS_CELL_ELEC_MAP
            SELECT CS.DIVISION_ID    AS DIVISION_ID_CS
                 , CS.COMPANY_ID     AS COMPANY_ID_CS
                 , CS.PLANT_ID       AS PLANT_ID_CS
                 , ROW_NUMBER() OVER (PARTITION BY CS.DIVISION_ID
                                                 , CS.COMPANY_ID
                                                 , CS.PLANT_ID
                                          ORDER BY CS.SCM_SITE_ID) AS CELL_PLANT_PRIORITY
                 , CS.SITE_DESCRIPTION AS SITE_DESCRIPTION_CS
                 , CS.SCM_SITE_ID    AS SCM_SITE_ID_CS
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
              FROM SCM_MST_SITE       CS
                 , GT_PIS_ELEC_PLANT  E1
                 , GT_PIS_ELEC_PLANT  E2
                 , GT_PIS_ELEC_PLANT  E3
                 , GT_PIS_ELEC_PLANT  E4
             WHERE E1.ELEC_PLANT_PRIORITY_1ST(+) = 1
               AND E1.DIVISION_ID(+) = CS.DIVISION_ID
               AND E1.COMPANY_ID(+)  = CS.COMPANY_ID
               AND E1.PLANT_ID(+)    = CS.PLANT_ID
               AND E2.ELEC_PLANT_PRIORITY_2ND(+) = 1
               AND E2.DIVISION_ID(+) = CS.DIVISION_ID
               AND E2.COMPANY_ID(+)  = CS.COMPANY_ID
               AND E2.CITY(+)        = NVL(CS.CITY,    'Z')
               AND E2.COUNTRY(+)     = NVL(CS.COUNTRY, 'Z')
               AND E3.ELEC_PLANT_PRIORITY_3RD(+) = 1
               AND E3.DIVISION_ID(+) = CS.DIVISION_ID
               AND E3.COMPANY_ID(+)  = CS.COMPANY_ID
               AND E4.ELEC_PLANT_PRIORITY_4TH(+) = 1
               AND E4.COMPANY_ID(+)  = CS.COMPANY_ID
               AND 1 = 1
               AND CS.VALID_YN        = 'Y'
               AND CS.OPERATION_GROUP = 'A'   /* Cell Plant */
               AND CS.SITE_TYPE       = 'PLANT'
               AND CS.OSP_YN          = 'N';

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서 */

            /* (원본 死 임시테이블 #tmp_SCP_ANL_PSI_INTEGRATION_small_330_yield 는 주석처리 상태로 미생성) */
            /* ----------------------------------------------------------------------------------------------------------- */

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 ) */
            /* 0.MKT FCST 입력 */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '0.MKT FCST ';
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
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
                         WHEN A.OPERATION_GROUP = 'A' AND B.TCO_CELL_YN = 'Y' THEN '600'
                         WHEN A.OPERATION_GROUP = 'A' THEN '300'
                         END ) AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(A.QTY, 0)), 0) AS QTY
              FROM SCP_ANL_PSI_GLOBAL_SMALL A
                 , SCM_MST_SITE             X
                 , SCP_MST_FINAL_ITEM       B
                 , SCP_MST_FINAL_ITEM       C
             WHERE X.DIVISION_ID(+) = A.DIVISION_ID
               AND X.SCM_SITE_ID(+) = A.TO_SITE
               AND B.DIVISION_ID(+) = A.DIVISION_ID
               AND B.OPERATION_GROUP(+) = 'A'
               AND B.ITEM_ID(+) = A.ITEM_ID   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
               AND C.ITEM_ID = A.ITEM_ID
               AND C.DIVISION_ID = A.DIVISION_ID
               AND C.FLOW_ID <> 'P5000'
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'MKT_FCST'
               AND A.OPERATION_GROUP IN ('A', 'P')
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
                            WHEN A.OPERATION_GROUP = 'A' AND B.TCO_CELL_YN = 'Y' THEN '600'
                            WHEN A.OPERATION_GROUP = 'A' THEN '300'
                            END )
                    , SUBSTR(A.YYYYMMDD, 1, 6);

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 ) */
            /* 1.Ship. Plan(RTF) 입력 */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '1.Ship. Plan(RTF)  ';
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , NVL(B.COMPANY_ID, '-') AS COMPANY_ID
                 , NVL((CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
                             ELSE B.PLANT_ID
                             END ), '-') AS PLANT_ID
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
                 , (CASE WHEN (A.OPERATION_GROUP = 'P' AND C.FLOW_ID =  'P5000') THEN '210'
                         WHEN (A.OPERATION_GROUP = 'P' AND C.FLOW_ID <> 'P5000') THEN '110'
                         WHEN A.OPERATION_GROUP = 'A' AND FI.TCO_CELL_YN = 'Y' THEN '610'  /* > TCO_CELL_YN : Y : 후공정 CELL : SCP_MST_FINAL_ITEM_V */
                         WHEN A.OPERATION_GROUP = 'A' THEN '310'  /* > TCO_CELL_YN : Y : 후공정 CELL : SCP_MST_FINAL_ITEM_V */
                         END ) AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(ALLOCATION_QTY, 1)), 1) AS QTY
              /*                        콤마 + (+) 로 옮기면 B.SCM_SITE_ID(+) = (CASE ... (SELECT ...) ... END) 가 되어 */
              FROM /* SCP_PLN_RTF_ALLOCATION_V a */
                   SCP_PLN_RTF_ALLOCATION_ALL_V A /* 2025-02-03 kimcd MAIN 결과 사용 가능하도록 View all로 변경 */
              LEFT JOIN SCM_MST_SITE B
                     ON B.DIVISION_ID = A.DIVISION_ID
                    AND B.SCM_SITE_ID = (CASE WHEN (A.DELIVERY_ORDER_ID IS NULL OR A.DELIVERY_ORDER_ID < '0') THEN
                                                  (SELECT MAX(K.FROM_SITE)
                                                     FROM SCP_ANL_SHIPMENT_PLAN_FG K
                                                    WHERE K.ITEM_ID = A.FROM_ITEM_ID /* Group 에 의해 실제 제공된 Item 표시 */
                                                      AND K.PROJECT_CODE = A.PROJECT_CODE
                                                      AND K.TO_SITE = A.SALES_SITE_ID
                                                      /* and k.incoterms = a.incoterms */
                                                      AND K.INCOTERMS = A.SCP_INCOTERMS
                                                      AND K.DIVISION_ID = V_DIVISION_ID
                                                      AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                      AND K.PLAN_TYPE = V_PLAN_TYPE
                                                      AND K.SEQ = V_PLAN_SEQ
                                                      AND K.QTY <> 0
                                                      AND K.YYYYMMDD = ( SELECT MIN(M.YYYYMMDD)
                                                                           FROM SCP_ANL_SHIPMENT_PLAN_FG M
                                                                          WHERE M.ITEM_ID = A.FROM_ITEM_ID /* Group 에 의해 실제 제공된 Item 표시 */
                                                                            AND M.PROJECT_CODE = A.PROJECT_CODE
                                                                            AND M.TO_SITE = A.SALES_SITE_ID
                                                                            /* and m.incoterms = a.incoterms */
                                                                            AND M.INCOTERMS = A.SCP_INCOTERMS
                                                                            AND M.DIVISION_ID = V_DIVISION_ID
                                                                            AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                            AND M.PLAN_TYPE = V_PLAN_TYPE
                                                                            AND M.SEQ = V_PLAN_SEQ
                                                                            AND M.QTY <> 0
                                                                            AND M.MEASURE = 'WH_IN' )
                                                      AND K.MEASURE = 'WH_IN')
                                              ELSE
                                                  (SELECT SUBSTR(DE.FROM_SITE_ID, 1, (CASE WHEN INSTR(DE.FROM_SITE_ID, '~') = 0 THEN LENGTH(DE.FROM_SITE_ID) ELSE INSTR(DE.FROM_SITE_ID, '~') - 1 END))
                                                     FROM TH_EXP_DELIVERY_SN DE
                                                    WHERE DE.MASTER_ID = A.MASTER_ID
                                                      AND DE.PLAN_ID = A.OUT_VERSION_ID
                                                      AND DE.ITEM_ID = A.FROM_ITEM_ID /* Group 에 의해 실제 제공된 Item 표시 */
                                                      AND DE.OUT_VERSION_ID = A.OUT_VERSION_ID
                                                      AND DE.ORDER_ID = A.DELIVERY_ORDER_ID
                                                      AND DE.ORG_DEMAND_ID = A.ENG_DEMAND_ID  /* 2025.05.22 조인 컬럼 변경 : de.demand_id -> de.org_demand_id */
                                                      AND ROWNUM = 1)
                                                      /* 5/22 조인 컬럼 변경 and de.demand_id = a.eng_demand_id */
                                              END )
              LEFT JOIN SCM_MST_SITE X
                     ON X.DIVISION_ID = A.DIVISION_ID
                    AND X.SCM_SITE_ID = A.SALES_SITE_ID
              LEFT JOIN SCP_MST_FINAL_ITEM FI
                     ON FI.DIVISION_ID = A.DIVISION_ID
                    AND FI.OPERATION_GROUP = 'A'
                    AND FI.ITEM_ID = A.ITEM_ID   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
              INNER JOIN SCP_MST_FINAL_ITEM C
                     ON C.ITEM_ID = A.ITEM_ID
                    AND C.DIVISION_ID = A.DIVISION_ID
                    /* and c.FLOW_ID <> 'P5000' */
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.OPERATION_GROUP IN ('A', 'P')
/* AND a.YYYYMMDD <= '20241231' */
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.DIVISION_ID
                    , B.COMPANY_ID
                    , (CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
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
                    , (CASE WHEN (A.OPERATION_GROUP = 'P' AND C.FLOW_ID =  'P5000') THEN '210'
                            WHEN (A.OPERATION_GROUP = 'P' AND C.FLOW_ID <> 'P5000') THEN '110'
                            WHEN A.OPERATION_GROUP = 'A' AND FI.TCO_CELL_YN = 'Y' THEN '610'  /* > TCO_CELL_YN : Y : 후공정 CELL : SCP_MST_FINAL_ITEM_V */
                            WHEN A.OPERATION_GROUP = 'A' THEN '310'  /* > TCO_CELL_YN : Y : 후공정 CELL : SCP_MST_FINAL_ITEM_V */
                            END )
                    , SUBSTR(A.YYYYMMDD, 1, 6);


            UPDATE GT_PIS_MAIN A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT NVL(MAX(B.COMPANY_ID), '-')
                          , NVL(MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                         WHEN (B.SITE_TYPE = 'PLANT' AND B.PLANT_ID = 'KR02149300') THEN V_NJ_PLANT
                                         WHEN B.SITE_TYPE = 'PLANT' THEN B.PLANT_ID
                                         ELSE '-'
                                         END ), '-')
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
             WHERE NVL(A.PLANT_ID, '-') < '0'
               AND A.SEQ_FLAG IN ('110', '210', '310', '610');

/* 3번(추가) : 해당 아이템의 가장 빠른 생산계획이 있는 Plant */
            UPDATE GT_PIS_MAIN A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT NVL(MAX(B.COMPANY_ID), '-')  /* b.company_id */
                          , NVL(MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                         WHEN (B.SITE_TYPE = 'PLANT' AND B.PLANT_ID = 'KR02149300') THEN V_NJ_PLANT
                                         WHEN B.SITE_TYPE = 'PLANT' THEN B.PLANT_ID
                                         ELSE '-'
                                         END ), '-')
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
                                                                      AND M.ITEM_ID = NVL((SELECT MAX(ITEM_ID_ASSY)
                                                                                             FROM SCP_MST_CELL_PROD_ASSY_MAP Z
                                                                                            WHERE Z.DIVISION_ID = A.DIVISION_ID
                                                                                              AND Z.ITEM_ID_PROD = A.ITEM_ID
                                                                                              AND CELL_TYPE = 'CA1'
                                                                                              AND VALID_YN = 'Y'), A.ITEM_ID)
                                                                      AND M.DIVISION_ID = A.DIVISION_ID
                                                                      AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                      AND M.PLAN_TYPE = V_PLAN_TYPE
                                                                      AND M.SEQ = V_PLAN_SEQ
                                                                      AND M.QTY <> 0
                                                                      AND M.MEASURE = 'PROD_PLAN_AMEND' )
                                                AND K.MEASURE = 'PROD_PLAN_AMEND') )
             WHERE NVL(A.PLANT_ID, '-') < '0'
               AND A.SEQ_FLAG IN ('110', '210', '310', '610');

            /* ---------------------------------------------------------------------------------------------------------------- */
            /* RTF plant 매핑을 위한 Project Route 정보 추출  -- 2025.06.05 */
            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' RTF plant 매핑을 위한 Project Route 정보 추출');
            /* 원본: if object_id('tempdb..#scm_mst_site_item_priority_v') is not null drop table → DELETE 로 대체 */
            DELETE FROM GT_PIS_SITE_ITEM_PRIO;

            INSERT INTO GT_PIS_SITE_ITEM_PRIO
            SELECT PR.*
                 , PS.COMPANY_ID
                 , PS.PLANT_ID   /* 2025.07.09 소형은 외주 packer인 경우 logistic_plant_id로 case 처리 안함 */
                 , ROW_NUMBER() OVER (PARTITION BY PR.DIVISION_ID
                                                 , PR.ITEM_ID
                                          ORDER BY PR.PLANT_SITE_ID) AS PLANT_PRIORITY
              FROM SCM_MST_SITE_ITEM_PRIORITY_V PR
                 , SCM_MST_SITE                  PS
                 , GT_PIS_MAIN                   A
             WHERE PS.DIVISION_ID = PR.DIVISION_ID
               AND PS.SCM_SITE_ID = PR.PLANT_SITE_ID
               AND PS.VALID_YN    = 'Y'
               AND PS.SITE_TYPE   = 'PLANT'
               AND PR.DIVISION_ID  = A.DIVISION_ID
               AND PR.ITEM_ID      = A.ITEM_ID
               AND PR.FROM_YYYYMMDD <= A.YYYYMM || '01'
               AND PR.TO_YYYYMMDD   >= TO_CHAR(LAST_DAY(TO_DATE(A.YYYYMM || '01', 'YYYYMMDD')), 'YYYYMMDD')
               AND PR.DIVISION_ID = V_DIVISION_ID
               AND PR.TO_YYYYMMDD > V_PLAN_START_YYYYMMDD
               AND NVL(A.PLANT_ID, '-') < '0'
               AND A.SEQ_FLAG IN ('110', '210', '310', '610');

            /* ---------------------------------------------------------------------------------------------------------------- */
            /* Project Route 기준 RTF plant 매핑  -- 2025.06.05 */
            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' Project Route 기준 RTF plant 매핑');
            UPDATE GT_PIS_MAIN A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT P.COMPANY_ID, P.PLANT_ID
                       FROM GT_PIS_SITE_ITEM_PRIO P
                      WHERE P.DIVISION_ID   = A.DIVISION_ID
                        AND P.ITEM_ID       = A.ITEM_ID
                        AND P.PLANT_PRIORITY = 1 )
             WHERE NVL(A.PLANT_ID, '-') < '0'
               AND A.SEQ_FLAG IN ('110', '210', '310', '610')
               AND EXISTS ( SELECT 1
                              FROM GT_PIS_SITE_ITEM_PRIO P
                             WHERE P.DIVISION_ID   = A.DIVISION_ID
                               AND P.ITEM_ID       = A.ITEM_ID
                               AND P.PLANT_PRIORITY = 1 );
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' Project Route 기준 RTF plant 매핑 ENd');

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 ) */
            /* 5.PROD_PLAN 입력 */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '5.PROD_PLAN ';
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID
                 , NVL((CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
                             ELSE B.PLANT_ID
                             END ), '-') AS PLANT_ID
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
                 , '-' AS INCOTERMS,
                   /* (CASE WHEN a.operation_group = 'P' THEN '150' */
                   /* WHEN a.operation_group = 'A' THEN '450' */
                   /* END ) AS SEQ_FLAG, */
                   '150' AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(QTY, 0)), 0) AS QTY
              FROM SCP_ANL_PRODUCTION_PLAN A   /* 여기에서 pack 제품만 포함되도록 해야 함. pack반제품이 포함되어 있음. */
                 , SCM_MST_SITE          B
                 , SCP_MST_FINAL_ITEM    C
             WHERE B.DIVISION_ID(+) = A.DIVISION_ID
               AND B.SCM_SITE_ID(+) = A.SCM_SITE_ID
               AND C.ITEM_ID = A.ITEM_ID
               AND C.DIVISION_ID = A.DIVISION_ID
               AND C.FLOW_ID <> 'P5000'
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'PROD_PLAN_AMEND'
               AND A.OPERATION_GROUP = 'P'   /* ('A','P') */
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.DIVISION_ID
                    , B.COMPANY_ID
                    , (CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
                            ELSE B.PLANT_ID
                            END )
                    , A.PLAN_START_YYYYMMDD
                    , A.OPERATION_GROUP
                    , A.ITEM_ID
                    , A.LINE_ID
                    , SUBSTR(A.YYYYMMDD, 1, 6);

/* ----- 250 : 반제품 Prod_Plan 생성 */
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID
                 , NVL((CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
                             ELSE B.PLANT_ID
                             END ), '-') AS PLANT_ID
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
                 , '-' AS INCOTERMS,
                   /* (CASE WHEN a.operation_group = 'P' THEN '150' */
                   /* WHEN a.operation_group = 'A' THEN '450' */
                   /* END ) AS SEQ_FLAG, */
                   '250' AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(QTY, 0)), 0) AS QTY
              FROM SCP_ANL_PRODUCTION_PLAN A   /* 여기에서 pack 제품만 포함되도록 해야 함. pack반제품이 포함되어 있음. */
                 , SCP_MST_FINAL_ITEM    C
                 , SCM_MST_SITE          B
             WHERE C.ITEM_ID = A.ITEM_ID
               AND C.DIVISION_ID = A.DIVISION_ID
               AND C.FLOW_ID = 'P5000'
               AND B.DIVISION_ID(+) = A.DIVISION_ID
               AND B.SCM_SITE_ID(+) = A.SCM_SITE_ID
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'PROD_PLAN_AMEND'
               AND A.OPERATION_GROUP = 'P'   /* ('A','P') */
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.DIVISION_ID
                    , B.COMPANY_ID
                    , (CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
                            ELSE B.PLANT_ID
                            END )
                    , A.PLAN_START_YYYYMMDD
                    , A.OPERATION_GROUP
                    , A.ITEM_ID
                    , A.LINE_ID
                    , SUBSTR(A.YYYYMMDD, 1, 6);

/* --- 후공정 제품 (650) : Prod Plan - 셀 후공정 제품의 Shipment Plan FG start -------- '350' 활용 */
            /* 이하 shipment_plan_fg 입력 */
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID
                 , NVL((CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
                             ELSE B.PLANT_ID
                             END ), '-') AS PLANT_ID
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
                 , '650' AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(A.QTY, 0)), 0) AS QTY
              FROM SCP_ANL_SHIPMENT_PLAN_FG A
                 , SCM_MST_SITE           B
                 /* final_item 조인하기. */
                 , SCP_MST_FINAL_ITEM     FI
             WHERE B.DIVISION_ID(+) = A.DIVISION_ID
               AND B.SCM_SITE_ID(+) = A.FROM_SITE
               AND FI.DIVISION_ID = A.DIVISION_ID
               AND FI.OPERATION_GROUP = 'A'
               AND FI.ITEM_ID = A.ITEM_ID   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
               AND FI.TCO_CELL_YN = 'Y'
               AND FI.ATTRIBUTE8 = 'CP'
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'SHIP_PLAN_AMEND'
               AND A.BIZ_TYPE = 'A'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.DIVISION_ID
                    , B.COMPANY_ID
                    , (CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
                            ELSE B.PLANT_ID
                            END )
                    , A.PLAN_START_YYYYMMDD
                    , A.ITEM_ID
                    , SUBSTR(A.YYYYMMDD, 1, 6);
/* --- 후공정 제품 (650) : Prod Plan - 셀 후공정 제품의 Shipment Plan FG end -------- */

/* --- 후공정 반제품 (730, 750) START */
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , A.CELL_ITEM_ID
                 , CA.ITEM_ID_ASSY AS ITEM_ID
                 , 'IN_HOUSE_MOVING' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , A.PLANT_ID AS TO_SITE
                 , '-' AS INCOTERMS
                 , '730' AS SEQ_FLAG
                 , A.YYYYMM,
                   NVL(SUM(NVL(A.QTY, 0)), 0) AS QTY  /* pack, cell 수율반영 */
              FROM GT_PIS_MAIN                  A
                 , SCP_MST_CELL_PROD_ASSY_MAP   CA
             WHERE CA.DIVISION_ID = A.DIVISION_ID  /* '40' */
               AND CA.PLANT_ID = A.PLANT_ID
               AND CA.ITEM_ID_PROD = A.ITEM_ID
               AND CA.CELL_TYPE = 'CA2'
               AND CA.VALID_YN = 'Y'
               AND A.SEQ_FLAG = '650'
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.PLAN_START_YYYYMMDD
                    , A.CELL_ITEM_ID
                    , CA.ITEM_ID_ASSY
                    , A.YYYYMM;
/* --- 후공정 반제품 (730, 750) END */

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 ) inv start */
            /* 6.BOH 입력 */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '6.BOH ';
            INSERT INTO GT_PIS_INV
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, FROM_SITE, ITEM_ID, YYYYMMDD, RECEIVING_DTTM_YYYYMM
                , QTY, QTY_INCLUDE_YIELD, DESCR, ATTRIBUTE8, FLOW_ID, OPERATION_GROUP, TCO_CELL_YN )
            SELECT SUBSTR(A.MASTER_ID, 1, INSTR(A.MASTER_ID, '::') - 1) AS DIVISION_ID
                 , '-' AS COMPANY_ID
                 , '-' AS PLANT_ID
                 , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1) AS FROM_SITE
                 , A.ITEM_ID
                 , V_PLAN_START_YYYYMMDD AS YYYYMMDD
                 , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMM') AS RECEIVING_DTTM_YYYYMM
                 , NVL(SUM(NVL(A.QTY, 0)), 0) AS QTY
                 , NVL(SUM(NVL(A.QTY, 0) * NVL(FM.FORMATION_TOTAL_YIELD, 1)), 0) AS QTY_INCLUDE_YIELD
                 , A.DESCR
                 , C.ATTRIBUTE8, C.FLOW_ID, C.OPERATION_GROUP, C.TCO_CELL_YN
              FROM SCP_PLN_TH_ENG_STOCK_PLAN A
                 , SCM_MST_SITE             B
                 , SCP_MST_FINAL_ITEM       C
                 /* 활성화 수율 가져오기 */
                 , SCP_MST_FORMATION_V      FM
             WHERE B.DIVISION_ID = V_DIVISION_ID
               AND B.SCM_SITE_ID = SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)
               AND NOT (A.DESCR = 'WH' AND B.SITE_TYPE = 'SALES')
               AND C.ITEM_ID = A.ITEM_ID
               AND C.DIVISION_ID = SUBSTR(A.MASTER_ID, 1, INSTR(A.MASTER_ID, '::') - 1)
               AND C.DIVISION_ID = V_DIVISION_ID
               AND C.FLOW_ID <> 'P5000'
               AND FM.DIVISION_ID(+) = SUBSTR(A.MASTER_ID, 1, 2)  /* a.DIVISION_ID */
               AND FM.PLANT_SITE_ID(+) = SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)
               AND FM.ITEM_ID(+) = A.ITEM_ID
               AND 1 = 1
               AND A.MASTER_ID = V_MASTER_ID
               AND A.PLAN_ID   = V_ENG_PLAN_ID
               AND TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD') <= V_HORIZON_END_YYYYMMDD
             GROUP BY SUBSTR(A.MASTER_ID, 1, INSTR(A.MASTER_ID, '::') - 1)
                    , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)
                    , A.ITEM_ID
                    , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMM')
                    , A.DESCR
                    , C.ATTRIBUTE8, C.FLOW_ID, C.OPERATION_GROUP, C.TCO_CELL_YN;

/* SALES_ONHAND 추가 */
            INSERT INTO GT_PIS_INV
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, FROM_SITE, ITEM_ID, YYYYMMDD, RECEIVING_DTTM_YYYYMM
                , QTY, QTY_INCLUDE_YIELD, DESCR, ATTRIBUTE8, FLOW_ID, OPERATION_GROUP, TCO_CELL_YN )
            SELECT A.DIVISION_ID AS DIVISION_ID
                 , '-' AS COMPANY_ID
                 , '-' AS PLANT_ID
                 , A.SITE_ID AS FROM_SITE
                 , A.ITEM_ID
                 , V_PLAN_START_YYYYMMDD AS YYYYMMDD
                 , SUBSTR(V_PLAN_START_YYYYMMDD, 1, 6) AS RECEIVING_DTTM_YYYYMM
                 , NVL(SUM(NVL(A.PSI_BOH_QTY, 0)), 0) AS QTY
                 , NVL(SUM(NVL(A.PSI_BOH_QTY, 0)), 0) AS QTY_INCLUDE_YIELD
                 , 'WH' AS DESCR
                 , C.ATTRIBUTE8, C.FLOW_ID, C.OPERATION_GROUP, C.TCO_CELL_YN
              FROM SCP_PLN_SALES_ONHAND_V A
                 , SCM_MST_SITE        B
                 , SCP_MST_FINAL_ITEM  C
             WHERE B.DIVISION_ID = V_DIVISION_ID
               AND B.SCM_SITE_ID = A.SITE_ID
               AND C.ITEM_ID = A.ITEM_ID
               AND C.DIVISION_ID = A.DIVISION_ID
               AND C.DIVISION_ID = V_DIVISION_ID
               AND C.FLOW_ID <> 'P5000'
               AND A.DIVISION_ID = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE = V_PLAN_TYPE
               AND A.SEQ = V_PLAN_SEQ
               AND A.YYYYMMDD = V_PLAN_START_YYYYMMDD /* > 이부분 맞나요? */
               AND A.PSI_BOH_QTY <> 0
             GROUP BY A.DIVISION_ID
                    , A.SITE_ID
                    , A.ITEM_ID
                    , C.ATTRIBUTE8, C.FLOW_ID, C.OPERATION_GROUP, C.TCO_CELL_YN;

            /*****************************************
                #tmp_psi_integration_inv_small  'P5000'을 추가.
            ******************************************/
            V_STATUS_DESC := '6.BOH P5000';
/* = 'P5000' : not (a.DESCR = 'WH' and b.SITE_TYPE = 'SALES') */
            INSERT INTO GT_PIS_INV
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, FROM_SITE, ITEM_ID, YYYYMMDD, RECEIVING_DTTM_YYYYMM
                , QTY, QTY_INCLUDE_YIELD, DESCR, ATTRIBUTE8, FLOW_ID, OPERATION_GROUP, TCO_CELL_YN )
            SELECT SUBSTR(A.MASTER_ID, 1, INSTR(A.MASTER_ID, '::') - 1) AS DIVISION_ID
                 , '-' AS COMPANY_ID
                 , '-' AS PLANT_ID
                 , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1) AS FROM_SITE
                 , A.ITEM_ID
                 , V_PLAN_START_YYYYMMDD AS YYYYMMDD
                 , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMM') AS RECEIVING_DTTM_YYYYMMDD
                 , NVL(SUM(NVL(A.QTY, 0)), 0) AS QTY
                 , NVL(SUM(NVL(A.QTY, 0) * NVL(FM.FORMATION_TOTAL_YIELD, 1)), 0) AS QTY_INCLUDE_YIELD
                 , A.DESCR
                 , '-' AS ATTRIBUTE8, C.FLOW_ID, 'P' AS OPERATION_GROUP, '-' AS TCO_CELL_YN
              FROM SCP_PLN_TH_ENG_STOCK_PLAN A
                 , SCM_MST_SITE             B
                 , (SELECT DISTINCT DIVISION_ID, ITEM_ID, NVL(SCP_FLOW_ID, FLOW_ID) FLOW_ID
                      FROM SCM_MST_ITEM_SN
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND NVL(SCP_FLOW_ID, FLOW_ID) = 'P5000'
                   ) C
                 /* 활성화 수율 가져오기 */
                 , SCP_MST_FORMATION_V      FM
             WHERE B.DIVISION_ID = V_DIVISION_ID
               AND B.SCM_SITE_ID = SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)
               AND NOT (A.DESCR = 'WH' AND B.SITE_TYPE = 'SALES')
               AND C.DIVISION_ID = SUBSTR(A.MASTER_ID, 1, INSTR(A.MASTER_ID, '::') - 1)
               AND C.ITEM_ID = A.ITEM_ID
               AND FM.DIVISION_ID(+) = SUBSTR(A.MASTER_ID, 1, 2)  /* a.DIVISION_ID */
               AND FM.PLANT_SITE_ID(+) = SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)
               AND FM.ITEM_ID(+) = A.ITEM_ID
               AND 1 = 1
               AND A.MASTER_ID = V_MASTER_ID
               AND A.PLAN_ID   = V_ENG_PLAN_ID
               AND TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD') <= V_HORIZON_END_YYYYMMDD
             GROUP BY SUBSTR(A.MASTER_ID, 1, INSTR(A.MASTER_ID, '::') - 1)
                    , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)
                    , A.ITEM_ID
                    , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMM')
                    , A.DESCR
                    , C.FLOW_ID;

            /****************************************************
            EE 재고('560')를 #tmp_psi_integration_inv_small 에 추가로 insert 해야함.
            ****************************************************/
            V_STATUS_DESC := '6.BOH EE';

            /* 재고의 COMPANY_ID, PLANT_ID 반영. (원본 UPDATE...FROM LEFT JOIN b/cs → 상관 집계서브쿼리) */
            UPDATE GT_PIS_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT NVL(MAX(B.COMPANY_ID), '-')
                          , NVL(MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'
                                         WHEN A.OPERATION_GROUP = 'E' AND B.OPERATION_GROUP = 'A' AND CS.PLANT_ID_ES IS NOT NULL THEN CS.PLANT_ID_ES  /* 2025.02.13 전극 plant 매핑 로직 수정 */
                                         WHEN (B.SITE_TYPE = 'PLANT' AND B.PLANT_ID = 'KR02149300') THEN V_NJ_PLANT
                                         WHEN B.SITE_TYPE = 'PLANT' THEN B.PLANT_ID
                                         ELSE '-'
                                         END ), '-')
                       FROM SCM_MST_SITE           B
                          , GT_PIS_CELL_ELEC_MAP  CS  /* 2025.02.13 전극 plant 매핑 로직 수정 */
                      WHERE CS.CELL_PLANT_PRIORITY(+) = 1
                        AND CS.DIVISION_ID_CS(+) = B.DIVISION_ID
                        AND CS.PLANT_ID_CS(+)    = B.PLANT_ID
                        AND CS.COMPANY_ID_CS(+)  = B.COMPANY_ID
                        AND B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = A.FROM_SITE );

/* 1번(추가) : 가장 빠른 WH_IN이 있는 Plant */
            UPDATE GT_PIS_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT NVL(MAX(B.COMPANY_ID), '-')
                          , NVL(MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                         WHEN (B.SITE_TYPE = 'PLANT' AND B.PLANT_ID = 'KR02149300') THEN V_NJ_PLANT
                                         WHEN B.SITE_TYPE = 'PLANT' THEN B.PLANT_ID
                                         ELSE '-'
                                         END ), '-')
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
             WHERE NVL(A.PLANT_ID, '-') < '0';

/* 2번(기존) */
            UPDATE GT_PIS_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT NVL(MAX(B.COMPANY_ID), '-')
                          , NVL(MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                         WHEN (B.SITE_TYPE = 'PLANT' AND B.PLANT_ID = 'KR02149300') THEN V_NJ_PLANT
                                         WHEN B.SITE_TYPE = 'PLANT' THEN B.PLANT_ID
                                         ELSE '-'
                                         END ), '-')
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
             WHERE NVL(A.PLANT_ID, '-') < '0';

/* 3번(추가) : 해당 아이템의 가장 빠른 생산계획이 있는 Plant */
            UPDATE GT_PIS_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT NVL(MAX(B.COMPANY_ID), '-')
                          , NVL(MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                         WHEN (B.SITE_TYPE = 'PLANT' AND B.PLANT_ID = 'KR02149300') THEN V_NJ_PLANT
                                         WHEN B.SITE_TYPE = 'PLANT' THEN B.PLANT_ID
                                         ELSE '-'
                                         END ), '-')
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
                                                                      AND M.ITEM_ID = NVL((SELECT MAX(ITEM_ID_ASSY)
                                                                                             FROM SCP_MST_CELL_PROD_ASSY_MAP Z
                                                                                            WHERE Z.DIVISION_ID = A.DIVISION_ID
                                                                                              AND Z.ITEM_ID_PROD = A.ITEM_ID
                                                                                              AND CELL_TYPE = 'CA1'
                                                                                              AND VALID_YN = 'Y'), A.ITEM_ID)
                                                                      AND M.DIVISION_ID = A.DIVISION_ID
                                                                      AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                      AND M.PLAN_TYPE = V_PLAN_TYPE
                                                                      AND M.SEQ = V_PLAN_SEQ
                                                                      AND M.QTY <> 0
                                                                      AND M.MEASURE = 'PROD_PLAN_AMEND' )
                                                AND K.MEASURE = 'PROD_PLAN_AMEND') )
             WHERE NVL(A.PLANT_ID, '-') < '0';

/* 3-2번(2025.07.09 RTF에 맞춰 매핑 우선순위 변경) : Project Route 생산 Plant 기준으로 매핑 */
            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' 재고 plant 매핑을 위한 Project Route 정보 추출');  /* 2025.06.11 */
            /* 원본: if object_id('tempdb..#scm_mst_site_item_priority_v_for_inv') is not null drop table → DELETE 로 대체 */
            DELETE FROM GT_PIS_SITE_ITEM_PRIO_INV;

            INSERT INTO GT_PIS_SITE_ITEM_PRIO_INV
            SELECT PR.*
                 , PS.COMPANY_ID
                 , PS.PLANT_ID   /* 2025.07.09 소형은 외주 packer인 경우 logistic_plant_id로 case 처리 안함 */
                 , ROW_NUMBER() OVER (PARTITION BY PR.DIVISION_ID
                                                 , PR.ITEM_ID
                                          ORDER BY PR.PLANT_SITE_ID) AS PLANT_PRIORITY
              FROM SCM_MST_SITE_ITEM_PRIORITY_V PR
                 , SCM_MST_SITE                  PS
                 , GT_PIS_INV                    A
             WHERE PS.DIVISION_ID = PR.DIVISION_ID
               AND PS.SCM_SITE_ID = PR.PLANT_SITE_ID
               AND PS.VALID_YN    = 'Y'
               AND PS.SITE_TYPE   = 'PLANT'
               AND PR.DIVISION_ID  = A.DIVISION_ID
               AND PR.ITEM_ID      = A.ITEM_ID
               AND PR.FROM_YYYYMMDD <= A.YYYYMMDD
               AND PR.TO_YYYYMMDD   >= A.YYYYMMDD
               AND PR.DIVISION_ID = V_DIVISION_ID
               AND PR.TO_YYYYMMDD > V_PLAN_START_YYYYMMDD
               AND NVL(A.PLANT_ID, '-') < '0';

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' Project Route 기준 재고 plant 매핑');  /* 2025.06.11 */
            UPDATE GT_PIS_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT P.COMPANY_ID, P.PLANT_ID
                       FROM GT_PIS_SITE_ITEM_PRIO_INV P
                      WHERE P.DIVISION_ID   = A.DIVISION_ID
                        AND P.ITEM_ID       = A.ITEM_ID
                        AND P.PLANT_PRIORITY = 1 )
             WHERE NVL(A.PLANT_ID, '-') < '0'
               AND EXISTS ( SELECT 1
                              FROM GT_PIS_SITE_ITEM_PRIO_INV P
                             WHERE P.DIVISION_ID   = A.DIVISION_ID
                               AND P.ITEM_ID       = A.ITEM_ID
                               AND P.PLANT_PRIORITY = 1 );
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' Project Route 기준 재고 plant 매핑 ENd');  /* 2025.06.11 */

/* 4번(추가) : 해당 아이템의 BOH가 가장 큰 Plant로 지정 */
            UPDATE GT_PIS_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT NVL(MAX(B.COMPANY_ID), '-')  /* b.company_id */
                          , NVL(MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                         WHEN (B.SITE_TYPE = 'PLANT' AND B.PLANT_ID = 'KR02149300') THEN V_NJ_PLANT
                                         WHEN B.SITE_TYPE = 'PLANT' THEN B.PLANT_ID
                                         ELSE '-'
                                         END ), '-')
                       FROM SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = (SELECT FROM_SITE FROM (
                                               SELECT K.FROM_SITE
                                                 FROM GT_PIS_INV   K
                                                    , SCM_MST_SITE M
                                                WHERE M.DIVISION_ID = K.DIVISION_ID
                                                  AND M.SCM_SITE_ID = K.FROM_SITE
                                                  AND M.SITE_TYPE = 'PLANT'
                                                  AND K.DIVISION_ID = A.DIVISION_ID
                                                  AND (K.ITEM_ID = A.ITEM_ID OR K.ITEM_ID = NVL((SELECT MAX(ITEM_ID_ASSY)
                                                                                                   FROM SCP_MST_CELL_PROD_ASSY_MAP Z
                                                                                                  WHERE Z.DIVISION_ID = A.DIVISION_ID
                                                                                                    AND Z.ITEM_ID_PROD = A.ITEM_ID
                                                                                                    AND CELL_TYPE = 'CA1'
                                                                                                    AND VALID_YN = 'Y'), A.ITEM_ID))
                                                  AND K.QTY <> 0
                                                GROUP BY K.FROM_SITE, K.ITEM_ID
                                                ORDER BY SUM(K.QTY) DESC )
                                             WHERE ROWNUM = 1) )
             WHERE NVL(A.PLANT_ID, '-') < '0';

/* 5번(기존) */
            UPDATE GT_PIS_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT NVL(MAX(B.COMPANY_ID), '-')  /* b.company_id */
                          , NVL(MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'
                                         WHEN (B.SITE_TYPE = 'PLANT' AND B.PLANT_ID = 'KR02149300') THEN V_NJ_PLANT
                                         WHEN B.SITE_TYPE = 'PLANT' THEN B.PLANT_ID
                                         ELSE '-'
                                         END ), '-')
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
             WHERE NVL(A.PLANT_ID, '-') < '0';

            UPDATE GT_PIS_INV A
               SET A.COMPANY_ID = ( SELECT MIN(B.COMPANY_ID)
                                      FROM SCM_MST_SITE B
                                     WHERE B.DIVISION_ID = A.DIVISION_ID
                                       AND B.OPERATION_GROUP = A.OPERATION_GROUP
                                       AND B.PLANT_ID = A.PLANT_ID )
             WHERE A.PLANT_ID = V_NJ_PLANT
               AND NVL(A.COMPANY_ID, '-') <> ( SELECT MIN(B.COMPANY_ID)
                                                 FROM SCM_MST_SITE B
                                                WHERE B.DIVISION_ID = A.DIVISION_ID
                                                  AND B.OPERATION_GROUP = A.OPERATION_GROUP
                                                  AND B.PLANT_ID = A.PLANT_ID );

/* -------- 450, 430 만든는 부분 여기에 넣을것.START -------- */
            INSERT INTO GT_PIS_450
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMMDD, YYYYMMDD_LT, YIELD, QTY )
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID
                 , NVL((CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
                             ELSE B.PLANT_ID
                             END ), '-') AS PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , A.LINE_ID
                 , 0 AS BOH_QTY
                 , '-' AS TO_SITE
                 , '-' AS INCOTERMS
                 , '450' AS SEQ_FLAG
                 , A.YYYYMMDD AS YYYYMMDD
                 , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD') + TRUNC(NVL(FM.TOTAL_LT_FORMATION, 0)), 'YYYYMMDD') AS YYYYMMDD_LT
                 , NVL(FM.FORMATION_TOTAL_YIELD, 1) AS YIELD
                 , NVL(QTY, 0) AS QTY
              FROM SCP_ANL_PRODUCTION_PLAN A
                 , SCP_MST_FINAL_ITEM     FI
                 , SCM_MST_SITE           B
                 /* 활성화 수율 가져오기 */
                 , SCP_MST_FORMATION_V    FM
             WHERE FI.DIVISION_ID = A.DIVISION_ID
               AND FI.OPERATION_GROUP = 'A'
               AND FI.ITEM_ID = A.ITEM_ID   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
               AND SUBSTR(FI.ATTRIBUTE8, 1, 2) = 'CA'  /* CP:제품, CA:반제품 */
               AND NVL(FI.TCO_CELL_YN, 'N') <> 'Y'  /* 'Y':후공정, <>'Y':후공정아님. */
               AND B.DIVISION_ID(+) = A.DIVISION_ID
               AND B.SCM_SITE_ID(+) = A.SCM_SITE_ID
               AND FM.DIVISION_ID(+) = A.DIVISION_ID
               AND FM.PLANT_SITE_ID(+) = A.SCM_SITE_ID
               AND FM.ITEM_ID(+) = A.ITEM_ID
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'PROD_PLAN_AMEND'
               AND A.OPERATION_GROUP = 'A'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD;

/* 450 insert */
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT DIVISION_ID
                 , COMPANY_ID
                 , PLANT_ID AS PLANT_ID
                 , PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , LINE_ID
                 , 0 AS BOH_QTY
                 , '-' AS TO_SITE
                 , '-' AS INCOTERMS
                 , '450' AS SEQ_FLAG
                 , SUBSTR(YYYYMMDD, 1, 6)
                 , NVL(SUM(NVL(QTY, 0)), 0) AS QTY
              FROM GT_PIS_450
             GROUP BY DIVISION_ID
                    , COMPANY_ID
                    , PLANT_ID
                    , PLAN_START_YYYYMMDD
                    , OPERATION_GROUP
                    , ITEM_ID
                    , LINE_ID
                    , SUBSTR(YYYYMMDD, 1, 6);

/* 430 만들기 */
/* 1. 활성화 lt 포함 */
/* 430 : A.ITEM_ID <> 'MASS20253-A2' */
            INSERT INTO GT_PIS_430
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID AS PLANT_ID
                 , V_PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , 'IN_HOUSE_MOVING' AS MEASURE
                 , '-' AS VALUE_TYPE,
/* FC.item_id_PROD as TO_PRODUCT, */
/* 반영1/4 start */
                   (SELECT MIN(FC.ITEM_ID_PROD)
                      FROM SCP_MST_CELL_PROD_ASSY_MAP FC
                         , SCP_MST_FINAL_ITEM          FI  /* 2,237,978,407.1687378580 */
                     WHERE FI.DIVISION_ID = FC.DIVISION_ID
                       AND FI.OPERATION_GROUP = 'A'
                       AND FI.ITEM_ID = FC.ITEM_ID_PROD   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
                       AND SUBSTR(FI.ATTRIBUTE8, 1, 2) = 'CP'  /* CP:제품, CA:반제품 */
                       /* and isnull(fi.TCO_CELL_YN,'N') <> 'Y'  -- 'Y':후공정, <>'Y':후공정아님. */
                       AND FC.DIVISION_ID = A.DIVISION_ID
                       AND FC.ITEM_ID_ASSY = A.ITEM_ID
                       AND FC.CELL_TYPE = 'CA1'
                       AND FC.PLANT_ID = A.PLANT_ID
                       AND FC.VALID_YN = 'Y'
                   ) AS TO_PRODUCT,
/* 반영1/4 end */
                   '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , A.PLANT_ID AS TO_SITE
                 , '-' AS INCOTERMS
                 , '430' AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD_LT, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(A.QTY, 0)), 0) AS QTY
              FROM GT_PIS_450 A
/* 반영2/4 start */
             WHERE EXISTS (SELECT 1
                             FROM SCP_MST_CELL_PROD_ASSY_MAP FC
                            WHERE EXISTS (SELECT 1
                                            FROM SCP_MST_FINAL_ITEM FI  /* 2,237,978,407.1687378580 */
                                           WHERE FI.DIVISION_ID = FC.DIVISION_ID
                                             AND FI.OPERATION_GROUP = 'A'
                                             AND FI.ITEM_ID = FC.ITEM_ID_PROD   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
                                             AND SUBSTR(FI.ATTRIBUTE8, 1, 2) = 'CP'  /* CP:제품, CA:반제품 */
                                             /* and isnull(fi.TCO_CELL_YN,'N') <> 'Y' */
                                          )
                              AND FC.DIVISION_ID = A.DIVISION_ID
                              AND FC.ITEM_ID_ASSY = A.ITEM_ID
                              AND FC.CELL_TYPE = 'CA1'
                              AND FC.PLANT_ID = A.PLANT_ID
                              AND FC.VALID_YN = 'Y' )
/* 반영2/4 end */
               AND A.YYYYMMDD_LT <= V_HORIZON_END_YYYYMMDD
/* AND A.ITEM_ID <> 'MASS20253-A2' */
               AND A.ITEM_ID NOT IN (SELECT DISTINCT SEGMENT1
                                       FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM
                                      WHERE LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
                                        AND VALID_YN = 'Y')
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.ITEM_ID,
                      /* to_product,  --FC.item_id_PROD, */
                      SUBSTR(YYYYMMDD_LT, 1, 6);

/* 2. aging */
/* AGING : A.ITEM_ID <> 'MASS20253-A2' */
            INSERT INTO GT_PIS_430
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID
                 , V_PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , 'IN_HOUSE_MOVING' AS MEASURE
                 , '-' AS VALUE_TYPE,
/* FC.item_id_PROD as TO_PRODUCT, */
/* 반영3/4 start */
                   (SELECT MIN(FC.ITEM_ID_PROD)
                      FROM SCP_MST_CELL_PROD_ASSY_MAP FC
                         , SCP_MST_FINAL_ITEM          FI  /* 2,237,978,407.1687378580 */
                     WHERE FI.DIVISION_ID = FC.DIVISION_ID
                       AND FI.OPERATION_GROUP = 'A'
                       AND FI.ITEM_ID = FC.ITEM_ID_PROD   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
                       AND SUBSTR(FI.ATTRIBUTE8, 1, 2) = 'CP'  /* CP:제품, CA:반제품 */
                       /* and isnull(fi.TCO_CELL_YN,'N') <> 'Y'  -- 'Y':후공정, <>'Y':후공정아님. */
                       AND FC.DIVISION_ID = A.DIVISION_ID
                       AND FC.ITEM_ID_ASSY = A.ITEM_ID
                       AND FC.CELL_TYPE = 'CA1'
                       AND FC.PLANT_ID = A.PLANT_ID
                       AND FC.VALID_YN = 'Y'
                   ) AS TO_PRODUCT,
/* 반영3/4 end */
                   '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , A.PLANT_ID AS TO_SITE
                 , '-' AS INCOTERMS
                 , '430' AS SEQ_FLAG
                 , A.RECEIVING_DTTM_YYYYMM AS YYYYMM
                 , NVL(SUM(NVL(A.QTY, 0)), 0) AS QTY
              FROM GT_PIS_INV A
/* 반영4/4 start */
             WHERE EXISTS (SELECT 1
                             FROM SCP_MST_CELL_PROD_ASSY_MAP FC
                            WHERE EXISTS (SELECT 1
                                            FROM SCP_MST_FINAL_ITEM FI  /* 2,237,978,407.1687378580 */
                                           WHERE FI.DIVISION_ID = FC.DIVISION_ID
                                             AND FI.OPERATION_GROUP = 'A'
                                             AND FI.ITEM_ID = FC.ITEM_ID_PROD   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
                                             AND SUBSTR(FI.ATTRIBUTE8, 1, 2) = 'CP'  /* CP:제품, CA:반제품 */
                                             /* and isnull(fi.TCO_CELL_YN,'N') <> 'Y' */
                                          )
                              AND FC.DIVISION_ID = A.DIVISION_ID
                              AND FC.ITEM_ID_ASSY = A.ITEM_ID
                              AND FC.CELL_TYPE = 'CA1'
                              AND FC.PLANT_ID = A.PLANT_ID
                              AND FC.VALID_YN = 'Y' )
/* 반영4/4 end */
               AND A.OPERATION_GROUP = 'A'
               AND A.ATTRIBUTE8 = 'CA1'
               AND NVL(A.TCO_CELL_YN, 'N') <> 'Y'
               AND (A.DESCR LIKE 'FOR%' OR A.DESCR = 'WH')
/* AND A.ITEM_ID <> 'MASS20253-A2' */
               AND A.ITEM_ID NOT IN (SELECT DISTINCT SEGMENT1
                                       FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM
                                      WHERE LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
                                        AND VALID_YN = 'Y')
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.ITEM_ID,
                      /* to_product,  -- FC.item_id_PROD, */
                      A.RECEIVING_DTTM_YYYYMM;

/* 430 취합해서 넣기 */
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT DIVISION_ID
                 , COMPANY_ID
                 , PLANT_ID
                 , V_PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , ITEM_ID
                 , 'IN_HOUSE_MOVING' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , TO_SITE
                 , '-' AS INCOTERMS
                 , '430' AS SEQ_FLAG
                 , YYYYMM
                 , NVL(SUM(NVL(QTY, 0)), 0) AS QTY
              FROM GT_PIS_430  /* 12,984,  ==> 129,584 */
             GROUP BY DIVISION_ID
                    , COMPANY_ID
                    , PLANT_ID
                    , ITEM_ID
                    , TO_PRODUCT
                    , TO_SITE
                    , YYYYMM;

/* 430 to start */
            UPDATE GT_PIS_MAIN A
               SET A.TO_PRODUCT = NVL((SELECT MIN(FC4.ITEM_ID_ASSY)
                                         FROM SCP_MST_CELL_PROD_ASSY_MAP FC3
                                            , SCP_MST_FINAL_ITEM          FI3
                                            , SCP_MST_CELL_PROD_ASSY_MAP  FC4
                                        WHERE FI3.DIVISION_ID = A.DIVISION_ID
                                          AND FI3.OPERATION_GROUP = 'A'
                                          AND FI3.ITEM_ID = FC3.ITEM_ID_PROD   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
                                          AND SUBSTR(FI3.ATTRIBUTE8, 1, 2) = 'CP'
                                          AND NVL(FI3.TCO_CELL_YN, 'N') = 'Y'
                                          AND FC4.DIVISION_ID = A.DIVISION_ID  /* '40' */
                                          AND FC4.ITEM_ID_PROD = FI3.ITEM_ID
                                          AND FC4.CELL_TYPE = 'CA2'
                                          AND FC4.PLANT_ID = A.PLANT_ID
                                          AND FC4.VALID_YN = 'Y'
                                          AND FC3.DIVISION_ID = A.DIVISION_ID  /* '40'  -- */
                                          AND FC3.ITEM_ID_ASSY = A.ITEM_ID
                                          AND FC3.CELL_TYPE = 'CA1'
                                          AND FC3.PLANT_ID = A.PLANT_ID
                                          AND FC3.VALID_YN = 'Y'), A.TO_PRODUCT)
             WHERE A.DIVISION_ID = V_DIVISION_ID /* '40' */
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD  /* '20240923' */
               AND A.SEQ_FLAG = '430'
               AND EXISTS ( SELECT 1
                              FROM SCP_MST_CELL_PROD_ASSY_MAP FC2
                                 , SCP_MST_FINAL_ITEM          FI2
                             WHERE FI2.DIVISION_ID = A.DIVISION_ID
                               AND FI2.OPERATION_GROUP = 'A'
                               AND FI2.ITEM_ID = FC2.ITEM_ID_PROD   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
                               AND SUBSTR(FI2.ATTRIBUTE8, 1, 2) = 'CP'
                               AND NVL(FI2.TCO_CELL_YN, 'N') = 'Y'
                               AND FC2.DIVISION_ID = A.DIVISION_ID
                               AND FC2.ITEM_ID_ASSY = A.ITEM_ID
                               AND FC2.CELL_TYPE = 'CA1'
                               AND FC2.PLANT_ID = A.PLANT_ID
                               AND FC2.VALID_YN = 'Y');
/* 430 to end */

/* ======================================  350 만들기 start ======================= */
/* 430 복사해서 350 만듦 */
/* 430 만들기 */
/* 1. 활성화 lt 포함 */
            INSERT INTO GT_PIS_350
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID AS PLANT_ID
                 , V_PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , FC.ITEM_ID_PROD AS ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , A.LINE_ID AS LINE_ID
                 , 0 AS BOH_QTY
                 , '-' AS TO_SITE
                 , '-' AS INCOTERMS
                 , '350' AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD_LT, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(A.QTY, 0) * NVL(A.YIELD, 1)), 0) AS QTY
              FROM GT_PIS_450                 A
                 , SCP_MST_CELL_PROD_ASSY_MAP FC
                 , SCP_MST_FINAL_ITEM         FI
             WHERE FC.DIVISION_ID = V_DIVISION_ID /* '40' */
               AND FC.ITEM_ID_ASSY = A.ITEM_ID
               AND FC.CELL_TYPE = 'CA1'
               AND FC.PLANT_ID = A.PLANT_ID
               AND FC.VALID_YN = 'Y'
               AND FI.DIVISION_ID = A.DIVISION_ID
               AND FI.OPERATION_GROUP = 'A'
               AND FI.ITEM_ID = FC.ITEM_ID_PROD   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
               AND SUBSTR(FI.ATTRIBUTE8, 1, 2) = 'CP'
               AND NVL(FI.TCO_CELL_YN, 'N') <> 'Y'
               AND YYYYMMDD_LT <= V_HORIZON_END_YYYYMMDD
               AND NOT EXISTS (SELECT 1
                                 FROM SCP_MST_CELL_PROD_ASSY_MAP FC2
                                    , SCP_MST_FINAL_ITEM          FI2
                                WHERE FI2.DIVISION_ID = A.DIVISION_ID
                                  AND FI2.OPERATION_GROUP = 'A'
                                  AND FI2.ITEM_ID = FC2.ITEM_ID_PROD   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
                                  AND FI2.ITEM_ID NOT IN (SELECT SEGMENT1
                                                            FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMA
                                                           WHERE LOOKUP_TYPE = 'TCO_NO_CA2_ITEM_PROD'
                                                             AND VALID_YN = 'Y')
                                  AND SUBSTR(FI2.ATTRIBUTE8, 1, 2) = 'CP'
                                  AND NVL(FI2.TCO_CELL_YN, 'N') = 'Y'
                                  AND FC2.DIVISION_ID = V_DIVISION_ID /* '40' */
                                  AND FC2.ITEM_ID_ASSY = A.ITEM_ID
                                  AND FC2.CELL_TYPE = 'CA1'
                                  AND FC2.PLANT_ID = A.PLANT_ID
                                  AND FC2.VALID_YN = 'Y')
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , FC.ITEM_ID_PROD
                    , A.LINE_ID
                    , SUBSTR(A.YYYYMMDD_LT, 1, 6);

/* 2. aging */
            INSERT INTO GT_PIS_350
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID
                 , V_PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , FC.ITEM_ID_PROD AS ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , '-' AS TO_SITE
                 , '-' AS INCOTERMS
                 , '350' AS SEQ_FLAG
                 , A.RECEIVING_DTTM_YYYYMM AS YYYYMM
                 , NVL(SUM(NVL(QTY_INCLUDE_YIELD, 0)), 0) AS QTY
              FROM GT_PIS_INV                 A
                 , SCP_MST_CELL_PROD_ASSY_MAP FC
                 , SCP_MST_FINAL_ITEM         FI
             WHERE FC.DIVISION_ID = V_DIVISION_ID /* '40' */
               AND FC.ITEM_ID_ASSY = A.ITEM_ID
               AND FC.CELL_TYPE = 'CA1'
               AND FC.PLANT_ID = A.PLANT_ID
               AND FC.VALID_YN = 'Y'
               AND FI.DIVISION_ID = A.DIVISION_ID
               AND FI.OPERATION_GROUP = 'A'
               AND FI.ITEM_ID = FC.ITEM_ID_PROD   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
               AND FI.ATTRIBUTE8 = 'CP'
               AND NVL(FI.TCO_CELL_YN, 'N') <> 'Y'
               AND NOT EXISTS (SELECT 1
                                 FROM SCP_MST_CELL_PROD_ASSY_MAP FC2
                                    , SCP_MST_FINAL_ITEM          FI2
                                WHERE FI2.DIVISION_ID = A.DIVISION_ID
                                  AND FI2.OPERATION_GROUP = 'A'
                                  AND FI2.ITEM_ID = FC2.ITEM_ID_PROD   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
                                  AND FI2.ITEM_ID NOT IN (SELECT SEGMENT1
                                                            FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMA
                                                           WHERE LOOKUP_TYPE = 'TCO_NO_CA2_ITEM_PROD'
                                                             AND VALID_YN = 'Y')
                                  AND SUBSTR(FI2.ATTRIBUTE8, 1, 2) = 'CP'
                                  AND NVL(FI2.TCO_CELL_YN, 'N') = 'Y'
                                  AND FC2.DIVISION_ID = V_DIVISION_ID /* '40' */
                                  AND FC2.ITEM_ID_ASSY = A.ITEM_ID
                                  AND FC2.CELL_TYPE = 'CA1'
                                  AND FC2.PLANT_ID = A.PLANT_ID
                                  AND FC2.VALID_YN = 'Y')
               AND A.OPERATION_GROUP = 'A'
               AND A.ATTRIBUTE8 = 'CA1'
               AND NVL(A.TCO_CELL_YN, 'N') <> 'Y'
               AND (A.DESCR LIKE 'FOR%' OR A.DESCR = 'WH')  /* a.DESCR like 'FOR%' */
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , FC.ITEM_ID_PROD
                    , A.PLANT_ID
                    , A.RECEIVING_DTTM_YYYYMM;

/* 350 취합해서 넣기 */
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT DIVISION_ID
                 , COMPANY_ID
                 , PLANT_ID
                 , V_PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , TO_SITE
                 , '-' AS INCOTERMS
                 , '350' AS SEQ_FLAG
                 , YYYYMM
                 , NVL(SUM(NVL(QTY, 0)), 0) AS QTY
              FROM GT_PIS_350
             GROUP BY DIVISION_ID
                    , COMPANY_ID
                    , PLANT_ID
                    , ITEM_ID
                    , TO_PRODUCT
                    , TO_SITE
                    , YYYYMM;
/* 350 만들기 end */

/* 750 만들기 start */
            INSERT INTO GT_PIS_750
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID AS PLANT_ID
                 , V_PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , FC2.ITEM_ID_ASSY AS ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , A.LINE_ID AS LINE_ID
                 , 0 AS BOH_QTY,
                   '-' AS TO_SITE,  /* a.plant_id?? */
                   '-' AS INCOTERMS,  /* - 250에서 '-' 를 넣었으므로 모두 '-' 임. */
                   '750' AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD_LT, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(A.QTY, 0) * NVL(A.YIELD, 1)), 0) AS QTY
              FROM GT_PIS_450                 A  /* 12,984,  ==> 129,584   ==> 여기에 MAP 추가하기. */
                 , SCP_MST_CELL_PROD_ASSY_MAP FC
                 , SCP_MST_CELL_PROD_ASSY_MAP FC2
                 /* 아래부분 다시 추가함. */
                 , SCP_MST_FINAL_ITEM         FI
             WHERE FC.DIVISION_ID = V_DIVISION_ID /* '40'  -- A.DIVISION_ID */
               AND FC.ITEM_ID_ASSY = A.ITEM_ID
               AND FC.CELL_TYPE = 'CA1'
               AND FC.PLANT_ID = A.PLANT_ID
               AND FC.VALID_YN = 'Y'
               AND FC.ITEM_ID_ASSY NOT IN (SELECT DISTINCT SEGMENT1
                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM
                                            WHERE LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
                                              AND VALID_YN = 'Y')
               AND FC2.DIVISION_ID = V_DIVISION_ID /* '40' */
               AND FC2.ITEM_ID_PROD = FC.ITEM_ID_PROD
               AND FC2.CELL_TYPE = 'CA2'
               AND FC2.PLANT_ID = FC.PLANT_ID
               AND FC2.VALID_YN = 'Y'
               AND FI.DIVISION_ID = FC2.DIVISION_ID
               AND FI.OPERATION_GROUP = 'A'
               AND FI.ITEM_ID = FC2.ITEM_ID_ASSY   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
               AND FI.ATTRIBUTE8 = 'CA2'
               AND NVL(FI.TCO_CELL_YN, 'N') = 'Y'
               AND YYYYMMDD_LT <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , FC2.ITEM_ID_ASSY
                    , A.LINE_ID
                    , SUBSTR(A.YYYYMMDD_LT, 1, 6);

/* 2. aging */
            INSERT INTO GT_PIS_750
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID
                 , V_PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , FC2.ITEM_ID_ASSY AS ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE,
                   '-' AS TO_PRODUCT,   /* A.item_id as TO_PRODUCT, */
                   '-' AS LINE_ID
                 , 0 AS BOH_QTY,
                   '-' AS TO_SITE,  /* A.PLANT_ID as TO_SITE, */
                   '-' AS INCOTERMS
                 , '750' AS SEQ_FLAG
                 , A.RECEIVING_DTTM_YYYYMM AS YYYYMM
                 , NVL(SUM(NVL(QTY_INCLUDE_YIELD, 0)), 0) AS QTY
              FROM GT_PIS_INV                 A
                 , SCP_MST_CELL_PROD_ASSY_MAP FC
                 , SCP_MST_CELL_PROD_ASSY_MAP FC2
                 /* 아래부분 다시 추가함. */
                 , SCP_MST_FINAL_ITEM         FI
             WHERE FC.DIVISION_ID = V_DIVISION_ID /* '40'  -- A.DIVISION_ID */
               AND FC.ITEM_ID_ASSY = A.ITEM_ID
               AND FC.CELL_TYPE = 'CA1'
               AND FC.PLANT_ID = A.PLANT_ID
               AND FC.VALID_YN = 'Y'
               AND FC.ITEM_ID_ASSY NOT IN (SELECT DISTINCT SEGMENT1
                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM
                                            WHERE LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
                                              AND VALID_YN = 'Y')
               AND FC2.DIVISION_ID = V_DIVISION_ID /* '40' */
               AND FC2.ITEM_ID_PROD = FC.ITEM_ID_PROD
               AND FC2.CELL_TYPE = 'CA2'
               AND FC2.PLANT_ID = FC.PLANT_ID
               AND FC2.VALID_YN = 'Y'
               AND FI.DIVISION_ID = FC2.DIVISION_ID
               AND FI.OPERATION_GROUP = 'A'
               AND FI.ITEM_ID = FC2.ITEM_ID_ASSY   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
               AND FI.ATTRIBUTE8 = 'CA2'
               AND NVL(FI.TCO_CELL_YN, 'N') = 'Y'
               AND A.OPERATION_GROUP = 'A'
               AND A.ATTRIBUTE8 = 'CA1'
               AND NVL(A.TCO_CELL_YN, 'N') <> 'Y'
               AND (A.DESCR LIKE 'FOR%' OR A.DESCR = 'WH')  /* DESCR like 'FOR%' */
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , FC2.ITEM_ID_ASSY
                    , A.PLANT_ID
                    , A.RECEIVING_DTTM_YYYYMM;

/* 750 취합해서 넣기 */
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT DIVISION_ID
                 , COMPANY_ID
                 , PLANT_ID
                 , V_PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , TO_SITE
                 , '-' AS INCOTERMS
                 , '750' AS SEQ_FLAG
                 , YYYYMM
                 , NVL(SUM(NVL(QTY, 0)), 0) AS QTY
              FROM GT_PIS_750  /* 12,984,  ==> 129,584 */
             GROUP BY DIVISION_ID
                    , COMPANY_ID
                    , PLANT_ID
                    , ITEM_ID
                    , TO_PRODUCT
                    , TO_SITE
                    , YYYYMM;
/* 350 만들기 end */
/* 750 만들기 END */

/* 4번(추가) : 해당 아이템의 BOH가 가장 큰 Plant로 지정 */
            UPDATE GT_PIS_MAIN A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT NVL(MAX(B.COMPANY_ID), '-')
                          , NVL(MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'
                                         WHEN (B.SITE_TYPE = 'PLANT' AND B.PLANT_ID = 'KR02149300') THEN V_NJ_PLANT
                                         WHEN B.SITE_TYPE = 'PLANT' THEN B.PLANT_ID
                                         ELSE '-'
                                         END ), '-')
                       FROM SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = (SELECT FROM_SITE FROM (
                                               SELECT K.FROM_SITE
                                                 FROM GT_PIS_INV   K
                                                    , SCM_MST_SITE M
                                                WHERE M.DIVISION_ID = K.DIVISION_ID
                                                  AND M.SCM_SITE_ID = K.FROM_SITE
                                                  AND M.SITE_TYPE = 'PLANT'
                                                  AND K.DIVISION_ID = A.DIVISION_ID
                                                  AND (K.ITEM_ID = A.ITEM_ID OR K.ITEM_ID = NVL((SELECT MAX(ITEM_ID_ASSY)
                                                                                                   FROM SCP_MST_CELL_PROD_ASSY_MAP Z
                                                                                                  WHERE Z.DIVISION_ID = A.DIVISION_ID
                                                                                                    AND Z.ITEM_ID_PROD = A.ITEM_ID
                                                                                                    AND CELL_TYPE = 'CA1'
                                                                                                    AND VALID_YN = 'Y'), A.ITEM_ID))
                                                  AND K.QTY <> 0
                                                GROUP BY K.FROM_SITE, K.ITEM_ID
                                                ORDER BY SUM(K.QTY) DESC )
                                             WHERE ROWNUM = 1) )
             WHERE NVL(A.PLANT_ID, '-') < '0'
               AND A.SEQ_FLAG IN ('110', '210', '310', '610');

/* 5번(기존) */
            UPDATE GT_PIS_MAIN A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT NVL(MAX(B.COMPANY_ID), '-')
                          , NVL(MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'
                                         WHEN (B.SITE_TYPE = 'PLANT' AND B.PLANT_ID = 'KR02149300') THEN V_NJ_PLANT
                                         WHEN B.SITE_TYPE = 'PLANT' THEN B.PLANT_ID
                                         ELSE '-'
                                         END ), '-')
                       FROM SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = (SELECT MAX(K.FROM_SITE)
                                               FROM SCP_ANL_SHIPMENT_PLAN_FG K
                                              WHERE K.TO_SITE = A.TO_SITE
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
             WHERE NVL(A.PLANT_ID, '-') < '0'
               AND A.SEQ_FLAG IN ('110', '210', '310', '610');

            UPDATE GT_PIS_MAIN A
               SET A.COMPANY_ID = ( SELECT MIN(B.COMPANY_ID)
                                      FROM SCM_MST_SITE B
                                     WHERE B.DIVISION_ID = A.DIVISION_ID
                                       AND B.OPERATION_GROUP = A.OPERATION_GROUP
                                       AND B.PLANT_ID = A.PLANT_ID )
             WHERE A.PLANT_ID = V_NJ_PLANT
               AND NVL(A.COMPANY_ID, '-') <> ( SELECT MIN(B.COMPANY_ID)
                                                 FROM SCM_MST_SITE B
                                                WHERE B.DIVISION_ID = A.DIVISION_ID
                                                  AND B.OPERATION_GROUP = A.OPERATION_GROUP
                                                  AND B.PLANT_ID = A.PLANT_ID );

/* -- plant do 3, 4 작업 수행. end ---- */
            V_STATUS_DESC := '6.BOH inv';
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID AS DIVISION_ID
                 , NVL(A.COMPANY_ID, '-')
                 , NVL(A.PLANT_ID, '-')
                 , V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , A.OPERATION_GROUP AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , 'INV' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , NVL(SUM(NVL(A.QTY, 0)), 0) AS BOH_QTY
                 , '-' AS TO_SITE
                 , '-' AS INCOTERMS
                 , (CASE WHEN A.OPERATION_GROUP = 'P' AND A.FLOW_ID IN ('P5500', 'P9500')     THEN '160'
                         WHEN A.OPERATION_GROUP = 'P' AND A.FLOW_ID NOT IN ('P5500', 'P9500') THEN '260'
                         WHEN A.OPERATION_GROUP = 'A' AND SUBSTR(A.ATTRIBUTE8, 1, 2) = 'CP' AND A.TCO_CELL_YN = 'Y' THEN '660'
                         WHEN A.OPERATION_GROUP = 'A' AND SUBSTR(A.ATTRIBUTE8, 1, 2) = 'CP' THEN '360'
                         WHEN A.OPERATION_GROUP = 'A' AND SUBSTR(A.ATTRIBUTE8, 1, 2) = 'CA' AND A.TCO_CELL_YN = 'Y' THEN '760'
                         WHEN A.OPERATION_GROUP = 'A' AND SUBSTR(A.ATTRIBUTE8, 1, 2) = 'CA' THEN '460'
                         END ) AS SEQ_FLAG
                 , SUBSTR(V_PLAN_START_YYYYMMDD, 1, 6) AS YYYYMM
                 , 0
              FROM GT_PIS_INV A
             WHERE A.OPERATION_GROUP IN ('A', 'P')
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.OPERATION_GROUP
                    , A.ITEM_ID
                    , (CASE WHEN A.OPERATION_GROUP = 'P' AND A.FLOW_ID IN ('P5500', 'P9500')     THEN '160'
                            WHEN A.OPERATION_GROUP = 'P' AND A.FLOW_ID NOT IN ('P5500', 'P9500') THEN '260'
                            WHEN A.OPERATION_GROUP = 'A' AND SUBSTR(A.ATTRIBUTE8, 1, 2) = 'CP' AND A.TCO_CELL_YN = 'Y' THEN '660'
                            WHEN A.OPERATION_GROUP = 'A' AND SUBSTR(A.ATTRIBUTE8, 1, 2) = 'CP' THEN '360'
                            WHEN A.OPERATION_GROUP = 'A' AND SUBSTR(A.ATTRIBUTE8, 1, 2) = 'CA' AND A.TCO_CELL_YN = 'Y' THEN '760'
                            WHEN A.OPERATION_GROUP = 'A' AND SUBSTR(A.ATTRIBUTE8, 1, 2) = 'CA' THEN '460'
                            END );

            V_STATUS_DESC := '6.BOH inv E';

/* ------ 220, 240 (pack 반제품)  start */
            V_STATUS_DESC := '220, 240  1';
            INSERT INTO GT_PIS_220_240
                ( DIVISION_ID, COMPANY_ID, TO_COMPANY_ID, PLANT_ID, TO_PLANT_ID, BOD_ID, PLAN_START_YYYYMMDD
                , SEQ, OPERATION_GROUP, FROM_SITE, ITEM_ID, TO_SITE, INCOTERMS, QTY, LT_TOTAL_SSP
                , DEPARTURE_YYYYMMDD, ARRIVAL_YYYYMMDD )
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID
                 , X.COMPANY_ID AS TO_COMPANY_ID
                 , NVL((CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
                             ELSE B.PLANT_ID
                             END ), '-') AS PLANT_ID
                 , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.TO_SITE
                         WHEN (X.SITE_TYPE = 'PLANT' AND X.PLANT_ID = 'KR02149300') THEN V_NJ_PLANT
                         WHEN X.SITE_TYPE = 'PLANT' THEN X.PLANT_ID
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
                 , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD') + TRUNC(C.LT_TOTAL_SSP), 'YYYYMMDD') AS ARRIVAL_YYYYMMDD
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI A  /* '40' 에는 P 로 모두 제품 반제품만 있는 것 같음. */
                 , SCM_MST_SITE               B
                 , SCM_MST_SITE               X
                 , SCP_MST_BOD_N_V            C
                 , SCP_MST_FINAL_ITEM         FI
             WHERE B.DIVISION_ID(+) = A.DIVISION_ID
               AND B.SCM_SITE_ID(+) = A.FROM_SITE
               AND X.DIVISION_ID(+) = A.DIVISION_ID
               AND X.SCM_SITE_ID(+) = A.TO_SITE
               AND A.DIVISION_ID = C.DIVISION_ID(+)
               AND A.BOD_ID = C.BOD_ID(+)
               AND FI.ITEM_ID = A.ITEM_ID
               AND FI.DIVISION_ID = A.DIVISION_ID
               AND FI.FLOW_ID = 'P5000'
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'SHIP_PLAN_AMEND'
               AND A.OPERATION_GROUP = 'P'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD;

            /* 220 운송중 재고 포함하기. */
            INSERT INTO GT_PIS_220_240
                ( DIVISION_ID, COMPANY_ID, TO_COMPANY_ID, PLANT_ID, TO_PLANT_ID, BOD_ID, PLAN_START_YYYYMMDD
                , SEQ, OPERATION_GROUP, FROM_SITE, ITEM_ID, TO_SITE, INCOTERMS, QTY, LT_TOTAL_SSP
                , DEPARTURE_YYYYMMDD, ARRIVAL_YYYYMMDD )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.COMPANY_ID AS TO_COMPANY_ID
                 , A.PLANT_ID AS PLANT_ID
                 , A.PLANT_ID AS TO_PLANT_ID
                 , '-' AS BOD_ID
                 , V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , A.OPERATION_GROUP AS OPERATION_GROUP
                 , A.FROM_SITE
                 , A.ITEM_ID
                 , A.FROM_SITE AS TO_SITE
                 , '-' AS INCOTERMS
                 , A.QTY,
                   0 AS LT_TOTAL_SSP,  /* STOCK PLAN 값을 수작업으로 가져와서 LT_TOTAL_SSP는 불필요해서 0으로 셋팅함. */
                   (CASE WHEN A.RECEIVING_DTTM_YYYYMM IS NULL THEN NULL ELSE A.RECEIVING_DTTM_YYYYMM || '01' END) AS DEPARTURE_YYYYMMDD
                 , (CASE WHEN A.RECEIVING_DTTM_YYYYMM IS NULL THEN NULL ELSE A.RECEIVING_DTTM_YYYYMM || '01' END) AS ARRIVAL_YYYYMMDD
              FROM GT_PIS_INV A
             WHERE A.DESCR LIKE 'INT%'
               AND A.OPERATION_GROUP = 'P'
               AND A.FLOW_ID = 'P5000';

            V_STATUS_DESC := '220. 2.SHIP_PLAN_SEMI';
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT DIVISION_ID
                 , COMPANY_ID
                 , PLANT_ID
                 , PLAN_START_YYYYMMDD,
                   1 AS SEQ,   /* 최종 넣을때는 꼭 1로 넣어야 함. */
                   'P' AS OPERATION_GROUP
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
                 , '220' AS SEQ_FLAG
                 , SUBSTR(A.ARRIVAL_YYYYMMDD, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(QTY, 0)), 0) AS QTY
              FROM GT_PIS_220_240 A
             WHERE A.ARRIVAL_YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY DIVISION_ID
                    , COMPANY_ID
                    , PLANT_ID
                    , PLAN_START_YYYYMMDD
                    , ITEM_ID
                    , TO_PLANT_ID
                    , INCOTERMS
                    , SUBSTR(A.ARRIVAL_YYYYMMDD, 1, 6);

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 3. 셀 제품 ( N/A : 없음) */
            /* 4.Semi WH-IN */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '240.  4.Semi WH-IN';
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT DIVISION_ID
                 , TO_COMPANY_ID
                 , TO_PLANT_ID
                 , PLAN_START_YYYYMMDD,
                   1 AS SEQ,   /* 최종 넣을때는 꼭 1로 넣어야 함. */
                   'P' AS OPERATION_GROUP
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
                 , '240' AS SEQ_FLAG
                 , SUBSTR(A.ARRIVAL_YYYYMMDD, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(QTY, 0)), 0) AS QTY
              FROM GT_PIS_220_240 A
             WHERE PLANT_ID <> TO_PLANT_ID
               AND A.ARRIVAL_YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY DIVISION_ID
                    , TO_COMPANY_ID
                    , TO_PLANT_ID
                    , PLAN_START_YYYYMMDD
                    , ITEM_ID
                    , SUBSTR(A.ARRIVAL_YYYYMMDD, 1, 6);
/* -220, 240 (pack 반제품)  end */

            V_STATUS_DESC := 'bbb  1';
            INSERT INTO GT_PIS_320_340
                ( DIVISION_ID, COMPANY_ID, TO_COMPANY_ID, PLANT_ID, TO_PLANT_ID, BOD_ID, PLAN_START_YYYYMMDD
                , SEQ, OPERATION_GROUP, FROM_SITE, ITEM_ID, TO_SITE, INCOTERMS, QTY, LT_TOTAL_SSP
                , DEPARTURE_YYYYMMDD, ARRIVAL_YYYYMMDD )
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID
                 , X.COMPANY_ID AS TO_COMPANY_ID
                 , NVL((CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
                             ELSE B.PLANT_ID
                             END ), '-') AS PLANT_ID
                 , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.TO_SITE
                         WHEN (X.SITE_TYPE = 'PLANT' AND X.PLANT_ID = 'KR02149300') THEN V_NJ_PLANT
                         WHEN X.SITE_TYPE = 'PLANT' THEN X.PLANT_ID
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
                 , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD') + TRUNC(C.LT_TOTAL_SSP), 'YYYYMMDD') AS ARRIVAL_YYYYMMDD
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                 , SCP_MST_FINAL_ITEM         FI
                 , SCM_MST_SITE               B
                 , SCM_MST_SITE               X
                 , SCP_MST_BOD_N_V            C
             WHERE FI.DIVISION_ID = A.DIVISION_ID
               AND FI.OPERATION_GROUP = 'A'
               AND FI.ITEM_ID = A.ITEM_ID   /* in ('MIF469958A11-I07', 'MCCH114030D3-M04') */
               AND SUBSTR(FI.ATTRIBUTE8, 1, 2) = 'CP'  /* CP:제품, CA:반제품 */
               AND NVL(FI.TCO_CELL_YN, 'N') <> 'Y'  /* 'Y':후공정, <>'Y':후공정아님. */
               AND B.DIVISION_ID(+) = A.DIVISION_ID
               AND B.SCM_SITE_ID(+) = A.FROM_SITE
               AND X.DIVISION_ID(+) = A.DIVISION_ID
               AND X.SCM_SITE_ID(+) = A.TO_SITE
               AND A.DIVISION_ID = C.DIVISION_ID(+)
               AND A.BOD_ID = C.BOD_ID(+)
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'SHIP_PLAN_AMEND'
               AND A.OPERATION_GROUP = 'A'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD;

            INSERT INTO GT_PIS_320_340
                ( DIVISION_ID, COMPANY_ID, TO_COMPANY_ID, PLANT_ID, TO_PLANT_ID, BOD_ID, PLAN_START_YYYYMMDD
                , SEQ, OPERATION_GROUP, FROM_SITE, ITEM_ID, TO_SITE, INCOTERMS, QTY, LT_TOTAL_SSP
                , DEPARTURE_YYYYMMDD, ARRIVAL_YYYYMMDD )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.COMPANY_ID AS TO_COMPANY_ID
                 , A.PLANT_ID AS PLANT_ID
                 , A.PLANT_ID AS TO_PLANT_ID
                 , '-' AS BOD_ID
                 , V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , A.OPERATION_GROUP AS OPERATION_GROUP
                 , A.FROM_SITE
                 , A.ITEM_ID
                 , A.FROM_SITE AS TO_SITE
                 , '-' AS INCOTERMS
                 , A.QTY
                 , 0 AS LT_TOTAL_SSP
                 , (CASE WHEN A.RECEIVING_DTTM_YYYYMM IS NULL THEN NULL ELSE A.RECEIVING_DTTM_YYYYMM || '01' END) AS DEPARTURE_YYYYMMDD
                 , (CASE WHEN A.RECEIVING_DTTM_YYYYMM IS NULL THEN NULL ELSE A.RECEIVING_DTTM_YYYYMM || '01' END) AS ARRIVAL_YYYYMMDD
              FROM GT_PIS_INV A
             WHERE A.DESCR LIKE 'INT%'
               AND A.OPERATION_GROUP = 'A'
               AND SUBSTR(A.ATTRIBUTE8, 1, 2) = 'CP'
               AND NVL(A.TCO_CELL_YN, 'N') <> 'Y';

            V_STATUS_DESC := 'bbb  320';
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
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
                 , SUBSTR(A.ARRIVAL_YYYYMMDD, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(QTY, 0)), 0) AS QTY
              FROM GT_PIS_320_340 A
             WHERE PLANT_ID <> TO_PLANT_ID
               AND A.ARRIVAL_YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY DIVISION_ID
                    , COMPANY_ID
                    , PLANT_ID
                    , PLAN_START_YYYYMMDD
                    , ITEM_ID
                    , TO_PLANT_ID
                    , INCOTERMS
                    , SUBSTR(A.ARRIVAL_YYYYMMDD, 1, 6);

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 3. 셀 제품 ( N/A : 없음) */
            /* 4.Semi WH-IN */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '4.Semi WH-IN';
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
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
                 , SUBSTR(A.ARRIVAL_YYYYMMDD, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(QTY, 0)), 0) AS QTY
              FROM GT_PIS_320_340 A
             WHERE PLANT_ID <> TO_PLANT_ID
               AND A.ARRIVAL_YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY DIVISION_ID
                    , TO_COMPANY_ID
                    , TO_PLANT_ID
                    , PLAN_START_YYYYMMDD
                    , ITEM_ID
                    , SUBSTR(A.ARRIVAL_YYYYMMDD, 1, 6);

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 3. 셀 제품 ( N/A : 없음) */
            /* 3.IN_HOUSE_MOVING */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '3.IN_HOUSE_MOVING';
            INSERT INTO GT_PIS_230_ITEM
            SELECT DISTINCT A.ITEM_ID
              FROM GT_PIS_MAIN                    A
                 , SCM_MST_SITE                   X
                 , SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                 , SCP_MST_FINAL_ITEM             C
             WHERE X.DIVISION_ID = A.DIVISION_ID
               AND X.PLANT_ID = A.PLANT_ID
               AND X.OPERATION_GROUP = 'P'
               AND B.DIVISION_ID = A.DIVISION_ID
               AND B.PLANT_ID = (CASE WHEN X.OSP_YN = 'Y' THEN X.LOGISTIC_PLANT_ID
                                      ELSE A.PLANT_ID
                                      END )
               AND B.MODEL_ID = A.ITEM_ID
               AND TO_DATE(A.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN B.EFF_START_DATE AND B.EFF_END_DATE
               AND C.ITEM_ID = B.CHILD_ITEM_ID
               AND C.DIVISION_ID = A.DIVISION_ID
               AND C.FLOW_ID = 'P5000'
               AND A.SEQ_FLAG IN ('150', '250');

            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
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
                 , A.ITEM_ID AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , A.PLANT_ID AS TO_SITE
                 , '-' AS INCOTERMS
                 , '330' AS SEQ_FLAG
                 , A.YYYYMM,
                   NVL(SUM(NVL(A.QTY, 0) * NVL(B.ACCUMULATED_CHILD_QTY, 1)), 0) AS QTY  /* pack, cell 수율반영 */
              FROM GT_PIS_MAIN                    A
                 , SCM_MST_SITE                   X
                 , SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                 , SCP_MST_FINAL_ITEM             C
             WHERE X.DIVISION_ID(+) = A.DIVISION_ID
               AND X.PLANT_ID(+) = A.PLANT_ID
               AND X.OPERATION_GROUP(+) = 'P'
               AND B.DIVISION_ID = A.DIVISION_ID
               AND B.PLANT_ID = (CASE WHEN X.OSP_YN = 'Y' THEN X.LOGISTIC_PLANT_ID
                                      ELSE A.PLANT_ID
                                      END )
               AND B.MODEL_ID = A.ITEM_ID
               AND TO_DATE(A.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN B.EFF_START_DATE AND B.EFF_END_DATE
               AND C.ITEM_ID = B.CHILD_ITEM_ID
               AND C.DIVISION_ID = A.DIVISION_ID
               AND C.OPERATION_GROUP_ID = 'A'
               AND C.ATTRIBUTE8 = 'CP'
               AND NVL(C.TCO_CELL_YN, 'N') <> 'Y'
               AND A.SEQ_FLAG = '150'
               AND A.ITEM_ID NOT IN ( SELECT XI.ITEM_ID FROM GT_PIS_230_ITEM XI )
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.PLAN_START_YYYYMMDD
                    , A.CELL_ITEM_ID
                    , B.CHILD_ITEM_ID
                    , A.ITEM_ID
                    , A.YYYYMM;

            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
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
                 , A.ITEM_ID AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , A.PLANT_ID AS TO_SITE
                 , '-' AS INCOTERMS
                 , '330' AS SEQ_FLAG
                 , A.YYYYMM,
                   NVL(SUM(NVL(A.QTY, 0) * NVL(B.ACCUMULATED_CHILD_QTY, 1) / NVL(YH.YIELD, 1)), 0) AS QTY  /* pack, cell 수율반영 */
              FROM GT_PIS_MAIN                    A
                 , SCM_MST_SITE                   X
                 , SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                 , SCP_MST_FINAL_ITEM             C
                 , SCM_MST_YIELD_VER_H_V          YH
             WHERE X.DIVISION_ID(+) = A.DIVISION_ID
               AND X.PLANT_ID(+) = A.PLANT_ID
               AND X.OPERATION_GROUP(+) = 'P'
               AND B.DIVISION_ID = A.DIVISION_ID
               AND B.PLANT_ID = (CASE WHEN X.OSP_YN = 'Y' THEN X.LOGISTIC_PLANT_ID
                                      ELSE A.PLANT_ID
                                      END )
               AND B.MODEL_ID = A.ITEM_ID
               AND TO_DATE(A.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN B.EFF_START_DATE AND B.EFF_END_DATE
               AND C.ITEM_ID = B.CHILD_ITEM_ID
               AND C.DIVISION_ID = A.DIVISION_ID
               AND C.OPERATION_GROUP_ID = 'A'
               AND C.ATTRIBUTE8 = 'CP'
               AND NVL(C.TCO_CELL_YN, 'N') <> 'Y'
               AND YH.DIVISION_ID = A.DIVISION_ID  /* '40' */
               AND YH.COMPANY_ID = A.COMPANY_ID  /* 'G180' */
               AND YH.PLANT_ID = A.PLANT_ID  /* @NJ_PLANT */
               AND YH.ITEM_ID = A.ITEM_ID  /* 'AMDMO0001A' */
               AND YH.LINE_ID = A.LINE_ID  /* 'PDQ01' */
               AND YH.MONTH = A.YYYYMM  /* '202409' */
               AND A.SEQ_FLAG = '250'
               AND A.ITEM_ID IN ( SELECT XI.ITEM_ID FROM GT_PIS_230_ITEM XI )
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.PLAN_START_YYYYMMDD
                    , A.CELL_ITEM_ID
                    , B.CHILD_ITEM_ID
                    , A.ITEM_ID
                    , A.YYYYMM;

            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'P' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , A.CELL_ITEM_ID
                 , B.CHILD_ITEM_ID
                 , 'IN_HOUSE_MOVING' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , A.ITEM_ID AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , A.PLANT_ID AS TO_SITE
                 , '-' AS INCOTERMS
                 , '230' AS SEQ_FLAG
                 , A.YYYYMM,
                   NVL(SUM(NVL(A.QTY, 0) * NVL(B.ACCUMULATED_CHILD_QTY, 1)), 0) AS QTY  /* pack, cell 수율반영 */
              FROM GT_PIS_MAIN                    A
                 , SCM_MST_SITE                   X
                 , SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                 , SCP_MST_FINAL_ITEM             C
             WHERE X.DIVISION_ID(+) = A.DIVISION_ID
               AND X.PLANT_ID(+) = A.PLANT_ID
               AND X.OPERATION_GROUP(+) = 'P'
               AND B.DIVISION_ID = A.DIVISION_ID
               AND B.PLANT_ID = (CASE WHEN X.OSP_YN = 'Y' THEN X.LOGISTIC_PLANT_ID
                                      ELSE A.PLANT_ID
                                      END )
               AND B.MODEL_ID = A.ITEM_ID
               AND TO_DATE(A.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN B.EFF_START_DATE AND B.EFF_END_DATE
               AND C.ITEM_ID = B.CHILD_ITEM_ID
               AND C.DIVISION_ID = A.DIVISION_ID
               AND C.OPERATION_GROUP = 'P'
               AND C.FLOW_ID = 'P5000'
               AND A.SEQ_FLAG = '150'
               AND A.ITEM_ID IN ( SELECT XI.ITEM_ID FROM GT_PIS_230_ITEM XI )
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.PLAN_START_YYYYMMDD
                    , A.CELL_ITEM_ID
                    , B.CHILD_ITEM_ID
                    , A.ITEM_ID
                    , A.YYYYMM;

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 5. 전극 ( N/A : 없음) */
            /* 3.IN_HOUSE_MOVING */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '3.IN_HOUSE_MOVING  EE';
            /* 원본: select ... into #tmp_YIELD_VER_H_V_A_small → DELETE + INSERT (인덱스는 GTT DDL) */
            DELETE FROM GT_PIS_YIELD_A;
            INSERT INTO GT_PIS_YIELD_A
            SELECT Y.OPERATION_GROUP, A.VERSION_ID, A.DIVISION_ID, A.COMPANY_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.MONTH, A.YIELD
              FROM SCM_MST_YIELD_VER_H_V A
                 , ( SELECT DISTINCT SEGMENT4 AS OPERATION_ID, SEGMENT5 AS OPERATION_GROUP
                       FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                      WHERE B.LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                        AND B.VALID_YN = 'Y'
                        AND B.SEGMENT3 = 'Y'
                        AND B.SEGMENT5 = 'A' ) Y
             WHERE A.OPERATION_ID = Y.OPERATION_ID
               AND 1 = 1
               AND A.DIVISION_ID = V_DIVISION_ID;
            /* 원본: create index i_tmp_YIELD_VER_H_V_A_small_01 on ...(item_id) → GTT DDL(IX_PIS_YIELD_A_01) */

            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID,
/* substring(a.plant_id,1, len(a.plant_id)-1) + convert(nvarchar(1),convert(int, right(a.plant_id,1)) + 1) as plant_id,  -- 전극 Plant    -- 아래로 대체. */
/* 1,2,3순위 조건 추가(2024.12.31) start */
                   /* 2025.02.12 변경전 (case  when exists (select y from scm_mst_site x where x.site_type = PLANT and x.valid_yn = Y and x.company_id = a.company_id and x.division_id = a.division_id and x.plant_id = a.plant_id and x.operation_group = E)  then (select top 1 plant_id ...) */
                   /* 2025.02.12 변경전 		when exists (select y from scm_mst_site x where ... and x.operation_group = E)  then (select top 1 plant_id ...) */
                   /* 2025.02.12 변경전		else (select top 1 plant_id from scm_mst_site k where ... and k.operation_group = E ) */
                   /* 2025.02.12 변경전		end) as plant_id,  -- 전극 Plant */
/* 1,2,3순위 조건 추가(2024.12.31) end */
                   EP.PLANT_ID_ES AS PLANT_ID,		/* 2025.02.12 cell/전극 plant 매핑 로직 수정 */
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
                 , FLOOR(NVL(SUM(A.QTY * NVL(B.USAGE, 1) / NVL(Y.YIELD, 1)), 0)) AS QTY
              FROM GT_PIS_MAIN           A
                 , SCP_MST_BOM_ELEC      B
                 /* pack/cell 수율 반영 start */
                 , GT_PIS_YIELD_A        Y
                 , GT_PIS_CELL_ELEC_MAP  EP	/* 2025.02.12 cell/전극 plant 매핑 로직 수정 (2순위 적용) */
             WHERE B.DIVISION_ID = V_DIVISION_ID
               AND B.PARENT_ITEM_ID = A.ITEM_ID
               AND B.SCP_YN = 'Y'
               AND Y.DIVISION_ID(+) = A.DIVISION_ID
               AND Y.OPERATION_GROUP(+) = A.OPERATION_GROUP
               AND Y.COMPANY_ID(+) = A.COMPANY_ID
               AND Y.LINE_ID(+) = A.LINE_ID
               AND Y.MONTH(+) = A.YYYYMM
               AND Y.ITEM_ID(+) = A.ITEM_ID
               AND EP.CELL_PLANT_PRIORITY(+) = 1
               AND EP.DIVISION_ID_CS(+) = A.DIVISION_ID
               AND EP.COMPANY_ID_CS(+)  = A.COMPANY_ID
               AND EP.PLANT_ID_CS(+)    = A.PLANT_ID
               AND A.SEQ_FLAG = '450'
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID,
                      /* 2025.02.12 변경전 소스 substring(a.plant_id,1, len(a.plant_id)-1) 등 → EP.PLANT_ID_ES 로 대체 */
                      EP.PLANT_ID_ES,  /* 2025.02.12 전극 plant 매핑 로직 수정 */
                      A.PLAN_START_YYYYMMDD
                    , B.CHILD_ITEM_ID
                    , A.PLANT_ID
                    , A.YYYYMM;

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 5. 전극 : 5.PROD_PLAN  (원본 SET @V_STATUS_DESC 만 존재) */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '5.PROD_PLAN  EE';

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 9.1  CELL_ITEM_ID UPDATE */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := 'CELL_ITEM_ID Pack';
            /* 원본: select model_id, child_item_id into #tmp_FINAL_ITEM_BOM_V_small → DELETE + INSERT (인덱스는 GTT DDL) */
            DELETE FROM GT_PIS_ITEM_BOM;
            INSERT INTO GT_PIS_ITEM_BOM
            SELECT MODEL_ID, CHILD_ITEM_ID
              FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Y
             WHERE Y.CELL_TYPE          = 'CP'
               AND Y.OPERATION_GROUP_ID = 'A'
               AND Y.DIVISION_ID        = V_DIVISION_ID;  /* 3742 */
            /* 원본: create index i_tmp_FINAL_ITEM_BOM_V_small_01 on ...(model_id) → GTT DDL(IX_PIS_ITEM_BOM_01) */

            /* PACK 일경우 : CELL_ITEM_ID 적용 */
            UPDATE GT_PIS_MAIN X
               SET X.CELL_ITEM_ID = NVL(( SELECT CHILD_ITEM_ID
                                            FROM GT_PIS_ITEM_BOM Y
                                           WHERE Y.MODEL_ID = X.ITEM_ID
                                             AND ROWNUM = 1), '-')
             WHERE X.OPERATION_GROUP = 'P'
               AND SUBSTR(X.SEQ_FLAG, 1, 1) <> '5'  /* 전극 제외 */
               AND (X.CELL_ITEM_ID IS NULL OR X.CELL_ITEM_ID < '0');

            /* 상위 모델 이용하여 CELL_ITEM_ID 적용 */
            UPDATE GT_PIS_MAIN X
               SET X.CELL_ITEM_ID = NVL(( SELECT CHILD_ITEM_ID
                                            FROM GT_PIS_ITEM_BOM Y
                                           WHERE Y.MODEL_ID = ( SELECT MODEL_ID
                                                                  FROM SCM_MST_MODEL_ONE_LEVEL_BOM_V Y2
                                                                 WHERE Y2.DIVISION_ID = X.DIVISION_ID
                                                                   AND Y2.CHILD_ITEM_ID = X.ITEM_ID
                                                                   AND Y2.PLANT_ID = X.PLANT_ID
                                                                   AND ROWNUM = 1)
                                             AND ROWNUM = 1), '-')
             WHERE X.OPERATION_GROUP = 'P'
               AND SUBSTR(X.SEQ_FLAG, 1, 1) <> '5'
               AND (X.CELL_ITEM_ID IS NULL OR X.CELL_ITEM_ID < '0');

            V_STATUS_DESC := 'CELL_ITEM_ID Cell';
            /* CELL 일경우 : 원본 ;WITH CP_INFO(ROW_NUMBER 3종) + UPDATE...FROM(INNER F + LEFT C1/C2/C3) */
            /* → CP_INFO priority=1 = 파티션별 MIN(ITEM_ID_PROD) (VALID_YN='Y' 필터) 상관 서브쿼리로 재현. */
            /* F(SCP_MST_FINAL_ITEM_V) 는 INNER JOIN 이므로 EXISTS 가드. */
            UPDATE GT_PIS_MAIN X
               SET X.CELL_ITEM_ID = NVL(( SELECT CASE WHEN F.CELL_TYPE LIKE 'CA%'
                                                      THEN NVL(NVL(NVL(
                                                             ( SELECT MIN(M.ITEM_ID_PROD) FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                                                WHERE M.VALID_YN = 'Y' AND M.DIVISION_ID = X.DIVISION_ID AND M.PLANT_ID = X.PLANT_ID AND M.ITEM_ID_ASSY = X.ITEM_ID)
                                                           , ( SELECT MIN(M.ITEM_ID_PROD) FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                                                WHERE M.VALID_YN = 'Y' AND M.DIVISION_ID = X.DIVISION_ID AND M.ITEM_ID_ASSY = X.ITEM_ID))
                                                           , ( SELECT MIN(M.ITEM_ID_PROD) FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                                                WHERE M.VALID_YN = 'Y' AND M.ITEM_ID_ASSY = X.ITEM_ID))
                                                           , X.ITEM_ID)
                                                      ELSE X.ITEM_ID
                                                      END
                                            FROM SCP_MST_FINAL_ITEM_V F
                                           WHERE F.ITEM_ID = X.ITEM_ID
                                             AND ROWNUM = 1), '-')
             WHERE X.OPERATION_GROUP = 'A'
               AND SUBSTR(X.SEQ_FLAG, 1, 1) <> '5'
               AND (X.CELL_ITEM_ID IS NULL OR X.CELL_ITEM_ID < '0')
               AND EXISTS ( SELECT 1 FROM SCP_MST_FINAL_ITEM_V F WHERE F.ITEM_ID = X.ITEM_ID );

            V_STATUS_DESC := 'CELL_ITEM_ID MEB';
            /* -------------------------------------------------- */
            /* PJ20214997 ... MEB biz. 적용 - CELL_ITEM_ID update - start */
            /* 원본 UPDATE...FROM INNER JOIN (파생 Z) → 상관 서브쿼리(MIN) + EXISTS 가드 */
            /* -------------------------------------------------- */
            UPDATE GT_PIS_MAIN X
               SET X.CELL_ITEM_ID = NVL(( SELECT NVL(MIN(Z.CELL_ITEM_ID), '-')
                                            FROM ( SELECT DISTINCT Z.MODEL_ID AS ITEM_ID, Z.CHILD_ITEM_ID AS CELL_ITEM_ID, Z.ACCUMULATED_CHILD_QTY AS CELL_QTY_PACK, Y.MODULE_ID, Y.MODULE_QTY_PACK
                                                     FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Z
                                                        , ( SELECT BS.DIVISION_ID, BS.MODEL_ID, BS.CHILD_ITEM_ID AS MODULE_ID, BS.CHILD_QTY AS MODULE_QTY_PACK
                                                              FROM SCM_MST_BOM_SN_V BS	/* 2021-03-09	SCP 대치 BOM 적용 */
                                                                 , SCM_MST_ITEM_SN   I
                                                             WHERE BS.CHILD_DIVISION_ID = I.DIVISION_ID
                                                               AND BS.CHILD_ITEM_ID     = I.ITEM_ID
                                                               AND I.FLOW_ID = 'P5200'
                                                               AND BS.CHILD_COMPANY_ID  = I.COMPANY_ID /* A002 빈강 추가 따른 조건 추가 */
                                                               AND BS.CHILD_SITE_ID     = I.SITE_ID
                                                               AND I.ACTIVE_FLAG        = 'Y'
                                                               AND BS.DIVISION_ID       = P_DIVISION_ID /* CSR E20250829-001508 속도개선위해 추가 */
                                                               AND 1 = 1
                                                          ) Y
                                                    WHERE Z.DIVISION_ID        = Y.DIVISION_ID
                                                      AND Z.MODEL_ID           = Y.MODEL_ID
                                                      AND Z.CELL_TYPE          = 'CP' /* 2023.06.08 활성화코드 분리 대응(Cell Product 조건 추가) */
                                                      AND Z.OPERATION_GROUP_ID = 'A'
                                                      AND Z.DIVISION_ID        = P_DIVISION_ID  /* CSR E20250829-001508 속도개선위해 추가 */
                                                 ) Z
                                           WHERE Z.MODULE_ID = X.ITEM_ID ), '-')
             WHERE X.ATTRIBUTE9 = 'P5200'
               AND SUBSTR(X.SEQ_FLAG, 1, 1) <> '5'
               AND (X.CELL_ITEM_ID IS NULL OR X.CELL_ITEM_ID < '0')
               AND EXISTS ( SELECT 1
                              FROM ( SELECT DISTINCT Z.MODEL_ID AS ITEM_ID, Z.CHILD_ITEM_ID AS CELL_ITEM_ID, Z.ACCUMULATED_CHILD_QTY AS CELL_QTY_PACK, Y.MODULE_ID, Y.MODULE_QTY_PACK
                                       FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Z
                                          , ( SELECT BS.DIVISION_ID, BS.MODEL_ID, BS.CHILD_ITEM_ID AS MODULE_ID, BS.CHILD_QTY AS MODULE_QTY_PACK
                                                FROM SCM_MST_BOM_SN_V BS
                                                   , SCM_MST_ITEM_SN   I
                                               WHERE BS.CHILD_DIVISION_ID = I.DIVISION_ID
                                                 AND BS.CHILD_ITEM_ID     = I.ITEM_ID
                                                 AND I.FLOW_ID = 'P5200'
                                                 AND BS.CHILD_COMPANY_ID  = I.COMPANY_ID
                                                 AND BS.CHILD_SITE_ID     = I.SITE_ID
                                                 AND I.ACTIVE_FLAG        = 'Y'
                                                 AND BS.DIVISION_ID       = P_DIVISION_ID
                                                 AND 1 = 1
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
            /* 5.PROD_PLAN */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '5.PROD_PLAN 222';
            INSERT INTO GT_PIS_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT I.DIVISION_ID
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
                 , I.PLANT_ID AS TO_SITE
                 , '-' AS INCOTERMS
                 , '230' AS SEQ_FLAG
                 , I.YYYYMM
                 , NVL(SUM(NVL(I.QTY, 0) * NVL(A.ACCUMULATED_CHILD_QTY, 1)), 0) AS QTY
              FROM GT_PIS_MAIN                 I
                 , SCM_MST_BOM_EFFECTIVE_SN_V  A
                 , SCM_MST_ITEM_SN             B
             WHERE A.MODEL_ID(+) = I.ITEM_ID
               AND A.PARENT_ITEM_ID(+) = I.ITEM_ID
               AND A.DIVISION_ID(+) = I.DIVISION_ID
               AND A.COMPANY_ID(+) = I.COMPANY_ID
               AND A.PLANT_ID(+) = I.PLANT_ID
               AND TO_DATE(I.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN A.EFF_START_DATE(+) AND A.EFF_END_DATE(+)
               AND (A.ALT_ID(+) IS NULL
                    OR (A.ALT_ID(+) IS NOT NULL AND A.SCP_PLAN_YN(+) IS NULL AND NVL(A.ALT_PRIORITY(+), '1') = 'Y')
                    OR (A.ALT_ID(+) IS NOT NULL AND A.SCP_PLAN_YN(+) IS NOT NULL AND A.SCP_PLAN_YN(+) = 'Y'))
               AND A.DIVISION_ID = B.DIVISION_ID
               AND A.COMPANY_ID = B.COMPANY_ID
               AND A.CHILD_ITEM_ID = B.ITEM_ID
               AND NVL(B.SCP_FLOW_ID, B.FLOW_ID) = 'P5000'
               AND I.SEQ_FLAG IN ('150')
             GROUP BY I.DIVISION_ID
                    , I.COMPANY_ID
                    , I.PLANT_ID
                    , I.PLAN_START_YYYYMMDD
                    , I.CELL_ITEM_ID
                    , A.CHILD_ITEM_ID
                    , I.ITEM_ID
                    , I.YYYYMM;

            INSERT INTO GT_PIS_GRP
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, SUM(BOH_QTY), TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, SUM(QTY)
              FROM GT_PIS_MAIN
             GROUP BY DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM;

/* 셀후공정제품 BOH(660)로 PROD_PLAN(650) 차감하기 START */
/* ------------------------------------------ */
/* 셀 제품의 BOH로 셀 제품의 PROD_PLAN 차감.  (원본 커서/WHILE → PL/SQL FOR 루프, break → EXIT) */
/* ------------------------------------------ */
            DECLARE
                V_CUR1ST_REMAIN_QTY     NUMBER;
                V_CUR1ST_BOH_QTY        NUMBER;
                V_CUR2ND_MIN_MONTH      VARCHAR2(6 CHAR);
                V_CUR1ST_PROD_TOTAL     NUMBER;
                V_CUR1ST_SHIP_TOTAL     NUMBER;
                V_CUR730_BOH_QTY        NUMBER;
                V_CUR730_BOH_REMAIN_QTY NUMBER;
            BEGIN
                FOR R1 IN ( SELECT A.SEQ_FLAG, A.DIVISION_ID, A.OPERATION_GROUP, A.COMPANY_ID, A.PLANT_ID, A.PLAN_START_YYYYMMDD, A.CELL_ITEM_ID, A.ITEM_ID, A.BOH_QTY
                              FROM GT_PIS_GRP A
                             WHERE A.BOH_QTY > 0
                               AND A.MEASURE = 'INV'
                               AND A.SEQ_FLAG = '660'
                               AND A.YYYYMM = SUBSTR(V_PLAN_START_YYYYMMDD, 1, 6)
                             ORDER BY A.SEQ_FLAG, A.ITEM_ID ) LOOP

                    V_CUR1ST_BOH_QTY    := R1.BOH_QTY;
                    V_CUR1ST_REMAIN_QTY := R1.BOH_QTY;

/* - 최소월 찾기 START --- */
                    SELECT MIN(YYYYMM) INTO V_CUR2ND_MIN_MONTH
                      FROM GT_PIS_GRP
                     WHERE DIVISION_ID = R1.DIVISION_ID
                       AND OPERATION_GROUP = R1.OPERATION_GROUP
                       AND COMPANY_ID = R1.COMPANY_ID
                       AND PLANT_ID = R1.PLANT_ID
                       AND PLAN_START_YYYYMMDD = R1.PLAN_START_YYYYMMDD
                       AND CELL_ITEM_ID = R1.CELL_ITEM_ID
                       AND ITEM_ID = R1.ITEM_ID
                       AND MEASURE = 'PROD_PLAN'
                       AND SEQ_FLAG = '650'
                       AND QTY > 0;
/* - 최소월 찾기 END --- */

/* - boh 체크 기능 추가 start 1/2 */
                    SELECT NVL(SUM(NVL(QTY, 0)), 0) INTO V_CUR1ST_PROD_TOTAL
                      FROM GT_PIS_GRP A
                     WHERE A.OPERATION_GROUP = R1.OPERATION_GROUP
                       AND A.COMPANY_ID = R1.COMPANY_ID
                       AND A.PLANT_ID = R1.PLANT_ID
                       AND A.PLAN_START_YYYYMMDD = R1.PLAN_START_YYYYMMDD
                       AND A.CELL_ITEM_ID = R1.CELL_ITEM_ID
                       AND A.ITEM_ID = R1.ITEM_ID
                       AND A.MEASURE = 'PROD_PLAN'
                       AND A.SEQ_FLAG = '650';

                    SELECT NVL(SUM(NVL(QTY, 0)), 0) INTO V_CUR1ST_SHIP_TOTAL
                      FROM GT_PIS_GRP A
                     WHERE A.OPERATION_GROUP = R1.OPERATION_GROUP
                       AND A.COMPANY_ID = R1.COMPANY_ID
                       AND A.PLANT_ID = R1.PLANT_ID
                       AND A.PLAN_START_YYYYMMDD = R1.PLAN_START_YYYYMMDD
                       AND A.CELL_ITEM_ID = R1.CELL_ITEM_ID
                       AND A.ITEM_ID = R1.ITEM_ID
                       AND A.MEASURE IN ('SHIP_PLAN_RTF', 'SHIP_PLAN_SEMI')
                       AND A.SEQ_FLAG IN ('610', '620');

                    IF ((V_CUR1ST_REMAIN_QTY + V_CUR1ST_PROD_TOTAL) - V_CUR1ST_SHIP_TOTAL) > 0 THEN

                        IF V_CUR1ST_REMAIN_QTY > ((V_CUR1ST_REMAIN_QTY + V_CUR1ST_PROD_TOTAL) - V_CUR1ST_SHIP_TOTAL) THEN
                            V_CUR1ST_REMAIN_QTY := ((V_CUR1ST_REMAIN_QTY + V_CUR1ST_PROD_TOTAL) - V_CUR1ST_SHIP_TOTAL);
                        END IF;
/* - boh 체크 기능 추가 end 1/2 */

                        /* PROD_PLAN Cursor */
                        FOR R2 IN ( SELECT DIVISION_ID, OPERATION_GROUP, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, YYYYMM, QTY, MEASURE, SEQ_FLAG
                                         , VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS
                                      FROM GT_PIS_GRP
                                     WHERE DIVISION_ID = R1.DIVISION_ID
                                       AND OPERATION_GROUP = R1.OPERATION_GROUP
                                       AND COMPANY_ID = R1.COMPANY_ID
                                       AND PLANT_ID = R1.PLANT_ID
                                       AND PLAN_START_YYYYMMDD = R1.PLAN_START_YYYYMMDD
                                       AND CELL_ITEM_ID = R1.CELL_ITEM_ID
                                       AND ITEM_ID = R1.ITEM_ID
                                       AND MEASURE = 'PROD_PLAN'
                                       AND SEQ_FLAG = '650'
                                       AND QTY > 0
                                     ORDER BY YYYYMM ) LOOP

                            IF V_CUR1ST_REMAIN_QTY > R2.QTY THEN
                                UPDATE GT_PIS_GRP A SET A.QTY = 0
                                 WHERE A.DIVISION_ID = R2.DIVISION_ID
                                   AND A.OPERATION_GROUP = R2.OPERATION_GROUP
                                   AND A.COMPANY_ID = R2.COMPANY_ID
                                   AND A.PLANT_ID = R2.PLANT_ID
                                   AND A.PLAN_START_YYYYMMDD = R2.PLAN_START_YYYYMMDD
                                   AND A.CELL_ITEM_ID = R2.CELL_ITEM_ID
                                   AND A.ITEM_ID = R2.ITEM_ID
                                   AND A.YYYYMM = R2.YYYYMM
                                   AND A.MEASURE = R2.MEASURE
                                   AND A.SEQ_FLAG = R2.SEQ_FLAG
                                   AND A.VALUE_TYPE = R2.VALUE_TYPE
                                   AND A.TO_PRODUCT = R2.TO_PRODUCT
                                   AND A.LINE_ID = R2.LINE_ID
                                   AND A.TO_SITE = R2.TO_SITE
                                   AND A.INCOTERMS = R2.INCOTERMS;

                                V_CUR1ST_REMAIN_QTY := V_CUR1ST_REMAIN_QTY - R2.QTY;

                            ELSIF V_CUR1ST_REMAIN_QTY <= R2.QTY THEN
                                UPDATE GT_PIS_GRP A SET A.QTY = A.QTY - V_CUR1ST_REMAIN_QTY
                                 WHERE A.DIVISION_ID = R2.DIVISION_ID
                                   AND A.OPERATION_GROUP = R2.OPERATION_GROUP
                                   AND A.COMPANY_ID = R2.COMPANY_ID
                                   AND A.PLANT_ID = R2.PLANT_ID
                                   AND A.PLAN_START_YYYYMMDD = R2.PLAN_START_YYYYMMDD
                                   AND A.CELL_ITEM_ID = R2.CELL_ITEM_ID
                                   AND A.ITEM_ID = R2.ITEM_ID
                                   AND A.YYYYMM = R2.YYYYMM
                                   AND A.MEASURE = R2.MEASURE
                                   AND A.SEQ_FLAG = R2.SEQ_FLAG
                                   AND A.VALUE_TYPE = R2.VALUE_TYPE
                                   AND A.TO_PRODUCT = R2.TO_PRODUCT
                                   AND A.LINE_ID = R2.LINE_ID
                                   AND A.TO_SITE = R2.TO_SITE
                                   AND A.INCOTERMS = R2.INCOTERMS;

                                V_CUR1ST_REMAIN_QTY := 0;
                                EXIT;  /* 원본 break : @CUR1st_REMAIN_QTY = 0 */
                            END IF;
                        END LOOP;
                        /* -------------------------------------- */
                        /* PROD_PLAN Cursor : END */
                        /* -------------------------------------- */
                    END IF;  /* --- boh 체크 기능 추가 start end 2/2 */

/* 후공정 반제품(730) in_house_moving 차감 start */
                    IF ( V_CUR1ST_BOH_QTY <> V_CUR1ST_REMAIN_QTY ) THEN
                        V_CUR730_BOH_QTY := V_CUR1ST_BOH_QTY;  /* * @260boh_CHILD_QTY / @260boh_YIELD */
                        V_CUR730_BOH_REMAIN_QTY := V_CUR730_BOH_QTY;

                        /* PROD_PLAN Cursor (730) */
                        FOR R3 IN ( SELECT A.DIVISION_ID, A.OPERATION_GROUP, A.COMPANY_ID, A.PLANT_ID, A.PLAN_START_YYYYMMDD, A.CELL_ITEM_ID, A.ITEM_ID, A.YYYYMM, A.QTY, A.MEASURE, A.SEQ_FLAG
                                         , A.VALUE_TYPE, A.TO_PRODUCT, A.LINE_ID, A.TO_SITE, A.INCOTERMS
                                      FROM GT_PIS_GRP                  A
                                         , SCP_MST_CELL_PROD_ASSY_MAP  MP
                                     WHERE MP.DIVISION_ID = R1.DIVISION_ID
                                       AND MP.PLANT_ID = R1.PLANT_ID
                                       AND MP.ITEM_ID_PROD = R1.ITEM_ID
                                       AND MP.CELL_TYPE = 'CA2'
                                       AND MP.VALID_YN = 'Y'
                                       AND A.DIVISION_ID = R1.DIVISION_ID
                                       AND A.OPERATION_GROUP = 'A'
                                       AND A.COMPANY_ID = R1.COMPANY_ID
                                       AND A.PLANT_ID = R1.PLANT_ID
                                       AND A.PLAN_START_YYYYMMDD = R1.PLAN_START_YYYYMMDD
                                       AND A.CELL_ITEM_ID = R1.CELL_ITEM_ID
                                       AND A.ITEM_ID = MP.ITEM_ID_ASSY
                                       AND A.TO_SITE = R1.PLANT_ID
                                       AND A.MEASURE = 'IN_HOUSE_MOVING'
                                       AND A.SEQ_FLAG = '730'
                                       AND A.QTY > 0
                                       AND A.YYYYMM >= V_CUR2ND_MIN_MONTH /* 최소 반영월 이상만 반영함. */
                                     ORDER BY A.YYYYMM ) LOOP

                            IF V_CUR730_BOH_REMAIN_QTY > R3.QTY THEN
                                UPDATE GT_PIS_GRP A SET A.QTY = 0
                                 WHERE A.DIVISION_ID = R3.DIVISION_ID
                                   AND A.OPERATION_GROUP = R3.OPERATION_GROUP
                                   AND A.COMPANY_ID = R3.COMPANY_ID
                                   AND A.PLANT_ID = R3.PLANT_ID
                                   AND A.PLAN_START_YYYYMMDD = R3.PLAN_START_YYYYMMDD
                                   AND A.CELL_ITEM_ID = R3.CELL_ITEM_ID
                                   AND A.ITEM_ID = R3.ITEM_ID
                                   AND A.YYYYMM = R3.YYYYMM
                                   AND A.MEASURE = R3.MEASURE
                                   AND A.SEQ_FLAG = R3.SEQ_FLAG
                                   AND A.VALUE_TYPE = R3.VALUE_TYPE
                                   AND A.TO_PRODUCT = R3.TO_PRODUCT
                                   AND A.LINE_ID = R3.LINE_ID
                                   AND A.TO_SITE = R3.TO_SITE
                                   AND A.INCOTERMS = R3.INCOTERMS;

                                V_CUR730_BOH_REMAIN_QTY := V_CUR730_BOH_REMAIN_QTY - R3.QTY;

                            ELSIF V_CUR730_BOH_REMAIN_QTY <= R3.QTY THEN
                                UPDATE GT_PIS_GRP A SET A.QTY = A.QTY - V_CUR730_BOH_REMAIN_QTY
                                 WHERE A.DIVISION_ID = R3.DIVISION_ID
                                   AND A.OPERATION_GROUP = R3.OPERATION_GROUP
                                   AND A.COMPANY_ID = R3.COMPANY_ID
                                   AND A.PLANT_ID = R3.PLANT_ID
                                   AND A.PLAN_START_YYYYMMDD = R3.PLAN_START_YYYYMMDD
                                   AND A.CELL_ITEM_ID = R3.CELL_ITEM_ID
                                   AND A.ITEM_ID = R3.ITEM_ID
                                   AND A.YYYYMM = R3.YYYYMM
                                   AND A.MEASURE = R3.MEASURE
                                   AND A.SEQ_FLAG = R3.SEQ_FLAG
                                   AND A.VALUE_TYPE = R3.VALUE_TYPE
                                   AND A.TO_PRODUCT = R3.TO_PRODUCT
                                   AND A.LINE_ID = R3.LINE_ID
                                   AND A.TO_SITE = R3.TO_SITE
                                   AND A.INCOTERMS = R3.INCOTERMS;

                                V_CUR730_BOH_REMAIN_QTY := 0;
                                EXIT;  /* 원본 break : @CUR730_Boh_REMAIN_QTY = 0 */
                            END IF;
                        END LOOP;
                    END IF;
/* 후공정 반제품(730) in_house_moving 차감 end */
                END LOOP;
            END;
/* === 660 boh 차감 end */

/* ============ (예외1. 1/2) CA2 없는 후공정 아이템 TCO_ITEM_PROD start =========== */
            INSERT INTO GT_PIS_650_330
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , A.CELL_ITEM_ID
                 , LMD.SEGMENT2 AS ITEM_ID
                 , 'IN_HOUSE_MOVING' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , A.ITEM_ID AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , A.PLANT_ID AS TO_SITE
                 , '-' AS INCOTERMS
                 , '330' AS SEQ_FLAG
                 , A.YYYYMM,
                   NVL(SUM(NVL(A.QTY, 0)), 0) AS QTY  /* pack, cell 수율반영 */
              FROM GT_PIS_GRP                    A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL  LMD
             WHERE LMD.LOOKUP_TYPE = 'TCO_NO_CA2_ITEM_PROD'
               AND LMD.VALID_YN = 'Y'
               AND LMD.SEGMENT1 = A.ITEM_ID
               AND A.SEQ_FLAG = '650'
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.PLAN_START_YYYYMMDD
                    , A.CELL_ITEM_ID
                    , LMD.SEGMENT2
                    , A.ITEM_ID
                    , A.YYYYMM;

/* -- 예외2 CASE2 START ============================ */
/* ----------예외2, CASE2 중 1. '450 -> 350 START */
            /* 원본 create table #tmp_ultra_small_lookup_cell → GTT DDL. 진입부 DELETE 완료. */
            DELETE FROM GT_PIS_ULS_LKUP_CELL;
            INSERT INTO GT_PIS_ULS_LKUP_CELL
            SELECT DISTINCT SEGMENT1, SEGMENT2
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM
             WHERE LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
               AND LM.VALID_YN = 'Y';

            /* INSERT INTO #tmp_PSI_INTEGRATION_350_750_430_ultra_small */
            INSERT INTO GT_PIS_650_330  /* > CELL_ITEM_ID를 setting 하기 위해. */
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID
                 , NVL((CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
                             ELSE B.PLANT_ID
                             END ), '-') AS PLANT_ID
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
                 , SUBSTR(A.YYYYMMDD, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(A.QTY, 0)), 0) AS QTY
              FROM SCP_ANL_SHIPMENT_PLAN_FG A
                 , GT_PIS_ULS_LKUP_CELL    CP
                 , SCM_MST_SITE            B
             WHERE CP.CELL_CP = A.ITEM_ID
               AND B.DIVISION_ID(+) = A.DIVISION_ID
               AND B.SCM_SITE_ID(+) = A.FROM_SITE
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD  /* '20240923' */
               AND A.PLAN_TYPE           = V_PLAN_TYPE  /* 'FN' */
               AND A.SEQ                 = V_PLAN_SEQ  /* 1 */
               AND A.DIVISION_ID         = V_DIVISION_ID  /* '40' */
               AND A.MEASURE = 'SHIP_PLAN_AMEND'
               AND A.BIZ_TYPE = 'A'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD  /* '20250921 */
             GROUP BY A.DIVISION_ID
                    , B.COMPANY_ID
                    , (CASE WHEN B.PLANT_ID = 'KR02149300' THEN V_NJ_PLANT
                            ELSE B.PLANT_ID
                            END )
                    , A.PLAN_START_YYYYMMDD
                    , A.ITEM_ID
                    , SUBSTR(A.YYYYMMDD, 1, 6);
/* ----------예외2, CASE2 중 1. '450 -> 350 END */

/* ----------예외2, CASE2 중 2. '650 -> 750 START */
            /* 원본 create table #tmp_ultra_small_lookup_tco_cell → GTT DDL. 진입부 DELETE 완료. */
            DELETE FROM GT_PIS_ULS_LKUP_TCO;
            INSERT INTO GT_PIS_ULS_LKUP_TCO
            SELECT DISTINCT SEGMENT1, SEGMENT3, SEGMENT4
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM
             WHERE LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
               AND LM.VALID_YN = 'Y';

            /* INSERT INTO #tmp_PSI_INTEGRATION_350_750_430_ultra_small */
            INSERT INTO GT_PIS_650_330  /* > CELL_ITEM_ID를 setting 하기 위해. */
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID AS PLANT_ID
                 , V_PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , TC.TCO_CELL_CA AS ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , A.LINE_ID AS LINE_ID
                 , 0 AS BOH_QTY
                 , '-' AS TO_SITE
                 , '-' AS INCOTERMS
                 , '750' AS SEQ_FLAG
                 , A.YYYYMM AS YYYYMM
                 , NVL(SUM(NVL(A.QTY, 0)), 0) AS QTY
              FROM GT_PIS_GRP            A /* 12,984,  ==> 129,584   ==> 여기에 MAP 추가하기. */
                 , GT_PIS_ULS_LKUP_TCO  TC
             WHERE TC.TCO_CELL_CP = A.ITEM_ID
               AND A.SEQ_FLAG = '650'
               AND A.DIVISION_ID = V_DIVISION_ID /* '40' */
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD  /* '20240923' */
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , TC.TCO_CELL_CA
                    , A.LINE_ID
                    , A.YYYYMM;
/* ----------예외2, CASE2 중 1. '650 -> 750 START */
/* -- 예외2 CASE2 END ============================ */

            /* CELL 일경우 -- 2023.06.08 활성화코드 분리 대응 - CP_INFO2 (priority=1 = 파티션별 MIN(ITEM_ID_PROD)) */
            UPDATE GT_PIS_650_330 X
               SET X.CELL_ITEM_ID = NVL(( SELECT CASE WHEN F.CELL_TYPE LIKE 'CA%'
                                                      THEN NVL(NVL(NVL(
                                                             ( SELECT MIN(M.ITEM_ID_PROD) FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                                                WHERE M.VALID_YN = 'Y' AND M.DIVISION_ID = X.DIVISION_ID AND M.PLANT_ID = X.PLANT_ID AND M.ITEM_ID_ASSY = X.ITEM_ID)
                                                           , ( SELECT MIN(M.ITEM_ID_PROD) FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                                                WHERE M.VALID_YN = 'Y' AND M.DIVISION_ID = X.DIVISION_ID AND M.ITEM_ID_ASSY = X.ITEM_ID))
                                                           , ( SELECT MIN(M.ITEM_ID_PROD) FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                                                WHERE M.VALID_YN = 'Y' AND M.ITEM_ID_ASSY = X.ITEM_ID))
                                                           , X.ITEM_ID)
                                                      ELSE X.ITEM_ID
                                                      END
                                            FROM SCP_MST_FINAL_ITEM_V F
                                           WHERE F.ITEM_ID = X.ITEM_ID
                                             AND ROWNUM = 1), '-')
             WHERE X.OPERATION_GROUP = 'A'
               /* and left(x.SEQ_FLAG,1) <> '5' */
               /* and isnull(x.CELL_ITEM_ID,'') < '0' */
               AND EXISTS ( SELECT 1 FROM SCP_MST_FINAL_ITEM_V F WHERE F.ITEM_ID = X.ITEM_ID );

/* ----------예외2, CASE2 중 1. '350 + 750  --> 430  START */
/* 여기에 350 boh 차감. start (원본 커서/WHILE → PL/SQL FOR 루프) */
            DECLARE
                V_C350_REMAIN_QTY  NUMBER;
                V_C350_PROD_TOTAL  NUMBER;
                V_C350_SHIP_TOTAL  NUMBER;
            BEGIN
                FOR R1 IN ( SELECT A.SEQ_FLAG, A.DIVISION_ID, A.OPERATION_GROUP, A.COMPANY_ID, A.PLANT_ID, A.PLAN_START_YYYYMMDD, A.CELL_ITEM_ID, A.ITEM_ID, A.BOH_QTY
                              FROM GT_PIS_GRP A
                             WHERE A.BOH_QTY > 0
                               AND A.MEASURE = 'INV'
                               AND A.SEQ_FLAG = '360'
                               AND A.YYYYMM = SUBSTR(V_PLAN_START_YYYYMMDD, 1, 6)
                               AND EXISTS (SELECT 1
                                             FROM GT_PIS_650_330 B
                                            WHERE B.DIVISION_ID = A.DIVISION_ID
                                              AND B.OPERATION_GROUP = A.OPERATION_GROUP
                                              AND B.COMPANY_ID = A.COMPANY_ID
                                              AND B.PLANT_ID = A.PLANT_ID
                                              AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND B.CELL_ITEM_ID = A.CELL_ITEM_ID
                                              AND B.ITEM_ID = A.ITEM_ID
                                              AND B.SEQ_FLAG = '350'
                                              AND B.QTY > 0 )
                             ORDER BY A.ITEM_ID ) LOOP

                    V_C350_REMAIN_QTY := R1.BOH_QTY;

/* - 대상 찾기 start */
                    SELECT NVL(SUM(NVL(QTY, 0)), 0) INTO V_C350_PROD_TOTAL
                      FROM GT_PIS_650_330 A
                     WHERE A.OPERATION_GROUP = R1.OPERATION_GROUP
                       AND A.COMPANY_ID = R1.COMPANY_ID
                       AND A.PLANT_ID = R1.PLANT_ID
                       AND A.PLAN_START_YYYYMMDD = R1.PLAN_START_YYYYMMDD
                       AND A.CELL_ITEM_ID = R1.CELL_ITEM_ID
                       AND A.ITEM_ID = R1.ITEM_ID
                       AND A.MEASURE = 'PROD_PLAN'
                       AND A.SEQ_FLAG = '350';

                    SELECT NVL(SUM(NVL(QTY, 0)), 0) INTO V_C350_SHIP_TOTAL
                      FROM GT_PIS_GRP A
                     WHERE A.OPERATION_GROUP = R1.OPERATION_GROUP
                       AND A.COMPANY_ID = R1.COMPANY_ID
                       AND A.PLANT_ID = R1.PLANT_ID
                       AND A.PLAN_START_YYYYMMDD = R1.PLAN_START_YYYYMMDD
                       AND A.CELL_ITEM_ID = R1.CELL_ITEM_ID
                       AND A.ITEM_ID = R1.ITEM_ID
                       AND A.MEASURE IN ('SHIP_PLAN_RTF', 'SHIP_PLAN_SEMI')
                       AND A.SEQ_FLAG IN ('310', '320');

                    IF ((V_C350_REMAIN_QTY + V_C350_PROD_TOTAL) - V_C350_SHIP_TOTAL) > 0 THEN

                        IF V_C350_REMAIN_QTY > ((V_C350_REMAIN_QTY + V_C350_PROD_TOTAL) - V_C350_SHIP_TOTAL) THEN
                            V_C350_REMAIN_QTY := ((V_C350_REMAIN_QTY + V_C350_PROD_TOTAL) - V_C350_SHIP_TOTAL);
                        END IF;
/* - 대상 찾기 end */
                        FOR R2 IN ( SELECT DIVISION_ID, OPERATION_GROUP, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, YYYYMM, QTY, MEASURE, SEQ_FLAG
                                         , VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS
                                      FROM GT_PIS_650_330
                                     WHERE DIVISION_ID = R1.DIVISION_ID
                                       AND OPERATION_GROUP = R1.OPERATION_GROUP
                                       AND COMPANY_ID = R1.COMPANY_ID
                                       AND PLANT_ID = R1.PLANT_ID
                                       AND PLAN_START_YYYYMMDD = R1.PLAN_START_YYYYMMDD
                                       AND CELL_ITEM_ID = R1.CELL_ITEM_ID
                                       AND ITEM_ID = R1.ITEM_ID
                                       AND MEASURE = 'PROD_PLAN'
                                       AND SEQ_FLAG = '350'
                                       AND QTY > 0
                                     ORDER BY YYYYMM ) LOOP

                            IF V_C350_REMAIN_QTY > R2.QTY THEN
                                UPDATE GT_PIS_650_330 A SET A.QTY = 0
                                 WHERE A.DIVISION_ID = R2.DIVISION_ID
                                   AND A.OPERATION_GROUP = R2.OPERATION_GROUP
                                   AND A.COMPANY_ID = R2.COMPANY_ID
                                   AND A.PLANT_ID = R2.PLANT_ID
                                   AND A.PLAN_START_YYYYMMDD = R2.PLAN_START_YYYYMMDD
                                   AND A.CELL_ITEM_ID = R2.CELL_ITEM_ID
                                   AND A.ITEM_ID = R2.ITEM_ID
                                   AND A.YYYYMM = R2.YYYYMM
                                   AND A.MEASURE = R2.MEASURE
                                   AND A.SEQ_FLAG = R2.SEQ_FLAG
                                   AND A.VALUE_TYPE = R2.VALUE_TYPE
                                   AND A.TO_PRODUCT = R2.TO_PRODUCT
                                   AND A.LINE_ID = R2.LINE_ID
                                   AND A.TO_SITE = R2.TO_SITE
                                   AND A.INCOTERMS = R2.INCOTERMS;

                                V_C350_REMAIN_QTY := V_C350_REMAIN_QTY - R2.QTY;

                            ELSIF V_C350_REMAIN_QTY <= R2.QTY THEN
                                UPDATE GT_PIS_650_330 A SET A.QTY = A.QTY - V_C350_REMAIN_QTY
                                 WHERE A.DIVISION_ID = R2.DIVISION_ID
                                   AND A.OPERATION_GROUP = R2.OPERATION_GROUP
                                   AND A.COMPANY_ID = R2.COMPANY_ID
                                   AND A.PLANT_ID = R2.PLANT_ID
                                   AND A.PLAN_START_YYYYMMDD = R2.PLAN_START_YYYYMMDD
                                   AND A.CELL_ITEM_ID = R2.CELL_ITEM_ID
                                   AND A.ITEM_ID = R2.ITEM_ID
                                   AND A.YYYYMM = R2.YYYYMM
                                   AND A.MEASURE = R2.MEASURE
                                   AND A.SEQ_FLAG = R2.SEQ_FLAG
                                   AND A.VALUE_TYPE = R2.VALUE_TYPE
                                   AND A.TO_PRODUCT = R2.TO_PRODUCT
                                   AND A.LINE_ID = R2.LINE_ID
                                   AND A.TO_SITE = R2.TO_SITE
                                   AND A.INCOTERMS = R2.INCOTERMS;

                                EXIT;
                            END IF;
                        END LOOP;
                    END IF;  /* 350 boh로 prod 차감 추가 2 (check2/2) */
                END LOOP;
            END;
/* 여기에 360으로 350 boh 차감. end */

/* 여기에 760으로 750 boh 차감. start (원본 커서/WHILE → PL/SQL FOR 루프) */
            DECLARE
                V_C750_REMAIN_QTY  NUMBER;
            BEGIN
                FOR R1 IN ( SELECT A.SEQ_FLAG, A.DIVISION_ID, A.OPERATION_GROUP, A.COMPANY_ID, A.PLANT_ID, A.PLAN_START_YYYYMMDD, A.CELL_ITEM_ID, A.ITEM_ID, A.BOH_QTY
                              FROM GT_PIS_GRP A
                             WHERE A.BOH_QTY > 0
                               AND A.MEASURE = 'INV'
                               AND A.SEQ_FLAG = '760'
                               AND A.YYYYMM = SUBSTR(V_PLAN_START_YYYYMMDD, 1, 6)
                               AND EXISTS (SELECT 1
                                             FROM GT_PIS_650_330 B
                                            WHERE B.DIVISION_ID = A.DIVISION_ID
                                              AND B.OPERATION_GROUP = A.OPERATION_GROUP
                                              AND B.COMPANY_ID = A.COMPANY_ID
                                              AND B.PLANT_ID = A.PLANT_ID
                                              AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND B.CELL_ITEM_ID = A.CELL_ITEM_ID
                                              AND B.ITEM_ID = A.ITEM_ID
                                              AND B.SEQ_FLAG = '750'
                                              AND B.QTY > 0 )
                             ORDER BY A.ITEM_ID ) LOOP

                    V_C750_REMAIN_QTY := R1.BOH_QTY;

                    FOR R2 IN ( SELECT DIVISION_ID, OPERATION_GROUP, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, YYYYMM, QTY, MEASURE, SEQ_FLAG
                                     , VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS
                                  FROM GT_PIS_650_330
                                 WHERE DIVISION_ID = R1.DIVISION_ID
                                   AND OPERATION_GROUP = R1.OPERATION_GROUP
                                   AND COMPANY_ID = R1.COMPANY_ID
                                   AND PLANT_ID = R1.PLANT_ID
                                   AND PLAN_START_YYYYMMDD = R1.PLAN_START_YYYYMMDD
                                   AND CELL_ITEM_ID = R1.CELL_ITEM_ID
                                   AND ITEM_ID = R1.ITEM_ID
                                   AND MEASURE = 'PROD_PLAN'
                                   AND SEQ_FLAG = '750'
                                   AND QTY > 0
                                 ORDER BY YYYYMM ) LOOP

                        IF V_C750_REMAIN_QTY > R2.QTY THEN
                            UPDATE GT_PIS_650_330 A SET A.QTY = 0
                             WHERE A.DIVISION_ID = R2.DIVISION_ID
                               AND A.OPERATION_GROUP = R2.OPERATION_GROUP
                               AND A.COMPANY_ID = R2.COMPANY_ID
                               AND A.PLANT_ID = R2.PLANT_ID
                               AND A.PLAN_START_YYYYMMDD = R2.PLAN_START_YYYYMMDD
                               AND A.CELL_ITEM_ID = R2.CELL_ITEM_ID
                               AND A.ITEM_ID = R2.ITEM_ID
                               AND A.YYYYMM = R2.YYYYMM
                               AND A.MEASURE = R2.MEASURE
                               AND A.SEQ_FLAG = R2.SEQ_FLAG
                               AND A.VALUE_TYPE = R2.VALUE_TYPE
                               AND A.TO_PRODUCT = R2.TO_PRODUCT
                               AND A.LINE_ID = R2.LINE_ID
                               AND A.TO_SITE = R2.TO_SITE
                               AND A.INCOTERMS = R2.INCOTERMS;

                            V_C750_REMAIN_QTY := V_C750_REMAIN_QTY - R2.QTY;

                        ELSIF V_C750_REMAIN_QTY <= R2.QTY THEN
                            UPDATE GT_PIS_650_330 A SET A.QTY = A.QTY - V_C750_REMAIN_QTY
                             WHERE A.DIVISION_ID = R2.DIVISION_ID
                               AND A.OPERATION_GROUP = R2.OPERATION_GROUP
                               AND A.COMPANY_ID = R2.COMPANY_ID
                               AND A.PLANT_ID = R2.PLANT_ID
                               AND A.PLAN_START_YYYYMMDD = R2.PLAN_START_YYYYMMDD
                               AND A.CELL_ITEM_ID = R2.CELL_ITEM_ID
                               AND A.ITEM_ID = R2.ITEM_ID
                               AND A.YYYYMM = R2.YYYYMM
                               AND A.MEASURE = R2.MEASURE
                               AND A.SEQ_FLAG = R2.SEQ_FLAG
                               AND A.VALUE_TYPE = R2.VALUE_TYPE
                               AND A.TO_PRODUCT = R2.TO_PRODUCT
                               AND A.LINE_ID = R2.LINE_ID
                               AND A.TO_SITE = R2.TO_SITE
                               AND A.INCOTERMS = R2.INCOTERMS;

                            EXIT;
                        END IF;
                    END LOOP;
                END LOOP;
            END;
/* 여기에 750 boh 차감. end */

            INSERT INTO GT_PIS_650_330
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT C.DIVISION_ID
                 , C.COMPANY_ID
                 , C.PLANT_ID
                 , V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , C.ITEM_ID AS ITEM_ID
                 , 'IN_HOUSE_MOVING' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , C.TO_PRODUCT AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , C.TO_SITE AS TO_SITE
                 , '-' AS INCOTERMS
                 , '430' AS SEQ_FLAG
                 , C.YYYYMM
                 , NVL(SUM(NVL(QTY, 0) / NVL(FM.FORMATION_TOTAL_YIELD, 1)), 0) AS QTY
              FROM (
                    /* 350 -> 430 */
                    SELECT DIVISION_ID
                         , COMPANY_ID
                         , PLANT_ID
                         , LC.CELL_CA AS ITEM_ID
                         , A.ITEM_ID AS TO_PRODUCT
                         , A.PLANT_ID AS TO_SITE
                         , YYYYMM
                         , QTY
                      FROM GT_PIS_650_330        A
                         , GT_PIS_ULS_LKUP_CELL  LC
                     WHERE LC.CELL_CP = A.ITEM_ID
                       AND A.SEQ_FLAG = '350'
                    UNION ALL
                    /* 750 -> 430 */
                    SELECT DIVISION_ID
                         , COMPANY_ID
                         , PLANT_ID
                         , LC.CELL_CA AS ITEM_ID
                         , B.ITEM_ID AS TO_PRODUCT
                         , B.PLANT_ID AS TO_SITE
                         , YYYYMM
                         , QTY
                      FROM GT_PIS_650_330       B
                         , GT_PIS_ULS_LKUP_TCO  LC
                     WHERE LC.TCO_CELL_CA = B.ITEM_ID
                       AND B.SEQ_FLAG = '750'
                   ) C
                 , SCM_MST_SITE          X
                 , SCP_MST_FORMATION_V   FM
             WHERE X.DIVISION_ID(+) = V_DIVISION_ID /* '40' */
               AND X.PLANT_ID(+) = C.PLANT_ID /* @NJ_PLANT */
               AND X.OPERATION_GROUP(+) = 'A'
               AND FM.DIVISION_ID(+) = V_DIVISION_ID /* '40' */
               AND FM.PLANT_SITE_ID(+) = X.SCM_SITE_ID
               AND FM.ITEM_ID(+) = C.ITEM_ID
             GROUP BY C.DIVISION_ID
                    , C.COMPANY_ID
                    , C.PLANT_ID
                    , C.ITEM_ID
                    , C.TO_PRODUCT
                    , C.TO_SITE
                    , C.YYYYMM;

            /* CELL 일경우 -- 2023.06.08 활성화코드 분리 대응 - CP_INFO3 */
            UPDATE GT_PIS_650_330 X
               SET X.CELL_ITEM_ID = NVL(( SELECT CASE WHEN F.CELL_TYPE LIKE 'CA%'
                                                      THEN NVL(NVL(NVL(
                                                             ( SELECT MIN(M.ITEM_ID_PROD) FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                                                WHERE M.VALID_YN = 'Y' AND M.DIVISION_ID = X.DIVISION_ID AND M.PLANT_ID = X.PLANT_ID AND M.ITEM_ID_ASSY = X.ITEM_ID)
                                                           , ( SELECT MIN(M.ITEM_ID_PROD) FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                                                WHERE M.VALID_YN = 'Y' AND M.DIVISION_ID = X.DIVISION_ID AND M.ITEM_ID_ASSY = X.ITEM_ID))
                                                           , ( SELECT MIN(M.ITEM_ID_PROD) FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                                                WHERE M.VALID_YN = 'Y' AND M.ITEM_ID_ASSY = X.ITEM_ID))
                                                           , X.ITEM_ID)
                                                      ELSE X.ITEM_ID
                                                      END
                                            FROM SCP_MST_FINAL_ITEM_V F
                                           WHERE F.ITEM_ID = X.ITEM_ID
                                             AND ROWNUM = 1), '-')
             WHERE X.OPERATION_GROUP = 'A'
               AND X.SEQ_FLAG = '430'
               /* and isnull(x.CELL_ITEM_ID,'') < '0' */
               AND EXISTS ( SELECT 1 FROM SCP_MST_FINAL_ITEM_V F WHERE F.ITEM_ID = X.ITEM_ID );
/* ----------예외2, CASE2 중 1. '350 + 750  --> 430  end */

            INSERT INTO GT_PIS_GRP
            SELECT * FROM GT_PIS_650_330;
/* 셀후공정제품 BOH(660)로 PROD_PLAN(650) 차감하기 END */

            INSERT INTO GT_PIS_GRP2
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, SUM(BOH_QTY), TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, SUM(QTY)
              FROM GT_PIS_GRP
             GROUP BY DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM;

/* 소숫점 없애기 */
            UPDATE GT_PIS_GRP2 A
               SET A.BOH_QTY = ROUND(NVL(A.BOH_QTY, 0), 0)
                 , A.QTY     = ROUND(NVL(A.QTY, 0), 0);

/* 월_INVentory 생성 START */
            V_STATUS_DESC := 'INV';
            V_MIN_YYYYMM := SUBSTR(V_PLAN_START_YYYYMMDD, 1, 6);

            SELECT MAX(YYYYMM) INTO V_MAX_YYYYMM
              FROM GT_PIS_GRP2 A
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
                    INSERT INTO GT_PIS_GRP2
                        ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                        , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                        , INCOTERMS, SEQ_FLAG, YYYYMM, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                    SELECT DISTINCT A.DIVISION_ID
                         , A.COMPANY_ID
                         , A.PLANT_ID
                         , A.PLAN_START_YYYYMMDD
                         , 1 AS SEQ /* a.SEQ */
                         , A.OPERATION_GROUP
                         , A.FROM_SITE
                         , A.CELL_ITEM_ID
                         , A.ITEM_ID
                         , 'INV' AS MEASURE
                         , '-' AS VALUE_TYPE
                         , '-' AS TO_PRODUCT
                         , '-' AS LINE_ID
                         , 0 AS BOH_QTY
                         , '-' AS TO_SITE
                         , '-' AS INCOTERMS
                         , SUBSTR(A.SEQ_FLAG, 1, 1) || '60' AS SEQ_FLAG
                         , V_PROC_YYYYMM AS YYYYMM
                         , 0 AS QTY
                         , 'SCP BATCH' AS CREATED_BY
                         , SYSDATE AS CREATION_DATE
                         , 'SCP BATCH' AS LAST_UPDATED_BY
                         , SYSDATE AS LAST_UPDATE_DATE
                      FROM GT_PIS_GRP2 A
                     WHERE NOT EXISTS ( SELECT 1
                                          FROM GT_PIS_GRP2 B
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
                    UPDATE GT_PIS_GRP2 A
                       SET A.QTY = NVL(( SELECT SUM(CASE WHEN B.MEASURE = 'INV' THEN B.BOH_QTY
                                                        WHEN B.MEASURE = 'SHIP_PLAN_SEMI' THEN B.QTY * -1
                                                        WHEN B.MEASURE = 'SHIP_PLAN_RTF' THEN B.QTY * -1
                                                        WHEN B.MEASURE = 'IN_HOUSE_MOVING' THEN B.QTY * -1
                                                        WHEN B.MEASURE = 'SEMI_WH_IN' THEN B.QTY
                                                        WHEN B.MEASURE = 'PROD_PLAN' THEN B.QTY
                                                        END)
                                           FROM GT_PIS_GRP2 B
                                          WHERE B.DIVISION_ID = A.DIVISION_ID
                                            AND B.COMPANY_ID = A.COMPANY_ID
                                            AND B.PLANT_ID = A.PLANT_ID
                                            AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                            AND B.SEQ = A.SEQ
                                            AND B.OPERATION_GROUP = A.OPERATION_GROUP
                                            AND B.FROM_SITE = A.FROM_SITE
                                            AND B.CELL_ITEM_ID = A.CELL_ITEM_ID
                                            AND B.ITEM_ID = A.ITEM_ID
                                            AND SUBSTR(B.SEQ_FLAG, 1, 1) = SUBSTR(A.SEQ_FLAG, 1, 1)
                                            AND B.YYYYMM = A.YYYYMM ), 0)
                     WHERE A.MEASURE = 'INV'
                       AND A.YYYYMM = V_PROC_YYYYMM
                       AND A.OPERATION_GROUP <> 'E';  /* 전극은 사실상 없음. */

                ELSE /* 두번째 월부터 마지막 월까지 재고 생성. */
                    INSERT INTO GT_PIS_GRP2
                        ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                        , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                        , INCOTERMS, SEQ_FLAG, YYYYMM, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                    SELECT DISTINCT A.DIVISION_ID
                         , A.COMPANY_ID
                         , A.PLANT_ID
                         , A.PLAN_START_YYYYMMDD
                         , 1 AS SEQ /* a.SEQ */
                         , A.OPERATION_GROUP
                         , A.FROM_SITE
                         , A.CELL_ITEM_ID
                         , A.ITEM_ID
                         , 'INV' AS MEASURE
                         , '-' AS VALUE_TYPE
                         , '-' AS TO_PRODUCT
                         , '-' AS LINE_ID
                         , A.BOH_QTY AS BOH_QTY
                         , '-' AS TO_SITE
                         , '-' AS INCOTERMS
                         , SUBSTR(A.SEQ_FLAG, 1, 1) || '60' AS SEQ_FLAG
                         , V_PROC_YYYYMM AS YYYYMM
                         , NVL(A.QTY, 0) + NVL(( SELECT SUM(CASE WHEN B.MEASURE = 'SHIP_PLAN_SEMI' THEN B.QTY * -1
                                                                WHEN B.MEASURE = 'SHIP_PLAN_RTF' THEN B.QTY * -1
                                                                WHEN B.MEASURE = 'IN_HOUSE_MOVING' THEN B.QTY * -1
                                                                WHEN B.MEASURE = 'SEMI_WH_IN' THEN B.QTY
                                                                WHEN B.MEASURE = 'PROD_PLAN' THEN B.QTY
                                                                END)
                                                   FROM GT_PIS_GRP2 B
                                                  WHERE B.DIVISION_ID = A.DIVISION_ID
                                                    AND B.COMPANY_ID = A.COMPANY_ID
                                                    AND B.PLANT_ID = A.PLANT_ID
                                                    AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                    AND B.SEQ = A.SEQ
                                                    AND B.OPERATION_GROUP = A.OPERATION_GROUP
                                                    AND B.FROM_SITE = A.FROM_SITE
                                                    AND B.CELL_ITEM_ID = A.CELL_ITEM_ID
                                                    AND B.ITEM_ID = A.ITEM_ID
                                                    AND SUBSTR(B.SEQ_FLAG, 1, 1) = SUBSTR(A.SEQ_FLAG, 1, 1)
                                                    AND B.YYYYMM = V_PROC_YYYYMM
                                                 ), 0) AS QTY
                         , 'SCP BATCH' AS CREATED_BY
                         , SYSDATE AS CREATION_DATE
                         , 'SCP BATCH' AS LAST_UPDATED_BY
                         , SYSDATE AS LAST_UPDATE_DATE
                      FROM GT_PIS_GRP2 A
                     WHERE A.MEASURE = 'INV'
                       AND A.YYYYMM = V_PRE_YYYYMM
                       AND A.OPERATION_GROUP <> 'E';  /* 전극은 사실상 없음. */
                END IF;

                V_I := V_I + 1;

                V_PROC_YYYYMMDD := TO_CHAR(ADD_MONTHS(TO_DATE(V_PROC_YYYYMMDD, 'YYYYMMDD'), 1), 'YYYYMMDD');
                V_PRE_YYYYMM := V_PROC_YYYYMM;
                V_PROC_YYYYMM := SUBSTR(V_PROC_YYYYMMDD, 1, 6);

            END LOOP;

            /* ----------------------------------------------------------------------------------------------------------- */
            /* ESS 용 전극 Item 정보 삭제 처리 : 81 전극에서 ESS 전극 일부 생산 */
            /* ----------------------------------------------------------------------------------------------------------- */
            DELETE FROM GT_PIS_GRP2
             WHERE 1 = 1
               AND OPERATION_GROUP = 'E'
               AND ITEM_ID IN (SELECT DISTINCT ITEM_ID FROM SCP_MST_FINAL_ITEM
                                WHERE DIVISION_ID = V_DIVISION_ID
                                  AND FLOW_ID LIKE 'E2000%'
                                  AND CELL_ITEM_ID LIKE 'EC%'
                               );

    /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
    /* 2025.03.013  Begin   PJ20249548R  : 빈월 수량 0 데이터 생성 반영 */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || 'Begin   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영');
    /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 기간 정보');
            V_FILL_0_TARGET_PERIOD := -1;
            V_FILL_0_TARGET_PERIOD_END_YYYYMM := SUBSTR(V_HORIZON_END_YYYYMMDD, 1, 6);

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '@V_FILL_0_TARGET_PERIOD : ' || TO_CHAR(V_FILL_0_TARGET_PERIOD));
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '@V_FILL_0_TARGET_PERIOD_END_YYYYMM : ' || V_FILL_0_TARGET_PERIOD_END_YYYYMM);

            /* 원본 SELECT TOP 1 (ORDER BY LAST_UPDATE_DATE DESC) : 무행이면 위 -1/horizon 값 유지 */
            BEGIN
                SELECT SEG1, END_YM
                  INTO V_FILL_0_TARGET_PERIOD, V_FILL_0_TARGET_PERIOD_END_YYYYMM
                  FROM ( SELECT TRUNC(TO_NUMBER(L.SEGMENT1)) AS SEG1
                              , CASE WHEN TRUNC(TO_NUMBER(L.SEGMENT1)) > 0
                                     THEN TO_CHAR(LAST_DAY(ADD_MONTHS(V_PLAN_START_DATE, TRUNC(TO_NUMBER(L.SEGMENT1)) - 1)), 'YYYYMM')
                                     ELSE V_FILL_0_TARGET_PERIOD_END_YYYYMM
                                     END AS END_YM
                           FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
                          WHERE 1 = 1
                            AND L.LOOKUP_TYPE = 'INTEGRATION_PSI_FIFO_NEED_PRE_PERIOD' /* ESS 선입선출 선점 차감 기간 (0 채우기 대상 기간 - 개월수) */
                            AND L.VALID_YN = 'Y'
                            AND NVL(L.SEGMENT1, '0') IS NOT NULL
                            AND VALIDATE_CONVERSION(L.SEGMENT1 AS NUMBER) = 1
                          ORDER BY L.LAST_UPDATE_DATE DESC )
                 WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;

            IF V_FILL_0_TARGET_PERIOD_END_YYYYMM > SUBSTR(V_HORIZON_END_YYYYMMDD, 1, 6) THEN
                V_FILL_0_TARGET_PERIOD_END_YYYYMM := SUBSTR(V_HORIZON_END_YYYYMMDD, 1, 6);
            END IF;

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '@V_FILL_0_TARGET_PERIOD : ' || TO_CHAR(V_FILL_0_TARGET_PERIOD));
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '@V_FILL_0_TARGET_PERIOD_END_YYYYMM : ' || V_FILL_0_TARGET_PERIOD_END_YYYYMM);

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 기간 월 목록');

            DELETE FROM GT_PIS_MM_LIST;
            INSERT INTO GT_PIS_MM_LIST
            SELECT DISTINCT YYYYMM
              FROM SCM_MST_BUCKET B
             WHERE 1 = 1
               AND B.YYYYMM BETWEEN V_PLAN_START_YYYYMM
                               AND V_FILL_0_TARGET_PERIOD_END_YYYYMM;

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 Measure');

            DELETE FROM GT_PIS_TARGET_MM_0;
            INSERT INTO GT_PIS_TARGET_MM_0
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY, ATTRIBUTE1 )
            SELECT T.DIVISION_ID
                 , T.COMPANY_ID
                 , T.PLANT_ID
                 , T.PLAN_START_YYYYMMDD
                 , T.SEQ
                 , T.OPERATION_GROUP
                 , T.FROM_SITE
                 , T.CELL_ITEM_ID
                 , T.ITEM_ID
                 , T.MEASURE
                 , T.VALUE_TYPE
                 , T.TO_PRODUCT
                 , T.LINE_ID
                 , T.BOH_QTY
                 , T.TO_SITE
                 , T.INCOTERMS
                 , T.SEQ_FLAG
                 , M.YYYYMM
                 , NVL(MAX(CASE WHEN T.YYYYMM = M.YYYYMM THEN T.QTY ELSE NULL END), 0) AS QTY  /* 재고를 제외하고 음수가 없기 떄문에 MAX처리 문제 없음 ?! */
                 , MAX(T.ATTRIBUTE1) AS ATTRIBUTE1
              FROM GT_PIS_GRP2      T
                 , GT_PIS_MM_LIST   M
             WHERE 1 = 1
               AND 1 = 1
               AND T.MEASURE NOT IN ('SHIP_PLAN_RTF', 'MKT_FCST', 'INV')
               AND T.YYYYMM BETWEEN V_PLAN_START_YYYYMM
                               AND V_FILL_0_TARGET_PERIOD_END_YYYYMM
             GROUP BY T.DIVISION_ID
                    , T.COMPANY_ID
                    , T.PLANT_ID
                    , T.PLAN_START_YYYYMMDD
                    , T.SEQ
                    , T.OPERATION_GROUP
                    , T.FROM_SITE
                    , T.CELL_ITEM_ID
                    , T.ITEM_ID
                    , T.MEASURE
                    , T.VALUE_TYPE
                    , T.TO_PRODUCT
                    , T.LINE_ID
                    , T.BOH_QTY
                    , T.TO_SITE
                    , T.INCOTERMS
                    , T.SEQ_FLAG
                    , M.YYYYMM;

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 Measure - 채우기 전 데이터 삭제 (해당 기간)');
            DELETE FROM GT_PIS_GRP2 T
             WHERE 1 = 1
               AND T.YYYYMM BETWEEN V_PLAN_START_YYYYMM
                               AND V_FILL_0_TARGET_PERIOD_END_YYYYMM
               AND T.MEASURE NOT IN ('SHIP_PLAN_RTF', 'MKT_FCST', 'INV');

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 Measure - 0 채운 데이터 Insert - Start ');
            INSERT INTO GT_PIS_GRP2 (
                   DIVISION_ID
                  , COMPANY_ID
                  , PLANT_ID
                  , PLAN_START_YYYYMMDD
                  , SEQ
                  , OPERATION_GROUP
                  , FROM_SITE
                  , CELL_ITEM_ID
                  , ITEM_ID
                  , MEASURE
                  , VALUE_TYPE
                  , TO_PRODUCT
                  , LINE_ID
                  , BOH_QTY
                  , TO_SITE
                  , INCOTERMS
                  , SEQ_FLAG
                  , YYYYMM
                  , QTY
                  , ATTRIBUTE1)
            SELECT T.DIVISION_ID
                 , T.COMPANY_ID
                 , T.PLANT_ID
                 , T.PLAN_START_YYYYMMDD
                 , T.SEQ
                 , T.OPERATION_GROUP
                 , T.FROM_SITE
                 , T.CELL_ITEM_ID
                 , T.ITEM_ID
                 , T.MEASURE
                 , T.VALUE_TYPE
                 , T.TO_PRODUCT
                 , T.LINE_ID
                 , T.BOH_QTY
                 , T.TO_SITE
                 , T.INCOTERMS
                 , T.SEQ_FLAG
                 , T.YYYYMM
                 , T.QTY
                 , T.ATTRIBUTE1
              FROM GT_PIS_TARGET_MM_0 T;
    /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
    /* 2025.03.013  End   PJ20249548R  : 빈월 수량 0 데이터 생성 반영 */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || 'End	 PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영');
    /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 이전 동일 수행건 삭제 후 수행내역 Insert */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := 'Delete';
            DELETE FROM SCP_ANL_PSI_INTEGRATION A
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.DIVISION_ID         = V_DIVISION_ID;

            V_STATUS_DESC := 'insert';
            INSERT INTO SCP_ANL_PSI_INTEGRATION
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE
                , INCOTERMS, SEQ_FLAG, YYYYMM, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                , ATTRIBUTE9, ATTRIBUTE10 )
            SELECT DIVISION_ID
                 , NVL(COMPANY_ID, '-')
                 , NVL(PLANT_ID, '-')
                 , PLAN_START_YYYYMMDD
                 , SEQ
                 , OPERATION_GROUP
                 , FROM_SITE
                 , CELL_ITEM_ID
                 , ITEM_ID
                 , MEASURE
                 , VALUE_TYPE
                 , TO_PRODUCT
                 , LINE_ID
                 , ROUND(NVL(BOH_QTY, 0), 0)
                 , TO_SITE
                 , NVL(INCOTERMS, '-')
                 , SEQ_FLAG
                 , YYYYMM
                 , ROUND(NVL(QTY, 0), 0)
                 , 'SCP BATCH' AS CREATED_BY
                 , SYSDATE AS CREATION_DATE
                 , 'SCP BATCH' AS LAST_UPDATED_BY
                 , SYSDATE AS LAST_UPDATE_DATE
                 , ATTRIBUTE1
                 , V_PLAN_TYPE                                AS ATTRIBUTE2  /* 2025.03.13 수정 */
                 , TO_CHAR(V_FILL_0_TARGET_PERIOD)            AS ATTRIBUTE3  /* 2025.03.13 수정 */
                 , ATTRIBUTE4
                 , ATTRIBUTE5
                 , ATTRIBUTE6
                 , ATTRIBUTE7
                 , ATTRIBUTE8
                 , ATTRIBUTE9
                 , ATTRIBUTE10
              FROM GT_PIS_GRP2;

            /* 원본 drop table #tmp_* → GTT 이므로 DELETE (세션 잔존 데이터 정리) */
            DELETE FROM GT_PIS_MAIN;
            DELETE FROM GT_PIS_GRP;
            DELETE FROM GT_PIS_GRP2;
            DELETE FROM GT_PIS_INV;
            DELETE FROM GT_PIS_220_240;
            DELETE FROM GT_PIS_320_340;
            DELETE FROM GT_PIS_230_ITEM;
            DELETE FROM GT_PIS_350;
            DELETE FROM GT_PIS_450;
            DELETE FROM GT_PIS_430;
            DELETE FROM GT_PIS_350_750_430;
            DELETE FROM GT_PIS_750;
            DELETE FROM GT_PIS_YIELD_A;
            DELETE FROM GT_PIS_ITEM_BOM;
            DELETE FROM GT_PIS_650_330;
            DELETE FROM GT_PIS_SITE_ITEM_PRIO;
            DELETE FROM GT_PIS_SITE_ITEM_PRIO_INV;
            DELETE FROM GT_PIS_ELEC_PLANT;
            DELETE FROM GT_PIS_CELL_ELEC_MAP;
            DELETE FROM GT_PIS_MM_LIST;
            DELETE FROM GT_PIS_TARGET_MM_0;
            DELETE FROM GT_PIS_ULS_LKUP_CELL;
            DELETE FROM GT_PIS_ULS_LKUP_TCO;

            /* TXN LOG */
            V_LOG_TYPE    := 'TXN';

            N_LOG_COUNT   := 1;
            V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
            D_EVENT_DATE  := SYSDATE;
            V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ':' || V_DIVISION_ID;

            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => V_LOG_TYPE
                                , P_LOG_COUNT    => N_LOG_COUNT
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

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
    /*       MSSQL REPLICATE 는 반복횟수가 음수면 NULL 을 돌려주고(REPLICATE('0',-1) IS NULL, */
    V_EXEC_TIME := CASE WHEN LENGTH(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60))) > 2 THEN NULL
                        ELSE LPAD(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0') || ':' ||
                             LPAD(TO_CHAR(MOD(ROUND((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0')
                   END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '[' || V_DIVISION_ID || '][' || V_PLAN_START_YYYYMMDD || '][' || V_EXEC_TIME || ']';
    V_DESCRIPTION := '[' || V_STATUS_DESC || '][' || V_PLAN_START_YYYYMMDD || '][' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;

    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );


    COMMIT;
    RETURN;

END;