PROCEDURE PR_SCP_ANL_PSI_INTEGRATION_SMALL_ELEC_ONLY
(
      P_DIVISION_ID          IN VARCHAR2
    , P_PLAN_START_YYYYMMDD  IN VARCHAR2   /* plan_name */
)
/*******************************************************************************************************************
 * Program ID   : PR_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
 * Description  : 재료비 TASK
 * OutTable     : SCP_ANL_PSI_INTEGRATION
 * Execute      :
                  EXEC PR_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY @p_division_id         = '40'
                     , @p_plan_start_yyyymmdd = '20240923'

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.10.25     lgjjg        Initial. PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화.
 * 2025.02.12     hrkim        cell/전극 plant 매핑 로직 수정
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
 * 2026.07.06   ZIONEX  [PJ202650304]  NextSCM Migration
 *******************************************************************************************/

/* exec PR_SCP_ANL_PSI_INTEGRATION_Small_Elec_only '40', '20250106' */
AS
    /* =========================================================================================
     *   - SHIP_PLAN_SEMI 블록(4중 아우터 : B, X, C, E2)도 (+)로 전환했다.
     * ========================================================================================= */
    /* LOG 용 변수 설정 */
    V_BATCH_USER   VARCHAR2(150 CHAR) := 'scp_batch';
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'PR_SCP_ANL_PSI_INTEGRATION_Small_Elec_only';
    V_LOG_TYPE     VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT    NUMBER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    V_TABLE_ID     VARCHAR2(150 CHAR) := 'SCP_ANL_PSI_INTEGRATION';
    D_EVENT_DATE   DATE;

    V_STATUS_DESC  VARCHAR2(1000 CHAR) := 'START';

    /* 임시 실행시간 확인용 (원본은 START 로그 이후 위치에서 DECLARE + 초기화) */
    V_START_TIME   DATE;
    V_EXEC_TIME    VARCHAR2(10 CHAR);   /* '00:00' */

    /* SCP 계힉 참조를 위한 변수 */
    V_DIVISION_ID            VARCHAR2(10 CHAR);
    V_PLAN_START_YYYYMMDD    VARCHAR2(8 CHAR)   := NULL;
    V_PLAN_START_DATE        DATE               := NULL;
    V_PLAN_TYPE              VARCHAR2(100 CHAR) := 'FN';
    V_PLAN_SEQ               NUMBER             := 1;
    V_HORIZON_END_YYYYMMDD   VARCHAR2(8 CHAR)   := NULL;
    V_PLAN_START_YYYYMM      VARCHAR2(6 CHAR)   := NULL;   /* 계획 구간 시작월 */
    V_MASTER_ID              VARCHAR2(100 CHAR) := NULL;
    V_ENG_PLAN_ID            VARCHAR2(100 CHAR) := NULL;

    /* 전극용 구하기 */
    V_EE_DIVISION_ID         VARCHAR2(10 CHAR)  := 'EE';
    V_EE_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR)   := NULL;
    V_EE_PLAN_TYPE           VARCHAR2(100 CHAR) := 'FN';
    V_EE_PLAN_SEQ            NUMBER             := 1;
    V_EE_MASTER_ID           VARCHAR2(100 CHAR) := NULL;
    V_EE_ENG_PLAN_ID         VARCHAR2(100 CHAR) := NULL;

    /* 월_INVentory 생성용 (원본은 본문 중간 DECLARE) */
    V_MIN_YYYYMM     VARCHAR2(6 CHAR);
    V_MAX_YYYYMM     VARCHAR2(6 CHAR);
    V_PRE_YYYYMM     VARCHAR2(6 CHAR);
    V_PROC_YYYYMM    VARCHAR2(6 CHAR);
    V_PROC_YYYYMMDD  VARCHAR2(8 CHAR);
    V_I              NUMBER;


    V_FILL_0_TARGET_PERIOD            NUMBER;
    V_FILL_0_TARGET_PERIOD_END_YYYYMM VARCHAR2(6 CHAR);


    V_JJGV_LOG_MESSAGE VARCHAR2(1000 CHAR);

