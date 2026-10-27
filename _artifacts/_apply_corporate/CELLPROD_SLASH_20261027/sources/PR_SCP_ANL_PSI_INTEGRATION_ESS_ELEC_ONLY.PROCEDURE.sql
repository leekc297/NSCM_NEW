PROCEDURE PR_SCP_ANL_PSI_INTEGRATION_ESS_ELEC_ONLY
(
      P_DIVISION_ID          IN VARCHAR2
    , P_PLAN_START_YYYYMMDD  IN VARCHAR2
)
/*******************************************************************************************************************
 * Program ID   : PR_SCP_ANL_PSI_INTEGRATION_ESS_Elec_only
 * Description  : 재료비 TASK
 * OutTable     : SCP_ANL_PSI_INTEGRATION_ESS
 * Execute      :
                  EXEC PR_SCP_ANL_PSI_INTEGRATION_ESSElec_only @p_division_id         = '82'
                      ,@p_plan_start_yyyymmdd = '20240617'

 * Program History
 *===================================================================================================
 * Date         In Charge      Description
 *===================================================================================================
 * 2024.06.20                  Initial 재료비 TASK PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : 통합 PSI용 정보 구성
 * 2024.10.14   vadabi5        NERP) Batch WEB/CS 특정 Comnpany Code 대응
 * 2025.02.03   hrkim          Semi WH In Company 오류 수정 (@v_ESNJ3 -> @v_ESNJ)
 * 2025.02.14   hrkim          cell/전극 plant 매핑 로직 수정
 *                                - 1순위 : division, company, plant 정보로 매핑
 *                                - 2순위 : division, company, city, country 정보로 매핑
 *                                - 3순위 : division, company 정보로 매핑
 *                                - 4순위 : company 정보로 매핑
 * 2025.03.13   hrkim          PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선
 *                                - 빈월 수량 0 데이터 생성 반영
 *                                - 비대상 measure : MKT_FCST, SHIP_PLAN_RTF
 *                                - plan 시작월 부터 lookup 설정한 개월수 만큼만 (lookup type : INTEGRATION_PSI_FIFO_NEED_PRE_PERIOD)
 *                                - attribute2 : PLAN_TYPE
 *                                - attribute3 : INTEGRATION_PSI_FIFO_NEED_PRE_PERIOD lookup 설정 값
 * 2025.04.25   hrkim          PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선
 *                                - 타division 전극 생산 plant 자division plant로 생성 적용
 *                                - 타division 전극 BOH  plant 자division plant로 생성 적용
 * 2026.01.12   YMH            - E20260109-002382 ESS JV 혼용생산 관련 통합 PSI 레포트 구성
 * 2026.07.06   ZIONEX  [PJ202650304]  NextSCM Migration
 *******************************************************************************************************************/
/* exec PR_SCP_ANL_PSI_INTEGRATION_ESS_Elec_only '82', '20250120' */
/* exec PR_SCP_ANL_PSI_INTEGRATION_ESS_Elec_only '82', '20241216' */
/* exec PR_SCP_ANL_PSI_INTEGRATION_ESS_Elec_only '82', '20240819' */
/* exec PR_SCP_ANL_PSI_INTEGRATION_ESS_Elec_only '82', '20240819' */
AS
    /* ============================================================================
     *       · SCM_MST_SITE B + ELEC_PLANT E2/E5 (상관 UPDATE 조인골격) : 실데이터 2890행
     *       · PLAN+PLAN_DETAIL / DIVISION 셀프조인 / MS-MS2 중첩 IN / INV+SITE / MM_LIST 크로스
     * ============================================================================ */
    /* LOG 용 변수 설정 */
    V_BATCH_USER   VARCHAR2(150 CHAR) := 'scp_batch';
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'PR_SCP_ANL_PSI_INTEGRATION_ESS_Elec_only';
    V_LOG_TYPE     VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT    NUMBER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    V_TABLE_ID     VARCHAR2(150 CHAR) := 'SCP_ANL_PSI_INTEGRATION_ESS';
    D_EVENT_DATE   DATE;

    V_ESOC          VARCHAR2(20 CHAR);
    V_ESNJ          VARCHAR2(20 CHAR);
    V_ESNJ3         VARCHAR2(20 CHAR);
    V_COMPANY_SALES VARCHAR2(20 CHAR);

    V_STATUS_DESC   VARCHAR2(1000 CHAR) := 'START';

    /* 임시 실행시간 확인용 */
    V_START_TIME    DATE;
    V_EXEC_TIME     VARCHAR2(10 CHAR) := '';  /* '00:00'; */

    /* SCP 계힉 참조를 위한 변수 */
    V_DIVISION_ID           VARCHAR2(10 CHAR)  := NVL(P_DIVISION_ID, '81');
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
    /* V_EE_PLAN_TYPE          VARCHAR2(100 CHAR) := 'MA'; */
    V_EE_PLAN_SEQ             NUMBER             := 1;
    V_EE_MASTER_ID            VARCHAR2(100 CHAR) := NULL;
    V_EE_ENG_PLAN_ID          VARCHAR2(100 CHAR) := NULL;

    /* 월_INVentory 생성용 (원본은 본문 중간 DECLARE — 대입은 원 위치에서 수행) */
    V_MIN_YYYYMM      VARCHAR2(6 CHAR);
    V_MAX_YYYYMM      VARCHAR2(6 CHAR);
    V_PRE_YYYYMM      VARCHAR2(6 CHAR);
    V_PROC_YYYYMM     VARCHAR2(6 CHAR);
    V_PROC_YYYYMMDD   VARCHAR2(8 CHAR);
    V_I               NUMBER;

    /* 빈월 0 채우기 대상 기간 (원본은 본문 중간 DECLARE — 대입은 원 위치에서 수행) */
    V_FILL_0_TARGET_PERIOD             NUMBER;
    V_FILL_0_TARGET_PERIOD_END_YYYYMM  VARCHAR2(6 CHAR);


    V_JJGV_LOG_MESSAGE  VARCHAR2(1000 CHAR);
