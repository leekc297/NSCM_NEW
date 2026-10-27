PROCEDURE PR_SCP_ANL_PSI_GLOBAL_ESS
(
      P_PLAN_CYCLE           IN VARCHAR2
    , P_PLAN_START_YYYYMMDD  IN VARCHAR2
    , P_PLAN_ID              IN VARCHAR2
    , P_MODELING_ID          IN VARCHAR2
    , P_SEQ                  IN VARCHAR2
    , P_PLAN_TYPE            IN VARCHAR2
    , P_MASTER_ID            IN VARCHAR2
    , P_DIVISION_ID          IN VARCHAR2
    , P_ENGINE_PLAN_ID       IN VARCHAR2
    , P_USER_ID              IN VARCHAR2 DEFAULT 'scp_batch'
)
/*
 * Program ID   : PR_SCP_ANL_PSI_GLOBAL_ESS
 * Description  : PR_SCP_ANL_CREATE_DATA 에서 호출함.
 * OutTable     :
 * Execute      :
 *    DELETE FROM SCM_SYS_LOG_BATCH WHERE PROGRAM_NAME = 'PR_SCP_ANL_PSI_GLOBAL_ESS' AND CREATED_BY = 'KTH'
 *    EXEC PR_SCP_ANL_PSI_GLOBAL_ESS
 *          p_plan_cycle          = 'WEEKLY'
 *        , p_plan_start_yyyymmdd = '20190701'
 *        , p_plan_id             = '1085'
 *        , p_modeling_id         = '3'
 *        , p_seq                 = '1'
 *        , p_plan_type           = 'PR'
 *        , p_master_id           = '82::WEEKLY'
 *        , p_division_id         = '82'
 *        , p_engine_plan_id      = '1085::PR::1'
 *        , p_user_id             = 'KTH'
 *
 *    SELECT * FROM SCM_SYS_LOG_BATCH WHERE PROGRAM_NAME = 'PR_SCP_ANL_PSI_GLOBAL_ESS' AND CREATED_BY = 'KTH' ORDER BY CREATION_DATE DESC
 *
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.07.01   KTH         Initial Release [PJ20189106] 전지.GSCM 고도화 이행
 * 2019.07.17   KTH         CONVERT_QTY_CELL 추가
 * 2019.07.23   KTH         PRODUCTION_CELL 추가
 *                          WH_IN pegging 테이블 조인 제거
 * 2019.10.15   KTH         AND A.CELL_ITEM_ID IS NOT NULL 추가
 * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2021.07.16   sclee       PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) : scp_mst_bod_v에서 scp_mst_bod_n_v로 변경
 * 2023.04.25   HRK         PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : BCU 모델 cell_item_id 정보 없는 경우도 적재
 * 2023.06.08   hrkim       PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 * 2023.06.20   hrkim       PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *                            1. Cell Product의 Model Inventory를 Cell Assy기준으로 합산
 *                              - Pack창고 Cell 재고는 제외 (attribute1 != 'CELL')
 *                              - From Site가 국내인 경우만 (company_id = 'C100' - 7월 임시조건)
 * 2023.06.27   hrkim       PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *                            - Cell 창고의 Cell Product를 Cell Assy 재고로 치환
 * 2023.06.29   hrkim       PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *                            4. Cell창고 Cell Product 생산관련 measure 전구간 0인 데이터 삭제 (2023년 7월은 국내만, 8월부터 전체 법인)
 *                            ------------------------------------------
 *                             대상 measure
 *                            ------------------------------------------
 *                            PRODUCTION              Production
 *                            ACTIVATE_COMPLETED      Char. Completed
 *                            CHAR_AVAILABLE          Char. Available
 *                            ACTIVATE_PROGRESS       Formation Progress
 *                            MODEL_INVENTORY         Model Inventory
 *                            DIO                     DIO
 *                            ------------------------------------------
 * 2023/07/17   hrkim       PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응 (8월 해외 오픈 대응)
 * 2023/07/26   hrkim       PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : SCP_MST_CELL_PROD_ASSY_MAP 참조시 Valid_yn = 'Y' 조건 추가
 * 2026.05.22   ymh         E20260331-000738 82사업부 MA Plan 수행 시 속도지연
 * 2026.07.06   ZIONEX      [PJ202650304]  NextSCM Migration
 * 2026.10.27    ZIONEX      [PJ202650304] 티라엔진 제거 - SCP_PLN_SALES_ONHAND -> 통합 Dataset 기반 뷰(SCP_PLN_SALES_ONHAND_V) 교체
 */
AS
    V_BATCH_USER    VARCHAR2(150 CHAR);
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_SCP_ANL_PSI_GLOBAL_ESS';
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     NUMBER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    V_TABLE_ID      VARCHAR2(150 CHAR) := 'PR_SCP_ANL_PSI_GLOBAL_ESS';
    D_EVENT_DATE    DATE;
    V_START_TIME    DATE;
    V_EXEC_TIME     VARCHAR2(10 CHAR) := '';
    V_EXEC_SEC      NUMBER;
    V_PET_DATE      VARCHAR2(12 CHAR) := '';