BEGIN


    /* --------------------------------------------------------------------------------------------- */

    /* --------------------------------------------------------------------------------------------- */
    DELETE
      FROM GT_PISEO_ELEC_PLANT;

    DELETE
      FROM GT_PISEO_INV;

    DELETE
      FROM GT_PISEO_CCC;

    DELETE
      FROM GT_PISEO_MAIN;

    DELETE
      FROM GT_PISEO_MM_LIST;

    DELETE
      FROM GT_PISEO_TARGET_MM_0;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';

    V_DESCRIPTION := CASE WHEN P_DIVISION_ID IS NULL THEN NULL
                          ELSE P_DIVISION_ID || ':' || V_PROGRAM_NAME || ':' || V_TABLE_ID || ' INSERT LOGIC'
                     END;
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
    V_EXEC_TIME  := '';


    V_DIVISION_ID := SUBSTR(NVL(P_DIVISION_ID, '40'), 1, 10);

    BEGIN
        BEGIN

            /* --------------------------------------------------------------------------------------------- */
            /* SCP PLAN 버전 정보 (PRODUCTION) */
            /* --------------------------------------------------------------------------------------------- */
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
                  FROM (SELECT D.PLAN_SEQ                                                       AS PLAN_SEQ              /* 1 */
                             , SUBSTR(P.PLAN_NAME, 1, 8)                                        AS PLAN_NAME             /* 20240527 */
                             , TO_DATE(P.PLAN_NAME, 'YYYYMMDD')                                 AS PLAN_START_DATE
                             , SUBSTR(P.PLAN_NAME, 1, 6)                                        AS PLAN_START_YYYYMM     /* 202405 */
                             , SUBSTR(P.HORIZON_END_DATE, 1, 8)                                 AS HORIZON_END_YYYYMMDD  /* 20250525 */
                             , P.DIVISION_ID || '::' || P.PLAN_CYCLE                            AS MASTER_ID             /* 81::WEEKLY */
                             , P.PLAN_ID || '::' || D.PLAN_TYPE || '::' || TO_CHAR(D.PLAN_SEQ)  AS ENG_PLAN_ID           /* 1341::FN::1 */
                          FROM SCM_MST_PLAN        P
                             , SCM_MST_PLAN_DETAIL D
                         WHERE 1 = 1
                           AND D.DIVISION_ID  = P.DIVISION_ID
                           AND D.PLAN_ID      = P.PLAN_ID
                           AND D.PLAN_STATUS  = '1'                     /* 정상 완료 */
                           AND D.CONFIRM_FLAG = 'Y'                     /* 최종 Confirm */
                           AND P.PLAN_CYCLE   = 'WEEKLY'
                           AND D.PLAN_TYPE    = V_PLAN_TYPE             /* FN */
                           AND P.DIVISION_ID  = V_DIVISION_ID
                           AND P.PLAN_NAME    = P_PLAN_START_YYYYMMDD
                         ORDER BY P.PLAN_NAME DESC
                                , D.PLAN_SEQ)
                 WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;

            V_STATUS_DESC := 'division EE ';
            /* 전극 V_EE_DIVISION_ID 구하기. */
            BEGIN
                SELECT DIVISION_ID
                  INTO V_EE_DIVISION_ID
                  FROM (SELECT SUBSTR(B.DIVISION_ID, 1, 10) AS DIVISION_ID
                          FROM SCM_MST_DIVISION A
                             , SCM_MST_DIVISION B
                         WHERE B.ATTRIBUTE4   = A.ATTRIBUTE4
                           AND B.ATTRIBUTE3   = 'EE'
                           AND A.DIVISION_ID  = V_DIVISION_ID)   /* '81_HM' */
                 WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;

            V_STATUS_DESC := ' plan EE';

            /* --------------------------------------------------------------------------------------------- */
            /* 'EE'추가  SCP PLAN 버전 정보 (PRODUCTION) */
            /* --------------------------------------------------------------------------------------------- */
            BEGIN
                SELECT PLAN_SEQ
                     , PLAN_NAME
                     , MASTER_ID
                     , ENG_PLAN_ID
                  INTO V_EE_PLAN_SEQ
                     , V_EE_PLAN_START_YYYYMMDD
                     , V_EE_MASTER_ID
                     , V_EE_ENG_PLAN_ID
                  FROM (SELECT D.PLAN_SEQ                                                       AS PLAN_SEQ
                             , SUBSTR(P.PLAN_NAME, 1, 8)                                        AS PLAN_NAME
                             , P.DIVISION_ID || '::' || P.PLAN_CYCLE                            AS MASTER_ID
                             , P.PLAN_ID || '::' || D.PLAN_TYPE || '::' || TO_CHAR(D.PLAN_SEQ)  AS ENG_PLAN_ID
                          FROM SCM_MST_PLAN        P
                             , SCM_MST_PLAN_DETAIL D
                         WHERE 1 = 1
                           AND D.DIVISION_ID  = P.DIVISION_ID
                           AND D.PLAN_ID      = P.PLAN_ID
                           AND D.PLAN_STATUS  = '1'                     /* 정상 완료 */
                           AND D.CONFIRM_FLAG = 'Y'                     /* 최종 Confirm */
                           AND P.PLAN_CYCLE   = 'WEEKLY'
                           AND D.PLAN_TYPE    = V_PLAN_TYPE             /* FN */
                           AND P.DIVISION_ID  = V_EE_DIVISION_ID
                           AND P.PLAN_NAME    = P_PLAN_START_YYYYMMDD
                         ORDER BY P.PLAN_NAME DESC
                                , D.PLAN_SEQ)
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

            /* ------------------------------------------------------------------------------------------------ */
            /* 전극 plant 사이트 정보 추출 - #elec_plant */
            /* 2025.02.12 cell/전극 plant 매핑 로직 수정 */
            /* 1순위 : division, company, plant 정보로 매핑 */
            /* 2순위 : division, company, city, country 정보로 매핑 */
            /* 3순위 : division, company 정보로 매핑 */
            /* 4순위 : company 정보로 매핑 */
            /* ------------------------------------------------------------------------------------------------ */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' 전극 plant 사이트 정보 추출 - #elec_plant');


            INSERT
              INTO GT_PISEO_ELEC_PLANT
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
                 , ELEC_PLANT_PRIORITY_4TH )
            SELECT ES.COMPANY_ID
                 , ES.DIVISION_ID
                 , NVL(ES.CITY, 'Z')     AS CITY
                 , NVL(ES.COUNTRY, 'Z')  AS COUNTRY
                 , ES.PLANT_ID
                 , ES.SITE_DESCRIPTION
                 , ES.SCM_SITE_ID
                 , ES.SITE_ID
                 , ROW_NUMBER() OVER (PARTITION BY ES.COMPANY_ID
                                                 , ES.DIVISION_ID
                                                 , ES.PLANT_ID
                                          ORDER BY ES.PLANT_ID)  AS ELEC_PLANT_PRIORITY_1ST
                 , ROW_NUMBER() OVER (PARTITION BY ES.COMPANY_ID
                                                 , ES.DIVISION_ID
                                                 , NVL(ES.CITY, 'Z')
                                                 , NVL(ES.COUNTRY, 'Z')
                                          ORDER BY ES.PLANT_ID)  AS ELEC_PLANT_PRIORITY_2ND
                 , ROW_NUMBER() OVER (PARTITION BY ES.COMPANY_ID
                                                 , ES.DIVISION_ID
                                          ORDER BY ES.PLANT_ID)  AS ELEC_PLANT_PRIORITY_3RD
                 , ROW_NUMBER() OVER (PARTITION BY ES.COMPANY_ID
                                          ORDER BY ES.PLANT_ID)  AS ELEC_PLANT_PRIORITY_4TH
              FROM SCM_MST_SITE ES
             WHERE 1 = 1
               AND ES.VALID_YN        = 'Y'
               AND ES.OPERATION_GROUP = 'E'   /* 전극 Plant */
               AND ES.SITE_TYPE       = 'PLANT';

            /* ------------------------------------------------------------------------------------------- */
            /* 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서 */
            /* ------------------------------------------------------------------------------------------- */


            /****************************************************
            EE 재고('560')를 #tmp_psi_integration_inv 에 추가로 insert 해야함.
            ****************************************************/

            V_STATUS_DESC := '6.BOH EE';

            INSERT
              INTO GT_PISEO_INV
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
                 , '-'                    AS COMPANY_ID
                 , '-'                    AS PLANT_ID
                 , A.SCM_SITE_ID          AS FROM_SITE
                 , A.ELEC_ITEM_ID         AS ITEM_ID
                 , V_PLAN_START_YYYYMMDD  AS YYYYMMDD
                 , NVL(SUM(CASE WHEN A.LVL IS NULL THEN NVL(A.SCM_QTY, 0)
                                WHEN A.LVL = '4'   THEN NVL(A.SCM_QTY, 0)
                                WHEN A.LVL = '3'   THEN NVL(A.L1_QTY, 0)
                                WHEN A.LVL = '2'   THEN NVL(A.L2_QTY, 0)
                                WHEN A.LVL = '1'   THEN NVL(A.L3_QTY, 0)
                           END), 0)       AS QTY
                 , (CASE WHEN A.STOCK_TYPE = 'INTRANSIT' THEN 'INT'
                         ELSE 'WH'
                    END )                 AS DESCR
                 , '-'                    AS ATTRIBUTE8
                 , 'E2000'                FLOW_ID
                 , 'E'                    AS OPERATION_GROUP
              FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A
/*            from SCP_ANL_PSI_INTEGRATION_ELEC_BOM_ACCUM A with (nolock)        -- */
             WHERE A.DIVISION_ID = V_DIVISION_ID  /* '81'  -- */