BEGIN

    IF P_DIVISION_ID <> '82' THEN
        RETURN;
    END IF;


    DELETE FROM GT_PIESSEO_JV_LAST_VER;
    DELETE FROM GT_PIESSEO_ELEC_PLANT;
    DELETE FROM GT_PIESSEO_INV;
    DELETE FROM GT_PIESSEO_520_540;
    DELETE FROM GT_PIESSEO_MAIN;
    DELETE FROM GT_PIESSEO_MM_LIST;
    DELETE FROM GT_PIESSEO_TARGET_MM_0;

    /* 원본 SELECT @v = SEGMENT2 FROM ... (0행이면 대입없이 직전값 유지 = NULL, 다행이면 임의1행 -> MAX) */
    SELECT MAX(SEGMENT2)
      INTO V_ESOC
      FROM SCM_CODE_LOOKUP_VALUE
     WHERE LOOKUP_TYPE_CODE = 'PR_SCP_ANL_PSI_INTEGRATION_ESS'
       AND SEGMENT1         = 'ESOC';

    SELECT MAX(SEGMENT2)
      INTO V_ESNJ
      FROM SCM_CODE_LOOKUP_VALUE
     WHERE LOOKUP_TYPE_CODE = 'PR_SCP_ANL_PSI_INTEGRATION_ESS'
       AND SEGMENT1         = 'ESNJ';

    SELECT MAX(SEGMENT2)
      INTO V_ESNJ3
      FROM SCM_CODE_LOOKUP_VALUE
     WHERE LOOKUP_TYPE_CODE = 'PR_SCP_ANL_PSI_INTEGRATION_ESS'
       AND SEGMENT1         = 'ESNJ3';

    SELECT MAX(SEGMENT2)
      INTO V_COMPANY_SALES
      FROM SCM_CODE_LOOKUP_VALUE
     WHERE LOOKUP_TYPE_CODE = 'PR_SCP_ANL_PSI_INTEGRATION_ESS'
       AND SEGMENT1         = 'COMPANY_SALES';

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
                SELECT PLAN_SEQ
                     , PLAN_NAME
                     , PLAN_START_DATE
                     , PLAN_START_YYYYMM
                     , HORIZON_END_YYYYMMDD
                     , MASTER_ID
                     , ENG_PLAN_ID
                  INTO V_PLAN_SEQ
                     , V_PLAN_START_YYYYMMDD
                     , V_PLAN_START_DATE
                     , V_PLAN_START_YYYYMM
                     , V_HORIZON_END_YYYYMMDD
                     , V_MASTER_ID
                     , V_ENG_PLAN_ID
                  FROM ( SELECT D.PLAN_SEQ                                                       AS PLAN_SEQ        /* 1 */
                              , P.PLAN_NAME                                                      AS PLAN_NAME       /* 20240527 */
                              , TO_DATE(P.PLAN_NAME, 'YYYYMMDD')                                 AS PLAN_START_DATE
                              , SUBSTR(P.PLAN_NAME, 1, 6)                                        AS PLAN_START_YYYYMM     /* 202405 */
                              , SUBSTR(P.HORIZON_END_DATE, 1, 8)                                 AS HORIZON_END_YYYYMMDD  /* 20250525 */
                              , P.DIVISION_ID || '::' || P.PLAN_CYCLE                            AS MASTER_ID       /* 81::WEEKLY */
                              , P.PLAN_ID || '::' || D.PLAN_TYPE || '::' || TO_CHAR(D.PLAN_SEQ)  AS ENG_PLAN_ID     /* 1341::FN::1 */
                           FROM SCM_MST_PLAN        P
                              , SCM_MST_PLAN_DETAIL D
                          WHERE 1 = 1
                            AND D.DIVISION_ID  = P.DIVISION_ID
                            AND D.PLAN_ID      = P.PLAN_ID
                            AND D.PLAN_TYPE    = V_PLAN_TYPE  /* FN */
                            AND D.PLAN_STATUS  = '1'   /* 정상 완료 */
                            AND D.CONFIRM_FLAG = 'Y'   /* 최종 Confirm */
                            AND P.DIVISION_ID  = V_DIVISION_ID
                            AND P.PLAN_NAME    = P_PLAN_START_YYYYMMDD
                            AND P.PLAN_CYCLE   = 'WEEKLY'
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
                SELECT PLAN_SEQ
                     , PLAN_NAME
                     , MASTER_ID
                     , ENG_PLAN_ID
                  INTO V_EE_PLAN_SEQ
                     , V_EE_PLAN_START_YYYYMMDD
                     , V_EE_MASTER_ID
                     , V_EE_ENG_PLAN_ID
                  FROM ( SELECT D.PLAN_SEQ                                                       AS PLAN_SEQ
                              , P.PLAN_NAME                                                      AS PLAN_NAME
                              , P.DIVISION_ID || '::' || P.PLAN_CYCLE                            AS MASTER_ID
                              , P.PLAN_ID || '::' || D.PLAN_TYPE || '::' || TO_CHAR(D.PLAN_SEQ)  AS ENG_PLAN_ID
                           FROM SCM_MST_PLAN        P
                              , SCM_MST_PLAN_DETAIL D
                          WHERE 1 = 1
                            AND D.DIVISION_ID  = P.DIVISION_ID
                            AND D.PLAN_ID      = P.PLAN_ID
                            AND D.PLAN_TYPE    = V_PLAN_TYPE  /* FN */
                            AND D.PLAN_STATUS  = '1'   /* 정상 완료 */
                            AND D.CONFIRM_FLAG = 'Y'   /* 최종 Confirm */
                            AND P.DIVISION_ID  = V_EE_DIVISION_ID
                            AND P.PLAN_NAME    = P_PLAN_START_YYYYMMDD
                            AND P.PLAN_CYCLE   = 'WEEKLY'
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

            /* E20260109-002382 JV전극 최종버전 조회. */

            DELETE FROM GT_PIESSEO_JV_LAST_VER;

            INSERT
              INTO GT_PIESSEO_JV_LAST_VER
                 ( PLAN_SEQ
                 , PLAN_NAME
                 , MASTER_ID
                 , ENGINE_PLAN_ID
                 , DIVISION_ID )
            SELECT TP.PLAN_SEQ
                 , TP.PLAN_NAME
                 , TP.MASTER_ID
                 , TP.ENGINE_PLAN_ID
                 , TP.DIVISION_ID
              FROM ( SELECT PM.PLAN_NAME
                          , PD.PLAN_SEQ
                          , PM.DIVISION_ID || '::' || PM.PLAN_CYCLE                              AS MASTER_ID
                          , PM.PLAN_ID || '::' || PD.PLAN_TYPE || '::' || TO_CHAR(PD.PLAN_SEQ)   AS ENGINE_PLAN_ID
                          , PM.DIVISION_ID
                          , ROW_NUMBER() OVER (PARTITION BY PM.DIVISION_ID
                                                   ORDER BY CASE PD.PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 5 END
                                                          , CASE WHEN PD.CONFIRM_FLAG = 'Y' THEN 1 ELSE 2 END
                                                          , PD.PLAN_SEQ DESC ) AS NUM
                       FROM SCM_MST_PLAN        PM
                          , SCM_MST_PLAN_DETAIL PD
                      WHERE PM.PLAN_ID          = PD.PLAN_ID
                        AND PM.DIVISION_ID      = PD.DIVISION_ID
                        AND PM.DIVISION_ID IN ( SELECT DISTINCT EMD.DIVISION_ID
                                                  FROM SCM_MST_DIVISION MD
                                                     , SCM_MST_DIVISION EMD
                                                 WHERE MD.ATTRIBUTE4  = EMD.ATTRIBUTE4
                                                   AND EMD.ATTRIBUTE3 = 'EE'
                                                   AND MD.DIVISION_ID IN ( SELECT DISTINCT MS2.DIVISION_ID
                                                                             FROM SCM_MST_SITE MS
                                                                                , SCM_MST_SITE MS2
                                                                            WHERE MS.ATTRIBUTE9 = MS2.SCM_SITE_ID  /* 실제 생산 Site가 Attribute9에 관리됨 */
                                                                              AND MS.DIVISION_ID = P_DIVISION_ID
                                                                              AND MS.SITE_TYPE   = 'PLANT'
                                                                              AND MS.VALID_YN    = 'Y' ) )
                        AND PM.PLAN_NAME          = P_PLAN_START_YYYYMMDD
                        AND PM.PLAN_CYCLE         = 'WEEKLY'
                        AND PD.PLAN_STATUS        = '1'
                        AND PD.PLAN_TYPE          = V_PLAN_TYPE  /* FN */
                        AND PD.PLAN_STATUS        = '1'   /* 정상 완료 */
                        AND PD.CONFIRM_FLAG       = 'Y'   /* 최종 Confirm */
                        AND PD.ACTIVE_FLAG        = 'Y' ) TP
             WHERE TP.NUM = 1
               AND TP.DIVISION_ID != V_EE_DIVISION_ID;

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' 전극 plant 사이트 정보 추출 - #elec_plant');
            /* 2025.02.14 cell/전극 plant 매핑 로직 수정 */
            /* 1순위 : division, company, plant 정보로 매핑 */
            /* 2순위 : division, company, city, country 정보로 매핑 */
            /* 3순위 : division, company 정보로 매핑 */
            /* 4순위 : company 정보로 매핑 */
            /* ---------------------------------------------------------------------------------------------------------------- */

            DELETE FROM GT_PIESSEO_ELEC_PLANT;

            INSERT
              INTO GT_PIESSEO_ELEC_PLANT
                 ( COMPANY_ID
                 , DIVISION_ID
                 , CITY
                 , COUNTRY
                 , PLANT_ID
                 , SITE_DESCRIPTION
                 , SCM_SITE_ID
                 , SITE_ID
                 , ELEC_PLANT_PRIORITY_1ST
                 , ELEC_PLANT_PRIORITY_2ND
                 , ELEC_PLANT_PRIORITY_3RD
                 , ELEC_PLANT_PRIORITY_4TH
                 , ELEC_PLANT_PRIORITY_5TH )
            SELECT ES.COMPANY_ID
                 , ES.DIVISION_ID
                 , NVL(ES.CITY   ,'Z') AS CITY
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
                                                 , NVL(ES.CITY   ,'Z')
                                                 , NVL(ES.COUNTRY,'Z')
                                          ORDER BY ES.PLANT_ID) AS ELEC_PLANT_PRIORITY_2ND
                 , ROW_NUMBER() OVER (PARTITION BY ES.COMPANY_ID
                                                 , ES.DIVISION_ID
                                          ORDER BY ES.PLANT_ID) AS ELEC_PLANT_PRIORITY_3RD
                 , ROW_NUMBER() OVER (PARTITION BY ES.COMPANY_ID
                                          ORDER BY ES.PLANT_ID) AS ELEC_PLANT_PRIORITY_4TH
                 , ROW_NUMBER() OVER (PARTITION BY ES.COMPANY_ID
                                                 , NVL(ES.CITY   ,'Z')
                                                 , NVL(ES.COUNTRY,'Z')
                                          ORDER BY CASE WHEN ES.DIVISION_ID = V_DIVISION_ID
                                                        THEN 1
                                                        ELSE 2
                                                   END
                                                 , ES.PLANT_ID) AS ELEC_PLANT_PRIORITY_5TH  /* - 2025.04.25 타division생성 전극 반영시 plant 매핑 */
              FROM SCM_MST_SITE ES
             WHERE 1 = 1
               AND ES.VALID_YN        = 'Y'
               AND ES.OPERATION_GROUP = 'E'   /* 전극 Plant */
               AND ES.SITE_TYPE       = 'PLANT';

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서 */
            /*    → GTT(GT_PIESSEO_INV / _520_540 / _MAIN) 사전 생성 + 진입부 DELETE 로 대체 */

            /* ----------------------------------------------------------------------------------------------------------- */

            /**********************************************************************
             EE 재고('560')를 #tmp_PSI_INTEGRATION_ESS_inv 에 추가로 insert 해야함.
            ***********************************************************************/

            V_STATUS_DESC := '6.BOH EE';

            INSERT
              INTO GT_PIESSEO_INV
                 ( DIVISION_ID
                 , COMPANY_ID
                 , PLANT_ID
                 , FROM_SITE
                 , ITEM_ID
                 , YYYYMMDD
                 , QTY
                 , DESCR
                 , ATTRIBUTE8
                 , FLOW_ID
                 , OPERATION_GROUP )
            SELECT V_DIVISION_ID
                 , '-' AS COMPANY_ID
                 , '-' AS PLANT_ID
                 , A.SCM_SITE_ID  AS FROM_SITE
                 , A.ELEC_ITEM_ID AS ITEM_ID
                 , V_PLAN_START_YYYYMMDD  AS YYYYMMDD
                 , NVL(SUM(CASE  WHEN A.LVL IS NULL THEN NVL(A.SCM_QTY,0)
                                 WHEN A.LVL = '4'   THEN NVL(A.SCM_QTY,0)
                                 WHEN A.LVL = '3'   THEN NVL(A.L1_QTY,0)
                                 WHEN A.LVL = '2'   THEN NVL(A.L2_QTY,0)
                                 WHEN A.LVL = '1'   THEN NVL(A.L3_QTY,0)
                                 END),0) AS QTY
                 , (CASE WHEN A.STOCK_TYPE = 'INTRANSIT' THEN 'INT'
                         ELSE 'WH'
                         END ) AS DESCR
                 , '-' AS ATTRIBUTE8
                 , 'E2000' FLOW_ID
                 , 'E' AS OPERATION_GROUP
              FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A