BEGIN
    /* LOG 용 변수 설정 */
    V_BATCH_USER := P_USER_ID;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' PR_SCP_ANL_PSI_GLOBAL_ESS INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

    /* 임시 실행시간 확인용 */
    V_START_TIME := SYSDATE;

    /* 2021.05.10 KSW PJ20209642 중장기 플랜 대응 : Plan End Date + 1일 */
    BEGIN
        SELECT P.HORIZON_END_DATE
          INTO V_PET_DATE
          FROM SCM_MST_PLAN P
         WHERE P.DIVISION_ID = P_DIVISION_ID
           AND P.PLAN_ID     = P_PLAN_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_PET_DATE := NULL;
    END;
    IF V_PET_DATE IS NOT NULL AND LENGTH(TRIM(V_PET_DATE)) = 8 THEN
        V_PET_DATE := TO_CHAR(TO_DATE(V_PET_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD');
    ELSE
        V_PET_DATE := NULL;
    END IF;

    BEGIN
        /* GTT 초기화 (자기 GTT DELETE) */
        DELETE FROM GT_PSIGE_TMP;
        DELETE FROM GT_PSIGE_CELLASSY;
        DELETE FROM GT_PSIGE_CPMI;
        DELETE FROM GT_PSIGE_INT;
        DELETE FROM GT_PSIGE_BOH;
        DELETE FROM GT_PSIGE_Y;
        DELETE FROM GT_PSIGE_DIO1;
        DELETE FROM GT_PSIGE_DIO2;
        DELETE FROM GT_PSIGE_DIO3;
        DELETE FROM GT_PSIGE_SITEID;
        DELETE FROM GT_PSIGE_DELTGT;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 1. SEMI 입력   TO SITE TRANSPORT_MODE */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIGE_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1 )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP, A.ITEM_ID, NULL
             , A.TO_SITE, NULL, NULL, A.FROM_SITE, NULL, A.BOD_ID, NULL
             , A.MEASURE, A.YYYYMMDD, A.QTY, 'SCP_ANL_SHIPMENT_PLAN_SEMI'
          FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
         WHERE 1 = 1
           AND A.DIVISION_ID         = P_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = P_SEQ
           AND A.MEASURE             IN ('SHIP_PLAN', 'SHIP_REQ');

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2. PSI 입력 */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIGE_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1 )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP, A.ITEM_ID, NULL
             , A.TO_SITE, NULL, NULL, A.FROM_SITE, NULL, NULL
             , (CASE WHEN A.PSI_TYPE = 'P' THEN A.PSI_VALUE ELSE NULL END)
             , (CASE WHEN A.PSI_TYPE = 'P' THEN 'PRODUCTION'
                     WHEN A.PSI_TYPE = 'I' AND A.PSI_VALUE IN ('ACTIVATE_PROGRESS', 'CHAR_AVAILABLE', 'MODEL_INVENTORY', 'ACTIVATE_COMPLETED') THEN A.PSI_VALUE
                ELSE '-' END)
             , A.YYYYMMDD, SUM(A.QTY), 'SCP_ANL_PSI_PRODUCTION'
          FROM SCP_ANL_PSI_PRODUCTION A
         WHERE 1 = 1
           AND A.DIVISION_ID         = P_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = P_SEQ
           AND A.PSI_VALUE           <> 'DIO'
           AND A.PSI_VALUE           <> 'ISSUM'
         GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP, A.ITEM_ID
                , A.TO_SITE, A.FROM_SITE
                , (CASE WHEN A.PSI_TYPE = 'P' THEN A.PSI_VALUE ELSE NULL END)
                , (CASE WHEN A.PSI_TYPE = 'P' THEN 'PRODUCTION'
                        WHEN A.PSI_TYPE = 'I' AND A.PSI_VALUE IN ('ACTIVATE_PROGRESS', 'CHAR_AVAILABLE', 'MODEL_INVENTORY', 'ACTIVATE_COMPLETED') THEN A.PSI_VALUE
                   ELSE '-' END)
                , A.YYYYMMDD;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 3. FG 입력   FROM SITE TRANSPORT_MODE */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIGE_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1 )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.BIZ_TYPE, A.ITEM_ID, NULL
             , A.TO_SITE, NULL, A.INCOTERMS, A.FROM_SITE, NULL, A.BOD_ID, NULL
             , A.MEASURE, A.YYYYMMDD, SUM(A.QTY), 'SCP_ANL_SHIPMENT_PLAN_FG'
          FROM SCP_ANL_SHIPMENT_PLAN_FG A
         WHERE 1 = 1
           AND A.DIVISION_ID         = P_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = P_SEQ
           AND A.MEASURE             NOT IN ('SHIP_PLAN_AMEND', 'WH_IN_BALANCE')
         GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.BIZ_TYPE, A.ITEM_ID
                , A.TO_SITE, A.INCOTERMS, A.FROM_SITE, A.BOD_ID, A.MEASURE, A.YYYYMMDD;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 4. SEMI 추가 로직 : WH_IN */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIGE_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1 )
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, MAX(OPERATION_GROUP), ITEM_ID, NULL
             , TO_SITE, NULL, '-', FROM_SITE, NULL, '-', TRANSPORT_MODE_LINE
             , MEASURE, YYYYMMDD, SUM(QTY), 'WH_IN'
          FROM (
                SELECT B.DIVISION_ID, B.PLAN_START_YYYYMMDD, B.PLAN_TYPE, B.SEQ, B.OPERATION_GROUP, B.ITEM_ID
                     , NULL AS CELL_ITEM_ID, B.TO_SITE, B.INCOTERMS, B.FROM_SITE, B.BOD_ID
                     , NULL AS TRANSPORT_MODE_LINE, 'WH_IN' AS MEASURE
                     , TO_CHAR(B.END_TIME, 'YYYYMMDD') AS YYYYMMDD, B.COMPLETE_QTY AS QTY
                  FROM SCP_PLN_SHIPMENT_PLAN B
                 WHERE 1 = 1
                   AND B.DIVISION_ID         = P_DIVISION_ID
                   AND B.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND B.PLAN_TYPE           = P_PLAN_TYPE
                   AND B.SEQ                 = P_SEQ
                   AND B.MEASURE             = 'SHIP_PLAN'
                   AND B.SEMI_YN             = 'Y'
                   AND B.COMPLETE_QTY        IS NOT NULL
                   AND B.INCOTERMS           <> '-'
               ) X
         GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, TO_SITE, INCOTERMS
                , FROM_SITE, TRANSPORT_MODE_LINE, MEASURE, YYYYMMDD;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 5. PACK SITE CELL 재고 'MODEL_INVENTORY' 추가 (정렬용 ATTRIBUTE10 = '2') */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIGE_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1, ATTRIBUTE10 )
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, 'A', ITEM_ID, ITEM_ID
             , '-', NULL, '-', SITE_ID, NULL, '-', NULL
             , 'MODEL_INVENTORY', YYYYMMDD, NVL(PSI_EOH_QTY, 0), 'CELL', '2'
          FROM SCP_PLN_PLANT_ONHAND
         WHERE DIVISION_ID         = P_DIVISION_ID
           AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND PLAN_TYPE           = P_PLAN_TYPE
           AND SEQ                 = P_SEQ
           AND OPERATION_GROUP     = 'A'
           AND SITE_ID             LIKE '%-P'
           AND STOCK_TYPE          = 'A_PACK';

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 6. 활성화코드 분리 대응 : Cell Product의 Model Inventory 를 Cell Assy 기준으로 변환 합산 */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* 6.0 Cell Product 기준 Cell Assy 정보 추출 (3단계 우선순위) */
        INSERT INTO GT_PSIGE_CELLASSY
            ( DIVISION_ID, PLANT_ID, ITEM_ID_ASSY, ITEM_ID_PROD, PRIORITY_1ST, PRIORITY_2ND, PRIORITY_3RD )
        SELECT M.DIVISION_ID, M.PLANT_ID, M.ITEM_ID_ASSY, M.ITEM_ID_PROD
             , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.ITEM_ID_PROD, M.PLANT_ID
                                      ORDER BY M.VALID_YN DESC, M.CELL_TYPE, M.ITEM_ID_ASSY)
             , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.ITEM_ID_PROD
                                      ORDER BY M.VALID_YN DESC, M.CELL_TYPE, M.ITEM_ID_ASSY)
             , ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_PROD
                                      ORDER BY M.VALID_YN DESC, M.CELL_TYPE, M.ITEM_ID_ASSY)
          FROM SCP_MST_CELL_PROD_ASSY_MAP M
         WHERE 1 = 1
           AND M.VALID_YN = 'Y';

        /* 6.1 대상 Cell Product Model Inventory 데이터 추출 */
        INSERT INTO GT_PSIGE_CPMI
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , CONVERT_QTY_CELL, TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID
            , TRANSPORT_MODE_LINE, MEASURE, YYYYMMDD, QTY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE9, ATTRIBUTE10
            , PLANT_ID, CELL_ASSY )
        SELECT PG.DIVISION_ID, PG.PLAN_START_YYYYMMDD, PG.PLAN_TYPE, PG.SEQ, PG.OPERATION_GROUP, PG.ITEM_ID, PG.CELL_ITEM_ID
             , PG.CONVERT_QTY_CELL, PG.TO_SITE, PG.TO_BOH_QTY, PG.INCOTERMS, PG.FROM_SITE, PG.FROM_BOH_QTY, PG.BOD_ID
             , PG.TRANSPORT_MODE_LINE, PG.MEASURE, PG.YYYYMMDD, PG.QTY, PG.ATTRIBUTE1, PG.ATTRIBUTE2, PG.ATTRIBUTE9, PG.ATTRIBUTE10
             , FS.PLANT_ID
             , NVL(NVL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), CA3.ITEM_ID_ASSY) AS CELL_ASSY
          FROM GT_PSIGE_TMP PG
               INNER JOIN SCP_MST_FINAL_ITEM_V FI
                       ON FI.ITEM_ID   = PG.ITEM_ID
                      AND FI.CELL_TYPE = 'CP'
               INNER JOIN SCM_MST_SITE FS
                       ON FS.DIVISION_ID     = PG.DIVISION_ID
                      AND FS.SCM_SITE_ID     = PG.FROM_SITE
                      AND FS.SITE_TYPE       = 'PLANT'
                      AND FS.OPERATION_GROUP = 'A'
                      AND FS.OSP_YN          = 'N'
                LEFT JOIN GT_PSIGE_CELLASSY CA1
                       ON CA1.DIVISION_ID  = PG.DIVISION_ID
                      AND CA1.ITEM_ID_PROD = PG.ITEM_ID
                      AND CA1.PLANT_ID     = FS.PLANT_ID
                      AND CA1.PRIORITY_1ST = 1
                LEFT JOIN GT_PSIGE_CELLASSY CA2
                       ON CA2.DIVISION_ID  = PG.DIVISION_ID
                      AND CA2.ITEM_ID_PROD = PG.ITEM_ID
                      AND CA2.PRIORITY_2ND = 1
                LEFT JOIN GT_PSIGE_CELLASSY CA3
                       ON CA3.ITEM_ID_PROD = PG.ITEM_ID
                      AND CA3.PRIORITY_3RD = 1
         WHERE 1 = 1
           AND PG.OPERATION_GROUP = 'A'
           AND PG.MEASURE         = 'MODEL_INVENTORY';

        /* 6.2 Cell Product Model Inventory 데이터 삭제 */
        DELETE FROM GT_PSIGE_TMP X
         WHERE 1 = 1
           AND X.MEASURE = 'MODEL_INVENTORY'
           AND EXISTS ( SELECT 1
                          FROM GT_PSIGE_CPMI TGT
                         WHERE 1 = 1
                           AND TGT.CELL_ASSY           IS NOT NULL
                           AND TGT.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD
                           AND TGT.PLAN_TYPE           = X.PLAN_TYPE
                           AND TGT.SEQ                 = X.SEQ
                           AND TGT.DIVISION_ID         = X.DIVISION_ID
                           AND TGT.OPERATION_GROUP     = X.OPERATION_GROUP
                           AND TGT.ITEM_ID             = X.ITEM_ID
                           AND TGT.FROM_SITE           = X.FROM_SITE
                           AND TGT.MEASURE             = X.MEASURE
                           AND TGT.YYYYMMDD            = X.YYYYMMDD );

        /* 6.3 Cell Product Model Inventory 대상 데이터 Cell Assy 에 합산 적용 (UPDATE / INSERT) */
        MERGE INTO GT_PSIGE_TMP TGT
        USING ( SELECT PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, DIVISION_ID, OPERATION_GROUP
                     , CELL_ASSY AS ITEM_ID, CAST(NULL AS VARCHAR2(150 CHAR)) AS CELL_ITEM_ID
                     , TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMMDD
                     , SUM(QTY) AS QTY, SUM(FROM_BOH_QTY) AS FROM_BOH_QTY, SUM(TO_BOH_QTY) AS TO_BOH_QTY
                     , MAX(ATTRIBUTE1) AS ATTRIBUTE1, MAX(ATTRIBUTE2) AS ATTRIBUTE2
                     , MAX(ATTRIBUTE9) AS ATTRIBUTE9, MAX(ATTRIBUTE10) AS ATTRIBUTE10
                  FROM GT_PSIGE_CPMI
                 WHERE 1 = 1
                   AND CELL_ASSY IS NOT NULL
                 GROUP BY PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, DIVISION_ID, OPERATION_GROUP, CELL_ASSY
                        , TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMMDD
              ) SRC
           ON (    TGT.PLAN_START_YYYYMMDD = SRC.PLAN_START_YYYYMMDD
               AND TGT.PLAN_TYPE           = SRC.PLAN_TYPE
               AND TGT.SEQ                 = SRC.SEQ
               AND TGT.DIVISION_ID         = SRC.DIVISION_ID
               AND TGT.OPERATION_GROUP     = SRC.OPERATION_GROUP
               AND TGT.ITEM_ID             = SRC.ITEM_ID
               AND TGT.FROM_SITE           = SRC.FROM_SITE
               AND TGT.MEASURE             = SRC.MEASURE
               AND TGT.YYYYMMDD            = SRC.YYYYMMDD )
        WHEN MATCHED THEN
            UPDATE SET TGT.QTY          = TGT.QTY          + SRC.QTY
                     , TGT.FROM_BOH_QTY = TGT.FROM_BOH_QTY + SRC.FROM_BOH_QTY
                     , TGT.TO_BOH_QTY   = TGT.TO_BOH_QTY   + SRC.TO_BOH_QTY
                     , TGT.ATTRIBUTE2   = 'UPDATE :: ' || TO_CHAR(TGT.QTY) || ' :: ' || TO_CHAR(SRC.QTY)
        WHEN NOT MATCHED THEN
            INSERT ( PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, DIVISION_ID, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
                   , TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMMDD
                   , QTY, FROM_BOH_QTY, TO_BOH_QTY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE9, ATTRIBUTE10 )
            VALUES ( SRC.PLAN_START_YYYYMMDD, SRC.PLAN_TYPE, SRC.SEQ, SRC.DIVISION_ID, SRC.OPERATION_GROUP, SRC.ITEM_ID, SRC.CELL_ITEM_ID
                   , SRC.TO_SITE, SRC.INCOTERMS, SRC.FROM_SITE, SRC.BOD_ID, SRC.TRANSPORT_MODE_LINE, SRC.MEASURE, SRC.YYYYMMDD
                   , SRC.QTY, SRC.FROM_BOH_QTY, SRC.TO_BOH_QTY, SRC.ATTRIBUTE1, 'INSERT', SRC.ATTRIBUTE9, SRC.ATTRIBUTE10 );

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 8. 해상재고 반영 (WH_IN)  -- TH_ENG_STOCK_PLAN_SN, FN_CHARINDEX_REV */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIGE_INT
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1 )
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
             , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
             , MEASURE, YYYYMMDD, SUM(QTY), ATTRIBUTE1
          FROM (
                SELECT P_DIVISION_ID AS DIVISION_ID, P_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                     , P_PLAN_TYPE AS PLAN_TYPE, P_SEQ AS SEQ, C.OPERATION_GROUP, A.ITEM_ID, NULL AS CELL_ITEM_ID
                     , SUBSTR(A.SITE_ID, 1, FN_CHARINDEX_REV(A.SITE_ID, '~', 0) - 1) AS TO_SITE
                     , NULL AS TO_BOH_QTY, NULL AS INCOTERMS
                     , SUBSTR(A.LOT_ID, FN_CHARINDEX_REV(A.LOT_ID, '::', 0) + 2, 100) AS FROM_SITE
                     , NULL AS FROM_BOH_QTY, NULL AS BOD_ID, NULL AS TRANSPORT_MODE_LINE
                     , 'WH_IN' AS MEASURE, TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD') AS YYYYMMDD
                     , A.QTY AS QTY, 'WH_IN' AS ATTRIBUTE1
                  FROM TH_ENG_STOCK_PLAN_SN A
                       INNER JOIN SCP_MST_FINAL_ITEM_V C
                               ON A.ITEM_ID = C.ITEM_ID
                 WHERE 1 = 1
                   AND A.MASTER_ID = P_MASTER_ID
                   AND A.PLAN_ID   = P_ENGINE_PLAN_ID
                   AND A.DESCR     = 'INT'
               ) X
         GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
                , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
                , MEASURE, YYYYMMDD, ATTRIBUTE1;

        /* 8.1 기존 SEMI WH_IN 행에 해상재고 가산 (UPDATE..FROM JOIN -> 상관 UPDATE + EXISTS 가드) */
        UPDATE GT_PSIGE_TMP X
           SET X.QTY = NVL(X.QTY, 0) + NVL( ( SELECT Y.QTY
                                                FROM GT_PSIGE_INT Y
                                               WHERE Y.ITEM_ID   = X.ITEM_ID
                                                 AND Y.TO_SITE   = X.TO_SITE
                                                 AND Y.FROM_SITE = X.FROM_SITE
                                                 AND Y.YYYYMMDD  = X.YYYYMMDD
                                                 AND Y.MEASURE   = X.MEASURE ), 0 )
         WHERE X.MEASURE    = 'WH_IN'
           AND X.ATTRIBUTE1 = 'WH_IN'
           AND EXISTS ( SELECT 1
                          FROM GT_PSIGE_INT Y
                         WHERE Y.ITEM_ID   = X.ITEM_ID
                           AND Y.TO_SITE   = X.TO_SITE
                           AND Y.FROM_SITE = X.FROM_SITE
                           AND Y.YYYYMMDD  = X.YYYYMMDD
                           AND Y.MEASURE   = X.MEASURE );

        /* 8.2 매칭 WH_IN 행이 없는 해상재고는 신규 INSERT */
        MERGE INTO GT_PSIGE_TMP X
        USING GT_PSIGE_INT Y
           ON (    X.TO_SITE   = Y.TO_SITE
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.ITEM_ID   = Y.ITEM_ID
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = Y.MEASURE )
        WHEN NOT MATCHED THEN
            INSERT ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
                   , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
                   , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1 )
            VALUES ( Y.DIVISION_ID, Y.PLAN_START_YYYYMMDD, Y.PLAN_TYPE, Y.SEQ, Y.OPERATION_GROUP, Y.ITEM_ID, Y.CELL_ITEM_ID
                   , Y.TO_SITE, Y.TO_BOH_QTY, '-', Y.FROM_SITE, Y.FROM_BOH_QTY, '-', Y.TRANSPORT_MODE_LINE
                   , Y.MEASURE, Y.YYYYMMDD, Y.QTY, 'WH_IN' );

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 7. MKT_FCST / WH_IN 0 채워 넣기 (calendar CROSS JOIN + NOT EXISTS) */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* 7.1 MKT_FCST 0채움 (SEMI 키 기준) */
        INSERT INTO GT_PSIGE_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMMDD, QTY, ATTRIBUTE1 )
        SELECT SUB.DIVISION_ID, SUB.PLAN_START_YYYYMMDD, SUB.PLAN_TYPE, SUB.SEQ, SUB.OPERATION_GROUP, SUB.ITEM_ID, SUB.CELL_ITEM_ID
             , SUB.TO_SITE, '-', SUB.FROM_SITE, '-', SUB.TRANSPORT_MODE_LINE, 'MKT_FCST', SUB.YYYYMMDD, 0, 'SCP_ANL_SHIPMENT_PLAN_SEMI'
          FROM (
                SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
                     , FROM_SITE, TO_SITE, YYYYMMDD, NULL AS TRANSPORT_MODE_LINE
                  FROM ( SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
                           FROM SCM_SYS_CALENDAR_M C
                          WHERE 1 = 1
                            AND C.BASIS_YYYYMMDD >= P_PLAN_START_YYYYMMDD
                            AND C.BASIS_YYYYMMDD <  V_PET_DATE ) A
                     , ( SELECT DISTINCT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID
                              , CELL_ITEM_ID, FROM_SITE, TO_SITE, NULL AS TRANSPORT_MODE_LINE
                           FROM GT_PSIGE_TMP X
                          WHERE 1 = 1
                            AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI' ) B
               ) SUB
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1
                              FROM GT_PSIGE_TMP Z
                             WHERE 1 = 1
                               AND Z.DIVISION_ID         = SUB.DIVISION_ID
                               AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD
                               AND Z.PLAN_TYPE           = SUB.PLAN_TYPE
                               AND Z.SEQ                 = SUB.SEQ
                               AND Z.OPERATION_GROUP     = SUB.OPERATION_GROUP
                               AND Z.ITEM_ID             = SUB.ITEM_ID
                               AND Z.CELL_ITEM_ID        = SUB.CELL_ITEM_ID
                               AND Z.TO_SITE             = SUB.TO_SITE
                               AND Z.FROM_SITE           = SUB.FROM_SITE
                               AND Z.YYYYMMDD            = SUB.YYYYMMDD );

        /* 7.2 WH_IN 0채움 (SEMI WH_IN 키 기준) */
        INSERT INTO GT_PSIGE_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMMDD, QTY, ATTRIBUTE1 )
        SELECT SUB.DIVISION_ID, SUB.PLAN_START_YYYYMMDD, SUB.PLAN_TYPE, SUB.SEQ, SUB.OPERATION_GROUP, SUB.ITEM_ID, SUB.CELL_ITEM_ID
             , SUB.TO_SITE, '-', SUB.FROM_SITE, '-', SUB.TRANSPORT_MODE_LINE, 'WH_IN', SUB.YYYYMMDD, 0, 'SCP_ANL_SHIPMENT_PLAN_SEMI'
          FROM (
                SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
                     , FROM_SITE, TO_SITE, 'WH_IN' AS MEASURE, YYYYMMDD, NULL AS TRANSPORT_MODE_LINE
                  FROM ( SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
                           FROM SCM_SYS_CALENDAR_M C
                          WHERE 1 = 1
                            AND C.BASIS_YYYYMMDD >= P_PLAN_START_YYYYMMDD
                            AND C.BASIS_YYYYMMDD <  V_PET_DATE ) A
                     , ( SELECT DISTINCT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID
                              , CELL_ITEM_ID, FROM_SITE, TO_SITE, MEASURE, NULL AS TRANSPORT_MODE_LINE
                           FROM GT_PSIGE_TMP X
                          WHERE 1 = 1
                            AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                            AND MEASURE    = 'WH_IN' ) B
               ) SUB
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1
                              FROM GT_PSIGE_TMP Z
                             WHERE 1 = 1
                               AND Z.DIVISION_ID         = SUB.DIVISION_ID
                               AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD
                               AND Z.PLAN_TYPE           = SUB.PLAN_TYPE
                               AND Z.SEQ                 = SUB.SEQ
                               AND Z.OPERATION_GROUP     = SUB.OPERATION_GROUP
                               AND Z.ITEM_ID             = SUB.ITEM_ID
                               AND Z.CELL_ITEM_ID        = SUB.CELL_ITEM_ID
                               AND Z.TO_SITE             = SUB.TO_SITE
                               AND Z.FROM_SITE           = SUB.FROM_SITE
                               AND Z.MEASURE             = SUB.MEASURE
                               AND Z.YYYYMMDD            = SUB.YYYYMMDD );


        INSERT INTO GT_PSIGE_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMMDD, QTY, ATTRIBUTE1 )
        SELECT SUB.DIVISION_ID, SUB.PLAN_START_YYYYMMDD, SUB.PLAN_TYPE, SUB.SEQ, SUB.OPERATION_GROUP, SUB.ITEM_ID, SUB.CELL_ITEM_ID
             , SUB.TO_SITE, '-', SUB.FROM_SITE, '-', SUB.TRANSPORT_MODE_LINE, 'WH_IN', SUB.YYYYMMDD, 0, 'WH_IN'
          FROM (
                SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
                     , FROM_SITE, TO_SITE, 'WH_IN' AS MEASURE, YYYYMMDD, NULL AS TRANSPORT_MODE_LINE
                  FROM ( SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
                           FROM SCM_SYS_CALENDAR_M C
                          WHERE 1 = 1
                            AND C.BASIS_YYYYMMDD >= P_PLAN_START_YYYYMMDD
                            AND C.BASIS_YYYYMMDD <  V_PET_DATE ) A
                     , ( SELECT DISTINCT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID
                              , CELL_ITEM_ID, FROM_SITE, TO_SITE, MEASURE, NULL AS TRANSPORT_MODE_LINE
                           FROM GT_PSIGE_TMP X
                          WHERE 1 = 1
                            AND ATTRIBUTE1 = 'WH_IN'
                            AND MEASURE    = 'WH_IN' ) B
               ) SUB
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1
                              FROM GT_PSIGE_TMP Z
                             WHERE 1 = 1
                               AND Z.DIVISION_ID         = SUB.DIVISION_ID
                               AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD
                               AND Z.PLAN_TYPE           = SUB.PLAN_TYPE
                               AND Z.SEQ                 = SUB.SEQ
                               AND Z.OPERATION_GROUP     = SUB.OPERATION_GROUP
                               AND Z.ITEM_ID             = SUB.ITEM_ID
                               AND Z.CELL_ITEM_ID        = SUB.CELL_ITEM_ID
                               AND Z.TO_SITE             = SUB.TO_SITE
                               AND Z.FROM_SITE           = SUB.FROM_SITE
                               AND Z.MEASURE             = SUB.MEASURE
                               AND Z.YYYYMMDD            = SUB.YYYYMMDD );

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 9. UPDATE (BOH, TRANSPORT MODE) / WH_IN_BALANCE / CELL_ITEM_ID */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* 9.1 + 9.2 SCP_PLN_SALES_ONHAND UNION SCP_PLN_PLANT_ONHAND (Cell 창고 Cell Product -> Cell Assy 치환) */
        INSERT INTO GT_PSIGE_BOH
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SITE_ID, ITEM_ID, PSI_BOH_QTY )
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SITE_ID, ITEM_ID, PSI_BOH_QTY
          FROM (
                SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SITE_ID, ITEM_ID, PSI_BOH_QTY
                  FROM SCP_PLN_SALES_ONHAND_V
                 WHERE 0 = 0
                   AND DIVISION_ID         = P_DIVISION_ID
                   AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND PLAN_TYPE           = P_PLAN_TYPE
                   AND SEQ                 = P_SEQ
                   AND YYYYMMDD            = P_PLAN_START_YYYYMMDD
                UNION
                SELECT PO.DIVISION_ID, PO.PLAN_START_YYYYMMDD, PO.PLAN_TYPE, PO.SEQ, PO.SITE_ID
                     , CASE WHEN FS.OPERATION_GROUP = 'A' AND FS.SITE_TYPE = 'PLANT' AND FS.OSP_YN = 'N'
                                 AND (CA1.ITEM_ID_ASSY IS NOT NULL OR CA2.ITEM_ID_ASSY IS NOT NULL OR CA3.ITEM_ID_ASSY IS NOT NULL)
                            THEN NVL(NVL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), CA3.ITEM_ID_ASSY)
                            ELSE PO.ITEM_ID
                       END AS ITEM_ID
                     , NVL(SUM(PO.PSI_BOH_QTY), 0) AS PSI_BOH_QTY
                  FROM SCP_PLN_PLANT_ONHAND PO
                       INNER JOIN SCM_MST_SITE FS
                               ON FS.DIVISION_ID = PO.DIVISION_ID
                              AND FS.SCM_SITE_ID = PO.SITE_ID
                        LEFT JOIN GT_PSIGE_CELLASSY CA1
                               ON CA1.DIVISION_ID  = PO.DIVISION_ID
                              AND CA1.ITEM_ID_PROD = PO.ITEM_ID
                              AND CA1.PLANT_ID     = FS.PLANT_ID
                              AND CA1.PRIORITY_1ST = 1
                        LEFT JOIN GT_PSIGE_CELLASSY CA2
                               ON CA2.DIVISION_ID  = PO.DIVISION_ID
                              AND CA2.ITEM_ID_PROD = PO.ITEM_ID
                              AND CA2.PRIORITY_2ND = 1
                        LEFT JOIN GT_PSIGE_CELLASSY CA3
                               ON CA3.ITEM_ID_PROD = PO.ITEM_ID
                              AND CA3.PRIORITY_3RD = 1
                 WHERE PO.DIVISION_ID         = P_DIVISION_ID
                   AND PO.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND PO.PLAN_TYPE           = P_PLAN_TYPE
                   AND PO.SEQ                 = P_SEQ
                   AND PO.YYYYMMDD            = PO.PLAN_START_YYYYMMDD
                   AND PO.STOCK_TYPE          NOT IN ('ASSM', 'FOR_STOCKPLAN', 'FORMING', 'FORMED', 'CHARING')
                 GROUP BY PO.DIVISION_ID, PO.PLAN_START_YYYYMMDD, PO.PLAN_TYPE, PO.SEQ, PO.SITE_ID
                        , CASE WHEN FS.OPERATION_GROUP = 'A' AND FS.SITE_TYPE = 'PLANT' AND FS.OSP_YN = 'N'
                                    AND (CA1.ITEM_ID_ASSY IS NOT NULL OR CA2.ITEM_ID_ASSY IS NOT NULL OR CA3.ITEM_ID_ASSY IS NOT NULL)
                               THEN NVL(NVL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), CA3.ITEM_ID_ASSY)
                               ELSE PO.ITEM_ID
                          END
               ) X;

        /* 9.3 WH_IN_BALANCE 기준행 추출 */
        INSERT INTO GT_PSIGE_Y
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, INCOTERMS, YYYYMMDD, TO_BOH_QTY, FROM_BOH_QTY, FROM_SITE )
        SELECT DISTINCT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
             , TO_SITE, INCOTERMS, YYYYMMDD, TO_BOH_QTY, FROM_BOH_QTY, MIN(FROM_SITE) AS FROM_SITE
          FROM GT_PSIGE_TMP
         WHERE 1 = 1
           AND MEASURE    IN ('MKT_FCST', 'WH_IN')
           AND ATTRIBUTE1 <> 'WH_IN'
         GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
                , TO_SITE, INCOTERMS, YYYYMMDD, TO_BOH_QTY, FROM_BOH_QTY;

        /* 9.3 WH_IN_BALANCE 입력 (to site 기준 BOH + 누적 Fcst * (-1) + 누적 WH_IN) */
        INSERT INTO GT_PSIGE_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1 )
        SELECT Y.DIVISION_ID, Y.PLAN_START_YYYYMMDD, Y.PLAN_TYPE, Y.SEQ, Y.OPERATION_GROUP, Y.ITEM_ID, Y.CELL_ITEM_ID
             , Y.TO_SITE, Y.TO_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE, Y.FROM_BOH_QTY, '-', NULL
             , 'WH_IN_BALANCE', Y.YYYYMMDD
             , ( SELECT NVL( SUM( CASE MEASURE WHEN 'MKT_FCST' THEN -1 * NVL(QTY, 0)
                                              WHEN 'WH_IN'    THEN      NVL(QTY, 0)
                                         ELSE 0.0 END ), 0 )
                   FROM GT_PSIGE_TMP X
                  WHERE 1 = 1
                    AND X.DIVISION_ID         = Y.DIVISION_ID
                    AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD
                    AND X.PLAN_TYPE           = Y.PLAN_TYPE
                    AND X.SEQ                 = Y.SEQ
                    AND X.ITEM_ID             = Y.ITEM_ID
                    AND X.TO_SITE             = Y.TO_SITE
                    AND X.INCOTERMS           = Y.INCOTERMS
                    AND X.MEASURE             IN ('MKT_FCST', 'WH_IN')
                    AND X.YYYYMMDD            <= Y.YYYYMMDD
               ) + NVL(BOH.PSI_BOH_QTY, 0)
             , NULL
          FROM GT_PSIGE_Y Y
               LEFT OUTER JOIN GT_PSIGE_BOH BOH
                            ON Y.DIVISION_ID         = BOH.DIVISION_ID
                           AND Y.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD
                           AND Y.PLAN_TYPE           = BOH.PLAN_TYPE
                           AND Y.SEQ                 = BOH.SEQ
                           AND Y.TO_SITE             = BOH.SITE_ID
                           AND Y.ITEM_ID             = BOH.ITEM_ID
         WHERE 1 = 1;

        /* 9.4 FROM_BOH_QTY 계산 (UPDATE..FROM JOIN -> MERGE, 다중매칭 결정적 MAX) */
        MERGE INTO GT_PSIGE_TMP X
        USING ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SITE_ID, ITEM_ID, MAX(PSI_BOH_QTY) AS PSI_BOH_QTY
                  FROM GT_PSIGE_BOH
                 GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SITE_ID, ITEM_ID ) BOH
           ON (    X.DIVISION_ID         = BOH.DIVISION_ID
               AND X.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD
               AND X.PLAN_TYPE           = BOH.PLAN_TYPE
               AND X.SEQ                 = BOH.SEQ
               AND X.FROM_SITE           = BOH.SITE_ID
               AND X.ITEM_ID             = BOH.ITEM_ID )
        WHEN MATCHED THEN
            UPDATE SET X.FROM_BOH_QTY = NVL(BOH.PSI_BOH_QTY, 0);

        /* 9.4 TO_BOH_QTY 계산 */
        MERGE INTO GT_PSIGE_TMP X
        USING ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SITE_ID, ITEM_ID, MAX(PSI_BOH_QTY) AS PSI_BOH_QTY
                  FROM GT_PSIGE_BOH
                 GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SITE_ID, ITEM_ID ) BOH
           ON (    X.DIVISION_ID         = BOH.DIVISION_ID
               AND X.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD
               AND X.PLAN_TYPE           = BOH.PLAN_TYPE
               AND X.SEQ                 = BOH.SEQ
               AND X.TO_SITE             = BOH.SITE_ID
               AND X.ITEM_ID             = BOH.ITEM_ID )
        WHEN MATCHED THEN
            UPDATE SET X.TO_BOH_QTY = NVL(BOH.PSI_BOH_QTY, 0);

        /* 9.5 CELL_ITEM_ID UPDATE : PACK (OPERATION_GROUP = 'P') = MODEL_FINAL_ITEM_BOM_V MIN(CHILD) */
        /* (E20260331-000738 82사업부 MA Plan 속도지연 개선로직) */
        MERGE INTO GT_PSIGE_TMP X
        USING ( SELECT Y.DIVISION_ID, Y.MODEL_ID, MIN(Y.CHILD_ITEM_ID) AS CHILD_ITEM_ID
                  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Y
                 WHERE Y.DIVISION_ID        = P_DIVISION_ID
                   AND Y.CELL_TYPE          = 'CP'
                   AND Y.OPERATION_GROUP_ID = 'A'
                 GROUP BY Y.DIVISION_ID, Y.MODEL_ID ) Y
           ON (    Y.DIVISION_ID     = X.DIVISION_ID
               AND Y.MODEL_ID        = X.ITEM_ID
               AND X.OPERATION_GROUP = 'P' )
        WHEN MATCHED THEN
            UPDATE SET X.CELL_ITEM_ID = Y.CHILD_ITEM_ID;

        /* 9.5 CELL_ITEM_ID UPDATE : CELL (OPERATION_GROUP = 'A') = CP_INFO 3단계 체인 (ROWID MERGE, 다중매칭 MAX) */
        MERGE INTO GT_PSIGE_TMP T
        USING ( WITH CP_INFO AS (
                    SELECT M.DIVISION_ID, M.PLANT_ID, M.ITEM_ID_ASSY, M.ITEM_ID_PROD
                         , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.ITEM_ID_ASSY, M.PLANT_ID
                                                  ORDER BY M.VALID_YN DESC, M.ITEM_ID_PROD) PRIORITY_1ST
                         , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.ITEM_ID_ASSY
                                                  ORDER BY M.VALID_YN DESC, M.ITEM_ID_PROD) PRIORITY_2ND
                         , ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_ASSY
                                                  ORDER BY M.VALID_YN DESC, M.ITEM_ID_PROD) PRIORITY_3RD
                      FROM SCP_MST_CELL_PROD_ASSY_MAP M
                     WHERE 1 = 1
                       AND M.VALID_YN = 'Y'
                )
                SELECT RID, MAX(CELL_VAL) AS CELL_VAL
                  FROM (
                        SELECT X.ROWID AS RID
                             , CASE WHEN F.CELL_TYPE LIKE 'CA%'
                                    THEN NVL(NVL(NVL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD), C3.ITEM_ID_PROD), X.ITEM_ID)
                                    ELSE X.ITEM_ID
                               END AS CELL_VAL
                          FROM GT_PSIGE_TMP X
                               INNER JOIN SCP_MST_FINAL_ITEM_V F
                                       ON F.ITEM_ID = X.ITEM_ID
                                LEFT JOIN SCM_MST_SITE FS
                                       ON FS.DIVISION_ID = X.DIVISION_ID
                                      AND FS.SCM_SITE_ID = X.FROM_SITE
                                      AND FS.SITE_TYPE   = 'PLANT'
                                LEFT JOIN CP_INFO C1
                                       ON C1.DIVISION_ID  = X.DIVISION_ID
                                      AND C1.PLANT_ID     = FS.PLANT_ID
                                      AND C1.ITEM_ID_ASSY = X.ITEM_ID
                                      AND C1.PRIORITY_1ST = 1
                                LEFT JOIN CP_INFO C2
                                       ON C2.DIVISION_ID  = X.DIVISION_ID
                                      AND C2.ITEM_ID_ASSY = X.ITEM_ID
                                      AND C2.PRIORITY_2ND = 1
                                LEFT JOIN CP_INFO C3
                                       ON C3.ITEM_ID_ASSY = X.ITEM_ID
                                      AND C3.PRIORITY_3RD = 1
                         WHERE 0 = 0
                           AND X.OPERATION_GROUP = 'A'
                       ) GROUP BY RID
              ) S
           ON ( T.ROWID = S.RID )
        WHEN MATCHED THEN
            UPDATE SET T.CELL_ITEM_ID = S.CELL_VAL;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 10. 'MKT_FCST' 로 ALLOCATION / BALANCE / WH_IN_BALANCE 0 채워 넣기 */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIGE_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, MEASURE, YYYYMMDD, QTY
            , TRANSPORT_MODE_LINE, ATTRIBUTE1 )
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
             , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, 'ALLOCATION', YYYYMMDD, 0
             , TRANSPORT_MODE_LINE, '0'
          FROM GT_PSIGE_TMP
         WHERE 1 = 1
           AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
           AND MEASURE    = 'MKT_FCST'
           AND TO_SITE    <> '-'
        UNION ALL
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
             , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, 'BALANCE', YYYYMMDD, 0
             , TRANSPORT_MODE_LINE, '0'
          FROM GT_PSIGE_TMP
         WHERE 1 = 1
           AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
           AND MEASURE    = 'MKT_FCST'
           AND TO_SITE    <> '-'
        UNION ALL
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
             , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, 'WH_IN_BALANCE', YYYYMMDD, 0
             , TRANSPORT_MODE_LINE, NULL
          FROM GT_PSIGE_TMP
         WHERE 1 = 1
           AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
           AND MEASURE    = 'MKT_FCST'
           AND TO_SITE    <> '-';

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 11. TRANSPORT_MODE_LINE UPDATE (scp_mst_bod_n_v) + 생산제외 DELETE */
        /* ----------------------------------------------------------------------------------------------------------- */
        MERGE INTO GT_PSIGE_TMP X
        USING ( SELECT DIVISION_ID, BOD_ID, FROM_SITE, MAX(TRANSPORT_MODE) AS TRANSPORT_MODE
                  FROM SCP_MST_BOD_N_V
                 GROUP BY DIVISION_ID, BOD_ID, FROM_SITE ) Y
           ON (    X.DIVISION_ID = Y.DIVISION_ID
               AND X.BOD_ID      = Y.BOD_ID
               AND X.FROM_SITE   = Y.FROM_SITE
               AND X.MEASURE     <> 'PRODUCTION'
               AND X.BOD_ID      <> '-' )
        WHEN MATCHED THEN
            UPDATE SET X.TRANSPORT_MODE_LINE = Y.TRANSPORT_MODE;

        DELETE FROM GT_PSIGE_TMP
         WHERE MEASURE IN ('MKT_FCST', 'ALLOCATION', 'BALANCE', 'WH_IN_BALANCE') AND TO_SITE = '-';

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 12. DIO 생성 */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* 12.1 DIO 임시 (OUT_QTY = SHIP_PLAN, FORMATION_QTY = ACTIVATE_PROGRESS, EOH_QTY = MODEL_INVENTORY) */
        INSERT INTO GT_PSIGE_DIO1
            ( DIVISION_ID, FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD, FROM_BOH_QTY, TO_BOH_QTY, OUT_QTY, FORMATION_QTY, EOH_QTY, INV_DAY )
        SELECT DIVISION_ID, NVL(FROM_SITE, ' '), ITEM_ID, CELL_ITEM_ID, YYYYMMDD
             , MAX(FROM_BOH_QTY), MAX(TO_BOH_QTY)
             , SUM( CASE MEASURE WHEN 'SHIP_PLAN'         THEN ROUND(QTY, 1) ELSE 0 END )
             , SUM( CASE MEASURE WHEN 'ACTIVATE_PROGRESS' THEN ROUND(QTY, 1) ELSE 0 END )
             , SUM( CASE MEASURE WHEN 'MODEL_INVENTORY'   THEN ROUND(QTY, 1) ELSE 0 END ), 0
          FROM GT_PSIGE_TMP P
         WHERE 1 = 1
           AND ATTRIBUTE1 <> 'CELL'
           AND FROM_SITE  <> '-'
         GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD;

        /* 12.2 DIO 누적합계와 전일누적합계 생성 */
        INSERT INTO GT_PSIGE_DIO2
            ( YYYYMMDD, FROM_SITE, ITEM_ID, CELL_ITEM_ID, FROM_BOH_QTY, TO_BOH_QTY, OUT_QTY, FORMATION_QTY, EOH_QTY, OUT_QTY_SUM, LAG_OUT_QTY_SUM )
        SELECT YYYYMMDD, FROM_SITE, ITEM_ID, CELL_ITEM_ID, FROM_BOH_QTY, TO_BOH_QTY, OUT_QTY, FORMATION_QTY, EOH_QTY, OUT_QTY_SUM
             , LAG( CASE WHEN OUT_QTY_SUM < 0 THEN 0 ELSE OUT_QTY_SUM END, 1, 0 ) OVER (PARTITION BY FROM_SITE, ITEM_ID, CELL_ITEM_ID ORDER BY YYYYMMDD)
          FROM (
                SELECT FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD
                     , MAX(FROM_BOH_QTY) AS FROM_BOH_QTY, MAX(TO_BOH_QTY) AS TO_BOH_QTY
                     , SUM( CASE WHEN OUT_QTY < 0 THEN 0 ELSE OUT_QTY END ) AS OUT_QTY
                     , SUM( CASE WHEN FORMATION_QTY < 0 THEN 0 ELSE FORMATION_QTY END ) AS FORMATION_QTY
                     , SUM( CASE WHEN EOH_QTY < 0 THEN 0 ELSE EOH_QTY END ) AS EOH_QTY
                     , ROUND( SUM( CASE WHEN OUT_QTY < 0 THEN 0 ELSE OUT_QTY END ) OVER (PARTITION BY FROM_SITE, ITEM_ID ORDER BY FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD), 2 ) AS OUT_QTY_SUM
                  FROM (
                        SELECT FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD
                             , MAX(FROM_BOH_QTY) AS FROM_BOH_QTY, MAX(TO_BOH_QTY) AS TO_BOH_QTY
                             , SUM(OUT_QTY) AS OUT_QTY, SUM(FORMATION_QTY) AS FORMATION_QTY, SUM(EOH_QTY) AS EOH_QTY
                          FROM GT_PSIGE_DIO1 P
                         WHERE 1 = 1
                         GROUP BY FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD
                       ) SUB
                 GROUP BY FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD, SUB.OUT_QTY, SUB.FORMATION_QTY, SUB.EOH_QTY
               ) AA;

        /* 12.3 재고소진일 / 재고일수(DD) : 원본 TOP-1(ORDER BY 無) -> 결정적 ORDER BY YYYYMMDD ASC FETCH FIRST 1 */
        INSERT INTO GT_PSIGE_DIO3
            ( DIVISION_ID, YYYYMMDD, FROM_SITE, ITEM_ID, CELL_ITEM_ID, FROM_BOH_QTY, TO_BOH_QTY, OUT_QTY, EOH_QTY, OUT_QTY_SUM, INV_YYYYMMDD, DD )
        SELECT P_DIVISION_ID, A.YYYYMMDD, A.FROM_SITE, A.ITEM_ID, A.CELL_ITEM_ID, A.FROM_BOH_QTY, A.TO_BOH_QTY, A.OUT_QTY, A.EOH_QTY, A.OUT_QTY_SUM
             , ( SELECT X.YYYYMMDD
                   FROM GT_PSIGE_DIO2 X
                  WHERE X.FROM_SITE    = A.FROM_SITE
                    AND X.ITEM_ID      = A.ITEM_ID
                    AND X.CELL_ITEM_ID = A.CELL_ITEM_ID
                    AND X.YYYYMMDD     > A.YYYYMMDD
                    AND ( A.OUT_QTY_SUM + A.EOH_QTY + A.FORMATION_QTY ) <= X.OUT_QTY_SUM
                  ORDER BY X.YYYYMMDD FETCH FIRST 1 ROW ONLY ) AS INV_YYYYMMDD
             , ( CASE WHEN A.EOH_QTY = 0.0 AND A.FORMATION_QTY = 0.0 THEN 0.0
                      ELSE NVL( ( ( SELECT TO_DATE(X.YYYYMMDD, 'YYYYMMDD')
                                      FROM GT_PSIGE_DIO2 X
                                     WHERE X.FROM_SITE    = A.FROM_SITE
                                       AND X.ITEM_ID      = A.ITEM_ID
                                       AND X.CELL_ITEM_ID = A.CELL_ITEM_ID
                                       AND X.YYYYMMDD     > A.YYYYMMDD
                                       AND ( A.OUT_QTY_SUM + A.EOH_QTY + A.FORMATION_QTY ) <= X.OUT_QTY_SUM
                                     ORDER BY X.YYYYMMDD FETCH FIRST 1 ROW ONLY ) - TO_DATE(A.YYYYMMDD, 'YYYYMMDD') ), 999 )
                 END ) AS DD
          FROM GT_PSIGE_DIO2 A;


        INSERT INTO GT_PSIGE_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, MEASURE, YYYYMMDD, QTY
            , TRANSPORT_MODE_LINE, ATTRIBUTE1 )
        SELECT P_DIVISION_ID, P_PLAN_START_YYYYMMDD, P_PLAN_TYPE, P_SEQ, Y.OPERATION_GROUP, X.ITEM_ID, X.CELL_ITEM_ID
             , '-', X.TO_BOH_QTY, '-', X.FROM_SITE, X.FROM_BOH_QTY, NULL, 'DIO', X.YYYYMMDD
             , ( CASE WHEN X.DD = 0 THEN 0 ELSE X.DD END ), '-', 'DIO'
          FROM GT_PSIGE_DIO3 X
               INNER JOIN SCP_MST_FINAL_ITEM_V Y
                       ON X.ITEM_ID = Y.ITEM_ID
         WHERE 1 = 1
           AND X.FROM_SITE <> '-';

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 13. 보정 (UI 정렬 조건, 공정코드) */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* ATTRIBUTE9 = FLOW_ID 5자리 (div 82 final item) */
        MERGE INTO GT_PSIGE_TMP X
        USING ( SELECT ITEM_ID, MAX(SUBSTR(FLOW_ID, 1, 5)) AS FLOW5
                  FROM SCP_MST_FINAL_ITEM
                 WHERE DIVISION_ID = '82'
                 GROUP BY ITEM_ID ) Y
           ON ( Y.ITEM_ID = X.ITEM_ID )
        WHEN MATCHED THEN
            UPDATE SET X.ATTRIBUTE9 = Y.FLOW5;

        /* ATTRIBUTE9 = PLANT_ID (OSP from-site) */
        MERGE INTO GT_PSIGE_TMP X
        USING ( SELECT DIVISION_ID, SCM_SITE_ID, MAX(PLANT_ID) AS PLANT_ID
                  FROM SCM_MST_SITE
                 WHERE OSP_YN = 'Y'
                 GROUP BY DIVISION_ID, SCM_SITE_ID ) Y
           ON ( Y.DIVISION_ID = X.DIVISION_ID AND Y.SCM_SITE_ID = X.FROM_SITE )
        WHEN MATCHED THEN
            UPDATE SET X.ATTRIBUTE9 = Y.PLANT_ID;

        /* BALANCE / WH_IN_BALANCE 를 '0' 으로 UPDATE (div 82 PLANT, 외주 제외) */
        INSERT INTO GT_PSIGE_SITEID ( SCM_SITE_ID )
        SELECT SCM_SITE_ID
          FROM SCM_MST_SITE
         WHERE SITE_TYPE = 'PLANT' AND OSP_YN = 'N' AND DIVISION_ID = '82';

        UPDATE GT_PSIGE_TMP X
           SET X.QTY = 0
         WHERE 0 = 0
           AND X.MEASURE         IN ('BALANCE', 'WH_IN_BALANCE')
           AND X.TO_SITE         IN ( SELECT SCM_SITE_ID FROM GT_PSIGE_SITEID )
           AND X.FROM_SITE       IN ( SELECT SCM_SITE_ID FROM GT_PSIGE_SITEID )
           AND X.OPERATION_GROUP = 'A'
           AND X.QTY             > 0.0;

        /* ATTRIBUTE10 정렬코드 */
        UPDATE GT_PSIGE_TMP X SET X.ATTRIBUTE10 = '1' WHERE 0 = 0 AND X.OPERATION_GROUP = 'P';
        UPDATE GT_PSIGE_TMP X SET X.ATTRIBUTE10 = '3' WHERE 0 = 0 AND X.OPERATION_GROUP = 'A' AND X.ATTRIBUTE10 IS NULL;

        /* CONVERT_QTY_CELL UPDATE (OPERATION_GROUP = 'P') : 원본 TOP-1(ORDER BY 無) -> 결정적 FETCH FIRST 1, CEIL */
        UPDATE GT_PSIGE_TMP X
           SET X.CONVERT_QTY_CELL = ( SELECT CEIL(V.ACCUMULATED_CHILD_QTY)
                                        FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V
                                       WHERE V.DIVISION_ID        = X.DIVISION_ID
                                         AND V.OPERATION_GROUP_ID = 'A'
                                         AND V.MODEL_ID           = X.ITEM_ID
                                         AND V.CHILD_ITEM_ID      = X.CELL_ITEM_ID
                                       ORDER BY V.ACCUMULATED_CHILD_QTY FETCH FIRST 1 ROW ONLY )
         WHERE 0 = 0
           AND X.OPERATION_GROUP = 'P';

        /* ----------------------------------------------------------------------------------------------------------- */
        /* PRODUCTION * CELL 환산 수량 (PRODUCTION_CELL) */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIGE_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1, ATTRIBUTE10 )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, 'A', A.CELL_ITEM_ID, A.CELL_ITEM_ID
             , A.FROM_SITE, SUM(A.TO_BOH_QTY), A.INCOTERMS, '-', SUM(A.FROM_BOH_QTY), A.BOD_ID
             , NVL(A.TRANSPORT_MODE_LINE, '-')   /* 원본 CASE TRANSPORT_MODE_LINE WHEN '' THEN '-' (Oracle ''=NULL -> NVL) */
             , 'PRODUCTION_CELL', A.YYYYMMDD, SUM(A.QTY * NVL(A.CONVERT_QTY_CELL, 1)), 'SCP_ANL_PSI_PRODUCTION', '3'
          FROM GT_PSIGE_TMP A
         WHERE 1 = 1
           AND A.MEASURE         = 'PRODUCTION'
           AND A.OPERATION_GROUP = 'P'
           AND A.CELL_ITEM_ID    IS NOT NULL
         GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.CELL_ITEM_ID
                , A.INCOTERMS, A.FROM_SITE, A.BOD_ID
                , NVL(A.TRANSPORT_MODE_LINE, '-'), A.YYYYMMDD;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 0 값 데이터 삭제 (ALLOCATION / BALANCE / MKT_FCST / 외주 WH_IN_BALANCE) */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_PSIGE_TMP WHERE 0 = 0 AND ATTRIBUTE1 = '0';
        DELETE FROM GT_PSIGE_TMP WHERE 0 = 0 AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI' AND MEASURE = 'MKT_FCST';
        DELETE FROM GT_PSIGE_TMP A
         WHERE 0 = 0
           AND A.ATTRIBUTE10 = '3'
           AND A.MEASURE     = 'WH_IN_BALANCE'
           AND EXISTS ( SELECT 1
                          FROM SCM_MST_SITE B
                         WHERE B.SCM_SITE_ID = A.TO_SITE
                           AND A.DIVISION_ID = B.DIVISION_ID
                           AND B.OSP_YN      = 'Y' );

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 활성화코드 분리 대응 : 전구간 0 인 Cell Product 생산관련 measure 삭제 (2023.06.29) */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIGE_DELTGT
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, TOTAL_QTY, QTY_CNT )
        SELECT PG.DIVISION_ID, PG.PLAN_START_YYYYMMDD, PG.PLAN_TYPE, PG.SEQ, PG.OPERATION_GROUP, PG.ITEM_ID, PG.CELL_ITEM_ID
             , PG.TO_SITE, PG.INCOTERMS, PG.FROM_SITE, PG.BOD_ID, PG.TRANSPORT_MODE_LINE, PG.MEASURE
             , NVL(SUM(PG.QTY), 0), COUNT(DISTINCT NVL(PG.QTY, 0))
          FROM GT_PSIGE_TMP PG
               INNER JOIN SCM_MST_SITE FS
                       ON FS.DIVISION_ID     = PG.DIVISION_ID
                      AND FS.SCM_SITE_ID     = PG.FROM_SITE
                      AND FS.OPERATION_GROUP = 'A'
                      AND FS.OSP_YN          = 'N'
               INNER JOIN SCP_MST_FINAL_ITEM FI
                       ON FI.DIVISION_ID = PG.DIVISION_ID
                      AND FI.ITEM_ID     = PG.ITEM_ID
                      AND FI.ATTRIBUTE8  = 'CP'
         WHERE 1 = 1
           AND PG.DIVISION_ID         = P_DIVISION_ID
           AND PG.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND PG.PLAN_TYPE           = P_PLAN_TYPE
           AND PG.SEQ                 = P_SEQ
           AND PG.OPERATION_GROUP     = 'A'
           AND ( NVL(PG.TO_SITE, '-') = '-' OR RTRIM(PG.TO_SITE) IS NULL )
           AND PG.MEASURE IN ('PRODUCTION', 'ACTIVATE_COMPLETED', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS', 'MODEL_INVENTORY', 'DIO')
           AND EXISTS ( SELECT 1
                          FROM SCP_MST_CELL_PROD_ASSY_MAP M
                         WHERE 1 = 1
                           AND M.VALID_YN     = 'Y'
                           AND M.ITEM_ID_PROD = PG.ITEM_ID )
         GROUP BY PG.DIVISION_ID, PG.PLAN_START_YYYYMMDD, PG.PLAN_TYPE, PG.SEQ, PG.OPERATION_GROUP, PG.ITEM_ID, PG.CELL_ITEM_ID
                , PG.TO_SITE, PG.INCOTERMS, PG.FROM_SITE, PG.BOD_ID, PG.TRANSPORT_MODE_LINE, PG.MEASURE
        HAVING NVL(SUM(PG.QTY), 0) = 0
           AND COUNT(DISTINCT NVL(PG.QTY, 0)) = 1;

        DELETE FROM GT_PSIGE_TMP TGT
         WHERE 1 = 1
           AND ( NVL(TGT.TO_SITE, '-') = '-' OR RTRIM(TGT.TO_SITE) IS NULL )
           AND EXISTS ( SELECT 1
                          FROM GT_PSIGE_DELTGT D
                         WHERE 1 = 1
                           AND D.DIVISION_ID         = TGT.DIVISION_ID
                           AND D.PLAN_START_YYYYMMDD = TGT.PLAN_START_YYYYMMDD
                           AND D.PLAN_TYPE           = TGT.PLAN_TYPE
                           AND D.SEQ                 = TGT.SEQ
                           AND D.OPERATION_GROUP     = TGT.OPERATION_GROUP
                           AND D.ITEM_ID             = TGT.ITEM_ID
                           AND D.FROM_SITE           = TGT.FROM_SITE
                           AND D.MEASURE             = TGT.MEASURE
                           AND NVL(D.CELL_ITEM_ID, ' ')        = NVL(TGT.CELL_ITEM_ID, ' ')
                           AND NVL(D.INCOTERMS, ' ')           = NVL(TGT.INCOTERMS, ' ')
                           AND NVL(D.BOD_ID, ' ')              = NVL(TGT.BOD_ID, ' ')
                           AND NVL(D.TRANSPORT_MODE_LINE, ' ') = NVL(TGT.TRANSPORT_MODE_LINE, ' ') );

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 14. SCP_ANL_PSI_GLOBAL_ESS 삭제 */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM SCP_ANL_PSI_GLOBAL_ESS
         WHERE DIVISION_ID         = P_DIVISION_ID
           AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND PLAN_TYPE           = P_PLAN_TYPE
           AND SEQ                 = P_SEQ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 15. SCP_ANL_PSI_GLOBAL_ESS 입력 */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO SCP_ANL_PSI_GLOBAL_ESS
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , CONVERT_QTY_CELL, TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID
            , TRANSPORT_MODE_LINE, MEASURE, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
            , LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE9, ATTRIBUTE10 )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, NVL(A.OPERATION_GROUP, '-'), A.ITEM_ID
             , NVL(A.CELL_ITEM_ID, '-')
             , A.CONVERT_QTY_CELL
             , (CASE WHEN A.OPERATION_GROUP = 'P' THEN '-' ELSE NVL(A.TO_SITE, '-') END)
             , MAX(NVL(A.TO_BOH_QTY, 0))
             , (CASE WHEN A.OPERATION_GROUP = 'P' THEN '-' ELSE NVL(A.INCOTERMS, '-') END)
             , NVL(A.FROM_SITE, '-')
             , A.FROM_BOH_QTY
             , NVL(A.BOD_ID, '-')
             , (CASE WHEN A.OPERATION_GROUP = 'P' THEN '-' ELSE NVL(A.TRANSPORT_MODE_LINE, '-') END)
             , A.MEASURE, A.YYYYMMDD, SUM(NVL(A.QTY, 0))
             , V_BATCH_USER, SYSDATE, V_BATCH_USER, SYSDATE
             , MAX(A.ATTRIBUTE1), A.ATTRIBUTE9, A.ATTRIBUTE10
          FROM GT_PSIGE_TMP A
               LEFT JOIN SCP_MST_FINAL_ITEM F
                      ON F.DIVISION_ID = A.DIVISION_ID
                     AND F.ITEM_ID     = A.ITEM_ID
         WHERE 1 = 1
           AND A.YYYYMMDD < V_PET_DATE
           AND ( A.CELL_ITEM_ID IS NOT NULL OR F.ITEM_CLASS = 'EM0306' )
           AND A.MEASURE <> '-'
         GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, NVL(A.OPERATION_GROUP, '-'), A.ITEM_ID  /* [NVL센티넬소급 2026-08-12] OPERATION_GROUP(적재식 GROUP BY 동반) : DBA_TAB_COLUMNS.NULLABLE='N' 문자컬럼 -> NVL(x,'-') */
                , NVL(A.CELL_ITEM_ID, '-')
                , A.CONVERT_QTY_CELL
                , (CASE WHEN A.OPERATION_GROUP = 'P' THEN '-' ELSE NVL(A.TO_SITE, '-') END)
                , (CASE WHEN A.OPERATION_GROUP = 'P' THEN '-' ELSE NVL(A.INCOTERMS, '-') END)
                , NVL(A.FROM_SITE, '-')  /* [NVL센티넬소급 2026-08-12] FROM_SITE(적재식 GROUP BY 동반) : DBA_TAB_COLUMNS.NULLABLE='N' 문자컬럼 -> NVL(x,'-') */
                , A.FROM_BOH_QTY
                , NVL(A.BOD_ID, '-')
                , (CASE WHEN A.OPERATION_GROUP = 'P' THEN '-' ELSE NVL(A.TRANSPORT_MODE_LINE, '-') END)
                , A.MEASURE, A.YYYYMMDD, A.ATTRIBUTE9, A.ATTRIBUTE10;

        N_LOG_COUNT := SQL%ROWCOUNT;


        DELETE FROM GT_PSIGE_TMP;
        DELETE FROM GT_PSIGE_CELLASSY;
        DELETE FROM GT_PSIGE_CPMI;
        DELETE FROM GT_PSIGE_INT;
        DELETE FROM GT_PSIGE_BOH;
        DELETE FROM GT_PSIGE_Y;
        DELETE FROM GT_PSIGE_DIO1;
        DELETE FROM GT_PSIGE_DIO2;
        DELETE FROM GT_PSIGE_DIO3;
        DELETE FROM GT_PSIGE_SITEID;
        DELETE FROM GT_PSIGE_DELTGT;

        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            /* MSSQL CATCH: 에러 흡수 후 return -1 -> Oracle ROLLBACK + 에러로그 + 흡수 RETURN */
            ROLLBACK;
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := V_PROGRAM_NAME || 'ERROR_LINE : ' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 200);
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);
            RETURN;
    END;

    /* 실행시간(MM:SS) 계산 (임시 운영반영시 주석처리 할 것) */
    V_EXEC_SEC  := ROUND((SYSDATE - V_START_TIME) * 86400);
    V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(V_EXEC_SEC / 60)), 2, '0') || ':' || LPAD(TO_CHAR(MOD(V_EXEC_SEC, 60)), 2, '0');

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '[' || P_MASTER_ID || '][' || P_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);
END;