/*            AND PLAN_TYPE = @V_EE_PLAN_TYPE  -- 'FN'  -- */
               AND A.PLAN_ID = SUBSTR(V_EE_ENG_PLAN_ID, 1, INSTR(V_EE_ENG_PLAN_ID, '::') - 1)  /* '1348'  -- */
             GROUP BY A.SCM_SITE_ID
                    , A.ELEC_ITEM_ID
                    , (CASE WHEN A.STOCK_TYPE = 'INTRANSIT' THEN 'INT'
                            ELSE 'WH'
                       END );

            /* 재고의 COMPANY_ID, PLANT_ID 반영. */

            /*  → 상관 서브쿼리. SCM_MST_SITE PK = (DIVISION_ID, SCM_SITE_ID) 이므로 B 는 최대 1행(결정적). */

            /*    e2 는 (company_id, division_id, city, country) 파티션의 rn=1 이라 최대 1행(결정적). */
            UPDATE GT_PISEO_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   (SELECT MAX(B.COMPANY_ID)
                         , CASE WHEN COUNT(*) = 0 THEN '-'
                                ELSE MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'
/* 1,2,3순위 조건 추가(2024.12.31) start */
                                              WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND B.OPERATION_GROUP IN ('A', 'P') AND
                                                    EXISTS (SELECT 1
                                                              FROM SCM_MST_SITE X
                                                             WHERE X.SITE_TYPE       = 'PLANT'
                                                               AND X.VALID_YN        = 'Y'
                                                               AND X.COMPANY_ID      = B.COMPANY_ID
                                                               AND X.DIVISION_ID     = B.DIVISION_ID
                                                               AND X.PLANT_ID        = B.PLANT_ID
                                                               AND X.OPERATION_GROUP = 'E')) THEN (SELECT K.PLANT_ID
                                                                                                     FROM SCM_MST_SITE K
                                                                                                    WHERE K.SITE_TYPE       = 'PLANT'
                                                                                                      AND K.VALID_YN        = 'Y'
                                                                                                      AND K.COMPANY_ID      = B.COMPANY_ID
                                                                                                      AND K.DIVISION_ID     = B.DIVISION_ID
                                                                                                      AND K.PLANT_ID        = B.PLANT_ID
                                                                                                      AND K.OPERATION_GROUP = 'E'
                                                                                                      AND ROWNUM            = 1)
                                              WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND B.OPERATION_GROUP IN ('A', 'P')
                                                    AND (SELECT E2.PLANT_ID
                                                           FROM GT_PISEO_ELEC_PLANT E2
                                                          WHERE E2.ELEC_PLANT_PRIORITY_2ND = 1
                                                            AND E2.DIVISION_ID             = B.DIVISION_ID
                                                            AND E2.COMPANY_ID              = B.COMPANY_ID
                                                            AND E2.CITY                    = NVL(B.CITY, 'Z')
                                                            AND E2.COUNTRY                 = NVL(B.COUNTRY, 'Z')) IS NOT NULL) THEN (SELECT E2.PLANT_ID
                                                                                                                                      FROM GT_PISEO_ELEC_PLANT E2
                                                                                                                                     WHERE E2.ELEC_PLANT_PRIORITY_2ND = 1
                                                                                                                                       AND E2.DIVISION_ID             = B.DIVISION_ID
                                                                                                                                       AND E2.COMPANY_ID              = B.COMPANY_ID
                                                                                                                                       AND E2.CITY                    = NVL(B.CITY, 'Z')
                                                                                                                                       AND E2.COUNTRY                 = NVL(B.COUNTRY, 'Z'))
                                                                                                  /* 2025.02.12  cell/전극 plant 매핑 로직 수정 : 2순위 참조 케이스 추가 (division, company, city, country정보로 매핑) */
                                              WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND B.OPERATION_GROUP IN ('A', 'P') AND
                                                    EXISTS (SELECT 1
                                                              FROM SCM_MST_SITE X
                                                             WHERE X.SITE_TYPE       = 'PLANT'
                                                               AND X.VALID_YN        = 'Y'
                                                               AND X.COMPANY_ID      = B.COMPANY_ID
                                                               AND X.DIVISION_ID     = B.DIVISION_ID
                                                               AND X.OPERATION_GROUP = 'E')) THEN (SELECT K.PLANT_ID
                                                                                                     FROM SCM_MST_SITE K
                                                                                                    WHERE K.SITE_TYPE       = 'PLANT'
                                                                                                      AND K.VALID_YN        = 'Y'
                                                                                                      AND K.COMPANY_ID      = B.COMPANY_ID
                                                                                                      AND K.DIVISION_ID     = B.DIVISION_ID
                                                                                                      AND K.OPERATION_GROUP = 'E'
                                                                                                      AND ROWNUM            = 1)
                                              WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND B.OPERATION_GROUP IN ('A', 'P'))
                                                                                              THEN (SELECT K.PLANT_ID
                                                                                                     FROM SCM_MST_SITE K
                                                                                                    WHERE K.SITE_TYPE       = 'PLANT'
                                                                                                      AND K.VALID_YN        = 'Y'
                                                                                                      AND K.COMPANY_ID      = B.COMPANY_ID
                                                                                                      AND K.OPERATION_GROUP = 'E'
                                                                                                      AND ROWNUM            = 1)
/* 1,2,3순위 조건 추가(2024.12.31) end */
                                              WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N') THEN B.PLANT_ID
                                              WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'Y') THEN B.LOGISTIC_PLANT_ID
                                              ELSE '-'
                                         END )
                           END
                      FROM SCM_MST_SITE B
                     WHERE B.DIVISION_ID = A.DIVISION_ID
                       AND B.SCM_SITE_ID = A.FROM_SITE);

/* 1번(추가) : 가장 빠른 WH_IN이 있는 Plant */
            UPDATE GT_PISEO_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   (SELECT MAX(B.COMPANY_ID)
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
                                             WHERE K.TO_SITE             = A.FROM_SITE
                                               AND K.ITEM_ID             = A.ITEM_ID
                                               AND K.DIVISION_ID         = A.DIVISION_ID
                                               AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                               AND K.PLAN_TYPE           = V_PLAN_TYPE
                                               AND K.SEQ                 = V_PLAN_SEQ
                                               AND K.QTY                <> 0
                                               AND K.YYYYMMDD            = (SELECT MIN(M.YYYYMMDD)
                                                                              FROM SCP_ANL_SHIPMENT_PLAN_FG M
                                                                             WHERE M.TO_SITE             = A.FROM_SITE
                                                                               AND M.ITEM_ID             = A.ITEM_ID
                                                                               AND M.DIVISION_ID         = A.DIVISION_ID
                                                                               AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                               AND M.PLAN_TYPE           = V_PLAN_TYPE
                                                                               AND M.SEQ                 = V_PLAN_SEQ
                                                                               AND M.QTY                <> 0
                                                                               AND M.MEASURE             = 'WH_IN')  /* WH_IN을 봄 */
                                               AND K.MEASURE             = 'WH_IN'))                                 /* WH_IN */
             WHERE NVL(A.PLANT_ID, '-') < '0';

/* 2번(기존) */
            UPDATE GT_PISEO_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   (SELECT MAX(B.COMPANY_ID)
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
                                             WHERE K.TO_SITE             = A.FROM_SITE
                                               AND K.ITEM_ID             = A.ITEM_ID
                                               AND K.DIVISION_ID         = A.DIVISION_ID
                                               AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                               AND K.PLAN_TYPE           = V_PLAN_TYPE
                                               AND K.SEQ                 = V_PLAN_SEQ
                                               AND K.QTY                <> 0
                                               AND K.YYYYMMDD            = (SELECT MIN(M.YYYYMMDD)
                                                                              FROM SCP_ANL_SHIPMENT_PLAN_FG M
                                                                             WHERE M.TO_SITE             = A.FROM_SITE
                                                                               AND M.ITEM_ID             = A.ITEM_ID
                                                                               AND M.DIVISION_ID         = A.DIVISION_ID
                                                                               AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                               AND M.PLAN_TYPE           = V_PLAN_TYPE
                                                                               AND M.SEQ                 = V_PLAN_SEQ
                                                                               AND M.QTY                <> 0
                                                                               AND M.MEASURE             = 'SHIP_PLAN_AMEND')
                                               AND K.MEASURE             = 'SHIP_PLAN_AMEND'))
             WHERE NVL(A.PLANT_ID, '-') < '0';