/*            from SCP_ANL_PSI_INTEGRATION_ELEC_BOM_ACCUM A with (nolock) */
                 , SCP_MST_FINAL_ITEM FI
             WHERE 1 = 1  /* DIVISION_ID = @V_DIVISION_ID  -- '82'  -- */
               AND FI.ITEM_ID         = A.ELEC_ITEM_ID
               AND FI.OPERATION_GROUP = 'E'
               AND FI.CELL_ITEM_ID LIKE 'EC%'
               AND FI.DIVISION_ID     = V_DIVISION_ID
/*            AND PLAN_TYPE = @V_EE_PLAN_TYPE  -- 'FN'  -- */
               AND A.PLAN_ID = SUBSTR(V_EE_ENG_PLAN_ID, 1, INSTR(V_EE_ENG_PLAN_ID, '::') - 1)  /* '1348'  -- */
             GROUP BY A.SCM_SITE_ID
                    , A.ELEC_ITEM_ID
                    , (CASE WHEN A.STOCK_TYPE = 'INTRANSIT' THEN 'INT'
                            ELSE 'WH'
                            END );

            /* 재고의 COMPANY_ID, PLANT_ID 반영. */
            /* 원본 UPDATE ... FROM (#tmp a LEFT OUTER JOIN scm_mst_site b ON b.scm_site_id=a.from_site, LEFT JOIN #elec_plant e2/e5) */

            /*     (26ai 실데이터에 division 넘나드는 SCM_SITE_ID 중복 존재). MSSQL 은 임의1행을 갱신하나, */
            /*     상관 서브쿼리에서는 COMPANY/PLANT 를 각각 MAX 로 독립계산(결정적). LEFT JOIN 비매칭 시 */

            UPDATE GT_PIESSEO_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT CASE WHEN COUNT(*) = 0 THEN '-'
                                 ELSE MAX(CASE WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND B.OPERATION_GROUP = 'A' AND B.COMPANY_ID = V_ESOC) THEN V_ESNJ  /* 'G183'의 company_id = 'G180' 으로 변경. */
                                               ELSE NVL(B.COMPANY_ID,'-')
                                          END )
                            END
                          , CASE WHEN COUNT(*) = 0 THEN '-'
                                 ELSE MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND B.OPERATION_GROUP = 'A' AND B.COMPANY_ID = V_ESOC) THEN V_ESNJ3 /* 'A041' 에서 'G183' 으로 변경. */
                                               WHEN B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND B.DIVISION_ID != V_DIVISION_ID AND E5.PLANT_ID IS NOT NULL THEN E5.PLANT_ID /* 2025.04.25 타division plant BOH -> 자division plant로 수정 적용 (WA00->WA01) */
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND B.OPERATION_GROUP = 'A'
                                                     AND E2.PLANT_ID IS NOT NULL) THEN E2.PLANT_ID  /* 2025.02.14  2순위 참조 케이스 추가 (division, company, city, country정보로 매핑) */
/* 2순위 Division 조건 추가(2024.12.31) start */
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND B.OPERATION_GROUP = 'A' AND
                                                     EXISTS (SELECT 1
                                                               FROM SCM_MST_SITE X
                                                              WHERE X.SITE_TYPE = 'PLANT'
                                                                AND X.VALID_YN = 'Y'
                                                                AND X.COMPANY_ID = B.COMPANY_ID
                                                                AND X.DIVISION_ID = B.DIVISION_ID
                                                                AND X.OPERATION_GROUP = 'E'))  THEN (SELECT K.PLANT_ID
                                                                                                       FROM SCM_MST_SITE K
                                                                                                      WHERE K.SITE_TYPE = 'PLANT'
                                                                                                        AND K.VALID_YN = 'Y'
                                                                                                        AND K.COMPANY_ID = B.COMPANY_ID
                                                                                                        AND K.DIVISION_ID = B.DIVISION_ID
                                                                                                        AND K.OPERATION_GROUP = 'E'
                                                                                                        AND ROWNUM = 1)
