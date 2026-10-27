PROCEDURE PR_SCP_ANL_PSI_GLOBAL
(
      P_PLAN_CYCLE           IN VARCHAR2
    , P_PLAN_START_YYYYMMDD  IN VARCHAR2      /* plan_name */
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
 * Program ID   : PR_SCP_ANL_PSI_GLOBAL
 * Description  : PR_SCP_ANL_CREATE_DATA 에서 호출함.
 * OutTable     :
 * Execute      :
 *                  DELETE FROM SCM_SYS_LOG_BATCH WHERE PROGRAM_NAME ='PR_SCP_ANL_PSI_GLOBAL' AND CREATED_BY = 'KTH'
 *                  EXEC PR_SCP_ANL_PSI_GLOBAL
 *                     @p_plan_cycle          = 'WEEKLY'
 *                   , @p_plan_start_yyyymmdd = '20180903'
 *                   , @p_plan_id             = '1042'
 *                   , @p_modeling_id         = '2'
 *                   , @p_seq                 = '1'
 *                   , @p_plan_type           = 'SE'
 *                   , @p_master_id           = '81::WEEKLY'
 *                   , @p_division_id         = '81'
 *                   , @p_engine_plan_id      = '1042::SE::1'
 *                   , @p_user_id             = 'KTH'
 *
 *                 SELECT * FROM SCM_SYS_LOG_BATCH  WITH (NOLOCK)  WHERE PROGRAM_NAME ='PR_SCP_ANL_PSI_GLOBAL' AND CREATED_BY = 'KTH'  order by CREATION_DATE desc
 *
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.09.06   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.09.18   KTH         BALANCE, WH_IN MEASURE 로직 변경
 * 2018.11.08   KTH         'MODEL_INVENTORY','ACTIVATE_COMPLETED' 로직 변경, BOH 로직 변경
 * 2018.11.09   YYDOK       FROM BOH, TO BOH UPDATE로직 수정
 * 2018.11.13   YYDOK       WH_IN_BALANCE 추가
 * 2018.11.19   KTH         DIO 추가, Operation_ID(ATTRIBUTE9) 추가
 * 2018.11.29   KTH         CELL_ITEM_ID 컬럼사이즈 변경(50 --> 150), ISSUM  제외 조건 추가
 * 2018.12.05   KTH         ATTRIBUTE9 조건 변경
 * 2018.12.06   KTH         WH_IN_BLANCE 계산로직 변경
 * 2018.12.10   KTH         WH_IN 해상재고 추가
 * 2018.12.11   KTH         BALANCE,WH_IN_BALANCE 로직 변경
 * 2018.12.12   KTH         PACKE SITE CELL 재고 ('MODEL_INVENTORY' 추가) 주석 처리
 * 2018.12.13   KTH         Balance(WH_IN) INTRANSIT 반영('INTRANSIT' 추가)  <-- 진행후 ROLLBACK 함
 * 2018.12.14   KTH         MEASURE 삭제로직 반영
 * 2018.12.17   KTH         MEASURE 삭제로직 수정
 * 2018.12.19   KTH         PACKE SITE CELL 재고 ('MODEL_INVENTORY' 추가) 반영
 * 2019.01.03   KTH         해상재고 반영 (WH_IN) 수정
 * 2019.01.16   KTH         TEMPDB TABLE DROP 로직 추가, DIO 로직 변경
 * 2019.06.18   KTH         82추가(FROM_SITE NULL 오류 수정)
 * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2021.07.16   sclee       PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) : scp_mst_bod_v에서 scp_mst_bod_n_v로 변경
 * 2021.10.12   KSW         PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용
 * 2021.11.04   KSW         전진검사 BOH 추가 --> PI 에서 더 이상 진행하지 않으므로 주석처리
 * 2021.11.11   sclee.lee   튜닝개선안에 따른 일부 쿼리 변경 및 집계시 Pegging 물량 포함하도록 변경
 * 2022.03.15   hrkim       PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : SAFETY_STOCK measure 추가
 * 2022.03.23   KSW         GM JV 반영 :: 81_UC  추가
 * 2023.03.29   hrkim       PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2023.06.08   hrkim       PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *                            1. 대표 Cell Item Id : Cell Product 기준으로 Update
 * 2023.06.20   hrkim       PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *                            2. Cell Product의 Model Inventory를 Cell Assy기준으로 합산
 *                                - Pack창고 Cell 재고는 제외 (attribute1 != 'CELL')
 *                                - From Site가 국내인 경우만 (company_id = 'C100' - 7월 임시조건)
 * 2023.06.26   hrkim       PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *                            3. Cell 창고의 Cell Product를 Cell Assy 재고로 치환
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
 * 2025.08.29   YMH         CSR E20250829-001508 실행계획개선 (속도개선)
 * 2026.05.22   ymh         E20260331-000738 82사업부 MA Plan 수행 시 속도지연
 * 2026.07.06   ZIONEX      [PJ202650304]  NextSCM Migration
 * 2026.10.27    ZIONEX      [PJ202650304] 티라엔진 제거 - SCP_PLN_SALES_ONHAND -> 통합 Dataset 기반 뷰(SCP_PLN_SALES_ONHAND_V) 교체
 */
AS
    V_BATCH_USER    VARCHAR2(150 CHAR);
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_SCP_ANL_PSI_GLOBAL';
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    V_TABLE_ID      VARCHAR2(150 CHAR) := 'PR_SCP_ANL_PSI_GLOBAL';
    D_EVENT_DATE    DATE;
    V_START_TIME    DATE;
    V_EXEC_TIME     VARCHAR2(10 CHAR) := '';
    V_PET_DATE      VARCHAR2(12 CHAR) := '';
    V_DEL_CNT       NUMBER := 0;