/* 3번(추가) : 해당 아이템의 가장 빠른 생산계획이 있는 Plant */
            UPDATE GT_PISEO_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   (SELECT MAX(B.COMPANY_ID)
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
                                               AND K.ITEM_ID             = A.ITEM_ID
                                               AND K.DIVISION_ID         = A.DIVISION_ID
                                               AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                               AND K.PLAN_TYPE           = V_PLAN_TYPE
                                               AND K.SEQ                 = V_PLAN_SEQ
                                               AND K.QTY                <> 0
                                               AND K.YYYYMMDD            = (SELECT MIN(M.YYYYMMDD)
                                                                              FROM SCP_ANL_PRODUCTION_PLAN M
                                                                             WHERE 1 = 1
                                                                               AND M.ITEM_ID             = NVL((SELECT MAX(Z.ITEM_ID_ASSY)
                                                                                                                  FROM SCP_MST_CELL_PROD_ASSY_MAP Z
                                                                                                                 WHERE Z.DIVISION_ID  = A.DIVISION_ID
                                                                                                                   AND Z.ITEM_ID_PROD = A.ITEM_ID
                                                                                                                   AND Z.CELL_TYPE    = 'CA1'
                                                                                                                   AND Z.VALID_YN     = 'Y'), A.ITEM_ID)
                                                                               AND M.DIVISION_ID         = A.DIVISION_ID
                                                                               AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                               AND M.PLAN_TYPE           = V_PLAN_TYPE
                                                                               AND M.SEQ                 = V_PLAN_SEQ
                                                                               AND M.QTY                <> 0
                                                                               AND M.MEASURE             = 'PROD_PLAN_AMEND')
                                               AND K.MEASURE             = 'PROD_PLAN_AMEND'))
             WHERE NVL(A.PLANT_ID, '-') < '0';

/* 4번(추가) : 해당 아이템의 BOH가 가장 큰 Plant로 지정 */
            UPDATE GT_PISEO_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   (SELECT MAX(B.COMPANY_ID)
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
                                              FROM (SELECT K.FROM_SITE
                                                      FROM GT_PISEO_INV K
                                                         , SCM_MST_SITE M
                                                     WHERE M.DIVISION_ID = K.DIVISION_ID
                                                       AND M.SCM_SITE_ID = K.FROM_SITE
                                                       AND M.SITE_TYPE   = 'PLANT'
                                                       AND K.DIVISION_ID = A.DIVISION_ID
                                                       AND (K.ITEM_ID = A.ITEM_ID OR K.ITEM_ID = NVL((SELECT MAX(Z.ITEM_ID_ASSY)
                                                                                                        FROM SCP_MST_CELL_PROD_ASSY_MAP Z
                                                                                                       WHERE Z.DIVISION_ID  = A.DIVISION_ID
                                                                                                         AND Z.ITEM_ID_PROD = A.ITEM_ID
                                                                                                         AND Z.CELL_TYPE    = 'CA1'
                                                                                                         AND Z.VALID_YN     = 'Y'), A.ITEM_ID))
                                                       AND K.QTY <> 0
                                                     GROUP BY K.FROM_SITE
                                                            , K.ITEM_ID
                                                     ORDER BY SUM(K.QTY) DESC) H
                                             WHERE ROWNUM = 1))
             WHERE NVL(A.PLANT_ID, '-') < '0';

/* 5번(기존) */
            UPDATE GT_PISEO_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   (SELECT MAX(B.COMPANY_ID)
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
                                             WHERE K.TO_SITE             = A.FROM_SITE
                                               AND K.DIVISION_ID         = A.DIVISION_ID
                                               AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                               AND K.PLAN_TYPE           = V_PLAN_TYPE
                                               AND K.SEQ                 = V_PLAN_SEQ
                                               AND K.QTY                <> 0
                                               AND K.YYYYMMDD            = (SELECT MIN(M.YYYYMMDD)
                                                                              FROM SCP_ANL_SHIPMENT_PLAN_FG M
                                                                             WHERE M.TO_SITE             = A.FROM_SITE
                                                                               AND M.DIVISION_ID         = A.DIVISION_ID
                                                                               AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                               AND M.PLAN_TYPE           = V_PLAN_TYPE
                                                                               AND M.SEQ                 = V_PLAN_SEQ
                                                                               AND M.QTY                <> 0
                                                                               AND M.MEASURE             = 'SHIP_PLAN_AMEND')
                                               AND K.MEASURE             = 'SHIP_PLAN_AMEND'))
             WHERE NVL(A.PLANT_ID, '-') < '0';

            V_STATUS_DESC := '6.BOH inv E';

            INSERT
              INTO GT_PISEO_MAIN
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
                 , QTY )
            SELECT A.DIVISION_ID                        AS DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID
                 , V_PLAN_START_YYYYMMDD                AS PLAN_START_YYYYMMDD
                 , 1                                    AS SEQ
                 , 'E'                                  AS OPERATION_GROUP
                 , '-'                                  AS FROM_SITE
                 , '-'                                  AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , 'INV'                                AS MEASURE
                 , '-'                                  AS VALUE_TYPE
                 , '-'                                  AS TO_PRODUCT
                 , '-'                                  AS LINE_ID
                 , NVL(SUM(NVL(A.QTY, 0)), 0)           AS BOH_QTY
                 , '-'                                  AS TO_SITE
                 , '-'                                  AS INCOTERMS
                 , '560'                                AS SEQ_FLAG
                 /* ,convert(nvarchar(6),getdate(),112) */
                 , SUBSTR(V_PLAN_START_YYYYMMDD, 1, 6)  AS YYYYMM
                 , 0                                    QTY
              FROM GT_PISEO_INV A
             WHERE A.OPERATION_GROUP = 'E'
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.ITEM_ID;

            V_STATUS_DESC := '0.  MKT_FCST EE';

            /* ------------------------------------------------------------------------------------------- */
            /* 5. 전극 ( N/A : 없음) */
            /*    1.Ship. Plan(RTF) */
            /* ------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '1.Ship. Plan(RTF) EE';

            INSERT
              INTO GT_PISEO_MAIN
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
                 , QTY )
            SELECT V_DIVISION_ID
                 , B.COMPANY_ID
                 , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                         ELSE B.PLANT_ID
                    END )                            AS PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1                                 AS SEQ
                 , 'E'                               AS OPERATION_GROUP
                 , '-'                               AS FROM_SITE
                 , '-'                               AS CELL_ITEM_ID
                 , A.FROM_ITEM_ID                    AS ITEM_ID
                 , 'SHIP_PLAN_RTF'                   AS MEASURE
                 , '-'                               AS VALUE_TYPE
                 , '-'                               AS TO_PRODUCT
                 , '-'                               AS LINE_ID
                 , 0                                 AS BOH_QTY
                 , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.SALES_SITE_ID
                         WHEN X.SITE_TYPE = 'PLANT' THEN X.PLANT_ID
                         ELSE '-'
                    END )                            AS TO_SITE
                 , '-'                               AS INCOTERMS
                 , '510'                             AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD, 1, 6)          AS YYYYMM
                 , NVL(SUM(NVL(A.ALLOCATION_QTY, 0)), 0)  AS QTY
              FROM SCP_PLN_RTF_ALLOCATION_V A
                 , SCM_MST_SITE             B
                 , SCM_MST_SITE             X
             WHERE B.SCM_SITE_ID = A.PLANT_SITE_ID
               AND X.SCM_SITE_ID = A.SALES_SITE_ID
               AND B.DIVISION_ID = V_DIVISION_ID
               AND X.DIVISION_ID = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = V_EE_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_EE_PLAN_TYPE
               AND A.SEQ                 = V_EE_PLAN_SEQ
               AND A.DIVISION_ID         = V_EE_DIVISION_ID
               AND A.OPERATION_GROUP     = 'E'
               AND A.YYYYMMDD           <= V_HORIZON_END_YYYYMMDD
             GROUP BY B.COMPANY_ID
                    , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                            ELSE B.PLANT_ID
                       END )
                    , A.PLAN_START_YYYYMMDD
                    , A.FROM_ITEM_ID
                    , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.SALES_SITE_ID
                            WHEN X.SITE_TYPE = 'PLANT' THEN X.PLANT_ID
                            ELSE '-'
                       END )
                    , SUBSTR(A.YYYYMMDD, 1, 6);

            /* ------------------------------------------------------------------------------------------- */
            /* 5. 전극 ( N/A : 없음) */
            /*    2.Ship. Plan(Semi) */
            /* ------------------------------------------------------------------------------------------- */

            V_STATUS_DESC := '2.Ship. Plan(Semi) EE';

            INSERT
              INTO GT_PISEO_CCC
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
            SELECT A.DIVISION_ID
                 , A.ORIGIN_FROM_DIVISION_ID
                 , A.ORIGIN_TO_DIVISION_ID
                 , B.COMPANY_ID
                 , X.COMPANY_ID  AS TO_COMPANY_ID
                 , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                         ELSE B.PLANT_ID
                    END )        AS PLANT_ID
                 , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.TO_SITE