/* 2순위 Division 조건 추가(2024.12.31) end */
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND B.OPERATION_GROUP = 'A')
                                                                                                THEN (SELECT K.PLANT_ID
                                                                                                        FROM SCM_MST_SITE K
                                                                                                       WHERE K.SITE_TYPE = 'PLANT'
                                                                                                         AND K.VALID_YN = 'Y'
                                                                                                         AND K.COMPANY_ID = B.COMPANY_ID
                                                                                                         AND K.OPERATION_GROUP = 'E'
                                                                                                         AND ROWNUM = 1)
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N') THEN B.PLANT_ID
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'Y') THEN B.LOGISTIC_PLANT_ID
                                               ELSE '-'
                                          END )
                            END
                       FROM SCM_MST_SITE            B
                          , GT_PIESSEO_ELEC_PLANT   E2  /* 2025.02.14 */
                          , GT_PIESSEO_ELEC_PLANT   E5  /* 2025.04.25 */
                      WHERE B.SCM_SITE_ID = A.FROM_SITE
                        AND E2.DIVISION_ID(+) = B.DIVISION_ID
                        AND E2.COMPANY_ID(+)  = B.COMPANY_ID
                        AND E2.CITY(+)        = NVL(B.CITY,'Z')
                        AND E2.COUNTRY(+)     = NVL(B.COUNTRY,'Z')
                        AND E2.ELEC_PLANT_PRIORITY_2ND(+) = 1
                        AND E5.COMPANY_ID(+)  = B.COMPANY_ID
                        AND E5.CITY(+)        = NVL(B.CITY,'Z')
                        AND E5.COUNTRY(+)     = NVL(B.COUNTRY,'Z')
                        AND E5.ELEC_PLANT_PRIORITY_5TH(+) = 1 );

/* 1번(추가) */
            UPDATE GT_PIESSEO_INV A
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
                                                                      AND M.MEASURE = 'WH_IN' )
                                                AND K.MEASURE = 'WH_IN') )
             WHERE NVL(A.PLANT_ID,'-') < '0';

/* 2번(기존) */
            UPDATE GT_PIESSEO_INV A
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
            UPDATE GT_PIESSEO_INV A
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

/* 4번(추가) : 해당 아이템의 BOH가 가장 큰 Plant로 지정 */
            UPDATE GT_PIESSEO_INV A
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
                        AND B.SCM_SITE_ID = (SELECT H.FROM_SITE
                                               FROM ( SELECT K.FROM_SITE
                                                        FROM GT_PIESSEO_INV K
                                                           , SCM_MST_SITE    M
                                                       WHERE M.DIVISION_ID = K.DIVISION_ID
                                                         AND M.SCM_SITE_ID = K.FROM_SITE
                                                         AND M.SITE_TYPE = 'PLANT'
                                                         AND K.DIVISION_ID = A.DIVISION_ID
                                                         AND (K.ITEM_ID = A.ITEM_ID OR K.ITEM_ID = NVL((SELECT MAX(Z.ITEM_ID_ASSY) FROM SCP_MST_CELL_PROD_ASSY_MAP Z WHERE Z.DIVISION_ID = A.DIVISION_ID AND Z.ITEM_ID_PROD = A.ITEM_ID AND Z.CELL_TYPE = 'CA1' AND Z.VALID_YN = 'Y'), A.ITEM_ID))
                                                         AND K.QTY <> 0
                                                       GROUP BY K.FROM_SITE
                                                              , K.ITEM_ID
                                                       ORDER BY SUM(K.QTY) DESC ) H
                                              WHERE ROWNUM = 1) )
             WHERE NVL(A.PLANT_ID,'-') < '0';

/* 5번(기존) */
            UPDATE GT_PIESSEO_INV A
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

            V_STATUS_DESC := '6.BOH inv';

/* '160' :  STOCK_OSP 의 외부 업체(OSP= 'Y') 정보 입력. (RACK/DC 임) */

            /* 전극 재고(560)는 stock_plan 에서 입력 */

            INSERT
              INTO GT_PIESSEO_MAIN
                    (   DIVISION_ID
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
                    )
            SELECT   A.DIVISION_ID AS DIVISION_ID
                   , A.COMPANY_ID
                   , A.PLANT_ID
                   , V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                   , 1 AS SEQ
                   , 'E' AS OPERATION_GROUP
                   , '-'  AS FROM_SITE
                   , '-' AS CELL_ITEM_ID
                   , A.ITEM_ID
                   , 'INV' AS MEASURE
                   , '-' AS VALUE_TYPE
                   , '-' AS TO_PRODUCT
                   , '-' AS LINE_ID
                   , NVL(SUM(NVL(A.QTY,0)),0)   AS BOH_QTY
                   , '-' AS TO_SITE
                   , '-' AS INCOTERMS
                   , '560' AS SEQ_FLAG
                   , SUBSTR(V_PLAN_START_YYYYMMDD,1,6) AS YYYYMM
                   , 0
              FROM GT_PIESSEO_INV A
             WHERE A.OPERATION_GROUP = 'E'
             GROUP BY A.DIVISION_ID
                   , A.COMPANY_ID
                   , A.PLANT_ID
                   , A.ITEM_ID;

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 500. 전극 */
            /*    520. 540. Ship. Plan(Semi), WH_IN */
            /* ----------------------------------------------------------------------------------------------------------- */

            INSERT
              INTO GT_PIESSEO_520_540
                 ( DIVISION_ID
                 , ORIGIN_FROM_DIVISION_ID
                 , ORIGIN_TO_DIVISION_ID
                 , COMPANY_ID
                 , TO_COMPANY_ID
                 , PLANT_ID
                 , TO_PLANT_ID
                 , BOD_ID
                 , PLAN_START_YYYYMMDD
                 , SEQ
                 , OPERATION_GROUP
                 , FROM_SITE
                 , ITEM_ID
                 , TO_SITE
                 , INCOTERMS
                 , QTY
                 , LT_TOTAL_SSP
                 , DEPARTURE_YYYYMMDD
                 , ARRIVAL_YYYYMMDD )
            SELECT  A.DIVISION_ID
                  , A.ORIGIN_FROM_DIVISION_ID
                  , A.ORIGIN_TO_DIVISION_ID
                  , B.COMPANY_ID
                    /* x.COMPANY_ID as to_COMPANY_ID, */
                  , (CASE WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND X.OPERATION_GROUP = 'A' AND X.COMPANY_ID = V_ESOC) THEN V_ESNJ  /* 2025.02.03 변수 사용 오류 수정 @v_ESNJ3  to  @v_ESNJ */
                          ELSE X.COMPANY_ID
                          END) AS TO_COMPANY_ID
                  , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                          ELSE B.PLANT_ID
                          END ) AS PLANT_ID
                  , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.TO_SITE
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND X.OPERATION_GROUP = 'A' AND X.COMPANY_ID = V_ESOC) THEN V_ESNJ3
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND X.OPERATION_GROUP = 'A'
                                AND E2.PLANT_ID IS NOT NULL) THEN E2.PLANT_ID  /* 2025.02.14  2순위 참조 케이스 추가 */
/* 2순위 Division 조건 추가(2024.12.31) start */
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND X.OPERATION_GROUP = 'A' AND
                                EXISTS (SELECT 1
                                          FROM SCM_MST_SITE SS
                                         WHERE SS.SITE_TYPE = 'PLANT'
                                           AND SS.VALID_YN = 'Y'
                                           AND SS.COMPANY_ID = X.COMPANY_ID
                                           AND SS.DIVISION_ID = X.DIVISION_ID
                                           AND SS.OPERATION_GROUP = 'E'))  THEN (SELECT K.PLANT_ID
                                                                                   FROM SCM_MST_SITE K
                                                                                  WHERE K.SITE_TYPE = 'PLANT'
                                                                                    AND K.VALID_YN = 'Y'
                                                                                    AND K.COMPANY_ID = X.COMPANY_ID
                                                                                    AND K.DIVISION_ID = X.DIVISION_ID
                                                                                    AND K.OPERATION_GROUP = 'E'
                                                                                    AND ROWNUM = 1)