BEGIN
    V_BATCH_USER := P_USER_ID;

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME||':'||' PR_SCP_ANL_PSI_GLOBAL INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

    V_START_TIME := SYSDATE;

    /* Plan End Date +1 (중장기 플랜 대응) */
    BEGIN
        SELECT P.HORIZON_END_DATE INTO V_PET_DATE
          FROM SCM_MST_PLAN P WHERE P.DIVISION_ID = P_DIVISION_ID AND P.PLAN_ID = P_PLAN_ID;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_PET_DATE := NULL;
    END;
    IF V_PET_DATE IS NOT NULL AND LENGTH(TRIM(V_PET_DATE)) = 8 THEN
        V_PET_DATE := TO_CHAR(TO_DATE(V_PET_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD');
    ELSE
        V_PET_DATE := NULL;
    END IF;

    BEGIN
        DELETE FROM GT_PSIG_TMP;
        DELETE FROM GT_PSIG_CELLASSY;
        DELETE FROM GT_PSIG_CPMI;
        DELETE FROM GT_PSIG_INT;
        DELETE FROM GT_PSIG_BOH;
        DELETE FROM GT_PSIG_Y;
        DELETE FROM GT_PSIG_DIO1;
        DELETE FROM GT_PSIG_DIO2;
        DELETE FROM GT_PSIG_DIO3;
        DELETE FROM GT_PSIG_SITEID;
        DELETE FROM GT_PSIG_DELTGT;
        DELETE FROM GT_PSIG_SS;

        /* -------------------------------------------------------------------------------- */
        /* 1. SEMI 입력 (TO SITE TRANSPORT_MODE) */
        /* -------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIG_TMP
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
           AND A.MEASURE             IN ('SHIP_PLAN','SHIP_REQ');

        /* -------------------------------------------------------------------------------- */
        /* 2. PSI 입력 (MODEL_INVENTORY/ACTIVATE_PROGRESS/CHAR_AVAILABLE/ACTIVATE_COMPLETED/PRODUCTION) + ATTRIBUTE9(MEB) */
        /* -------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIG_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1, ATTRIBUTE9 )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP, A.ITEM_ID, NULL
             , A.TO_SITE, NULL, NULL, A.FROM_SITE, NULL, NULL
             , (CASE WHEN A.PSI_TYPE = 'P' THEN A.PSI_VALUE ELSE NULL END)
             , (CASE WHEN A.PSI_TYPE = 'P' THEN 'PRODUCTION'
                     WHEN A.PSI_TYPE = 'I' AND A.PSI_VALUE IN ('ACTIVATE_PROGRESS','CHAR_AVAILABLE','MODEL_INVENTORY','ACTIVATE_COMPLETED') THEN A.PSI_VALUE
                ELSE '-' END)
             , A.YYYYMMDD, SUM(A.QTY), 'SCP_ANL_PSI_PRODUCTION', A.ATTRIBUTE9
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
                        WHEN A.PSI_TYPE = 'I' AND A.PSI_VALUE IN ('ACTIVATE_PROGRESS','CHAR_AVAILABLE','MODEL_INVENTORY','ACTIVATE_COMPLETED') THEN A.PSI_VALUE
                   ELSE '-' END)
                , A.YYYYMMDD, A.ATTRIBUTE9;

        /* -------------------------------------------------------------------------------- */
        /* 3. FG 입력 (FROM SITE TRANSPORT_MODE) */
        /* -------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIG_TMP
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

        /* -------------------------------------------------------------------------------- */
        /* 4. SEMI 추가 로직 : WH_IN (SHIPMENT_PLAN_PEGGING.ALLOCATION_QTY + SHIPMENT_PLAN LEFT JOIN) */
        /* -------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIG_TMP
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
                     , TO_CHAR(B.END_TIME,'YYYYMMDD') AS YYYYMMDD, A.ALLOCATION_QTY AS QTY
                  FROM SCP_PLN_SHIPMENT_PLAN_PEGGING A
                       LEFT OUTER JOIN SCP_PLN_SHIPMENT_PLAN B
                              ON 0 = 0
                             AND A.DIVISION_ID         = B.DIVISION_ID
                             AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                             AND A.PLAN_TYPE           = B.PLAN_TYPE
                             AND A.SEQ                 = B.SEQ
                             AND A.ORDER_ID            = B.ORDER_ID
                             AND A.DIVISION_ID         = P_DIVISION_ID
                             AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                             AND A.PLAN_TYPE           = P_PLAN_TYPE
                             AND A.SEQ                 = P_SEQ
                             AND B.MEASURE             = 'SHIP_PLAN'
                             AND B.SEMI_YN             = 'Y'
                 WHERE 1 = 1
                   AND A.DIVISION_ID         = P_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE           = P_PLAN_TYPE
                   AND A.SEQ                 = P_SEQ
                   AND B.DIVISION_ID         IS NOT NULL
               ) X
         GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, TO_SITE, INCOTERMS
                , FROM_SITE, TRANSPORT_MODE_LINE, MEASURE, YYYYMMDD;

        /* -------------------------------------------------------------------------------- */
        /* 5. PACK SITE CELL 재고 'MODEL_INVENTORY' 추가 (정렬 ATTRIBUTE10='2') */
        /* -------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIG_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1, ATTRIBUTE10 )
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, 'A', ITEM_ID, ITEM_ID
             , '-', NULL, '-', SITE_ID, NULL, '-', NULL
             , 'MODEL_INVENTORY', YYYYMMDD, NVL(PSI_EOH_QTY,0), 'CELL', '2'
          FROM SCP_PLN_PLANT_ONHAND
         WHERE DIVISION_ID         = P_DIVISION_ID
           AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND PLAN_TYPE           = P_PLAN_TYPE
           AND SEQ                 = P_SEQ
           AND OPERATION_GROUP     = 'A'
           AND SITE_ID             LIKE '%-P'
           AND STOCK_TYPE          = 'A_PACK';

        /* -------------------------------------------------------------------------------- */
        /* 6. Cell Product Model Inventory -> Cell Assy 변환 합산 (2023.06.20 활성화코드 분리) */
        /* -------------------------------------------------------------------------------- */
        /* 6.0 Cell Product 기준 Cell Assy 정보 추출(3단계 우선순위) */
        INSERT INTO GT_PSIG_CELLASSY
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
        INSERT INTO GT_PSIG_CPMI
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE9, ATTRIBUTE10, PLANT_ID, CELL_ASSY )
        SELECT PG.DIVISION_ID, PG.PLAN_START_YYYYMMDD, PG.PLAN_TYPE, PG.SEQ, PG.OPERATION_GROUP, PG.ITEM_ID, PG.CELL_ITEM_ID
             , PG.TO_SITE, PG.TO_BOH_QTY, PG.INCOTERMS, PG.FROM_SITE, PG.FROM_BOH_QTY, PG.BOD_ID, PG.TRANSPORT_MODE_LINE
             , PG.MEASURE, PG.YYYYMMDD, PG.QTY, PG.ATTRIBUTE1, PG.ATTRIBUTE2, PG.ATTRIBUTE9, PG.ATTRIBUTE10
             , FS.PLANT_ID
             , NVL(NVL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), CA3.ITEM_ID_ASSY) AS CELL_ASSY
          FROM GT_PSIG_TMP PG
               INNER JOIN SCP_MST_FINAL_ITEM_V FI
                       ON FI.ITEM_ID = PG.ITEM_ID
                      AND FI.CELL_TYPE = 'CP'
               INNER JOIN SCM_MST_SITE FS
                       ON FS.DIVISION_ID     = PG.DIVISION_ID
                      AND FS.SCM_SITE_ID     = PG.FROM_SITE
                      AND FS.SITE_TYPE       = 'PLANT'
                      AND FS.OPERATION_GROUP = 'A'
                      AND FS.OSP_YN          = 'N'
                LEFT JOIN GT_PSIG_CELLASSY CA1
                       ON CA1.DIVISION_ID  = PG.DIVISION_ID
                      AND CA1.ITEM_ID_PROD = PG.ITEM_ID
                      AND CA1.PLANT_ID     = FS.PLANT_ID
                      AND CA1.PRIORITY_1ST = 1
                LEFT JOIN GT_PSIG_CELLASSY CA2
                       ON CA2.DIVISION_ID  = PG.DIVISION_ID
                      AND CA2.ITEM_ID_PROD = PG.ITEM_ID
                      AND CA2.PRIORITY_2ND = 1
                LEFT JOIN GT_PSIG_CELLASSY CA3
                       ON CA3.ITEM_ID_PROD = PG.ITEM_ID
                      AND CA3.PRIORITY_3RD = 1
         WHERE 1 = 1
           AND PG.OPERATION_GROUP = 'A'
           AND PG.MEASURE         = 'MODEL_INVENTORY';

        /* 6.2 Cell Product Model Inventory 데이터 삭제 */
        DELETE FROM GT_PSIG_TMP X
         WHERE 1 = 1
           AND X.MEASURE = 'MODEL_INVENTORY'
           AND EXISTS ( SELECT 1
                          FROM GT_PSIG_CPMI TGT
                         WHERE 1 = 1
                           AND TGT.CELL_ASSY IS NOT NULL
                           AND TGT.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD
                           AND TGT.PLAN_TYPE           = X.PLAN_TYPE
                           AND TGT.SEQ                 = X.SEQ
                           AND TGT.DIVISION_ID         = X.DIVISION_ID
                           AND TGT.OPERATION_GROUP     = X.OPERATION_GROUP
                           AND TGT.ITEM_ID             = X.ITEM_ID
                           AND TGT.FROM_SITE           = X.FROM_SITE
                           AND TGT.MEASURE             = X.MEASURE
                           AND TGT.YYYYMMDD            = X.YYYYMMDD );

        /* 6.3 Cell Product Model Inventory 대상 데이터 Cell Assy에 합산 적용 (UPDATE / INSERT) */
        MERGE INTO GT_PSIG_TMP TGT
        USING ( SELECT PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, DIVISION_ID, OPERATION_GROUP
                     , CELL_ASSY AS ITEM_ID, CAST(NULL AS VARCHAR2(150 CHAR)) AS CELL_ITEM_ID
                     , TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMMDD
                     , SUM(QTY) AS QTY, SUM(FROM_BOH_QTY) AS FROM_BOH_QTY, SUM(TO_BOH_QTY) AS TO_BOH_QTY
                     , MAX(ATTRIBUTE1) AS ATTRIBUTE1, MAX(ATTRIBUTE2) AS ATTRIBUTE2
                     , MAX(ATTRIBUTE9) AS ATTRIBUTE9, MAX(ATTRIBUTE10) AS ATTRIBUTE10
                  FROM GT_PSIG_CPMI
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
                     , TGT.ATTRIBUTE2   = 'UPDATE :: '||TO_CHAR(TGT.QTY)||' :: '||TO_CHAR(SRC.QTY)
        WHEN NOT MATCHED THEN
            INSERT ( PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, DIVISION_ID, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
                   , TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMMDD
                   , QTY, FROM_BOH_QTY, TO_BOH_QTY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE9, ATTRIBUTE10 )
            VALUES ( SRC.PLAN_START_YYYYMMDD, SRC.PLAN_TYPE, SRC.SEQ, SRC.DIVISION_ID, SRC.OPERATION_GROUP, SRC.ITEM_ID, SRC.CELL_ITEM_ID
                   , SRC.TO_SITE, SRC.INCOTERMS, SRC.FROM_SITE, SRC.BOD_ID, SRC.TRANSPORT_MODE_LINE, SRC.MEASURE, SRC.YYYYMMDD
                   , SRC.QTY, SRC.FROM_BOH_QTY, SRC.TO_BOH_QTY, SRC.ATTRIBUTE1, 'INSERT', SRC.ATTRIBUTE9, SRC.ATTRIBUTE10 );

        /* -------------------------------------------------------------------------------- */
        /* 8. 해상재고 반영 (WH_IN) -- TH_ENG_STOCK_PLAN_SN, FN_CHARINDEX_REV */
        /* -------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIG_INT
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1 )
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
             , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
             , MEASURE, YYYYMMDD, SUM(QTY), ATTRIBUTE1
          FROM (
                SELECT P_DIVISION_ID AS DIVISION_ID, P_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                     , P_PLAN_TYPE AS PLAN_TYPE, P_SEQ AS SEQ, C.OPERATION_GROUP, A.ITEM_ID, NULL AS CELL_ITEM_ID
                     , SUBSTR(A.SITE_ID, 1, FN_CHARINDEX_REV(A.SITE_ID, '~', 0)-1) AS TO_SITE
                     , NULL AS TO_BOH_QTY, NULL AS INCOTERMS
                     , SUBSTR(A.LOT_ID, FN_CHARINDEX_REV(A.LOT_ID, '::', 0)+2, 100) AS FROM_SITE
                     , NULL AS FROM_BOH_QTY, NULL AS BOD_ID, NULL AS TRANSPORT_MODE_LINE
                     , 'WH_IN' AS MEASURE, TO_CHAR(A.RECEIVING_DTTM,'YYYYMMDD') AS YYYYMMDD
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

        /* 8.1 기존 SEMI WH_IN 행에 해상재고 가산 (상관 UPDATE + EXISTS 가드) */
        UPDATE GT_PSIG_TMP X
           SET X.QTY = NVL(X.QTY,0) + NVL( ( SELECT Y.QTY FROM GT_PSIG_INT Y
                                              WHERE Y.ITEM_ID   = X.ITEM_ID
                                                AND Y.TO_SITE   = X.TO_SITE
                                                AND Y.FROM_SITE = X.FROM_SITE
                                                AND Y.YYYYMMDD  = X.YYYYMMDD
                                                AND Y.MEASURE   = X.MEASURE ), 0 )
         WHERE X.MEASURE = 'WH_IN'
           AND X.ATTRIBUTE1 = 'WH_IN'
           AND EXISTS ( SELECT 1 FROM GT_PSIG_INT Y
                         WHERE Y.ITEM_ID   = X.ITEM_ID
                           AND Y.TO_SITE   = X.TO_SITE
                           AND Y.FROM_SITE = X.FROM_SITE
                           AND Y.YYYYMMDD  = X.YYYYMMDD
                           AND Y.MEASURE   = X.MEASURE );

        /* 8.2 매칭 WH_IN 행이 없는 해상재고는 신규 INSERT */
        MERGE INTO GT_PSIG_TMP X
        USING GT_PSIG_INT Y
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

        /* -------------------------------------------------------------------------------- */
        /* 7. MKT_FCST / WH_IN 0 채워 넣기 (calendar CROSS JOIN + NOT EXISTS) */
        /* -------------------------------------------------------------------------------- */
        /* 7.1 MKT_FCST 0채움 (SEMI 키 기준) */
        INSERT INTO GT_PSIG_TMP
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
                           FROM GT_PSIG_TMP X
                          WHERE 1 = 1
                            AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI' ) B
               ) SUB
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1
                              FROM GT_PSIG_TMP Z
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
        INSERT INTO GT_PSIG_TMP
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
                           FROM GT_PSIG_TMP X
                          WHERE 1 = 1
                            AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                            AND MEASURE    = 'WH_IN' ) B
               ) SUB
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1
                              FROM GT_PSIG_TMP Z
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


        INSERT INTO GT_PSIG_TMP
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
                           FROM GT_PSIG_TMP X
                          WHERE 1 = 1
                            AND ATTRIBUTE1 = 'WH_IN'
                            AND MEASURE    = 'WH_IN' ) B
               ) SUB
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1
                              FROM GT_PSIG_TMP Z
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

        /* -------------------------------------------------------------------------------- */
        /* 9. BOH / WH_IN_BALANCE / CELL_ITEM_ID (+ MEB biz) */
        /* -------------------------------------------------------------------------------- */
        /* 9.1+9.2 SALES_ONHAND UNION PLANT_ONHAND(Cell창고 Cell Product -> Cell Assy 치환) */
        INSERT INTO GT_PSIG_BOH
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
                     , NVL(SUM(PO.PSI_BOH_QTY),0) AS PSI_BOH_QTY
                  FROM SCP_PLN_PLANT_ONHAND PO
                       INNER JOIN SCM_MST_SITE FS
                               ON FS.DIVISION_ID = PO.DIVISION_ID
                              AND FS.SCM_SITE_ID = PO.SITE_ID
                        LEFT JOIN GT_PSIG_CELLASSY CA1
                               ON CA1.DIVISION_ID  = PO.DIVISION_ID
                              AND CA1.ITEM_ID_PROD = PO.ITEM_ID
                              AND CA1.PLANT_ID     = FS.PLANT_ID
                              AND CA1.PRIORITY_1ST = 1
                        LEFT JOIN GT_PSIG_CELLASSY CA2
                               ON CA2.DIVISION_ID  = PO.DIVISION_ID
                              AND CA2.ITEM_ID_PROD = PO.ITEM_ID
                              AND CA2.PRIORITY_2ND = 1
                        LEFT JOIN GT_PSIG_CELLASSY CA3
                               ON CA3.ITEM_ID_PROD = PO.ITEM_ID
                              AND CA3.PRIORITY_3RD = 1
                 WHERE PO.DIVISION_ID         = P_DIVISION_ID
                   AND PO.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND PO.PLAN_TYPE           = P_PLAN_TYPE
                   AND PO.SEQ                 = P_SEQ
                   AND PO.YYYYMMDD            = PO.PLAN_START_YYYYMMDD
                   AND PO.STOCK_TYPE          NOT IN ('ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING')
                 GROUP BY PO.DIVISION_ID, PO.PLAN_START_YYYYMMDD, PO.PLAN_TYPE, PO.SEQ, PO.SITE_ID
                        , CASE WHEN FS.OPERATION_GROUP = 'A' AND FS.SITE_TYPE = 'PLANT' AND FS.OSP_YN = 'N'
                                    AND (CA1.ITEM_ID_ASSY IS NOT NULL OR CA2.ITEM_ID_ASSY IS NOT NULL OR CA3.ITEM_ID_ASSY IS NOT NULL)
                               THEN NVL(NVL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), CA3.ITEM_ID_ASSY)
                               ELSE PO.ITEM_ID
                          END
               ) X;

        /* 9.3 WH_IN_BALANCE 기준행(#Y) 추출 */
        INSERT INTO GT_PSIG_Y
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, INCOTERMS, YYYYMMDD, TO_BOH_QTY, FROM_BOH_QTY, FROM_SITE )
        SELECT DISTINCT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
             , TO_SITE, INCOTERMS, YYYYMMDD, TO_BOH_QTY, FROM_BOH_QTY, MIN(FROM_SITE) AS FROM_SITE
          FROM GT_PSIG_TMP
         WHERE 1 = 1
           AND MEASURE    IN ('MKT_FCST','WH_IN')
           AND ATTRIBUTE1 <> 'WH_IN'
         GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
                , TO_SITE, INCOTERMS, YYYYMMDD, TO_BOH_QTY, FROM_BOH_QTY;

        /* 9.3 WH_IN_BALANCE 입력 (to site BOH + 누적 Fcst*(-1) + 누적 WH_IN) */
        INSERT INTO GT_PSIG_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1 )
        SELECT Y.DIVISION_ID, Y.PLAN_START_YYYYMMDD, Y.PLAN_TYPE, Y.SEQ, Y.OPERATION_GROUP, Y.ITEM_ID, Y.CELL_ITEM_ID
             , Y.TO_SITE, Y.TO_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE, Y.FROM_BOH_QTY, '-', NULL
             , 'WH_IN_BALANCE', Y.YYYYMMDD
             , ( SELECT NVL( SUM( CASE MEASURE WHEN 'MKT_FCST' THEN -1 * NVL(QTY,0)
                                               WHEN 'WH_IN'    THEN      NVL(QTY,0)
                                          ELSE 0.0 END ), 0 )
                   FROM GT_PSIG_TMP X
                  WHERE 1 = 1
                    AND X.DIVISION_ID         = Y.DIVISION_ID
                    AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD
                    AND X.PLAN_TYPE           = Y.PLAN_TYPE
                    AND X.SEQ                 = Y.SEQ
                    AND X.ITEM_ID             = Y.ITEM_ID
                    AND X.TO_SITE             = Y.TO_SITE
                    AND X.INCOTERMS           = Y.INCOTERMS
                    AND X.MEASURE             IN ('MKT_FCST','WH_IN')
                    AND X.YYYYMMDD            <= Y.YYYYMMDD
               ) + NVL(BOH.PSI_BOH_QTY,0)
             , NULL
          FROM GT_PSIG_Y Y
               LEFT OUTER JOIN GT_PSIG_BOH BOH
                            ON Y.DIVISION_ID         = BOH.DIVISION_ID
                           AND Y.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD
                           AND Y.PLAN_TYPE           = BOH.PLAN_TYPE
                           AND Y.SEQ                 = BOH.SEQ
                           AND Y.TO_SITE             = BOH.SITE_ID
                           AND Y.ITEM_ID             = BOH.ITEM_ID
         WHERE 1 = 1;

        /* 9.4 FROM_BOH_QTY 계산 (MERGE, 다중매칭 결정적 MAX) */
        MERGE INTO GT_PSIG_TMP X
        USING ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SITE_ID, ITEM_ID, MAX(PSI_BOH_QTY) AS PSI_BOH_QTY
                  FROM GT_PSIG_BOH
                 GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SITE_ID, ITEM_ID ) BOH
           ON (    X.DIVISION_ID         = BOH.DIVISION_ID
               AND X.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD
               AND X.PLAN_TYPE           = BOH.PLAN_TYPE
               AND X.SEQ                 = BOH.SEQ
               AND X.FROM_SITE           = BOH.SITE_ID
               AND X.ITEM_ID             = BOH.ITEM_ID )
        WHEN MATCHED THEN
            UPDATE SET X.FROM_BOH_QTY = NVL(BOH.PSI_BOH_QTY,0);

        /* 9.4 TO_BOH_QTY 계산 */
        MERGE INTO GT_PSIG_TMP X
        USING ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SITE_ID, ITEM_ID, MAX(PSI_BOH_QTY) AS PSI_BOH_QTY
                  FROM GT_PSIG_BOH
                 GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SITE_ID, ITEM_ID ) BOH
           ON (    X.DIVISION_ID         = BOH.DIVISION_ID
               AND X.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD
               AND X.PLAN_TYPE           = BOH.PLAN_TYPE
               AND X.SEQ                 = BOH.SEQ
               AND X.TO_SITE             = BOH.SITE_ID
               AND X.ITEM_ID             = BOH.ITEM_ID )
        WHEN MATCHED THEN
            UPDATE SET X.TO_BOH_QTY = NVL(BOH.PSI_BOH_QTY,0);

        /* 9.5 CELL_ITEM_ID UPDATE : PACK(OG='P') = MODEL_FINAL_ITEM_BOM_V MIN(CHILD) */
        MERGE INTO GT_PSIG_TMP X
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

        /* 9.5 CELL_ITEM_ID UPDATE : CELL(OG='A') = CP_INFO 3단계 ISNULL 체인 (ROWID MERGE, 다중매칭 MAX) */
        MERGE INTO GT_PSIG_TMP T
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
                SELECT RID, MAX(CELL_VAL) AS CELL_VAL FROM (
                    SELECT X.ROWID AS RID
                         , CASE WHEN F.CELL_TYPE LIKE 'CA%'
                                THEN NVL(NVL(NVL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD), C3.ITEM_ID_PROD), X.ITEM_ID)
                                ELSE X.ITEM_ID
                           END AS CELL_VAL
                      FROM GT_PSIG_TMP X
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

        /* 9.5 MEB biz : ATTRIBUTE9='P5200' 모듈 -> Cell Item 변환 (bom_sn_V + item_sn, ROWID 불필요 MODULE_ID MERGE MAX) */
        MERGE INTO GT_PSIG_TMP X
        USING ( SELECT MODULE_ID, MAX(CELL_ITEM_ID) AS CELL_ITEM_ID
                  FROM (
                        SELECT DISTINCT Z.MODEL_ID AS ITEM_ID, Z.CHILD_ITEM_ID AS CELL_ITEM_ID
                             , Z.ACCUMULATED_CHILD_QTY AS CELL_QTY_PACK, Y.MODULE_ID, Y.MODULE_QTY_PACK
                          FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Z
                             , ( SELECT X.DIVISION_ID, X.MODEL_ID, X.CHILD_ITEM_ID AS MODULE_ID, X.CHILD_QTY AS MODULE_QTY_PACK
                                   FROM SCM_MST_BOM_SN_V X
                                        INNER JOIN SCM_MST_ITEM_SN I
                                                ON X.CHILD_DIVISION_ID = I.DIVISION_ID
                                               AND X.CHILD_ITEM_ID     = I.ITEM_ID
                                               AND I.FLOW_ID            = 'P5200'
                                               AND X.CHILD_COMPANY_ID   = I.COMPANY_ID
                                               AND X.CHILD_SITE_ID      = I.SITE_ID
                                               AND I.ACTIVE_FLAG        = 'Y'
                                               AND X.DIVISION_ID        = P_DIVISION_ID
                                  WHERE 1 = 1 ) Y
                         WHERE Z.DIVISION_ID        = Y.DIVISION_ID
                           AND Z.MODEL_ID           = Y.MODEL_ID
                           AND Z.CELL_TYPE          = 'CP'
                           AND Z.OPERATION_GROUP_ID = 'A'
                           AND Z.DIVISION_ID        = P_DIVISION_ID
                       )
                 GROUP BY MODULE_ID ) Z
           ON ( X.ITEM_ID = Z.MODULE_ID AND X.ATTRIBUTE9 = 'P5200' )
        WHEN MATCHED THEN
            UPDATE SET X.CELL_ITEM_ID = Z.CELL_ITEM_ID;

        /* -------------------------------------------------------------------------------- */
        /* 10. ALLOCATION / BALANCE / WH_IN_BALANCE 0 채워 넣기 */
        /* -------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIG_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, MEASURE, YYYYMMDD, QTY
            , TRANSPORT_MODE_LINE, ATTRIBUTE1 )
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
             , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, 'ALLOCATION', YYYYMMDD, 0
             , TRANSPORT_MODE_LINE, '0'
          FROM GT_PSIG_TMP
         WHERE 1 = 1
           AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
           AND MEASURE    = 'MKT_FCST'
           AND TO_SITE    <> '-'
        UNION ALL
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
             , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, 'BALANCE', YYYYMMDD, 0
             , TRANSPORT_MODE_LINE, '0'
          FROM GT_PSIG_TMP
         WHERE 1 = 1
           AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
           AND MEASURE    = 'MKT_FCST'
           AND TO_SITE    <> '-'
        UNION ALL
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
             , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, 'WH_IN_BALANCE', YYYYMMDD, 0
             , TRANSPORT_MODE_LINE, NULL
          FROM GT_PSIG_TMP
         WHERE 1 = 1
           AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
           AND MEASURE    = 'MKT_FCST'
           AND TO_SITE    <> '-';

        /* -------------------------------------------------------------------------------- */
        /* 11. TRANSPORT_MODE_LINE UPDATE (scp_mst_bod_n_v) + 생산제외 DELETE */
        /* -------------------------------------------------------------------------------- */
        MERGE INTO GT_PSIG_TMP X
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

        DELETE FROM GT_PSIG_TMP
         WHERE MEASURE IN ('MKT_FCST','ALLOCATION','BALANCE','WH_IN_BALANCE') AND TO_SITE = '-';

        /* -------------------------------------------------------------------------------- */
        /* 12. DIO 생성 */
        /* -------------------------------------------------------------------------------- */
        /* 12.1 DIO 원천 (OUT_QTY=SHIP_PLAN, FORMATION_QTY=ACTIVATE_PROGRESS, EOH_QTY=MODEL_INVENTORY) */
        INSERT INTO GT_PSIG_DIO1
            ( DIVISION_ID, FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD, FROM_BOH_QTY, TO_BOH_QTY, OUT_QTY, FORMATION_QTY, EOH_QTY, INV_DAY )
        SELECT DIVISION_ID, NVL(FROM_SITE,' '), ITEM_ID, CELL_ITEM_ID, YYYYMMDD
             , MAX(FROM_BOH_QTY), MAX(TO_BOH_QTY)
             , SUM( CASE MEASURE WHEN 'SHIP_PLAN'         THEN ROUND(QTY,1) ELSE 0 END )
             , SUM( CASE MEASURE WHEN 'ACTIVATE_PROGRESS' THEN ROUND(QTY,1) ELSE 0 END )
             , SUM( CASE MEASURE WHEN 'MODEL_INVENTORY'   THEN ROUND(QTY,1) ELSE 0 END ), 0
          FROM GT_PSIG_TMP P
         WHERE 1 = 1
           AND ATTRIBUTE1 <> 'CELL'
           AND FROM_SITE  <> '-'
         GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD;

        /* 12.2 누적합/전일누적합 (#Tbl_DIO) */
        INSERT INTO GT_PSIG_DIO2
            ( YYYYMMDD, FROM_SITE, ITEM_ID, CELL_ITEM_ID, FROM_BOH_QTY, TO_BOH_QTY, OUT_QTY, FORMATION_QTY, EOH_QTY, OUT_QTY_SUM, LAG_OUT_QTY_SUM )
        SELECT YYYYMMDD, FROM_SITE, ITEM_ID, CELL_ITEM_ID, FROM_BOH_QTY, TO_BOH_QTY, OUT_QTY, FORMATION_QTY, EOH_QTY, OUT_QTY_SUM
             , LAG( CASE WHEN OUT_QTY_SUM < 0 THEN 0 ELSE OUT_QTY_SUM END, 1, 0 ) OVER ( PARTITION BY FROM_SITE, ITEM_ID, CELL_ITEM_ID ORDER BY YYYYMMDD )
          FROM (
                SELECT FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD
                     , MAX(FROM_BOH_QTY) AS FROM_BOH_QTY, MAX(TO_BOH_QTY) AS TO_BOH_QTY
                     , SUM( CASE WHEN OUT_QTY < 0 THEN 0 ELSE OUT_QTY END ) AS OUT_QTY
                     , SUM( CASE WHEN FORMATION_QTY < 0 THEN 0 ELSE FORMATION_QTY END ) AS FORMATION_QTY
                     , SUM( CASE WHEN EOH_QTY < 0 THEN 0 ELSE EOH_QTY END ) AS EOH_QTY
                     , ROUND( SUM( CASE WHEN OUT_QTY < 0 THEN 0 ELSE OUT_QTY END ) OVER ( PARTITION BY FROM_SITE, ITEM_ID ORDER BY FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD ), 2 ) AS OUT_QTY_SUM
                  FROM (
                        SELECT FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD
                             , MAX(FROM_BOH_QTY) AS FROM_BOH_QTY, MAX(TO_BOH_QTY) AS TO_BOH_QTY
                             , SUM(OUT_QTY) AS OUT_QTY, SUM(FORMATION_QTY) AS FORMATION_QTY, SUM(EOH_QTY) AS EOH_QTY
                          FROM GT_PSIG_DIO1 P
                         WHERE 1 = 1
                         GROUP BY FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD
                       ) SUB
                 GROUP BY FROM_SITE, ITEM_ID, CELL_ITEM_ID, YYYYMMDD, SUB.OUT_QTY, SUB.FORMATION_QTY, SUB.EOH_QTY
               ) AA;

        /* 12.3 재고소진일/재고일수(DD)  ★D1: ORDER BY YYYYMMDD ASC FETCH FIRST 1. */
        INSERT INTO GT_PSIG_DIO3
            ( DIVISION_ID, YYYYMMDD, FROM_SITE, ITEM_ID, CELL_ITEM_ID, FROM_BOH_QTY, TO_BOH_QTY, OUT_QTY, EOH_QTY, OUT_QTY_SUM, INV_YYYYMMDD, DD )
        SELECT P_DIVISION_ID, A.YYYYMMDD, A.FROM_SITE, A.ITEM_ID, A.CELL_ITEM_ID, A.FROM_BOH_QTY, A.TO_BOH_QTY, A.OUT_QTY, A.EOH_QTY, A.OUT_QTY_SUM
             , ( SELECT X.YYYYMMDD FROM GT_PSIG_DIO2 X
                  WHERE X.FROM_SITE    = A.FROM_SITE
                    AND X.ITEM_ID      = A.ITEM_ID
                    AND X.CELL_ITEM_ID = A.CELL_ITEM_ID
                    AND X.YYYYMMDD     > A.YYYYMMDD
                    AND ( A.OUT_QTY_SUM + A.EOH_QTY + A.FORMATION_QTY ) <= X.OUT_QTY_SUM
                  ORDER BY X.YYYYMMDD FETCH FIRST 1 ROW ONLY ) AS INV_YYYYMMDD
             , ( CASE WHEN A.EOH_QTY = 0.0 AND A.FORMATION_QTY = 0.0 THEN 0.0
                      ELSE NVL( ( ( SELECT TO_DATE(X.YYYYMMDD,'YYYYMMDD') FROM GT_PSIG_DIO2 X
                                     WHERE X.FROM_SITE    = A.FROM_SITE
                                       AND X.ITEM_ID      = A.ITEM_ID
                                       AND X.CELL_ITEM_ID = A.CELL_ITEM_ID
                                       AND X.YYYYMMDD     > A.YYYYMMDD
                                       AND ( A.OUT_QTY_SUM + A.EOH_QTY + A.FORMATION_QTY ) <= X.OUT_QTY_SUM
                                     ORDER BY X.YYYYMMDD FETCH FIRST 1 ROW ONLY ) - TO_DATE(A.YYYYMMDD,'YYYYMMDD') ), 999 )
                 END ) AS DD
          FROM GT_PSIG_DIO2 A;


        INSERT INTO GT_PSIG_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, MEASURE, YYYYMMDD, QTY
            , TRANSPORT_MODE_LINE, ATTRIBUTE1 )
        SELECT P_DIVISION_ID, P_PLAN_START_YYYYMMDD, P_PLAN_TYPE, P_SEQ, Y.OPERATION_GROUP, X.ITEM_ID, X.CELL_ITEM_ID
             , '-', X.TO_BOH_QTY, '-', X.FROM_SITE, X.FROM_BOH_QTY, NULL, 'DIO', X.YYYYMMDD
             , ( CASE WHEN X.DD = 0 THEN 0 ELSE X.DD END ), '-', 'DIO'
          FROM GT_PSIG_DIO3 X
               INNER JOIN SCP_MST_FINAL_ITEM_V Y
                       ON X.ITEM_ID = Y.ITEM_ID
         WHERE 1 = 1
           AND X.FROM_SITE <> '-';

        /* -------------------------------------------------------------------------------- */
        /* 13. 보정 (UI 정렬 조건, 공정코드) -- JV 가상사업부(SCM_MST_DIVISION.ATTRIBUTE3='81') */
        /* -------------------------------------------------------------------------------- */
        /* ATTRIBUTE9 = FLOW_ID 5자리 (JV '81' 그룹 division) */
        MERGE INTO GT_PSIG_TMP X
        USING ( SELECT ITEM_ID, MAX(SUBSTR(FLOW_ID,1,5)) AS FLOW5
                  FROM SCP_MST_FINAL_ITEM
                 GROUP BY ITEM_ID ) Y
           ON ( Y.ITEM_ID = X.ITEM_ID
                AND EXISTS ( SELECT 1 FROM SCM_MST_DIVISION D
                              WHERE D.DIVISION_ID = X.DIVISION_ID AND D.ATTRIBUTE3 = '81' AND D.VALID_YN = 'Y' ) )
        WHEN MATCHED THEN
            UPDATE SET X.ATTRIBUTE9 = Y.FLOW5;

        /* ATTRIBUTE9 = PLANT_ID (OSP from-site) */
        MERGE INTO GT_PSIG_TMP X
        USING ( SELECT DIVISION_ID, SCM_SITE_ID, MAX(PLANT_ID) AS PLANT_ID
                  FROM SCM_MST_SITE
                 WHERE OSP_YN = 'Y'
                 GROUP BY DIVISION_ID, SCM_SITE_ID ) Y
           ON ( Y.DIVISION_ID = X.DIVISION_ID AND Y.SCM_SITE_ID = X.FROM_SITE )
        WHEN MATCHED THEN
            UPDATE SET X.ATTRIBUTE9 = Y.PLANT_ID;

        /* BALANCE / WH_IN_BALANCE 를 '0'으로 UPDATE (JV '81' 그룹 PLANT, 외주제외) */
        INSERT INTO GT_PSIG_SITEID ( SCM_SITE_ID )
        SELECT S.SCM_SITE_ID
          FROM SCM_MST_SITE S
               INNER JOIN SCM_MST_DIVISION D
                       ON D.DIVISION_ID = S.DIVISION_ID
                      AND D.ATTRIBUTE3  = '81'
                      AND D.VALID_YN    = 'Y'
         WHERE S.SITE_TYPE = 'PLANT' AND S.OSP_YN = 'N';

        UPDATE GT_PSIG_TMP X
           SET X.QTY = 0
         WHERE 0 = 0
           AND X.MEASURE         IN ('BALANCE','WH_IN_BALANCE')
           AND X.TO_SITE         IN ( SELECT SCM_SITE_ID FROM GT_PSIG_SITEID )
           AND X.FROM_SITE       IN ( SELECT SCM_SITE_ID FROM GT_PSIG_SITEID )
           AND X.OPERATION_GROUP = 'A'
           AND X.QTY             > 0.0;

        /* ATTRIBUTE10 정렬코드 */
        UPDATE GT_PSIG_TMP X SET X.ATTRIBUTE10 = '1' WHERE 0 = 0 AND X.OPERATION_GROUP = 'P';
        UPDATE GT_PSIG_TMP X SET X.ATTRIBUTE10 = '3' WHERE 0 = 0 AND X.OPERATION_GROUP = 'A' AND X.ATTRIBUTE10 IS NULL;

        /* -------------------------------------------------------------------------------- */
        /* 0 값 데이터 삭제 (ALLOCATION/BALANCE/MKT_FCST/외주 WH_IN_BALANCE) */
        /* -------------------------------------------------------------------------------- */
        DELETE FROM GT_PSIG_TMP WHERE 0 = 0 AND ATTRIBUTE1 = '0';
        DELETE FROM GT_PSIG_TMP WHERE 0 = 0 AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI' AND MEASURE = 'MKT_FCST';
        DELETE FROM GT_PSIG_TMP A
         WHERE 0 = 0
           AND A.ATTRIBUTE10 = '3'
           AND A.MEASURE     = 'WH_IN_BALANCE'
           AND EXISTS ( SELECT 1 FROM SCM_MST_SITE B
                         WHERE B.SCM_SITE_ID = A.TO_SITE
                           AND A.DIVISION_ID = B.DIVISION_ID
                           AND B.OSP_YN      = 'Y' );

        /* -------------------------------------------------------------------------------- */
        /* 전구간 0 인 Cell Product 생산관련 measure 삭제 (2023.06.29 활성화코드 분리) */
        /* -------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIG_DELTGT
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, TOTAL_QTY, QTY_CNT )
        SELECT PG.DIVISION_ID, PG.PLAN_START_YYYYMMDD, PG.PLAN_TYPE, PG.SEQ, PG.OPERATION_GROUP, PG.ITEM_ID, PG.CELL_ITEM_ID
             , PG.TO_SITE, PG.INCOTERMS, PG.FROM_SITE, PG.BOD_ID, PG.TRANSPORT_MODE_LINE, PG.MEASURE
             , NVL(SUM(PG.QTY),0), COUNT(DISTINCT NVL(PG.QTY,0))
          FROM GT_PSIG_TMP PG
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
           AND ( NVL(PG.TO_SITE,'-') = '-' OR RTRIM(PG.TO_SITE) IS NULL )
           AND PG.MEASURE IN ('PRODUCTION','ACTIVATE_COMPLETED','CHAR_AVAILABLE','ACTIVATE_PROGRESS','MODEL_INVENTORY','DIO')
           AND EXISTS ( SELECT 1 FROM SCP_MST_CELL_PROD_ASSY_MAP M
                         WHERE 1 = 1
                           AND M.VALID_YN     = 'Y'
                           AND M.ITEM_ID_PROD = PG.ITEM_ID )
         GROUP BY PG.DIVISION_ID, PG.PLAN_START_YYYYMMDD, PG.PLAN_TYPE, PG.SEQ, PG.OPERATION_GROUP, PG.ITEM_ID, PG.CELL_ITEM_ID
                , PG.TO_SITE, PG.INCOTERMS, PG.FROM_SITE, PG.BOD_ID, PG.TRANSPORT_MODE_LINE, PG.MEASURE
        HAVING NVL(SUM(PG.QTY),0) = 0
           AND COUNT(DISTINCT NVL(PG.QTY,0)) = 1;

        DELETE FROM GT_PSIG_TMP TGT
         WHERE 1 = 1
           AND ( NVL(TGT.TO_SITE,'-') = '-' OR RTRIM(TGT.TO_SITE) IS NULL )
           AND EXISTS ( SELECT 1
                          FROM GT_PSIG_DELTGT D
                         WHERE 1 = 1
                           AND D.DIVISION_ID         = TGT.DIVISION_ID
                           AND D.PLAN_START_YYYYMMDD = TGT.PLAN_START_YYYYMMDD
                           AND D.PLAN_TYPE           = TGT.PLAN_TYPE
                           AND D.SEQ                 = TGT.SEQ
                           AND D.OPERATION_GROUP     = TGT.OPERATION_GROUP
                           AND D.ITEM_ID             = TGT.ITEM_ID
                           AND D.FROM_SITE           = TGT.FROM_SITE
                           AND D.MEASURE             = TGT.MEASURE
                           AND NVL(D.CELL_ITEM_ID,' ')        = NVL(TGT.CELL_ITEM_ID,' ')
                           AND NVL(D.INCOTERMS,' ')           = NVL(TGT.INCOTERMS,' ')
                           AND NVL(D.BOD_ID,' ')              = NVL(TGT.BOD_ID,' ')
                           AND NVL(D.TRANSPORT_MODE_LINE,' ') = NVL(TGT.TRANSPORT_MODE_LINE,' ') );

        /* -------------------------------------------------------------------------------- */
        /* 14. SAFETY_STOCK measure (PJ20216891 안전재고일수) */
        /* -------------------------------------------------------------------------------- */
        INSERT INTO GT_PSIG_SS
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, YYYYMMDD
            , ATTRIBUTE1, ATTRIBUTE9, ATTRIBUTE10, DAYS, DAYS_NVAR, FROM_YMD, TO_YMD, QTY )
        WITH DAYS_SAFETY_STOCK AS (
            SELECT MS.SCM_SITE_ID AS SALES_SITE_ID
                 , LD.SEGMENT3    AS ITEM_ID
                 , TRUNC(TO_NUMBER(MAX(LD.SEGMENT4))) AS DAYS
                 , MAX(LD.SEGMENT4)                   AS DAYS_NVAR
              FROM SCM_MST_SITE MS
                   INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LD
                           ON LD.LOOKUP_TYPE = 'DAYS_SAFETY_STOCK'
                          AND LD.SEGMENT1    = MS.DIVISION_ID
                          AND LD.SEGMENT2    = MS.SCM_SITE_ID
                          AND REGEXP_LIKE(LD.SEGMENT4, '^[+-]?[0-9]+(\.[0-9]+)?$')
                          AND LD.VALID_YN    = 'Y'
             WHERE MS.SITE_TYPE   = 'SALES'
               AND MS.VALID_YN    = 'Y'
               AND MS.VMI_YN      = 'Y'
               AND MS.DIVISION_ID = P_DIVISION_ID
             GROUP BY MS.SCM_SITE_ID, LD.SEGMENT3
            HAVING TRUNC(TO_NUMBER(MAX(LD.SEGMENT4))) > 0
        )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP, A.ITEM_ID, A.CELL_ITEM_ID
             , A.TO_SITE, A.TO_BOH_QTY, NVL(A.INCOTERMS,'-'), NVL(A.FROM_SITE,' '), A.FROM_BOH_QTY
             , NVL(A.BOD_ID,'-'), NVL(A.TRANSPORT_MODE_LINE,'-'), A.YYYYMMDD
             , A.ATTRIBUTE1, A.ATTRIBUTE9, A.ATTRIBUTE10, DSS.DAYS, DSS.DAYS_NVAR
             , TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + 1,        'YYYYMMDD') AS FROM_YMD
             , TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + DSS.DAYS, 'YYYYMMDD') AS TO_YMD
             , NVL(A.QTY,0) AS QTY
          FROM GT_PSIG_TMP A
               INNER JOIN DAYS_SAFETY_STOCK DSS
                       ON DSS.SALES_SITE_ID = A.TO_SITE
                      AND DSS.ITEM_ID       = A.ITEM_ID
         WHERE 1 = 1
           AND A.YYYYMMDD < V_PET_DATE
           AND A.CELL_ITEM_ID IS NOT NULL
           AND A.MEASURE = 'MKT_FCST';

        INSERT INTO GT_PSIG_TMP
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE9, ATTRIBUTE10 )
        SELECT S.DIVISION_ID, S.PLAN_START_YYYYMMDD, S.PLAN_TYPE, S.SEQ, S.OPERATION_GROUP, S.ITEM_ID, S.CELL_ITEM_ID
             , S.TO_SITE, S.TO_BOH_QTY, S.INCOTERMS, S.FROM_SITE, S.FROM_BOH_QTY, S.BOD_ID, S.TRANSPORT_MODE_LINE
             , 'SAFETY_STOCK', S.YYYYMMDD, NVL(SUM(T.QTY),0)
             , MAX(S.ATTRIBUTE1)
             , MAX(S.DAYS_NVAR||'::'||S.FROM_YMD||'::'||S.TO_YMD)
             , MAX(S.ATTRIBUTE9), MAX(S.ATTRIBUTE10)
          FROM GT_PSIG_SS S
               LEFT JOIN GT_PSIG_SS T
                      ON T.DIVISION_ID         = S.DIVISION_ID
                     AND T.PLAN_START_YYYYMMDD = S.PLAN_START_YYYYMMDD
                     AND T.PLAN_TYPE           = S.PLAN_TYPE
                     AND T.SEQ                 = S.SEQ
                     AND T.OPERATION_GROUP     = S.OPERATION_GROUP
                     AND T.ITEM_ID             = S.ITEM_ID
                     AND T.CELL_ITEM_ID        = S.CELL_ITEM_ID
                     AND T.TO_SITE             = S.TO_SITE
                     AND T.INCOTERMS           = S.INCOTERMS
                     AND T.FROM_SITE           = S.FROM_SITE
                     AND T.BOD_ID              = S.BOD_ID
                     AND T.TRANSPORT_MODE_LINE = S.TRANSPORT_MODE_LINE
                     AND T.QTY > 0
                     AND T.YYYYMMDD BETWEEN S.FROM_YMD AND S.TO_YMD
         WHERE 1 = 1
         GROUP BY S.DIVISION_ID, S.PLAN_START_YYYYMMDD, S.PLAN_TYPE, S.SEQ, S.OPERATION_GROUP, S.ITEM_ID, S.CELL_ITEM_ID
                , S.TO_SITE, S.TO_BOH_QTY, S.INCOTERMS, S.FROM_SITE, S.FROM_BOH_QTY, S.BOD_ID, S.TRANSPORT_MODE_LINE, S.YYYYMMDD;

        /* -------------------------------------------------------------------------------- */
        /* 15. SCP_ANL_PSI_GLOBAL 삭제 (배치 LOOP) */
        /* -------------------------------------------------------------------------------- */
        LOOP
            DELETE FROM SCP_ANL_PSI_GLOBAL
             WHERE DIVISION_ID = P_DIVISION_ID
               AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND PLAN_TYPE = P_PLAN_TYPE
               AND SEQ = P_SEQ
               AND ROWNUM <= 10000;
            V_DEL_CNT := SQL%ROWCOUNT;
            EXIT WHEN V_DEL_CNT = 0;
        END LOOP;

        /* -------------------------------------------------------------------------------- */
        /* 16. SCP_ANL_PSI_GLOBAL 입력 */
        /* -------------------------------------------------------------------------------- */
        INSERT INTO SCP_ANL_PSI_GLOBAL
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID
            , TO_SITE, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , MEASURE, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE9, ATTRIBUTE10 )
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID,
               NVL(TO_SITE,'-'), TO_BOH_QTY, NVL(INCOTERMS,'-'), NVL(FROM_SITE,'-'), FROM_BOH_QTY, NVL(BOD_ID,'-'), NVL(TRANSPORT_MODE_LINE,'-'),
               MEASURE, YYYYMMDD, SUM(NVL(QTY,0))
             , V_BATCH_USER, SYSDATE, V_BATCH_USER, SYSDATE
             , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE9, ATTRIBUTE10
          FROM GT_PSIG_TMP
         WHERE 1 = 1
           AND YYYYMMDD < V_PET_DATE
           AND CELL_ITEM_ID IS NOT NULL
           AND MEASURE <> '-'
         GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, CELL_ITEM_ID,
                  NVL(TO_SITE,'-'), TO_BOH_QTY, NVL(INCOTERMS,'-'), NVL(FROM_SITE,'-'), FROM_BOH_QTY, NVL(BOD_ID,'-'), NVL(TRANSPORT_MODE_LINE,'-'),  /* [NVL센티넬소급 2026-08-12] FROM_SITE(적재식 GROUP BY 동반) : DBA_TAB_COLUMNS.NULLABLE='N' 문자컬럼 -> NVL(x,'-') */
                  MEASURE, YYYYMMDD, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE9, ATTRIBUTE10;

        N_LOG_COUNT := SQL%ROWCOUNT;

        DELETE FROM GT_PSIG_TMP;
        DELETE FROM GT_PSIG_CELLASSY;
        DELETE FROM GT_PSIG_CPMI;
        DELETE FROM GT_PSIG_INT;
        DELETE FROM GT_PSIG_BOH;
        DELETE FROM GT_PSIG_Y;
        DELETE FROM GT_PSIG_DIO1;
        DELETE FROM GT_PSIG_DIO2;
        DELETE FROM GT_PSIG_DIO3;
        DELETE FROM GT_PSIG_SITEID;
        DELETE FROM GT_PSIG_DELTGT;
        DELETE FROM GT_PSIG_SS;

        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT INTO '||V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...'||':'||TO_CHAR(D_EVENT_DATE,'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM,1,1000);
            V_DESCRIPTION := V_PROGRAM_NAME||'ERROR_LINE : '||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,1,200);
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);
            RETURN; /* 원본 return -1 (swallow) */
    END;

    V_EXEC_TIME := LPAD(TO_CHAR(TRUNC((SYSDATE - V_START_TIME) * 86400 / 60)), 2, '0')||':'||
                   LPAD(TO_CHAR(MOD(ROUND((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0');

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '['||P_MASTER_ID||']['||P_ENGINE_PLAN_ID||']['||V_EXEC_TIME||']';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);
END;