/* 1,2,3순위 조건 추가(2024.12.31) start */
                         WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N' AND
                               EXISTS (SELECT 1
                                         FROM SCM_MST_SITE SS
                                        WHERE SS.SITE_TYPE       = 'PLANT'
                                          AND SS.VALID_YN        = 'Y'
                                          AND SS.COMPANY_ID      = X.COMPANY_ID
                                          AND SS.DIVISION_ID     = X.DIVISION_ID
                                          AND SS.PLANT_ID        = X.PLANT_ID
                                          AND SS.OPERATION_GROUP = 'E')) THEN (SELECT K.PLANT_ID   /* 이부분을 그냥 x.plant_id 라고 해도 됨. */
                                                                                 FROM SCM_MST_SITE K
                                                                                WHERE K.SITE_TYPE       = 'PLANT'
                                                                                  AND K.VALID_YN        = 'Y'
                                                                                  AND K.COMPANY_ID      = X.COMPANY_ID
                                                                                  AND K.DIVISION_ID     = X.DIVISION_ID
                                                                                  AND K.PLANT_ID        = X.PLANT_ID
                                                                                  AND K.OPERATION_GROUP = 'E'
                                                                                  AND ROWNUM            = 1)
                         WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N'
                               AND E2.PLANT_ID IS NOT NULL)              THEN E2.PLANT_ID   /* 2025.02.12  cell/전극 plant 매핑 로직 수정 : 2순위 참조 케이스 추가 (division, company, city, country정보로 매핑) */
                         WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N' AND
                               EXISTS (SELECT 1
                                         FROM SCM_MST_SITE SS
                                        WHERE SS.SITE_TYPE       = 'PLANT'
                                          AND SS.VALID_YN        = 'Y'
                                          AND SS.COMPANY_ID      = X.COMPANY_ID
                                          AND SS.DIVISION_ID     = X.DIVISION_ID
                                          AND SS.OPERATION_GROUP = 'E')) THEN (SELECT K.PLANT_ID
                                                                                 FROM SCM_MST_SITE K
                                                                                WHERE K.SITE_TYPE       = 'PLANT'
                                                                                  AND K.VALID_YN        = 'Y'
                                                                                  AND K.COMPANY_ID      = X.COMPANY_ID
                                                                                  AND K.DIVISION_ID     = X.DIVISION_ID
                                                                                  AND K.OPERATION_GROUP = 'E'
                                                                                  AND ROWNUM            = 1)
                         WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N')
                                                                          THEN (SELECT K.PLANT_ID
                                                                                 FROM SCM_MST_SITE K
                                                                                WHERE K.SITE_TYPE       = 'PLANT'
                                                                                  AND K.VALID_YN        = 'Y'
                                                                                  AND K.COMPANY_ID      = X.COMPANY_ID
                                                                                  AND K.OPERATION_GROUP = 'E'
                                                                                  AND ROWNUM            = 1)