/* 2순위 Division 조건 추가(2024.12.31) end */
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND X.OPERATION_GROUP = 'A')
                                                                             THEN (SELECT K.PLANT_ID
                                                                                     FROM SCM_MST_SITE K
                                                                                    WHERE K.SITE_TYPE = 'PLANT'
                                                                                      AND K.VALID_YN = 'Y'
                                                                                      AND K.COMPANY_ID = X.COMPANY_ID
                                                                                      AND K.OPERATION_GROUP = 'E'
                                                                                      AND ROWNUM = 1)
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N') THEN X.PLANT_ID
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'Y') THEN X.LOGISTIC_PLANT_ID
                          ELSE '-'
                          END ) AS TO_PLANT_ID
                  , A.BOD_ID
                  , A.PLAN_START_YYYYMMDD
                  , 1 AS SEQ
                  , 'E' AS OPERATION_GROUP
                  , A.FROM_SITE
                  , A.ITEM_ID
                  , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.TO_SITE
                          WHEN X.SITE_TYPE = 'PLANT' THEN X.PLANT_ID
                          ELSE '-'
                          END ) AS TO_SITE
                  , C.SSP_INCOTERMS AS INCOTERMS
                  , A.QTY
                  , C.LT_TOTAL_SSP
                  , A.YYYYMMDD AS DEPARTURE_YYYYMMDD
                  , TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + TRUNC(NVL(C.LT_TOTAL_SSP,0)), 'YYYYMMDD') AS ARRIVAL_YYYYMMDD
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                 , SCP_MST_FINAL_ITEM          FI
                 , SCM_MST_SITE                B
                 , SCM_MST_SITE                X
                 , SCP_MST_BOD_N_V             C
                 , GT_PIESSEO_ELEC_PLANT       E2  /* 2025.02.14 */
             WHERE FI.ITEM_ID         = A.ITEM_ID
               AND FI.OPERATION_GROUP = 'E'
               AND FI.CELL_ITEM_ID LIKE 'EC%'
               AND FI.DIVISION_ID     = V_DIVISION_ID
               AND B.SCM_SITE_ID(+) = A.FROM_SITE
               AND X.SCM_SITE_ID(+) = A.TO_SITE
               AND C.BOD_ID(+)      = A.BOD_ID
               AND E2.DIVISION_ID(+) = X.DIVISION_ID
               AND E2.COMPANY_ID(+)  = X.COMPANY_ID
               AND E2.CITY(+)        = NVL(X.CITY,'Z')
               AND E2.COUNTRY(+)     = NVL(X.COUNTRY,'Z')
               AND E2.ELEC_PLANT_PRIORITY_2ND(+) = 1
               AND A.PLAN_START_YYYYMMDD = V_EE_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_EE_PLAN_TYPE
               AND A.SEQ                 = V_EE_PLAN_SEQ
               AND A.DIVISION_ID         = V_EE_DIVISION_ID
               AND A.MEASURE = 'SHIP_PLAN_AMEND'
               AND A.OPERATION_GROUP = 'E'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD

            /* CSR : E20260109-002382 ESS JV 혼용생산 관련 통합 PSI 레포트 구성 */
            UNION ALL
            SELECT  A.DIVISION_ID
                  , A.ORIGIN_FROM_DIVISION_ID
                  , A.ORIGIN_TO_DIVISION_ID
                  , B.COMPANY_ID
                    /* x.COMPANY_ID as to_COMPANY_ID, */
                  , (CASE WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND X.OPERATION_GROUP = 'A' AND X.COMPANY_ID = V_ESOC) THEN V_ESNJ  /* 2025.02.03 변수 사용 오류 수정 @v_ESNJ3  to  @v_ESNJ */
                          ELSE X.COMPANY_ID
                          END) AS TO_COMPANY_ID
                  , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                          ELSE B.PLANT_ID
                          END ) AS PLANT_ID
                  , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.TO_SITE
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND X.OPERATION_GROUP = 'A' AND X.COMPANY_ID = V_ESOC) THEN V_ESNJ3
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND X.OPERATION_GROUP = 'A'
                                AND E2.PLANT_ID IS NOT NULL) THEN E2.PLANT_ID  /* 2025.02.14  2순위 참조 케이스 추가 */
                    /* 2순위 Division 조건 추가(2024.12.31) start */
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND X.OPERATION_GROUP = 'A' AND
                                EXISTS (SELECT 1
                                          FROM SCM_MST_SITE SS
                                         WHERE SS.SITE_TYPE = 'PLANT'
                                           AND SS.VALID_YN = 'Y'
                                           AND SS.COMPANY_ID = X.COMPANY_ID
                                           AND SS.DIVISION_ID = X.DIVISION_ID
                                           AND SS.OPERATION_GROUP = 'E'))  THEN (SELECT K.PLANT_ID
                                                                                   FROM SCM_MST_SITE K
                                                                                  WHERE K.SITE_TYPE = 'PLANT'
                                                                                    AND K.VALID_YN = 'Y'
                                                                                    AND K.COMPANY_ID = X.COMPANY_ID
                                                                                    AND K.DIVISION_ID = X.DIVISION_ID
                                                                                    AND K.OPERATION_GROUP = 'E'
                                                                                    AND ROWNUM = 1)
                    /* 2순위 Division 조건 추가(2024.12.31) end */
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND X.OPERATION_GROUP = 'A')
                                                                             THEN (SELECT K.PLANT_ID
                                                                                     FROM SCM_MST_SITE K
                                                                                    WHERE K.SITE_TYPE = 'PLANT'
                                                                                      AND K.VALID_YN = 'Y'
                                                                                      AND K.COMPANY_ID = X.COMPANY_ID
                                                                                      AND K.OPERATION_GROUP = 'E'
                                                                                      AND ROWNUM = 1)
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N') THEN X.PLANT_ID
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'Y') THEN X.LOGISTIC_PLANT_ID
                          ELSE '-'
                          END ) AS TO_PLANT_ID
                  , A.BOD_ID
                  , A.PLAN_START_YYYYMMDD
                  , 1 AS SEQ
                  , 'E' AS OPERATION_GROUP
                  , A.FROM_SITE
                  , A.ITEM_ID
                  , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.TO_SITE
                          WHEN X.SITE_TYPE = 'PLANT' THEN X.PLANT_ID
                          ELSE '-'
                          END ) AS TO_SITE
                  , C.SSP_INCOTERMS AS INCOTERMS
                  , A.QTY
                  , C.LT_TOTAL_SSP
                  , A.YYYYMMDD AS DEPARTURE_YYYYMMDD
                  , TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + TRUNC(NVL(C.LT_TOTAL_SSP,0)), 'YYYYMMDD') AS ARRIVAL_YYYYMMDD
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                 , GT_PIESSEO_JV_LAST_VER      JELV
                 , SCP_MST_FINAL_ITEM          FI
                 , SCM_MST_SITE                B
                 , SCM_MST_SITE                X
                 , SCP_MST_BOD_N_V             C
                 , GT_PIESSEO_ELEC_PLANT       E2  /* 2025.02.14 */
             WHERE A.PLAN_START_YYYYMMDD = JELV.PLAN_NAME
               AND A.PLAN_TYPE           = V_EE_PLAN_TYPE
               AND A.SEQ                 = JELV.PLAN_SEQ
               AND A.DIVISION_ID         = JELV.DIVISION_ID
               AND FI.ITEM_ID         = A.ITEM_ID
               AND FI.OPERATION_GROUP = 'E'
               AND FI.CELL_ITEM_ID LIKE 'EC%'
               AND FI.DIVISION_ID     = V_DIVISION_ID
               AND B.SCM_SITE_ID(+) = A.FROM_SITE
               AND X.SCM_SITE_ID(+) = A.TO_SITE
               AND C.BOD_ID(+)      = A.BOD_ID
               AND E2.DIVISION_ID(+) = X.DIVISION_ID
               AND E2.COMPANY_ID(+)  = X.COMPANY_ID
               AND E2.CITY(+)        = NVL(X.CITY,'Z')
               AND E2.COUNTRY(+)     = NVL(X.COUNTRY,'Z')
               AND E2.ELEC_PLANT_PRIORITY_2ND(+) = 1
               AND A.PLAN_START_YYYYMMDD = JELV.PLAN_NAME
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.MEASURE = 'SHIP_PLAN_AMEND'
               AND A.OPERATION_GROUP = 'E'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD;

            V_STATUS_DESC := '2.Ship. Plan(Semi) EE 520';

            INSERT
              INTO GT_PIESSEO_MAIN
                ( DIVISION_ID
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
                 )
            SELECT V_DIVISION_ID AS DIVISION_ID
                 , COMPANY_ID
                 , PLANT_ID
                 , PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'E' AS OPERATION_GROUP
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
                 , '520' AS SEQ_FLAG
                 , SUBSTR(A.ARRIVAL_YYYYMMDD,1,6) AS YYYYMM
                 , NVL(SUM(NVL(QTY,0)),0) AS QTY
              FROM GT_PIESSEO_520_540 A
             WHERE A.COMPANY_ID <> A.TO_COMPANY_ID
               AND A.ARRIVAL_YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY ORIGIN_FROM_DIVISION_ID
                    , COMPANY_ID
                    , PLANT_ID
                    , PLAN_START_YYYYMMDD
                    , ITEM_ID
                    , TO_PLANT_ID
                    , INCOTERMS
                    , SUBSTR(A.ARRIVAL_YYYYMMDD,1,6);

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 500. ESS 전극 */
            /*    540.Semi WH In */
            /* ----------------------------------------------------------------------------------------------------------- */

            V_STATUS_DESC := '4.Semi WH-IN  EE';

            INSERT
              INTO GT_PIESSEO_MAIN
                ( DIVISION_ID
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
                 )
            SELECT V_DIVISION_ID AS DIVISION_ID
                 , TO_COMPANY_ID AS COMPANY_ID
                 , TO_PLANT_ID AS PLANT_ID
                 , PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'E' AS OPERATION_GROUP
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
                 , '540' AS SEQ_FLAG
                 , SUBSTR(A.ARRIVAL_YYYYMMDD,1,6) AS YYYYMM
                 , NVL(SUM(NVL(QTY,0)),0) AS QTY
              FROM GT_PIESSEO_520_540 A
             WHERE A.COMPANY_ID <> A.TO_COMPANY_ID
               AND A.ARRIVAL_YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY ORIGIN_TO_DIVISION_ID
                    , TO_COMPANY_ID
                    , TO_PLANT_ID
                    , PLAN_START_YYYYMMDD
                    , ITEM_ID
                    , TO_SITE
                    , SUBSTR(A.ARRIVAL_YYYYMMDD,1,6);

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 500. ESS 전극 */
            /*    530.IN_HOUSE_MOVING */
            /* ----------------------------------------------------------------------------------------------------------- */

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 500. ESS 전극 */
            /*    550.PROD_PLAN */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '5.PROD_PLAN  EE';

            INSERT
              INTO GT_PIESSEO_MAIN
                ( DIVISION_ID
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
                 )
            SELECT V_DIVISION_ID
                 , B.COMPANY_ID
                 , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                         WHEN A.ORIGIN_DIVISION_ID != V_DIVISION_ID AND E.PLANT_ID IS NOT NULL THEN E.PLANT_ID /* 2025.04.25 타 division생성 전극 반영 */
                         ELSE B.PLANT_ID
                         END ) AS PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'E' AS OPERATION_GROUP
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
                 , '550' AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
                 , NVL(SUM(NVL(QTY,0)),0) AS QTY
              FROM SCP_ANL_PRODUCTION_PLAN A
                 , SCP_MST_FINAL_ITEM      FI
                 , SCM_MST_SITE            B
                 , GT_PIESSEO_ELEC_PLANT   E  /* 2025.04.25 */
             WHERE FI.ITEM_ID         = A.ITEM_ID
               AND FI.OPERATION_GROUP = 'E'
               AND FI.CELL_ITEM_ID LIKE 'EC%'
               AND FI.DIVISION_ID     = V_DIVISION_ID
               AND B.SCM_SITE_ID = A.SCM_SITE_ID
               AND E.COMPANY_ID(+)  = B.COMPANY_ID
               AND E.CITY(+)        = NVL(B.CITY,'Z')
               AND E.COUNTRY(+)     = NVL(B.COUNTRY,'Z')
               AND E.ELEC_PLANT_PRIORITY_5TH(+) = 1
               AND E.DIVISION_ID(+) = V_DIVISION_ID  /* 자 division 전극 plant */
               AND A.PLAN_START_YYYYMMDD = V_EE_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_EE_PLAN_TYPE
               AND A.SEQ                 = V_EE_PLAN_SEQ
               AND A.DIVISION_ID         = V_EE_DIVISION_ID
               AND A.MEASURE = 'PROD_PLAN_AMEND'
               AND A.OPERATION_GROUP = 'E'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY B.COMPANY_ID
                   , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                           WHEN A.ORIGIN_DIVISION_ID != V_DIVISION_ID AND E.PLANT_ID IS NOT NULL THEN E.PLANT_ID /* 2025.04.25 타 division생성 전극 반영 */
                           ELSE B.PLANT_ID
                           END )
                    , A.PLAN_START_YYYYMMDD
                    , A.ITEM_ID
                    , A.LINE_ID
                    , SUBSTR(A.YYYYMMDD,1,6)

            /* E20260109-002382 ESS JV 혼용생산 관련 통합 PSI 레포트 구성 시작 */
            UNION ALL
            SELECT V_DIVISION_ID
                 , B.COMPANY_ID
                 , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                         WHEN A.ORIGIN_DIVISION_ID != V_DIVISION_ID AND E.PLANT_ID IS NOT NULL THEN E.PLANT_ID /* 2025.04.25 타 division생성 전극 반영 */
                         ELSE B.PLANT_ID
                         END ) AS PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'E' AS OPERATION_GROUP
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
                 , '550' AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
                 , NVL(SUM(NVL(QTY,0)),0) AS QTY
              FROM SCP_ANL_PRODUCTION_PLAN A
                 , GT_PIESSEO_JV_LAST_VER   JELV
                 , SCP_MST_FINAL_ITEM       FI
                 , SCM_MST_SITE             B
                 , GT_PIESSEO_ELEC_PLANT    E  /* 2025.04.25 */
             WHERE A.PLAN_START_YYYYMMDD = JELV.PLAN_NAME
               AND A.PLAN_TYPE           = V_EE_PLAN_TYPE
               AND A.SEQ                 = JELV.PLAN_SEQ
               AND A.DIVISION_ID         = JELV.DIVISION_ID
               AND FI.ITEM_ID         = A.ITEM_ID
               AND FI.OPERATION_GROUP = 'E'
               AND FI.CELL_ITEM_ID LIKE 'EC%'
               AND FI.DIVISION_ID     = V_DIVISION_ID
               AND B.SCM_SITE_ID = A.SCM_SITE_ID
               AND E.COMPANY_ID(+)  = B.COMPANY_ID
               AND E.CITY(+)        = NVL(B.CITY,'Z')
               AND E.COUNTRY(+)     = NVL(B.COUNTRY,'Z')
               AND E.ELEC_PLANT_PRIORITY_5TH(+) = 1
               AND E.DIVISION_ID(+) = V_DIVISION_ID  /* 자 division 전극 plant */
               AND A.PLAN_START_YYYYMMDD = JELV.PLAN_NAME
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.MEASURE = 'PROD_PLAN_AMEND'
               AND A.OPERATION_GROUP = 'E'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY B.COMPANY_ID
                   , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                           WHEN A.ORIGIN_DIVISION_ID != V_DIVISION_ID AND E.PLANT_ID IS NOT NULL THEN E.PLANT_ID /* 2025.04.25 타 division생성 전극 반영 */
                           ELSE B.PLANT_ID
                           END )
                    , A.PLAN_START_YYYYMMDD
                    , A.ITEM_ID
                    , A.LINE_ID
                    , SUBSTR(A.YYYYMMDD,1,6);
            /* E20260109-002382 ESS JV 혼용생산 관련 통합 PSI 레포트 구성 끝 */

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 9.1  CELL_ITEM_ID UPDATE */
            /* ----------------------------------------------------------------------------------------------------------- */

            V_STATUS_DESC := 'CELL_ITEM_ID Pack';

            V_STATUS_DESC := 'CELL_ITEM_ID Cell';

            V_STATUS_DESC := 'CELL_ITEM_ID MEB';

            V_STATUS_DESC := 'INV';

            /* 재고 없는 경우 첫날 재고 0으로 생성 완료 */

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 전극 중 ESS 용 전극이 아닌 Item 정보 삭제 처리 : 81 전극에서 ESS 전극 일부 생산 */
            /* ----------------------------------------------------------------------------------------------------------- */
            DELETE FROM GT_PIESSEO_MAIN
             WHERE 1 = 1
               AND OPERATION_GROUP = 'E'
               AND ITEM_ID NOT IN (SELECT DISTINCT ITEM_ID
                                     FROM SCP_MST_FINAL_ITEM
                                    WHERE FLOW_ID LIKE 'E2000%'
                                      AND CELL_ITEM_ID LIKE 'EC%'
                                   );

            V_STATUS_DESC := 'Delete';

            /* ---------------------------------------------------------- */
            /* 선입선출 처리 -> BOH 를 제외한 '-'/'PRD'/'PUR' 일자별 재고 계산 : START */
            /* ---------------------------------------------------------- */
            /* 1. 선입선출 처리 */
            /* 로직 추가 */

            /*  재고 반영 start */
            /*  1. 첫번째 날짜의 재고(QTY) 반영(360 제외) + PUR(370) + PRD(380) */
            /*  2. 두번째 날짜부터 마지막 날짜까지 재고 생성. */
            /*  3. PUR(370) + PRD(380)를 합친 360 재고 생성. */

            /* ---------------------------------------------------------- */
            /* 선입선출 처리 -> BOH 를 제외한 '-'/'PRD'/'PUR' 일자별 재고 계산 : END */
            /* ---------------------------------------------------------- */

            /*  ESS Daily를 월로 취합 START  */

            INSERT
              INTO GT_PIESSEO_MAIN
                  (  DIVISION_ID
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
                   , CREATED_BY
                   , CREATION_DATE
                   , LAST_UPDATED_BY
                   , LAST_UPDATE_DATE
                 )
            SELECT    A.DIVISION_ID
                   , A.COMPANY_ID
                   , A.PLANT_ID
                   , A.PLAN_START_YYYYMMDD
                   , A.SEQ
                   , A.OPERATION_GROUP
                   , A.FROM_SITE
                   , A.CELL_ITEM_ID
                   , A.ITEM_ID
                   , A.MEASURE
                   , A.VALUE_TYPE
                   , A.TO_PRODUCT
                   , A.LINE_ID
                   , A.BOH_QTY
                   , A.TO_SITE
                   , A.INCOTERMS
                   , A.SEQ_FLAG
                   , A.YYYYMM
                   , A.QTY
                   , A.CREATED_BY
                   , A.CREATION_DATE
                   , A.LAST_UPDATED_BY
                   , A.LAST_UPDATE_DATE
              FROM SCP_ANL_PSI_INTEGRATION A
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.SEQ                 = '1'
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.SEQ_FLAG = '530';