/* 1,2,3순위 조건 추가(2024.12.31) end */
                         WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'Y') THEN X.LOGISTIC_PLANT_ID
                         ELSE '-'
                    END )        AS TO_PLANT_ID
                 , A.BOD_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1             AS SEQ
                 , 'E'           AS OPERATION_GROUP
                 , A.FROM_SITE
                 , A.ITEM_ID
                 , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.TO_SITE
                         WHEN X.SITE_TYPE = 'PLANT' THEN X.PLANT_ID
                         ELSE '-'
                    END )        AS TO_SITE
                 , C.SSP_INCOTERMS  AS INCOTERMS
                 , A.QTY
                 , C.LT_TOTAL_SSP
                 , A.YYYYMMDD    AS DEPARTURE_YYYYMMDD


                 , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD') + TRUNC(C.LT_TOTAL_SSP), 'YYYYMMDD')  AS ARRIVAL_YYYYMMDD
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                 , SCM_MST_SITE               B
                 , SCM_MST_SITE               X
                 , SCP_MST_BOD_N_V            C
                 , GT_PISEO_ELEC_PLANT        E2   /* 2025.02.12  cell/전극 plant 매핑 로직 수정 */
             WHERE B.SCM_SITE_ID(+) = A.FROM_SITE
               AND X.SCM_SITE_ID(+) = A.TO_SITE
               AND C.BOD_ID(+)      = A.BOD_ID
               AND E2.DIVISION_ID(+) = X.DIVISION_ID
               AND E2.COMPANY_ID(+)  = X.COMPANY_ID
               AND E2.CITY(+)        = NVL(X.CITY, 'Z')
               AND E2.COUNTRY(+)     = NVL(X.COUNTRY, 'Z')
               AND E2.ELEC_PLANT_PRIORITY_2ND(+) = 1
               AND C.DIVISION_ID(+) = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = V_EE_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_EE_PLAN_TYPE
               AND A.SEQ                 = V_EE_PLAN_SEQ
               AND A.DIVISION_ID         = V_EE_DIVISION_ID
               AND (A.ORIGIN_FROM_DIVISION_ID = V_DIVISION_ID OR A.ORIGIN_TO_DIVISION_ID = V_DIVISION_ID)
               AND A.MEASURE             = 'SHIP_PLAN_AMEND'
               AND A.OPERATION_GROUP     = 'E'
               AND A.YYYYMMDD           <= V_HORIZON_END_YYYYMMDD;

            V_STATUS_DESC := '2.Ship. Plan(Semi) EE 520';

            INSERT
              INTO GT_PISEO_MAIN
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
                 , QTY )
            SELECT A.ORIGIN_FROM_DIVISION_ID  AS DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1                          AS SEQ
                 , 'E'                        AS OPERATION_GROUP
                 , '-'                        AS FROM_SITE
                 , '-'                        AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , 'SHIP_PLAN_SEMI'           AS MEASURE
                 , '-'                        AS VALUE_TYPE
                 , '-'                        AS TO_PRODUCT
                 , '-'                        AS LINE_ID
                 , 0                          AS BOH_QTY
                 , A.TO_PLANT_ID              AS TO_SITE
                 , A.INCOTERMS
                 , '520'                      AS SEQ_FLAG
                 , SUBSTR(A.ARRIVAL_YYYYMMDD, 1, 6)  AS YYYYMM
                 , NVL(SUM(NVL(A.QTY, 0)), 0)       AS QTY
              FROM GT_PISEO_CCC A
             WHERE A.COMPANY_ID             <> A.TO_COMPANY_ID
               AND A.ORIGIN_FROM_DIVISION_ID = V_DIVISION_ID   /* '81' */
               AND A.ARRIVAL_YYYYMMDD       <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.ORIGIN_FROM_DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.PLAN_START_YYYYMMDD
                    , A.ITEM_ID
                    , A.TO_PLANT_ID
                    , A.INCOTERMS
                    , SUBSTR(A.ARRIVAL_YYYYMMDD, 1, 6);

            /* ------------------------------------------------------------------------------------------- */
            /* 5. 전극 ( N/A : 없음) */
            /*    4.Semi WH-IN */
            /* ------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '4.Semi WH-IN  EE';

            INSERT
              INTO GT_PISEO_MAIN
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
                 , QTY )
            SELECT A.ORIGIN_TO_DIVISION_ID  AS DIVISION_ID
                 , A.TO_COMPANY_ID          AS COMPANY_ID
                 , A.TO_PLANT_ID            AS PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1                        AS SEQ
                 , 'E'                      AS OPERATION_GROUP
                 , '-'                      AS FROM_SITE
                 , '-'                      AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , 'SEMI_WH_IN'             AS MEASURE
                 , '-'                      AS VALUE_TYPE
                 , '-'                      AS TO_PRODUCT
                 , '-'                      AS LINE_ID
                 , 0                        AS BOH_QTY
                 , '-'                      AS TO_SITE
                 , '-'                      AS INCOTERMS
                 , '540'                    AS SEQ_FLAG
                 , SUBSTR(A.ARRIVAL_YYYYMMDD, 1, 6)  AS YYYYMM
                 , NVL(SUM(NVL(A.QTY, 0)), 0)       AS QTY
              FROM GT_PISEO_CCC A
             WHERE A.COMPANY_ID           <> A.TO_COMPANY_ID
               AND A.ORIGIN_TO_DIVISION_ID = V_DIVISION_ID
               AND A.ARRIVAL_YYYYMMDD     <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.ORIGIN_TO_DIVISION_ID
                    , A.TO_COMPANY_ID
                    , A.TO_PLANT_ID
                    , A.PLAN_START_YYYYMMDD
                    , A.ITEM_ID
                    , A.TO_SITE
                    , SUBSTR(A.ARRIVAL_YYYYMMDD, 1, 6);

            /* ------------------------------------------------------------------------------------------- */
            /* 5. 전극 ( N/A : 없음) */
            /*    3.IN_HOUSE_MOVING */
            /* ------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '3.IN_HOUSE_MOVING  EE';

            INSERT
              INTO GT_PISEO_MAIN
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
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            SELECT A.DIVISION_ID
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
            /* select TOP 100 * */
              FROM SCP_ANL_PSI_INTEGRATION A
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.SEQ                 = '1'
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.SEQ_FLAG            = '530';

            /* ------------------------------------------------------------------------------------------- */
            /* 5. 전극 ( N/A : 없음) */
            /*    5.PROD_PLAN */
            /* ------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '5.PROD_PLAN  EE';

            INSERT
              INTO GT_PISEO_MAIN
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
                 , QTY )
            SELECT V_DIVISION_ID
                 , B.COMPANY_ID
                 , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                         ELSE B.PLANT_ID
                    END )                   AS PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1                        AS SEQ
                 , 'E'                      AS OPERATION_GROUP
                 , '-'                      AS FROM_SITE
                 , '-'                      AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , 'PROD_PLAN'              AS MEASURE
                 , '-'                      AS VALUE_TYPE
                 , '-'                      AS TO_PRODUCT
                 , A.LINE_ID
                 , 0                        AS BOH_QTY
                 , '-'                      AS TO_SITE
                 , '-'                      AS INCOTERMS
                 , '550'                    AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD, 1, 6) AS YYYYMM
                 , NVL(SUM(NVL(A.QTY, 0)), 0)  AS QTY
              FROM SCP_ANL_PRODUCTION_PLAN A
                 , SCP_MST_FINAL_ITEM      FI
                 , SCM_MST_SITE            B
             WHERE FI.ITEM_ID    = A.ITEM_ID
               AND B.SCM_SITE_ID = A.SCM_SITE_ID
               AND FI.OPERATION_GROUP = 'E'
               AND FI.CELL_ITEM_ID NOT LIKE 'EC%'
               AND FI.DIVISION_ID = V_DIVISION_ID
               AND B.DIVISION_ID  = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = V_EE_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_EE_PLAN_TYPE
               AND A.SEQ                 = V_EE_PLAN_SEQ
               AND A.DIVISION_ID         = V_EE_DIVISION_ID
               AND A.MEASURE             = 'PROD_PLAN_AMEND'
               AND A.OPERATION_GROUP     = 'E'
               AND A.ORIGIN_DIVISION_ID  = V_DIVISION_ID
               AND A.YYYYMMDD           <= V_HORIZON_END_YYYYMMDD
             GROUP BY B.COMPANY_ID
                    , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                            ELSE B.PLANT_ID
                       END )
                    , A.PLAN_START_YYYYMMDD
                    , A.ITEM_ID
                    , A.LINE_ID
                    , SUBSTR(A.YYYYMMDD, 1, 6);

/* 소숫점 없애기 */

            UPDATE GT_PISEO_MAIN A
               SET A.BOH_QTY = ROUND(NVL(A.BOH_QTY, 0), 0)
                 , A.QTY     = ROUND(NVL(A.QTY, 0), 0);