/* 소숫점 없애기 */
            UPDATE GT_PIESSEO_MAIN A
               SET BOH_QTY = ROUND(NVL(BOH_QTY,0),0)
                 , QTY     = ROUND(NVL(QTY,0),0);

/* 월_INVentory 생성 START */

            V_STATUS_DESC := 'INV';

            V_MIN_YYYYMM := SUBSTR(V_PLAN_START_YYYYMMDD,1,6);

            V_MAX_YYYYMM := SUBSTR(V_HORIZON_END_YYYYMMDD,1,6);

            V_PROC_YYYYMM := V_MIN_YYYYMM;

            V_PROC_YYYYMMDD := V_PROC_YYYYMM || '01';

            V_I := 0;

            WHILE (V_PROC_YYYYMM <= V_MAX_YYYYMM)
            LOOP

                IF (V_I > 50) THEN
                    EXIT;
                END IF;

                IF ( V_PROC_YYYYMM = V_MIN_YYYYMM ) THEN
                    /* 재고가 없는 경우 첫번째 월을 QTY=0 으로 생성함. */
                    INSERT
                      INTO GT_PIESSEO_MAIN
                            (
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
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                            )
                    SELECT   DISTINCT A.DIVISION_ID
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
                           , SUBSTR(A.SEQ_FLAG,1,1) || '60' AS SEQ_FLAG
                           , V_PROC_YYYYMM AS YYYYMM
                           , 0 AS QTY
                           , 'SCP BATCH' AS CREATED_BY
                           , SYSDATE AS CREATION_DATE
                           , 'SCP BATCH' AS LAST_UPDATED_BY
                           , SYSDATE AS LAST_UPDATE_DATE
                      FROM GT_PIESSEO_MAIN A
                     WHERE NOT EXISTS (SELECT 1
                                         FROM GT_PIESSEO_MAIN B
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
                       AND A.MEASURE <> 'MKT_FCST';

                    /* 첫번째 월의 재고(QTY) 반영 */
                    UPDATE GT_PIESSEO_MAIN A
                       SET QTY = NVL(( SELECT SUM(CASE WHEN B.MEASURE = 'INV' THEN  B.BOH_QTY
                                                       WHEN B.MEASURE = 'SHIP_PLAN_SEMI' THEN  B.QTY * -1
                                                       WHEN B.MEASURE = 'SHIP_PLAN_RTF' THEN  B.QTY * -1
                                                       WHEN B.MEASURE = 'IN_HOUSE_MOVING' THEN  B.QTY * -1
                                                       WHEN B.MEASURE = 'SEMI_WH_IN' THEN  B.QTY
                                                       WHEN B.MEASURE = 'PROD_PLAN' THEN  B.QTY
                                                       END) QTY
                                         FROM GT_PIESSEO_MAIN B
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
                       AND A.YYYYMM = V_PROC_YYYYMM;

                ELSE /* 두번째 월부터 마지막 월까지 재고 생성. */

                    INSERT
                      INTO GT_PIESSEO_MAIN
                            (
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
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                            )
                    SELECT   DISTINCT A.DIVISION_ID
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
                           , SUBSTR(A.SEQ_FLAG,1,1) || '60' AS SEQ_FLAG
                           , V_PROC_YYYYMM AS YYYYMM
                           , NVL(A.QTY,0) + NVL(( SELECT SUM(CASE  WHEN B.MEASURE = 'SHIP_PLAN_SEMI' THEN  B.QTY * -1
                                                                  WHEN B.MEASURE = 'SHIP_PLAN_RTF' THEN  B.QTY * -1
                                                                  WHEN B.MEASURE = 'IN_HOUSE_MOVING' THEN  B.QTY * -1
                                                                  WHEN B.MEASURE = 'SEMI_WH_IN' THEN  B.QTY
                                                                  WHEN B.MEASURE = 'PROD_PLAN' THEN  B.QTY
                                                                  END) QTY
                                                    FROM GT_PIESSEO_MAIN B
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
                           , 'SCP BATCH' AS CREATED_BY
                           , SYSDATE AS CREATION_DATE
                           , 'SCP BATCH' AS LAST_UPDATED_BY
                           , SYSDATE AS LAST_UPDATE_DATE
                      FROM GT_PIESSEO_MAIN A
                     WHERE A.MEASURE = 'INV'
                       AND A.YYYYMM = V_PRE_YYYYMM;
                END IF;

                V_I := V_I + 1;

                V_PROC_YYYYMMDD := TO_CHAR(ADD_MONTHS(TO_DATE(V_PROC_YYYYMMDD,'YYYYMMDD'), 1),'YYYYMMDD');
                V_PRE_YYYYMM := V_PROC_YYYYMM;
                V_PROC_YYYYMM := SUBSTR(V_PROC_YYYYMMDD,1,6);

            END LOOP;

    /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
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
                SELECT SEGMENT1
                     , TARGET_PERIOD_END_YYYYMM
                  INTO V_FILL_0_TARGET_PERIOD
                     , V_FILL_0_TARGET_PERIOD_END_YYYYMM
                  FROM ( SELECT L.SEGMENT1 AS SEGMENT1
                              , CASE WHEN TO_NUMBER(L.SEGMENT1) > 0
                                     THEN TO_CHAR(LAST_DAY(ADD_MONTHS(V_PLAN_START_DATE, TO_NUMBER(L.SEGMENT1) - 1)), 'YYYYMM')
                                     ELSE V_FILL_0_TARGET_PERIOD_END_YYYYMM
                                END AS TARGET_PERIOD_END_YYYYMM
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

            DELETE FROM GT_PIESSEO_MM_LIST;
            INSERT
              INTO GT_PIESSEO_MM_LIST
            SELECT DISTINCT B.YYYYMM
              FROM SCM_MST_BUCKET B
             WHERE 1 = 1
               AND B.YYYYMM BETWEEN V_PLAN_START_YYYYMM
                                AND V_FILL_0_TARGET_PERIOD_END_YYYYMM;

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 Measure');
            /* ---------------------------------------------------------------------------------------------------------------- */

            DELETE FROM GT_PIESSEO_TARGET_MM_0;
            INSERT
              INTO GT_PIESSEO_TARGET_MM_0
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
                 , NVL(MAX(CASE WHEN T.YYYYMM = M.YYYYMM THEN T.QTY ELSE NULL END),0) AS QTY  /* 재고를 제외하고 음수가 없기 떄문에 MAX처리 문제 없음 ?! */
                 , MAX(T.ATTRIBUTE1)                                                 AS ATTRIBUTE1
              FROM GT_PIESSEO_MAIN    T
                 , GT_PIESSEO_MM_LIST M
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

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 Measure - 채우기 전 데이터 삭제 (해당 기간)');
            /* ---------------------------------------------------------------------------------------------------------------- */
            DELETE FROM GT_PIESSEO_MAIN T
             WHERE 1 = 1
               AND T.YYYYMM BETWEEN V_PLAN_START_YYYYMM
                                AND V_FILL_0_TARGET_PERIOD_END_YYYYMM
               AND T.MEASURE NOT IN ('SHIP_PLAN_RTF', 'MKT_FCST', 'INV');

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 Measure - 0 채운 데이터 Insert - Start ');
            /* ---------------------------------------------------------------------------------------------------------------- */
            INSERT
              INTO GT_PIESSEO_MAIN (
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
                 , ATTRIBUTE1
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE)
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
                 , '#TARGET_MM_0'  AS CREATED_BY
                 , SYSDATE         AS CREATION_DATE
                 , '#TARGET_MM_0'  AS LAST_UPDATED_BY
                 , SYSDATE         AS LAST_UPDATE_DATE
              FROM GT_PIESSEO_TARGET_MM_0 T;

    /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
    /* 2025.03.013  End   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영 */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || 'End  PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영');
    /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */

            DELETE FROM SCP_ANL_PSI_INTEGRATION A
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.SEQ_FLAG IN ('500','510','520','540','550','560');

            INSERT
              INTO SCP_ANL_PSI_INTEGRATION
                    (
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
                   , CREATED_BY
                   , CREATION_DATE
                   , LAST_UPDATED_BY
                   , LAST_UPDATE_DATE
                   , ATTRIBUTE1
                   , ATTRIBUTE2
                   , ATTRIBUTE3
                   , ATTRIBUTE4
                   , ATTRIBUTE5
                   , ATTRIBUTE6
                   , ATTRIBUTE7
                   , ATTRIBUTE8
                   , ATTRIBUTE9
                   , ATTRIBUTE10
                    )
            SELECT   DIVISION_ID
                   , NVL(COMPANY_ID,'-')
                   , NVL(PLANT_ID,'-')
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
/*                  ,isnull(sum(isnull(BOH_QTY,0)),0) BOH_QTY */
                   , ROUND(NVL(SUM(NVL(BOH_QTY,0)),0),0) BOH_QTY
                   , TO_SITE
                   , INCOTERMS
                   , SEQ_FLAG
                   , A.YYYYMM AS YYYYMM
/*                  ,isnull(sum(isnull(QTY,0)),0) as QTY */
                   , ROUND(NVL(SUM(NVL(QTY,0)),0),0) AS QTY
                   , 'SCP (ESS)BATCH' AS CREATED_BY
                   , SYSDATE AS CREATION_DATE
                   , 'SCP (ESS)BATCH' AS LAST_UPDATED_BY
                   , SYSDATE AS LAST_UPDATE_DATE
                   , '' AS ATTRIBUTE1
                   , V_PLAN_TYPE                            AS ATTRIBUTE2  /* 2025.03.13 수정 */
                   , TO_CHAR(V_FILL_0_TARGET_PERIOD)        AS ATTRIBUTE3  /* 2025.03.13 수정 */
                   , '' AS ATTRIBUTE4
                   , '' AS ATTRIBUTE5
                   , '' AS ATTRIBUTE6
                   , '' AS ATTRIBUTE7
                   , '' AS ATTRIBUTE8
                   , '' AS ATTRIBUTE9
                   , '' AS ATTRIBUTE10
              FROM GT_PIESSEO_MAIN A
             WHERE A.SEQ_FLAG IN ('500','510','520','540','550','560')
             GROUP BY DIVISION_ID
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
                    , TO_SITE
                    , INCOTERMS
                    , SEQ_FLAG
                    , A.YYYYMM;

            /*  ESS Daily를 월로 취합 END  */


            DELETE FROM GT_PIESSEO_MAIN;
            DELETE FROM GT_PIESSEO_INV;
            DELETE FROM GT_PIESSEO_520_540;

            DELETE FROM GT_PIESSEO_ELEC_PLANT;


            DELETE FROM GT_PIESSEO_MM_LIST;
            DELETE FROM GT_PIESSEO_TARGET_MM_0;

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


            /*   JOB.PR_SCP_ANL_PSI_INTEGRATION_82_EE → 프로시저 PR_SCP_ANL_PSI_INTEGRATION_ESS_ELEC_ONLY 실행) */


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
            V_DESCRIPTION := SUBSTR(V_STATUS_DESC || '  ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ':' || V_DIVISION_ID, 1, 500);
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
    /*       MSSQL REPLICATE 는 반복횟수가 음수면 NULL 을 돌려주고(REPLICATE('0',-1) IS NULL,
       REPLICATE('0',0)=''), '+' 결합은 NULL 을 전파하므로 분(分)이 100 이상이면 @v_exec_time */
    V_EXEC_TIME := CASE WHEN LENGTH(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60))) > 2 THEN NULL
                        ELSE LPAD(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0') || ':' ||
                             LPAD(TO_CHAR(MOD(ROUND((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0')
                   END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
/*  V_DESCRIPTION := '['||V_DIVISION_ID||']['||V_PLAN_START_YYYYMMDD||'][' || V_EXEC_TIME || ']'; */
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