/* 월_INVentory 생성 START */

            V_STATUS_DESC := 'INV';

            V_MIN_YYYYMM := SUBSTR(V_PLAN_START_YYYYMMDD, 1, 6);

            V_MAX_YYYYMM := SUBSTR(V_HORIZON_END_YYYYMMDD, 1, 6);

            V_PROC_YYYYMM := V_MIN_YYYYMM;


            V_PROC_YYYYMMDD := CASE WHEN V_PROC_YYYYMM IS NULL THEN NULL ELSE V_PROC_YYYYMM || '01' END;

            V_I := 0;

            WHILE (V_PROC_YYYYMM <= V_MAX_YYYYMM)
            LOOP

                EXIT WHEN V_I > 50;

                IF ( V_PROC_YYYYMM = V_MIN_YYYYMM ) THEN
                    /* 재고가 없는 경우 첫번째 월을 QTY=0 으로 생성함. */
                    INSERT
                      INTO GT_PISEO_MAIN
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
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                    SELECT DISTINCT A.DIVISION_ID
                         , A.COMPANY_ID
                         , A.PLANT_ID
                         , A.PLAN_START_YYYYMMDD
                         , 1              AS SEQ   /* a.SEQ */
                         , A.OPERATION_GROUP
                         , A.FROM_SITE
                         , A.CELL_ITEM_ID
                         , A.ITEM_ID
                         , 'INV'          AS MEASURE
                         , '-'            AS VALUE_TYPE
                         , '-'            AS TO_PRODUCT
                         , '-'            AS LINE_ID
                         , 0              AS BOH_QTY
                         , '-'            AS TO_SITE
                         , '-'            AS INCOTERMS
                         , CASE WHEN A.SEQ_FLAG IS NULL THEN NULL ELSE SUBSTR(A.SEQ_FLAG, 1, 1) || '60' END  AS SEQ_FLAG
                         , V_PROC_YYYYMM  AS YYYYMM
                         , 0              AS QTY
                         , 'SCP BATCH'    AS CREATED_BY
                         , SYSDATE        AS CREATION_DATE
                         , 'SCP BATCH'    AS LAST_UPDATED_BY
                         , SYSDATE        AS LAST_UPDATE_DATE
                      FROM GT_PISEO_MAIN A
                     WHERE NOT EXISTS (SELECT 1
                                         FROM GT_PISEO_MAIN B
                                        WHERE B.DIVISION_ID         = A.DIVISION_ID
                                          AND B.COMPANY_ID          = A.COMPANY_ID
                                          AND B.PLANT_ID            = A.PLANT_ID
                                          AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                          AND B.SEQ                 = A.SEQ
                                          AND B.OPERATION_GROUP     = A.OPERATION_GROUP
                                          /* and b.FROM_SITE = a.FROM_SITE */
                                          AND B.CELL_ITEM_ID        = A.CELL_ITEM_ID
                                          AND B.ITEM_ID             = A.ITEM_ID
                                          AND B.MEASURE             = 'INV')
                       AND A.MEASURE <> 'MKT_FCST';

                    /* 첫번째 월의 재고(QTY) 반영 */
                    UPDATE GT_PISEO_MAIN A
                       SET A.QTY = NVL((SELECT SUM(CASE WHEN B.MEASURE = 'INV'             THEN B.BOH_QTY
                                                        WHEN B.MEASURE = 'SHIP_PLAN_SEMI'  THEN B.QTY * -1
                                                        WHEN B.MEASURE = 'SHIP_PLAN_RTF'   THEN B.QTY * -1
                                                        WHEN B.MEASURE = 'IN_HOUSE_MOVING' THEN B.QTY * -1
                                                        WHEN B.MEASURE = 'SEMI_WH_IN'      THEN B.QTY
                                                        WHEN B.MEASURE = 'PROD_PLAN'       THEN B.QTY
                                                   END) QTY
                                          FROM GT_PISEO_MAIN B
                                         WHERE B.DIVISION_ID              = A.DIVISION_ID
                                           AND B.COMPANY_ID               = A.COMPANY_ID
                                           AND B.PLANT_ID                 = A.PLANT_ID
                                           AND B.PLAN_START_YYYYMMDD      = A.PLAN_START_YYYYMMDD
                                           AND B.SEQ                      = A.SEQ
                                           AND B.OPERATION_GROUP          = A.OPERATION_GROUP
                                           AND B.FROM_SITE                = A.FROM_SITE
                                           AND B.CELL_ITEM_ID             = A.CELL_ITEM_ID
                                           AND B.ITEM_ID                  = A.ITEM_ID
                                           AND SUBSTR(B.SEQ_FLAG, 1, 1)   = SUBSTR(A.SEQ_FLAG, 1, 1)
                                           AND B.YYYYMM                   = A.YYYYMM), 0)
                     WHERE A.MEASURE = 'INV'
                       AND A.YYYYMM  = V_PROC_YYYYMM;

                ELSE /* 두번째 월부터 마지막 월까지 재고 생성. */

                    INSERT
                      INTO GT_PISEO_MAIN
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
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                    SELECT DISTINCT A.DIVISION_ID
                         , A.COMPANY_ID
                         , A.PLANT_ID
                         , A.PLAN_START_YYYYMMDD
                         , 1              AS SEQ   /* a.SEQ */
                         , A.OPERATION_GROUP
                         , A.FROM_SITE
                         , A.CELL_ITEM_ID
                         , A.ITEM_ID
                         , 'INV'          AS MEASURE
                         , '-'            AS VALUE_TYPE
                         , '-'            AS TO_PRODUCT
                         , '-'            AS LINE_ID
                         , A.BOH_QTY      AS BOH_QTY
                         , '-'            AS TO_SITE
                         , '-'            AS INCOTERMS
                         , CASE WHEN A.SEQ_FLAG IS NULL THEN NULL ELSE SUBSTR(A.SEQ_FLAG, 1, 1) || '60' END  AS SEQ_FLAG
                         , V_PROC_YYYYMM  AS YYYYMM
                         , NVL(A.QTY, 0) + NVL((SELECT SUM(CASE WHEN B.MEASURE = 'SHIP_PLAN_SEMI'  THEN B.QTY * -1
                                                               WHEN B.MEASURE = 'SHIP_PLAN_RTF'   THEN B.QTY * -1
                                                               WHEN B.MEASURE = 'IN_HOUSE_MOVING' THEN B.QTY * -1
                                                               WHEN B.MEASURE = 'SEMI_WH_IN'      THEN B.QTY
                                                               WHEN B.MEASURE = 'PROD_PLAN'       THEN B.QTY
                                                          END) QTY
                                                 FROM GT_PISEO_MAIN B
                                                WHERE B.DIVISION_ID            = A.DIVISION_ID
                                                  AND B.COMPANY_ID             = A.COMPANY_ID
                                                  AND B.PLANT_ID               = A.PLANT_ID
                                                  AND B.PLAN_START_YYYYMMDD    = A.PLAN_START_YYYYMMDD
                                                  AND B.SEQ                    = A.SEQ
                                                  AND B.OPERATION_GROUP        = A.OPERATION_GROUP
                                                  AND B.FROM_SITE              = A.FROM_SITE
                                                  AND B.CELL_ITEM_ID           = A.CELL_ITEM_ID
                                                  AND B.ITEM_ID                = A.ITEM_ID
                                                  AND SUBSTR(B.SEQ_FLAG, 1, 1) = SUBSTR(A.SEQ_FLAG, 1, 1)
                                                  AND B.YYYYMM                 = V_PROC_YYYYMM), 0)  AS QTY
                         , 'SCP BATCH'    AS CREATED_BY
                         , SYSDATE        AS CREATION_DATE
                         , 'SCP BATCH'    AS LAST_UPDATED_BY
                         , SYSDATE        AS LAST_UPDATE_DATE
                      FROM GT_PISEO_MAIN A
                     WHERE A.MEASURE = 'INV'
                       AND A.YYYYMM  = V_PRE_YYYYMM;
                END IF;

                V_I := V_I + 1;

                V_PROC_YYYYMMDD := TO_CHAR(ADD_MONTHS(TO_DATE(V_PROC_YYYYMMDD, 'YYYYMMDD'), 1), 'YYYYMMDD');
                V_PRE_YYYYMM    := V_PROC_YYYYMM;
                V_PROC_YYYYMM   := SUBSTR(V_PROC_YYYYMMDD, 1, 6);

            END LOOP;

            /* ------------------------------------------------------------------------------------------- */
            /* ESS 용 전극 Item 정보 삭제 처리 : 81 전극에서 ESS 전극 일부 생산 */
            /* ------------------------------------------------------------------------------------------- */
            DELETE
              FROM GT_PISEO_MAIN
             WHERE 1 = 1
               AND OPERATION_GROUP = 'E'
               AND ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                 FROM SCP_MST_FINAL_ITEM
                                WHERE DIVISION_ID  = V_DIVISION_ID
                                  AND FLOW_ID      LIKE 'E2000%'
                                  AND CELL_ITEM_ID LIKE 'EC%');

    /* ------------------------------------------------------------------------------------------------------ */
    /* ------------------------------------------------------------------------------------------------------ */
    /* 2025.03.013  Begin   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영 */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || 'Begin   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영');
    /* ------------------------------------------------------------------------------------------------------ */

            /* ------------------------------------------------------------------------------------------------ */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 기간 정보');
            /* ------------------------------------------------------------------------------------------------ */
            V_FILL_0_TARGET_PERIOD            := -1;
            V_FILL_0_TARGET_PERIOD_END_YYYYMM := SUBSTR(V_HORIZON_END_YYYYMMDD, 1, 6);

            BEGIN
                SELECT FILL_0_TARGET_PERIOD
                     , FILL_0_TARGET_PERIOD_END_YYYYMM
                  INTO V_FILL_0_TARGET_PERIOD
                     , V_FILL_0_TARGET_PERIOD_END_YYYYMM
                  FROM (SELECT TO_NUMBER(L.SEGMENT1)  AS FILL_0_TARGET_PERIOD
                             , CASE WHEN TO_NUMBER(L.SEGMENT1) > 0
                                    THEN TO_CHAR(LAST_DAY(ADD_MONTHS(V_PLAN_START_DATE, TO_NUMBER(L.SEGMENT1) - 1)), 'YYYYMM')
                                    ELSE V_FILL_0_TARGET_PERIOD_END_YYYYMM
                               END  AS FILL_0_TARGET_PERIOD_END_YYYYMM
                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
                         WHERE 1 = 1
                           AND L.LOOKUP_TYPE = 'INTEGRATION_PSI_FIFO_NEED_PRE_PERIOD'   /* ESS 선입선출 선점 차감 기간 (0 채우기 대상 기간 - 개월수) */
                           AND L.VALID_YN = 'Y'
                           AND NVL(L.SEGMENT1, '0') IS NOT NULL
                           AND VALIDATE_CONVERSION(L.SEGMENT1 AS NUMBER) = 1
                         ORDER BY L.LAST_UPDATE_DATE DESC)
                 WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;

            IF V_FILL_0_TARGET_PERIOD_END_YYYYMM > SUBSTR(V_HORIZON_END_YYYYMMDD, 1, 6) THEN
                V_FILL_0_TARGET_PERIOD_END_YYYYMM := SUBSTR(V_HORIZON_END_YYYYMMDD, 1, 6);
            END IF;

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '@V_FILL_0_TARGET_PERIOD : ' || TO_CHAR(V_FILL_0_TARGET_PERIOD));
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '@V_FILL_0_TARGET_PERIOD_END_YYYYMM : ' || V_FILL_0_TARGET_PERIOD_END_YYYYMM);

            /* ------------------------------------------------------------------------------------------------ */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 기간 월 목록');
            /* ------------------------------------------------------------------------------------------------ */

            INSERT
              INTO GT_PISEO_MM_LIST
                 ( YYYYMM )
            SELECT DISTINCT B.YYYYMM
              FROM SCM_MST_BUCKET B
             WHERE 1 = 1
               AND B.YYYYMM BETWEEN V_PLAN_START_YYYYMM
                                AND V_FILL_0_TARGET_PERIOD_END_YYYYMM;

            /* ------------------------------------------------------------------------------------------------ */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 Measure');
            /* 대상 measure : PROD_PLAN , SHIP_PLAN_SEMI */
            /* ------------------------------------------------------------------------------------------------ */

            INSERT
              INTO GT_PISEO_TARGET_MM_0
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
                 , ATTRIBUTE1 )
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
                 , NVL(MAX(CASE WHEN T.YYYYMM = M.YYYYMM THEN T.QTY ELSE NULL END), 0)  AS QTY  /* 재고를 제외하고 음수가 없기 떄문에 MAX처리 문제 없음 ?! */
                 , MAX(T.ATTRIBUTE1)                                                    AS ATTRIBUTE1
              FROM GT_PISEO_MAIN     T
                 , GT_PISEO_MM_LIST  M

             WHERE 1 = 1
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

            /* ------------------------------------------------------------------------------------------------ */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 Measure - 채우기 전 데이터 삭제 (해당 기간)');
            /* ------------------------------------------------------------------------------------------------ */
            DELETE
              FROM GT_PISEO_MAIN T
             WHERE 1 = 1
               AND T.YYYYMM BETWEEN V_PLAN_START_YYYYMM
                                AND V_FILL_0_TARGET_PERIOD_END_YYYYMM
               AND T.MEASURE NOT IN ('SHIP_PLAN_RTF', 'MKT_FCST', 'INV');

            /* ------------------------------------------------------------------------------------------------ */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 Measure - 0 채운 데이터 Insert - Start ');
            /* ------------------------------------------------------------------------------------------------ */
            INSERT
              INTO GT_PISEO_MAIN
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
                 , ATTRIBUTE1 )
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
              FROM GT_PISEO_TARGET_MM_0 T;

    /* ------------------------------------------------------------------------------------------------------ */
    /* 2025.03.013  End   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영 */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || 'End  PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영');
    /* ------------------------------------------------------------------------------------------------------ */

            /* ------------------------------------------------------------------------------------------- */
            /* 이전 동일 수행건 삭제 후 수행내역 Insert */
            /* 삭제 & insert */
            /* ------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := 'Delete';

            DELETE
              FROM SCP_ANL_PSI_INTEGRATION A
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.SEQ_FLAG IN ('500', '510', '520', '540', '550', '560');

            V_STATUS_DESC := 'insert';

            INSERT
              INTO SCP_ANL_PSI_INTEGRATION
                 ( DIVISION_ID
                 , COMPANY_ID
                 , PLANT_ID
                 , PLAN_START_YYYYMMDD
                 , SEQ
                 , OPERATION_GROUP
                 , FROM_SITE
                 , CELL_ITEM_ID
                 , ITEM_ID
                 , MEASURE            /* 10 */
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
                 , LAST_UPDATED_BY    /* 10 */
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
                 , ATTRIBUTE10 )
            SELECT A.DIVISION_ID
                 , NVL(A.COMPANY_ID, '-')
                 , NVL(A.PLANT_ID, '-')
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
                 /* ,BOH_QTY */
                 /* ,isnull(sum(isnull(BOH_QTY,0)),0) as BOH_QTY */
                 , ROUND(NVL(SUM(NVL(A.BOH_QTY, 0)), 0), 0)  AS BOH_QTY
                 , A.TO_SITE
                 , NVL(A.INCOTERMS, '-')
                 , A.SEQ_FLAG
                 , A.YYYYMM
                 /* ,QTY */
                 /* ,isnull(sum(isnull(QTY,0)),0) as QTY */
                 , ROUND(NVL(SUM(NVL(A.QTY, 0)), 0), 0)      AS QTY
                 , 'SCP BATCH'                     AS CREATED_BY
                 , SYSDATE                         AS CREATION_DATE
                 , 'SCP BATCH'                     AS LAST_UPDATED_BY
                 , SYSDATE                         AS LAST_UPDATE_DATE
                 , ''                              AS ATTRIBUTE1
                 , V_PLAN_TYPE                     AS ATTRIBUTE2   /* 2025.03.13 수정 */
                 , TO_CHAR(V_FILL_0_TARGET_PERIOD) AS ATTRIBUTE3   /* 2025.03.13 수정 */
                 , ''                              AS ATTRIBUTE4
                 , ''                              AS ATTRIBUTE5
                 , ''                              AS ATTRIBUTE6
                 , ''                              AS ATTRIBUTE7
                 , ''                              AS ATTRIBUTE8
                 , ''                              AS ATTRIBUTE9
                 , ''                              AS ATTRIBUTE10
              FROM GT_PISEO_MAIN A
             WHERE A.SEQ_FLAG IN ('500', '510', '520', '540', '550', '560')
             GROUP BY A.DIVISION_ID
                    , NVL(A.COMPANY_ID, '-')
                    , NVL(A.PLANT_ID, '-')
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
                    , A.TO_SITE
                    , A.INCOTERMS
                    , A.SEQ_FLAG
                    , A.YYYYMM;


            DELETE
              FROM GT_PISEO_MAIN;

            DELETE
              FROM GT_PISEO_INV;

            DELETE
              FROM GT_PISEO_CCC;

            DELETE
              FROM GT_PISEO_ELEC_PLANT;


            DELETE
              FROM GT_PISEO_MM_LIST;

            DELETE
              FROM GT_PISEO_TARGET_MM_0;

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

            /* ★무TRAN + 최상위 스케줄 배치(master/JOB_차수선정_마스터.csv: JOB.PR_SCP_ANL_PSI_INTEGRATION_40_EE = 프로시저 PR_SCP_ANL_PSI_INTEGRATION_SMALL_ELEC_ONLY 실행) */


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

    V_DESCRIPTION := CASE WHEN V_PLAN_START_YYYYMMDD IS NULL OR V_EXEC_TIME IS NULL THEN NULL
                          ELSE '[' || V_DIVISION_ID || '][' || V_PLAN_START_YYYYMMDD || '][' || V_EXEC_TIME || ']'
                     END;
    V_DESCRIPTION := CASE WHEN V_PLAN_START_YYYYMMDD IS NULL OR V_EXEC_TIME IS NULL THEN NULL
                          ELSE '[' || V_STATUS_DESC || '][' || V_PLAN_START_YYYYMMDD || '][' || V_EXEC_TIME || ']'
                     END;
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