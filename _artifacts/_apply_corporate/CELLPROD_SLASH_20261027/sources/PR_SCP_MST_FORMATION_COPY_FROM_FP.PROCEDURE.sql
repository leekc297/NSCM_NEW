PROCEDURE PR_SCP_MST_FORMATION_COPY_FROM_FP
(
      P_DIVISION_ID             IN  VARCHAR2
)
/*
 * Program ID   : PR_SCP_MST_FORMATION_COPY_FROM_FP
 * Description  : CREATE DEFAULT FORMATION FROM FP NEXT MONTH DATA
 * OutTable     :
 * Execute      :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.11   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.31   KSG            활성화 LT 처리 수정
 * 2018.06.18   KSG            활성화 LT 처리 수정 : Delete Insert 에서 Update/Insert 로
 * 2018.06.19   KSG            Default Yield 처리 수정
 * 2018.07.23   KSG            우선 순위 조정 : Pilot Line 은 후순위로 처리
 * 2018.08.08   yydok          대상item에서 item master미존재 및 모델기준 셀(item id 2번째=C)이 아닌것제외,TCO/DSF/TAPED CELL은 제외
 * 2018.08.22   KSG            Formation L/T 올림 처리
 * 2018.11.13   KSG            공정 수율적용(해당공정 하드코딩을 lookup 테이블조회로 변경)
 * 2019.04.08   KSG            [전지고도화]특성 수율 별도 처리 : 활성화 수율 IF 시 조정 필요
 * 2019.04.23   KSG            [CSR ID:3979414] [요청] Formation L/T Default 값 TCO Cell로 분류된 것은 14일 -> 0일로 변경 요청 : 소형 TCO Model은 DEFALUT 활성화 LT = 0 처리
 * 2021.03.15   KSG            PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Yield Table 변경
 * 2023.06.02   KSG            PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 대응
 * 2023.09.11   KSG            E20230908-001596 활성화 코드분기 이후 SCP Formation 수율LT 기준정보 Cell Assembly만 표기 : CA1 만 생성 후 CP 는 CA1 기준으로 Copy
 * 2024.02.22   KSG            E20240214-000646 [공급 SCM PI팀] Formation 화면 데이터 소형사업부 업데이트 중단 요청
 *                               최초 INSERT 는 수행, 이후 Update 는 수행하지 않음
 * 2024.05.10   KSG            E20240509-001232 SCM FORMATION LT 산출기준 변경
 * 2025.05.09   kimcd          PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *                             E20250403-001452 자동차 사업부 실적기반 Formation L/T 정보 업데이트 중지
 *                               - 81, 81_HM, 81_ST 의 경우 Formation L/T 갱신에서 제외 하도록 수정
 *                               - 자동차 변경과 같은 기준으로 소형도 수율은 갱신되도록 수정
 * 2025.09.27   kimcd          PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  :
 *                               소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완
 *                               활성화 관련 반제품은 Cell Assy로 변환
 * 2025.10.28   hrkim          [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
 * 2026.07.30   ZIONEX         [PJ202650304] NextSCM Migration
 */
IS

    /*  LOG 용 변수 설정 */
    V_BATCH_USER    VARCHAR2(150 CHAR) := '';
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_SCP_MST_FORMATION_COPY_FROM_FP';
    V_LOG_TYPE      VARCHAR2(30 CHAR);   /*  START/END/ERROR/... */
    N_LOG_COUNT     NUMBER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    V_TABLE_ID      VARCHAR2(150 CHAR) := 'SCP_MST_FORMATION';
    D_EVENT_DATE    DATE;
BEGIN

    V_BATCH_USER := 'SCP';

    /*  시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' SCP_MST_FORMATION INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );


    BEGIN

        /* --------------------------------------------------------- */
        /*  1. SCP_MST_FORMATION 삭제 : 2018.06.18 Default 만 삭제 */
        /* --------------------------------------------------------- */
        DELETE
          FROM SCP_MST_FORMATION
         WHERE 1 = 1
           AND DIVISION_ID     = P_DIVISION_ID
           AND LAST_UPDATED_BY = 'DEFAULT';

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'DELETE DEFAULT ' || V_TABLE_ID;
        V_DESCRIPTION := 'DEFAULT...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------------- */
        /*  * LT 정보 : Pilot 라인용 Temp */
        /* --------------------------------------------------------- */


        DELETE
          FROM GT_SCP_MST_FORMATION_PILOT;

        /*  20240510 E20240509-001232 SCM FORMATION LT 산출기준 변경 */
        /*     소형 - 현행 유지 */
        /*     자동차/ESS - default_route = 'Y' 이고, ROUTE_TYPE 'D'이고, ROUTE_TOTAL_TIME에 값이 있는 것만 조회해서 */
        /*                  ROUTE_TYPE 'D'인 라우트에서 ROUTE_TOTAL_TIME까지 합산 */
        INSERT
          INTO GT_SCP_MST_FORMATION_PILOT
             ( COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , ITEM_ID
             , LINE_ID
             , SCM_SITE_ID
             , STANDARD_LT_MIN
             , STANDARD_LT_DAY )
        SELECT A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.ITEM_ID
             , A.LINE_ID
             , A.SCM_SITE_ID
             , A.STANDARD_LT_MIN
             , A.STANDARD_LT_DAY
          FROM ( /*  소형은 기존 로직 유지 */
                 SELECT A.COMPANY_ID
                      , A.DIVISION_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , A.ITEM_ID
                      , A.LINE_ID
                      , A.PLANT_ID || '-A' AS SCM_SITE_ID
                      , SUM(NVL(A.STANDARD_LT, 0))           AS STANDARD_LT_MIN
                      , SUM(NVL(A.STANDARD_LT, 0)) / 24 / 60 AS STANDARD_LT_DAY
                   FROM SCM_MST_AGING_ITEM_FLOW_M_SN A
                        /*  20230602  PJ20230691  활성화 대응 */
                      , SCP_MST_FINAL_ITEM          I /*  2018.08.08 item조인추가 */
                  WHERE A.DIVISION_ID     = I.DIVISION_ID
                    AND A.ITEM_ID         = I.ITEM_ID
                    AND I.OPERATION_GROUP = 'A' /* cell */
                    AND I.ATTRIBUTE8      = 'CA1' /*  20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy */
                    AND A.DIVISION_ID     = P_DIVISION_ID
                    AND A.DIVISION_ID     = '40' /*  소형은 기존 로직 유지 */
                    AND A.DEFAULT_ROUTE   = 'Y'
                    AND SUBSTR(A.LINE_ID, LENGTH(A.LINE_ID)-1, 1) = 'P' /*  2018.07.23 Pilot 라인 정보 */
                        /* AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거 */
                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.LINE_ID
                  UNION /*  자동차/ESS */
                 SELECT A.COMPANY_ID
                      , A.DIVISION_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , A.ITEM_ID
                      , A.LINE_ID
                      , A.PLANT_ID || '-A' AS SCM_SITE_ID
                      ,(SUM(NVL(A.STANDARD_LT, 0)) + MAX(NVL(A.ROUTE_TOTAL_TIME, 0)))           AS STANDARD_LT_MIN
                      ,(SUM(NVL(A.STANDARD_LT, 0)) + MAX(NVL(A.ROUTE_TOTAL_TIME, 0))) / 24 / 60 AS STANDARD_LT_DAY
                   FROM SCM_MST_AGING_ITEM_FLOW_M_SN A
                        /*  20230602  PJ20230691  활성화 대응 */
                      , SCP_MST_FINAL_ITEM          I /*  2018.08.08 item조인추가 */
                  WHERE A.DIVISION_ID     = I.DIVISION_ID
                    AND A.ITEM_ID         = I.ITEM_ID
                    AND I.OPERATION_GROUP = 'A' /* cell */
                    AND I.ATTRIBUTE8      = 'CA1' /*  20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy */
                    AND A.DIVISION_ID     = P_DIVISION_ID
                    AND A.DIVISION_ID    <> '40' /*  소형 외 */
                    AND A.DEFAULT_ROUTE   = 'Y'
                    AND SUBSTR(A.LINE_ID, LENGTH(A.LINE_ID)-1, 1) = 'P' /*  2018.07.23 Pilot 라인 정보 */
                        /* AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거 */
                    AND A.ROUTE_TYPE      = 'D'              /*  소형 외 조건 추가 */
                    AND NVL(A.ROUTE_TOTAL_TIME, -99) >= 0 /*  소형 외 조건 추가 */
                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.LINE_ID
               ) A;

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'UPDATE ' || V_TABLE_ID;
        V_DESCRIPTION := 'Temp DB : Pilot...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------------- */
        /*  * LT 정보 : 정상 라인용 Temp */
        /* --------------------------------------------------------- */


        DELETE
          FROM GT_SCP_MST_FORMATION_LINE;

        /*  20240510 E20240509-001232 SCM FORMATION LT 산출기준 변경 */
        /*     소형 - 현행 유지 */
        /*     자동차/ESS - default_route = 'Y' 이고, ROUTE_TYPE 'D'이고, ROUTE_TOTAL_TIME에 값이 있는 것만 조회해서 */
        /*                  ROUTE_TYPE 'D'인 라우트에서 ROUTE_TOTAL_TIME까지 합산 */
        INSERT
          INTO GT_SCP_MST_FORMATION_LINE
             ( COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , ITEM_ID
             , LINE_ID
             , SCM_SITE_ID
             , STANDARD_LT_MIN
             , STANDARD_LT_DAY )
        SELECT A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.ITEM_ID
             , A.LINE_ID
             , A.SCM_SITE_ID
             , A.STANDARD_LT_MIN
             , A.STANDARD_LT_DAY
          FROM ( /*  소형은 기존 로직 유지 */
                 SELECT A.COMPANY_ID
                      , A.DIVISION_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , A.ITEM_ID
                      , A.LINE_ID
                      , A.PLANT_ID || '-A' AS SCM_SITE_ID
                      , SUM(NVL(A.STANDARD_LT, 0))           AS STANDARD_LT_MIN
                      , SUM(NVL(A.STANDARD_LT, 0)) / 24 / 60 AS STANDARD_LT_DAY
                   FROM SCM_MST_AGING_ITEM_FLOW_M_SN A
                        /*  20230602  PJ20230691  활성화 대응 */
                      , SCP_MST_FINAL_ITEM          I /*  2018.08.08 item조인추가 */
                  WHERE A.DIVISION_ID     = I.DIVISION_ID
                    AND A.ITEM_ID         = I.ITEM_ID
                    AND I.OPERATION_GROUP = 'A' /* cell */
                    AND I.ATTRIBUTE8      = 'CA1' /*  20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy */
                    AND A.DIVISION_ID     = P_DIVISION_ID
                    AND A.DIVISION_ID     = '40' /*  소형은 기존 로직 유지 */
                    AND A.DEFAULT_ROUTE   = 'Y'
                    AND SUBSTR(A.LINE_ID, LENGTH(A.LINE_ID)-1, 1) <> 'P' /*  2018.07.23 Pilot 라인 정보 */
                        /* AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거 */
                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.LINE_ID
                  UNION /*  자동차/ESS */
                 SELECT A.COMPANY_ID
                      , A.DIVISION_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , A.ITEM_ID
                      , A.LINE_ID
                      , A.PLANT_ID || '-A' AS SCM_SITE_ID
                      ,(SUM(NVL(A.STANDARD_LT, 0)) + MAX(NVL(A.ROUTE_TOTAL_TIME, 0)))           AS STANDARD_LT_MIN
                      ,(SUM(NVL(A.STANDARD_LT, 0)) + MAX(NVL(A.ROUTE_TOTAL_TIME, 0))) / 24 / 60 AS STANDARD_LT_DAY
                   FROM SCM_MST_AGING_ITEM_FLOW_M_SN A
                        /*  20230602  PJ20230691  활성화 대응 */
                      , SCP_MST_FINAL_ITEM          I /*  2018.08.08 item조인추가 */
                  WHERE A.DIVISION_ID     = I.DIVISION_ID
                    AND A.ITEM_ID         = I.ITEM_ID
                    AND I.OPERATION_GROUP = 'A' /* cell */
                    AND I.ATTRIBUTE8      = 'CA1' /*  20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy */
                    AND A.DIVISION_ID     = P_DIVISION_ID
                    AND A.DIVISION_ID    <> '40' /*  소형 외 */
                    AND A.DEFAULT_ROUTE   = 'Y'
                    AND SUBSTR(A.LINE_ID, LENGTH(A.LINE_ID)-1, 1) <> 'P' /*  2018.07.23 Pilot 라인 정보 */
                        /* AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거 */
                    AND A.ROUTE_TYPE      = 'D'              /*  소형 외 조건 추가 */
                    AND NVL(A.ROUTE_TOTAL_TIME, -99) >= 0 /*  소형 외 조건 추가 */
                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.LINE_ID
               ) A;

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'UPDATE ' || V_TABLE_ID;
        V_DESCRIPTION := 'Temp DB : Line...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------------- */
        /*  2-1. SCP_MST_FORMATION : UPDATE : Pilot 라인 */
        /*       동일한 Site/Item 에 대하여 정상 라인 정보가 존재하면 2-2 에서 정상 라인 정보로 Update 됨 */
        /*       20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음 */
        /* --------------------------------------------------------- */

         MERGE
          INTO SCP_MST_FORMATION AA /*  attribute1은 설정값 유지 -- 활성화 추가 LT */
         USING (
               SELECT DISTINCT LT.DIVISION_ID
                    , LT.SCM_SITE_ID AS PLANT_SITE_ID
                    , LT.ITEM_ID
                    , LT.LT
                    , NVL(FT.YIELD, 1) AS FORMATION_YIELD
                    , NVL(TT.YIELD, 1) AS CHAR_YIELD
                 FROM ( SELECT DISTINCT B.DIVISION_ID
                             , B.SCM_SITE_ID
                             , B.ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                             , CEIL(MIN(B.STANDARD_LT_DAY)) AS LT /*  올림 처리 */
                          FROM GT_SCP_MST_FORMATION_PILOT B
                               /*  20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음 */
                         WHERE 1 = 1  /*  b.division_id <> '40'  -- 2025.05.09   kimcd PJ2024A332 E20250403-001452 */
                                      /*  81, 81_HM, 81_ST, 40 수율 반영하기 위해 조건 제거 */
                         GROUP BY B.DIVISION_ID, B.SCM_SITE_ID, B.ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                        HAVING CEIL(MIN(B.STANDARD_LT_DAY)) > 0
                      ) LT
                      /*  특성 수율 */
                    , ( SELECT SCM_SITE_ID
                             , DIVISION_ID
                             , PLANT_ID
                             , ITEM_ID
                             , MONTH
                             , MAX(YIELD) YIELD
                        /* -- PJ20209642 변경
                         FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                                       END  AS scm_site_id
                        */
                          FROM ( SELECT T.PLANT_SITE_ID AS SCM_SITE_ID
                                      , OP.FLOW_ID
                                      , T.DIVISION_ID
                                      , T.PLANT_ID
                                      , T.ITEM_ID
                                      , T.MONTH    /*  yield 존재 구간 */
                                        /*  수율 0또는 NULL은 1로 처리함 */
                                      , MAX(CASE WHEN NVL(T.YIELD, 1) <= 0 THEN 1
                                                 WHEN NVL(T.YIELD, 1) >= 1 THEN 1
                                                 ELSE NVL(T.YIELD, 1)
                                            END
                                           ) AS YIELD /*  누적수율은 곱해야 하나 일단 MAX 값으로 처리함 */
                                   FROM SCM_MST_YIELD_VER_H_V   T /*  PJ20209642 변경 */
                                        /* FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK) */
                                      , SCM_MST_OPERATION_FLOW_V OP
                                  WHERE T.DIVISION_ID  = P_DIVISION_ID
                                    AND T.DIVISION_ID  = OP.DIVISION_ID
                                    AND T.COMPANY_ID   = OP.COMPANY_ID
                                    AND T.SITE_ID      = OP.SITE_ID
                                    AND T.OPERATION_ID = OP.OPERATION_ID
                                    /* AND    t.operation_id      = 'F6000' */
                                    AND T.OPERATION_ID IN (SELECT SEGMENT1 AS OPERATION_ID
                                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                            WHERE LOOKUP_TYPE = 'OPERATION_CHAR'
                                                              AND SEGMENT3    = 'Y' /*  Tact Time / yield 적용 대상 공정 */
                                                              AND VALID_YN    = 'Y'
                                                          ) /*  20181113 수정 */
                                    AND T.MONTH        = SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)
                                    AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) = 'P' /*  2018.07.23 Pilot 라인 정보 */
                                  GROUP BY T.PLANT_SITE_ID, OP.FLOW_ID, T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID, T.MONTH
                               ) A
                         GROUP BY SCM_SITE_ID, DIVISION_ID, PLANT_ID, ITEM_ID, MONTH
                      ) TT
                      /*  20190408 활성화 수율 */
                    , ( SELECT T.PLANT_ID || '-A' AS SCM_SITE_ID
                             , T.DIVISION_ID
                             , T.PLANT_ID
                             , T.ITEM_ID
                               /*   , t.month    -- yield 존재 구간 */
                               /*  수율 0또는 NULL은 1로 처리함 */
                             , MAX(CASE WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) <= 0 THEN 1
                                        WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) >= 1 THEN 1
                                        ELSE NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1)
                                   END
                                  ) AS YIELD
                               /*        , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1 */
                               /* WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1 */
                               /*                   ELSE ISNULL(t.formation_total_yield, 1) */
                               /*              END */
                               /*             ) AS yield */
                          FROM SCM_MST_FORMATION_YIELD_SN T
                         WHERE T.DIVISION_ID = P_DIVISION_ID
                               /*    AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6) */
                           AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) = 'P' /*  2018.07.23 Pilot 라인 정보 */
                         GROUP BY T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID/* , t.month */
                      ) FT
                WHERE TT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND TT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND TT.ITEM_ID(+)     = LT.ITEM_ID
                  AND FT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND FT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND FT.ITEM_ID(+)     = LT.ITEM_ID
               ) XX
            ON ( XX.DIVISION_ID   = AA.DIVISION_ID
             AND XX.PLANT_SITE_ID = AA.PLANT_SITE_ID
             AND XX.ITEM_ID       = AA.ITEM_ID )
          WHEN MATCHED THEN
        UPDATE
           SET AA.LT_FORMATION          = CASE WHEN AA.DIVISION_ID IN ('81', '81_HM', '81_ST', '40') THEN AA.LT_FORMATION ELSE XX.LT END
                                         /*  2025.05.09   kimcd PJ2024A332 E20250403-001452 */
                                         /*  81, 81_HM, 81_ST, 40 은 lead time 갱신 제외 */
               /*  20190408 특성 수율 별도 처리 */
             , AA.FORMATION_YIELD       = NVL(XX.FORMATION_YIELD, 1)                         /*  활성화 수율 */
             , AA.CHAR_YIELD            = NVL(XX.CHAR_YIELD, 1)                              /*  특성 수율 */
             , AA.FORMATION_TOTAL_YIELD = NVL(XX.FORMATION_YIELD, 1) * NVL(XX.CHAR_YIELD, 1) /*  */
             , AA.LAST_UPDATED_BY       = 'COPY : Pilot'
             , AA.LAST_UPDATE_DATE      = SYSDATE;

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'UPDATE ' || V_TABLE_ID;
        V_DESCRIPTION := 'COPY : Pilot...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------------- */
        /*  2-2. SCP_MST_FORMATION : UPDATE : 정상 라인 - Pilot 라인과 동일한 Site/Item 정보는 정상 라인 정보로 Update 됨 */
        /*       20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음 */
        /* --------------------------------------------------------- */

         MERGE
          INTO SCP_MST_FORMATION AA /*  attribute1은 설정값 유지 -- 활성화 추가 LT */
         USING (
               SELECT DISTINCT LT.DIVISION_ID
                    , LT.SCM_SITE_ID AS PLANT_SITE_ID
                    , LT.ITEM_ID
                    , LT.LT
                    , NVL(FT.YIELD, 1) AS FORMATION_YIELD
                    , NVL(TT.YIELD, 1) AS CHAR_YIELD
                 FROM ( SELECT DISTINCT B.DIVISION_ID
                             , B.SCM_SITE_ID
                             , B.ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                             , CEIL(MIN(B.STANDARD_LT_DAY)) AS LT /*  올림 처리 */
                               /* , FLOOR(MIN(b.standard_lt_day)) AS lt -- 내림 처리  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경 */
                          FROM GT_SCP_MST_FORMATION_LINE B
                               /*  20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음 */
                         WHERE 1 = 1  /*  b.division_id <> '40'  -- 2025.05.09   kimcd PJ2024A332 E20250403-001452 */
                                      /*  81, 81_HM, 81_ST, 40 수율 반영하기 위해 조건 제거 */
                         GROUP BY B.DIVISION_ID, B.SCM_SITE_ID, B.ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                        HAVING CEIL(MIN(B.STANDARD_LT_DAY)) > 0
                               /* HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경 */
                      ) LT
                      /*  특성 수율 */
                    , ( SELECT SCM_SITE_ID
                             , DIVISION_ID
                             , PLANT_ID
                             , ITEM_ID
                             , MONTH
                             , MAX(YIELD) YIELD
                        /* -- PJ20209642 변경
                         FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                                       END  AS scm_site_id
                        */
                          FROM ( SELECT T.PLANT_SITE_ID AS SCM_SITE_ID
                                      , OP.FLOW_ID
                                      , T.DIVISION_ID
                                      , T.PLANT_ID
                                      , T.ITEM_ID
                                      , T.MONTH    /*  yield 존재 구간 */
                                        /*  수율 0또는 NULL은 1로 처리함 */
                                      , MAX(CASE WHEN NVL(T.YIELD, 1) <= 0 THEN 1
                                                 WHEN NVL(T.YIELD, 1) >= 1 THEN 1
                                                 ELSE NVL(T.YIELD, 1)
                                            END
                                           ) AS YIELD /*  누적수율은 곱해야 하나 일단 MAX 값으로 처리함 */
                                   FROM SCM_MST_YIELD_VER_H_V   T /*  PJ20209642 변경 */
                                        /* FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK) */
                                      , SCM_MST_OPERATION_FLOW_V OP
                                  WHERE T.DIVISION_ID  = P_DIVISION_ID
                                    AND T.DIVISION_ID  = OP.DIVISION_ID
                                    AND T.COMPANY_ID   = OP.COMPANY_ID
                                    AND T.SITE_ID      = OP.SITE_ID
                                    AND T.OPERATION_ID = OP.OPERATION_ID
                                    /* AND    t.operation_id      = 'F6000' */
                                    AND T.OPERATION_ID IN (SELECT SEGMENT1 AS OPERATION_ID
                                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                            WHERE LOOKUP_TYPE = 'OPERATION_CHAR'
                                                              AND SEGMENT3    = 'Y' /*  Tact Time / yield 적용 대상 공정 */
                                                              AND VALID_YN    = 'Y'
                                                          ) /*  20181113 수정 */
                                    AND T.MONTH        = SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)
                                    AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) <> 'P' /*  2018.07.23 정상 라인 정보 */
                                  GROUP BY T.PLANT_SITE_ID, OP.FLOW_ID, T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID, T.MONTH
                               ) A
                         GROUP BY SCM_SITE_ID, DIVISION_ID, PLANT_ID, ITEM_ID, MONTH
                      ) TT
                      /*  20190408 활성화 수율 */
                    , ( SELECT T.PLANT_ID || '-A' AS SCM_SITE_ID
                             , T.DIVISION_ID
                             , T.PLANT_ID
                             , T.ITEM_ID
                               /*   , t.month    -- yield 존재 구간 */
                               /*  수율 0또는 NULL은 1로 처리함 */
                             , MAX(CASE WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) <= 0 THEN 1
                                        WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) >= 1 THEN 1
                                        ELSE NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1)
                                   END
                                  ) AS YIELD
                               /*        , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1 */
                               /* WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1 */
                               /*                   ELSE ISNULL(t.formation_total_yield, 1) */
                               /*              END */
                               /*             ) AS yield */
                          FROM SCM_MST_FORMATION_YIELD_SN T
                         WHERE T.DIVISION_ID = P_DIVISION_ID
                               /*    AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6) */
                           AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) <> 'P' /*  2018.07.23 정상 라인 정보 */
                         GROUP BY T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID/* , t.month */
                      ) FT
                WHERE TT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND TT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND TT.ITEM_ID(+)     = LT.ITEM_ID
                  AND FT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND FT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND FT.ITEM_ID(+)     = LT.ITEM_ID
               ) XX
            ON ( XX.DIVISION_ID   = AA.DIVISION_ID
             AND XX.PLANT_SITE_ID = AA.PLANT_SITE_ID
             AND XX.ITEM_ID       = AA.ITEM_ID )
          WHEN MATCHED THEN
        UPDATE
           SET AA.LT_FORMATION          = CASE WHEN AA.DIVISION_ID IN ('81', '81_HM', '81_ST', '40') THEN AA.LT_FORMATION ELSE XX.LT END
                                         /*  2025.05.09   kimcd PJ2024A332 E20250403-001452 */
                                         /*  81, 81_HM, 81_ST, 40 은 lead time 갱신 제외 */
               /*  20190408 특성 수율 별도 처리 */
             , AA.FORMATION_YIELD       = NVL(XX.FORMATION_YIELD, 1)                         /*  활성화 수율 */
             , AA.CHAR_YIELD            = NVL(XX.CHAR_YIELD, 1)                              /*  특성 수율 */
             , AA.FORMATION_TOTAL_YIELD = NVL(XX.FORMATION_YIELD, 1) * NVL(XX.CHAR_YIELD, 1) /*  */
             , AA.LAST_UPDATED_BY       = 'COPY : Line'
             , AA.LAST_UPDATE_DATE      = SYSDATE;

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'UPDATE ' || V_TABLE_ID;
        V_DESCRIPTION := 'COPY : Line...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------------- */
        /*  3-1. SCP_MST_FORMATION : INSERT : 정상 라인 */
        /* --------------------------------------------------------- */

        INSERT
          INTO SCP_MST_FORMATION
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , ATTRIBUTE1 /*  20190408 char_yield / formation_total_yield 추가 */
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT XX.DIVISION_ID
             , XX.PLANT_SITE_ID
             , XX.ITEM_ID
             , XX.LT
               /*  20190408 특성 수율 별도 처리 */
             , NVL(XX.FORMATION_YIELD, 1)                         /*  활성화 수율 */
             , NVL(XX.CHAR_YIELD, 1)                              /*  특성 수율 */
             , NVL(XX.FORMATION_YIELD, 1) * NVL(XX.CHAR_YIELD, 1) /*  */
             , XX.ATTRIBUTE1
             , 'COPY : Line'    AS CREATED_BY
             , SYSDATE AS CREATION_DATE
             , 'COPY : Line'    AS LAST_UPDATED_BY
             , SYSDATE AS LAST_UPDATE_DATE
          FROM (
               SELECT DISTINCT LT.DIVISION_ID
                    , LT.SCM_SITE_ID AS PLANT_SITE_ID
                    , LT.ITEM_ID
                    , LT.LT
                    , NVL(FT.YIELD, 1) AS FORMATION_YIELD
                    , NVL(TT.YIELD, 1) AS CHAR_YIELD
                    , 0 AS ATTRIBUTE1 /*  활성화 추가 LT */
                 FROM ( SELECT DISTINCT B.DIVISION_ID
                             , B.SCM_SITE_ID
                             , B.ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                             , CEIL(MIN(B.STANDARD_LT_DAY)) AS LT /*  올림 처리 */
                               /* , FLOOR(MIN(b.standard_lt_day)) AS lt -- 내림 처리  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경 */
                          FROM GT_SCP_MST_FORMATION_LINE B
                         GROUP BY B.DIVISION_ID, B.SCM_SITE_ID, B.ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                        HAVING CEIL(MIN(B.STANDARD_LT_DAY)) > 0
                               /* HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경 */
                      ) LT
                      /*  특성 수율 */
                    , ( SELECT SCM_SITE_ID
                             , DIVISION_ID
                             , PLANT_ID
                             , ITEM_ID
                             , MONTH
                             , MAX(YIELD) YIELD
                        /* -- PJ20209642 변경
                         FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                                       END  AS scm_site_id
                        */
                          FROM ( SELECT T.PLANT_SITE_ID AS SCM_SITE_ID
                                      , OP.FLOW_ID
                                      , T.DIVISION_ID
                                      , T.PLANT_ID
                                      , T.ITEM_ID
                                      , T.MONTH    /*  yield 존재 구간 */
                                        /*  수율 0또는 NULL은 1로 처리함 */
                                      , MAX(CASE WHEN NVL(T.YIELD, 1) <= 0 THEN 1
                                                 WHEN NVL(T.YIELD, 1) >= 1 THEN 1
                                                 ELSE NVL(T.YIELD, 1)
                                            END
                                           ) AS YIELD /*  누적수율은 곱해야 하나 일단 MAX 값으로 처리함 */
                                   FROM SCM_MST_YIELD_VER_H_V   T /*  PJ20209642 변경 */
                                        /* FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK) */
                                      , SCM_MST_OPERATION_FLOW_V OP
                                  WHERE T.DIVISION_ID  = P_DIVISION_ID
                                    AND T.DIVISION_ID  = OP.DIVISION_ID
                                    AND T.COMPANY_ID   = OP.COMPANY_ID
                                    AND T.SITE_ID      = OP.SITE_ID
                                    AND T.OPERATION_ID = OP.OPERATION_ID
                                    /* AND    t.operation_id      = 'F6000' */
                                    AND T.OPERATION_ID IN (SELECT SEGMENT1 AS OPERATION_ID
                                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                            WHERE LOOKUP_TYPE = 'OPERATION_CHAR'
                                                              AND SEGMENT3    = 'Y' /*  Tact Time / yield 적용 대상 공정 */
                                                              AND VALID_YN    = 'Y'
                                                          ) /*  20181113 수정 */
                                    AND T.MONTH        = SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)
                                    AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) <> 'P' /*  2018.07.23 정상 라인 정보 */
                                  GROUP BY T.PLANT_SITE_ID, OP.FLOW_ID, T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID, T.MONTH
                               ) A
                         GROUP BY SCM_SITE_ID, DIVISION_ID, PLANT_ID, ITEM_ID, MONTH
                      ) TT
                      /*  20190408 활성화 수율 */
                    , ( SELECT T.PLANT_ID || '-A' AS SCM_SITE_ID
                             , T.DIVISION_ID
                             , T.PLANT_ID
                             , T.ITEM_ID
                               /*   , t.month    -- yield 존재 구간 */
                               /*  수율 0또는 NULL은 1로 처리함 */
                             , MAX(CASE WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) <= 0 THEN 1
                                        WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) >= 1 THEN 1
                                        ELSE NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1)
                                   END
                                  ) AS YIELD
                               /*        , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1 */
                               /* WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1 */
                               /*                   ELSE ISNULL(t.formation_total_yield, 1) */
                               /*              END */
                               /*             ) AS yield */
                          FROM SCM_MST_FORMATION_YIELD_SN T
                         WHERE T.DIVISION_ID = P_DIVISION_ID
                               /*    AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6) */
                           AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) <> 'P' /*  2018.07.23 정상 라인 정보 */
                         GROUP BY T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID/* , t.month */
                      ) FT
                WHERE TT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND TT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND TT.ITEM_ID(+)     = LT.ITEM_ID
                  AND FT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND FT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND FT.ITEM_ID(+)     = LT.ITEM_ID
               ) XX
         WHERE 1 = 1
           AND NOT EXISTS (SELECT 1
                             FROM SCP_MST_FORMATION X
                            WHERE X.DIVISION_ID   = XX.DIVISION_ID
                              AND X.PLANT_SITE_ID = XX.PLANT_SITE_ID
                              AND X.ITEM_ID       = XX.ITEM_ID
                          );

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT ' || V_TABLE_ID;
        V_DESCRIPTION := 'COPY : Line...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------------- */
        /*  3-2. SCP_MST_FORMATION : INSERT : Pilot 라인 - 정상 라인에 없는 정보만 Insert 됨 */
        /* --------------------------------------------------------- */

        INSERT
          INTO SCP_MST_FORMATION
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , ATTRIBUTE1 /*  20190408 char_yield / formation_total_yield 추가 */
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT XX.DIVISION_ID
             , XX.PLANT_SITE_ID
             , XX.ITEM_ID
             , XX.LT
               /*  20190408 특성 수율 별도 처리 */
             , NVL(XX.FORMATION_YIELD, 1)                         /*  활성화 수율 */
             , NVL(XX.CHAR_YIELD, 1)                              /*  특성 수율 */
             , NVL(XX.FORMATION_YIELD, 1) * NVL(XX.CHAR_YIELD, 1) /*  */
             , XX.ATTRIBUTE1
             , 'COPY : Pilot'    AS CREATED_BY
             , SYSDATE AS CREATION_DATE
             , 'COPY : Pilot'    AS LAST_UPDATED_BY
             , SYSDATE AS LAST_UPDATE_DATE
          FROM (
               SELECT DISTINCT LT.DIVISION_ID
                    , LT.SCM_SITE_ID AS PLANT_SITE_ID
                    , LT.ITEM_ID
                    , LT.LT
                    , NVL(FT.YIELD, 1) AS FORMATION_YIELD
                    , NVL(TT.YIELD, 1) AS CHAR_YIELD
                    , 0 AS ATTRIBUTE1 /*  활성화 추가 LT */
                 FROM ( SELECT DISTINCT B.DIVISION_ID
                             , B.SCM_SITE_ID
                             , B.ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                             , CEIL(MIN(B.STANDARD_LT_DAY)) AS LT /*  올림 처리 */
                               /* , FLOOR(MIN(b.standard_lt_day)) AS lt -- 내림 처리  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경 */
                          FROM GT_SCP_MST_FORMATION_PILOT B
                         GROUP BY B.DIVISION_ID, B.SCM_SITE_ID, B.ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                        HAVING CEIL(MIN(B.STANDARD_LT_DAY)) > 0
                               /* HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경 */
                      ) LT
                      /*  특성 수율 */
                    , ( SELECT SCM_SITE_ID
                             , DIVISION_ID
                             , PLANT_ID
                             , ITEM_ID
                             , MONTH
                             , MAX(YIELD) YIELD
                        /* -- PJ20209642 변경
                         FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                                       END  AS scm_site_id
                        */
                          FROM ( SELECT T.PLANT_SITE_ID AS SCM_SITE_ID
                                      , OP.FLOW_ID
                                      , T.DIVISION_ID
                                      , T.PLANT_ID
                                      , T.ITEM_ID
                                      , T.MONTH    /*  yield 존재 구간 */
                                        /*  수율 0또는 NULL은 1로 처리함 */
                                      , MAX(CASE WHEN NVL(T.YIELD, 1) <= 0 THEN 1
                                                 WHEN NVL(T.YIELD, 1) >= 1 THEN 1
                                                 ELSE NVL(T.YIELD, 1)
                                            END
                                           ) AS YIELD /*  누적수율은 곱해야 하나 일단 MAX 값으로 처리함 */
                                   FROM SCM_MST_YIELD_VER_H_V   T /*  PJ20209642 변경 */
                                        /* FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK) */
                                      , SCM_MST_OPERATION_FLOW_V OP
                                  WHERE T.DIVISION_ID  = P_DIVISION_ID
                                    AND T.DIVISION_ID  = OP.DIVISION_ID
                                    AND T.COMPANY_ID   = OP.COMPANY_ID
                                    AND T.SITE_ID      = OP.SITE_ID
                                    AND T.OPERATION_ID = OP.OPERATION_ID
                                    /* AND    t.operation_id      = 'F6000' */
                                    AND T.OPERATION_ID IN (SELECT SEGMENT1 AS OPERATION_ID
                                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                            WHERE LOOKUP_TYPE = 'OPERATION_CHAR'
                                                              AND SEGMENT3    = 'Y' /*  Tact Time / yield 적용 대상 공정 */
                                                              AND VALID_YN    = 'Y'
                                                          ) /*  20181113 수정 */
                                    AND T.MONTH        = SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)
                                    AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) = 'P' /*  2018.07.23 Pilot 라인 정보 */
                                  GROUP BY T.PLANT_SITE_ID, OP.FLOW_ID, T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID, T.MONTH
                               ) A
                         GROUP BY SCM_SITE_ID, DIVISION_ID, PLANT_ID, ITEM_ID, MONTH
                      ) TT
                      /*  20190408 활성화 수율 */
                    , ( SELECT T.PLANT_ID || '-A' AS SCM_SITE_ID
                             , T.DIVISION_ID
                             , T.PLANT_ID
                             , T.ITEM_ID
                               /*   , t.month    -- yield 존재 구간 */
                               /*  수율 0또는 NULL은 1로 처리함 */
                             , MAX(CASE WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) <= 0 THEN 1
                                        WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) >= 1 THEN 1
                                        ELSE NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1)
                                   END
                                  ) AS YIELD
                               /*        , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1 */
                               /* WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1 */
                               /*                   ELSE ISNULL(t.formation_total_yield, 1) */
                               /*              END */
                               /*             ) AS yield */
                          FROM SCM_MST_FORMATION_YIELD_SN T
                         WHERE T.DIVISION_ID = P_DIVISION_ID
                               /*    AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6) */
                           AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) = 'P' /*  2018.07.23 Pilot 라인 정보 */
                         GROUP BY T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID/* , t.month */
                      ) FT
                WHERE TT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND TT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND TT.ITEM_ID(+)     = LT.ITEM_ID
                  AND FT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND FT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND FT.ITEM_ID(+)     = LT.ITEM_ID
               ) XX
         WHERE 1 = 1
           AND NOT EXISTS (SELECT 1
                             FROM SCP_MST_FORMATION X
                            WHERE X.DIVISION_ID   = XX.DIVISION_ID
                              AND X.PLANT_SITE_ID = XX.PLANT_SITE_ID
                              AND X.ITEM_ID       = XX.ITEM_ID
                          );

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT ' || V_TABLE_ID;
        V_DESCRIPTION := 'COPY : Pilot...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);


        /*  2025.09.27   kimcd          PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : */
        /*                                소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완 */
        /*                                활성화 관련 반제품은 Cell Assy로 변환하여 정보 형성 */
        /*                              추가 시작 */
        /* --------------------------------------------------------- */
        /*  * BOM 기반 전개 정보 : 활성화 진행 중 Assy를 Cell Assy 연계 Temp */
        /* --------------------------------------------------------- */


        DELETE
          FROM GT_SCP_EXC_ITEM_ASSY_MAP;

        INSERT
          INTO GT_SCP_EXC_ITEM_ASSY_MAP
             ( COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , SCP_EXC_ITEM_ID
             , CELL_ASSY_ITEM_ID )
        SELECT COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , SCP_EXC_ITEM_ID
             , CELL_ASSY_ITEM_ID
          FROM TABLE(FN_GET_SCP_EXC_ITEM_ASSY_MAP(P_DIVISION_ID));

        /* --------------------------------------------------------- */
        /*  * 활성화 진행 중 Assy를 Cell Assy 연계 Temp LT 정보 : Pilot 라인용 Temp */
        /* --------------------------------------------------------- */


        DELETE
          FROM GT_SCP_MST_EXC_FORM_PILOT;

        INSERT
          INTO GT_SCP_MST_EXC_FORM_PILOT
             ( COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , SCP_EXC_ITEM_ID
             , CELL_ASSY_ITEM_ID
             , LINE_ID
             , SCM_SITE_ID
             , STANDARD_LT_MIN
             , STANDARD_LT_DAY )
        SELECT A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.SCP_EXC_ITEM_ID
             , A.CELL_ASSY_ITEM_ID
             , A.LINE_ID
             , A.SCM_SITE_ID
             , A.STANDARD_LT_MIN
             , A.STANDARD_LT_DAY
          FROM ( /*  소형은 기존 로직 유지 */
                 SELECT A.COMPANY_ID
                      , A.DIVISION_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , MAX(M.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID
                      , M.CELL_ASSY_ITEM_ID
                      , A.LINE_ID
                      , A.PLANT_ID || '-A' AS SCM_SITE_ID
                      , SUM(NVL(A.STANDARD_LT, 0))           AS STANDARD_LT_MIN
                      , SUM(NVL(A.STANDARD_LT, 0)) / 24 / 60 AS STANDARD_LT_DAY
                   FROM SCM_MST_AGING_ITEM_FLOW_M_SN A
                      , GT_SCP_EXC_ITEM_ASSY_MAP     M
                      , SCP_MST_FINAL_ITEM           I /*  2018.08.08 item조인추가 */
                  WHERE A.COMPANY_ID        = M.COMPANY_ID
                    AND A.DIVISION_ID       = M.DIVISION_ID
                    AND A.SITE_ID           = M.SITE_ID
                    AND A.PLANT_ID          = M.PLANT_ID
                    AND A.ITEM_ID           = M.SCP_EXC_ITEM_ID
                    AND A.DIVISION_ID       = I.DIVISION_ID
                    AND M.CELL_ASSY_ITEM_ID = I.ITEM_ID
                    AND I.OPERATION_GROUP   = 'A' /* cell */
                    AND I.ATTRIBUTE8        = 'CA1' /*  20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy */
                    AND A.DIVISION_ID       = P_DIVISION_ID
                    AND A.DIVISION_ID       = '40' /*  소형은 기존 로직 유지 */
                    AND A.DEFAULT_ROUTE     = 'Y'
                    AND SUBSTR(A.LINE_ID, LENGTH(A.LINE_ID)-1, 1) = 'P' /*  2018.07.23 Pilot 라인 정보 */
                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, M.CELL_ASSY_ITEM_ID, A.LINE_ID
                  UNION /*  자동차/ESS */
                 SELECT A.COMPANY_ID
                      , A.DIVISION_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , MAX(M.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID
                      , M.CELL_ASSY_ITEM_ID
                      , A.LINE_ID
                      , A.PLANT_ID || '-A' AS SCM_SITE_ID
                      ,(SUM(NVL(A.STANDARD_LT, 0)) + MAX(NVL(A.ROUTE_TOTAL_TIME, 0)))           AS STANDARD_LT_MIN
                      ,(SUM(NVL(A.STANDARD_LT, 0)) + MAX(NVL(A.ROUTE_TOTAL_TIME, 0))) / 24 / 60 AS STANDARD_LT_DAY
                   FROM SCM_MST_AGING_ITEM_FLOW_M_SN A
                      , GT_SCP_EXC_ITEM_ASSY_MAP     M
                      , SCP_MST_FINAL_ITEM           I /*  2018.08.08 item조인추가 */
                  WHERE A.COMPANY_ID        = M.COMPANY_ID
                    AND A.DIVISION_ID       = M.DIVISION_ID
                    AND A.SITE_ID           = M.SITE_ID
                    AND A.PLANT_ID          = M.PLANT_ID
                    AND A.ITEM_ID           = M.SCP_EXC_ITEM_ID
                    AND A.DIVISION_ID       = I.DIVISION_ID
                    AND M.CELL_ASSY_ITEM_ID = I.ITEM_ID
                    AND I.OPERATION_GROUP   = 'A' /* cell */
                    AND I.ATTRIBUTE8        = 'CA1' /*  20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy */
                    AND A.DIVISION_ID       = P_DIVISION_ID
                    AND A.DIVISION_ID      <> '40' /*  소형 외 */
                    AND A.DEFAULT_ROUTE     = 'Y'
                    AND SUBSTR(A.LINE_ID, LENGTH(A.LINE_ID)-1, 1) = 'P' /*  2018.07.23 Pilot 라인 정보 */
                        /* AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거 */
                    AND A.ROUTE_TYPE        = 'D'              /*  소형 외 조건 추가 */
                    AND NVL(A.ROUTE_TOTAL_TIME, -99) >= 0 /*  소형 외 조건 추가 */
                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, M.CELL_ASSY_ITEM_ID, A.LINE_ID
               ) A;

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT #scp_mst_exc_formation_pilot';
        V_DESCRIPTION := 'Temp DB : EXC Pilot...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------------- */
        /*  * 활성화 진행 중 Assy를 Cell Assy 연계 Temp LT 정보 : 정상 라인용 Temp */
        /* --------------------------------------------------------- */


        DELETE
          FROM GT_SCP_MST_EXC_FORM_LINE;

        /*     소형 - 현행 유지 */
        /*     자동차/ESS - default_route = 'Y' 이고, ROUTE_TYPE 'D'이고, ROUTE_TOTAL_TIME에 값이 있는 것만 조회해서 */
        /*                  ROUTE_TYPE 'D'인 라우트에서 ROUTE_TOTAL_TIME까지 합산 */
        INSERT
          INTO GT_SCP_MST_EXC_FORM_LINE
             ( COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , SCP_EXC_ITEM_ID
             , CELL_ASSY_ITEM_ID
             , LINE_ID
             , SCM_SITE_ID
             , STANDARD_LT_MIN
             , STANDARD_LT_DAY )
        SELECT A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.SCP_EXC_ITEM_ID
             , A.CELL_ASSY_ITEM_ID
             , A.LINE_ID
             , A.SCM_SITE_ID
             , A.STANDARD_LT_MIN
             , A.STANDARD_LT_DAY
          FROM ( /*  소형은 기존 로직 유지 */
                 SELECT A.COMPANY_ID
                      , A.DIVISION_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , MAX(M.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID
                      , M.CELL_ASSY_ITEM_ID
                      , A.LINE_ID
                      , A.PLANT_ID || '-A' AS SCM_SITE_ID
                      , SUM(NVL(A.STANDARD_LT, 0))           AS STANDARD_LT_MIN
                      , SUM(NVL(A.STANDARD_LT, 0)) / 24 / 60 AS STANDARD_LT_DAY
                   FROM SCM_MST_AGING_ITEM_FLOW_M_SN A
                      , GT_SCP_EXC_ITEM_ASSY_MAP     M
                      , SCP_MST_FINAL_ITEM           I /*  2018.08.08 item조인추가 */
                  WHERE A.COMPANY_ID        = M.COMPANY_ID
                    AND A.DIVISION_ID       = M.DIVISION_ID
                    AND A.SITE_ID           = M.SITE_ID
                    AND A.PLANT_ID          = M.PLANT_ID
                    AND A.ITEM_ID           = M.SCP_EXC_ITEM_ID
                    AND A.DIVISION_ID       = I.DIVISION_ID
                    AND M.CELL_ASSY_ITEM_ID = I.ITEM_ID
                    AND I.OPERATION_GROUP   = 'A' /* cell */
                    AND I.ATTRIBUTE8        = 'CA1' /*  20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy */
                    AND A.DIVISION_ID       = P_DIVISION_ID
                    AND A.DIVISION_ID       = '40' /*  소형은 기존 로직 유지 */
                    AND A.DEFAULT_ROUTE     = 'Y'
                    AND SUBSTR(A.LINE_ID, LENGTH(A.LINE_ID)-1, 1) <> 'P' /*  2018.07.23 Pilot 라인 정보 */
                        /* AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거 */
                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, M.CELL_ASSY_ITEM_ID, A.LINE_ID
                  UNION /*  자동차/ESS */
                 SELECT A.COMPANY_ID
                      , A.DIVISION_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , MAX(M.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID
                      , M.CELL_ASSY_ITEM_ID
                      , A.LINE_ID
                      , A.PLANT_ID || '-A' AS SCM_SITE_ID
                      ,(SUM(NVL(A.STANDARD_LT, 0)) + MAX(NVL(A.ROUTE_TOTAL_TIME, 0)))           AS STANDARD_LT_MIN
                      ,(SUM(NVL(A.STANDARD_LT, 0)) + MAX(NVL(A.ROUTE_TOTAL_TIME, 0))) / 24 / 60 AS STANDARD_LT_DAY
                   FROM SCM_MST_AGING_ITEM_FLOW_M_SN A
                      , GT_SCP_EXC_ITEM_ASSY_MAP     M
                      , SCP_MST_FINAL_ITEM           I /*  2018.08.08 item조인추가 */
                  WHERE A.COMPANY_ID        = M.COMPANY_ID
                    AND A.DIVISION_ID       = M.DIVISION_ID
                    AND A.SITE_ID           = M.SITE_ID
                    AND A.PLANT_ID          = M.PLANT_ID
                    AND A.ITEM_ID           = M.SCP_EXC_ITEM_ID
                    AND A.DIVISION_ID       = I.DIVISION_ID
                    AND M.CELL_ASSY_ITEM_ID = I.ITEM_ID
                    AND I.OPERATION_GROUP   = 'A' /* cell */
                    AND I.ATTRIBUTE8        = 'CA1' /*  20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy */
                    AND A.DIVISION_ID       = P_DIVISION_ID
                    AND A.DIVISION_ID      <> '40' /*  소형 외 */
                    AND A.DEFAULT_ROUTE     = 'Y'
                    AND SUBSTR(A.LINE_ID, LENGTH(A.LINE_ID)-1, 1) <> 'P' /*  2018.07.23 Pilot 라인 정보 */
                        /* AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거 */
                    AND A.ROUTE_TYPE        = 'D'              /*  소형 외 조건 추가 */
                    AND NVL(A.ROUTE_TOTAL_TIME, -99) >= 0 /*  소형 외 조건 추가 */
                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, M.CELL_ASSY_ITEM_ID, A.LINE_ID
               ) A;

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT #scp_mst_exc_formation_line';
        V_DESCRIPTION := 'Temp DB : EXC Line...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------------- */
        /*  2-1. EXC SCP_MST_FORMATION : UPDATE : Pilot 라인 */
        /*       동일한 Site/Item 에 대하여 정상 라인 정보가 존재하면 2-2 에서 정상 라인 정보로 Update 됨 */
        /*       20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음 */
        /* --------------------------------------------------------- */

         MERGE
          INTO SCP_MST_FORMATION AA /*  attribute1은 설정값 유지 -- 활성화 추가 LT */
         USING (
               SELECT DISTINCT LT.DIVISION_ID
                    , LT.SCM_SITE_ID AS PLANT_SITE_ID
                    , LT.CELL_ASSY_ITEM_ID AS ITEM_ID
                    , LT.LT
                    , NVL(FT.YIELD, 1) AS FORMATION_YIELD
                    , NVL(TT.YIELD, 1) AS CHAR_YIELD
                 FROM ( SELECT B.DIVISION_ID
                             , B.SCM_SITE_ID
                             , MAX(B.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID
                             , B.CELL_ASSY_ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                             , CEIL(MIN(B.STANDARD_LT_DAY)) AS LT /*  올림 처리 */
                          FROM GT_SCP_MST_EXC_FORM_PILOT B
                               /*  20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음 */
                         WHERE 1 = 1  /*  b.division_id <> '40'  -- 2025.05.09   kimcd PJ2024A332 E20250403-001452 */
                                      /*  81, 81_HM, 81_ST, 40 수율 반영하기 위해 조건 제거 */
                         GROUP BY B.DIVISION_ID, B.SCM_SITE_ID, B.CELL_ASSY_ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                        HAVING CEIL(MIN(B.STANDARD_LT_DAY)) > 0
                      ) LT
                      /*  특성 수율 */
                    , ( SELECT SCM_SITE_ID
                             , DIVISION_ID
                             , PLANT_ID
                             , ITEM_ID
                             , MONTH
                             , MAX(YIELD) YIELD
                        /* -- PJ20209642 변경
                         FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                                       END  AS scm_site_id
                        */
                          FROM ( SELECT T.PLANT_SITE_ID AS SCM_SITE_ID
                                      , OP.FLOW_ID
                                      , T.DIVISION_ID
                                      , T.PLANT_ID
                                      , T.ITEM_ID
                                      , T.MONTH    /*  yield 존재 구간 */
                                        /*  수율 0또는 NULL은 1로 처리함 */
                                      , MAX(CASE WHEN NVL(T.YIELD, 1) <= 0 THEN 1
                                                 WHEN NVL(T.YIELD, 1) >= 1 THEN 1
                                                 ELSE NVL(T.YIELD, 1)
                                            END
                                           ) AS YIELD /*  누적수율은 곱해야 하나 일단 MAX 값으로 처리함 */
                                   FROM SCM_MST_YIELD_VER_H_V   T /*  PJ20209642 변경 */
                                        /* FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK) */
                                      , SCM_MST_OPERATION_FLOW_V OP
                                  WHERE T.DIVISION_ID  = P_DIVISION_ID
                                    AND T.DIVISION_ID  = OP.DIVISION_ID
                                    AND T.COMPANY_ID   = OP.COMPANY_ID
                                    AND T.SITE_ID      = OP.SITE_ID
                                    AND T.OPERATION_ID = OP.OPERATION_ID
                                    /* AND    t.operation_id      = 'F6000' */
                                    AND T.OPERATION_ID IN (SELECT SEGMENT1 AS OPERATION_ID
                                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                            WHERE LOOKUP_TYPE = 'OPERATION_CHAR'
                                                              AND SEGMENT3    = 'Y' /*  Tact Time / yield 적용 대상 공정 */
                                                              AND VALID_YN    = 'Y'
                                                          ) /*  20181113 수정 */
                                    AND T.MONTH        = SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)
                                    AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) = 'P' /*  2018.07.23 Pilot 라인 정보 */
                                  GROUP BY T.PLANT_SITE_ID, OP.FLOW_ID, T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID, T.MONTH
                               ) A
                         GROUP BY SCM_SITE_ID, DIVISION_ID, PLANT_ID, ITEM_ID, MONTH
                      ) TT
                      /*  20190408 활성화 수율 */
                    , ( SELECT T.PLANT_ID || '-A' AS SCM_SITE_ID
                             , T.DIVISION_ID
                             , T.PLANT_ID
                             , T.ITEM_ID
                               /*   , t.month    -- yield 존재 구간 */
                               /*  수율 0또는 NULL은 1로 처리함 */
                             , MAX(CASE WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) <= 0 THEN 1
                                        WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) >= 1 THEN 1
                                        ELSE NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1)
                                   END
                                  ) AS YIELD
                               /*        , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1 */
                               /* WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1 */
                               /*                   ELSE ISNULL(t.formation_total_yield, 1) */
                               /*              END */
                               /*             ) AS yield */
                          FROM SCM_MST_FORMATION_YIELD_SN T
                         WHERE T.DIVISION_ID = P_DIVISION_ID
                               /*    AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6) */
                           AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) = 'P' /*  2018.07.23 Pilot 라인 정보 */
                         GROUP BY T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID/* , t.month */
                      ) FT
                WHERE TT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND TT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND TT.ITEM_ID(+)     = LT.SCP_EXC_ITEM_ID
                  AND FT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND FT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND FT.ITEM_ID(+)     = LT.SCP_EXC_ITEM_ID
               ) XX
            ON ( XX.DIVISION_ID   = AA.DIVISION_ID
             AND XX.PLANT_SITE_ID = AA.PLANT_SITE_ID
             AND XX.ITEM_ID       = AA.ITEM_ID )
          WHEN MATCHED THEN
        UPDATE
           SET AA.LT_FORMATION          = CASE WHEN AA.DIVISION_ID IN ('81', '81_HM', '81_ST', '40') THEN AA.LT_FORMATION ELSE XX.LT END
                                         /*  2025.05.09   kimcd PJ2024A332 E20250403-001452 */
                                         /*  81, 81_HM, 81_ST, 40 은 lead time 갱신 제외 */
               /*  20190408 특성 수율 별도 처리 */
             , AA.FORMATION_YIELD       = NVL(XX.FORMATION_YIELD, 1)                         /*  활성화 수율 */
             , AA.CHAR_YIELD            = NVL(XX.CHAR_YIELD, 1)                              /*  특성 수율 */
             , AA.FORMATION_TOTAL_YIELD = NVL(XX.FORMATION_YIELD, 1) * NVL(XX.CHAR_YIELD, 1) /*  */
             , AA.LAST_UPDATED_BY       = 'COPY : Pilot'
             , AA.LAST_UPDATE_DATE      = SYSDATE;

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'UPDATE EXC ' || V_TABLE_ID;
        V_DESCRIPTION := 'COPY : Pilot...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------------- */
        /*  2-2. SCP_MST_FORMATION : UPDATE : 정상 라인 - Pilot 라인과 동일한 Site/Item 정보는 정상 라인 정보로 Update 됨 */
        /*       20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음 */
        /* --------------------------------------------------------- */

         MERGE
          INTO SCP_MST_FORMATION AA /*  attribute1은 설정값 유지 -- 활성화 추가 LT */
         USING (
               SELECT DISTINCT LT.DIVISION_ID
                    , LT.SCM_SITE_ID AS PLANT_SITE_ID
                    , LT.CELL_ASSY_ITEM_ID AS ITEM_ID
                    , LT.LT
                    , NVL(FT.YIELD, 1) AS FORMATION_YIELD
                    , NVL(TT.YIELD, 1) AS CHAR_YIELD
                 FROM ( SELECT B.DIVISION_ID
                             , B.SCM_SITE_ID
                             , MAX(B.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID
                             , B.CELL_ASSY_ITEM_ID
                             , CEIL(MIN(B.STANDARD_LT_DAY)) AS LT /*  올림 처리 */
                          FROM GT_SCP_MST_EXC_FORM_LINE B
                               /*  20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음 */
                         WHERE 1 = 1  /*  b.division_id <> '40'  -- 2025.05.09   kimcd PJ2024A332 E20250403-001452 */
                                      /*  81, 81_HM, 81_ST, 40 수율 반영하기 위해 조건 제거 */
                         GROUP BY B.DIVISION_ID, B.SCM_SITE_ID, B.CELL_ASSY_ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                        HAVING CEIL(MIN(B.STANDARD_LT_DAY)) > 0
                               /* HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경 */
                      ) LT
                      /*  특성 수율 */
                    , ( SELECT SCM_SITE_ID
                             , DIVISION_ID
                             , PLANT_ID
                             , ITEM_ID
                             , MONTH
                             , MAX(YIELD) YIELD
                        /* -- PJ20209642 변경
                         FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                                       END  AS scm_site_id
                        */
                          FROM ( SELECT T.PLANT_SITE_ID AS SCM_SITE_ID
                                      , OP.FLOW_ID
                                      , T.DIVISION_ID
                                      , T.PLANT_ID
                                      , T.ITEM_ID
                                      , T.MONTH    /*  yield 존재 구간 */
                                        /*  수율 0또는 NULL은 1로 처리함 */
                                      , MAX(CASE WHEN NVL(T.YIELD, 1) <= 0 THEN 1
                                                 WHEN NVL(T.YIELD, 1) >= 1 THEN 1
                                                 ELSE NVL(T.YIELD, 1)
                                            END
                                           ) AS YIELD /*  누적수율은 곱해야 하나 일단 MAX 값으로 처리함 */
                                   FROM SCM_MST_YIELD_VER_H_V   T /*  PJ20209642 변경 */
                                        /* FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK) */
                                      , SCM_MST_OPERATION_FLOW_V OP
                                  WHERE T.DIVISION_ID  = P_DIVISION_ID
                                    AND T.DIVISION_ID  = OP.DIVISION_ID
                                    AND T.COMPANY_ID   = OP.COMPANY_ID
                                    AND T.SITE_ID      = OP.SITE_ID
                                    AND T.OPERATION_ID = OP.OPERATION_ID
                                    /* AND    t.operation_id      = 'F6000' */
                                    AND T.OPERATION_ID IN (SELECT SEGMENT1 AS OPERATION_ID
                                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                            WHERE LOOKUP_TYPE = 'OPERATION_CHAR'
                                                              AND SEGMENT3    = 'Y' /*  Tact Time / yield 적용 대상 공정 */
                                                              AND VALID_YN    = 'Y'
                                                          ) /*  20181113 수정 */
                                    AND T.MONTH        = SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)
                                    AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) <> 'P' /*  2018.07.23 정상 라인 정보 */
                                  GROUP BY T.PLANT_SITE_ID, OP.FLOW_ID, T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID, T.MONTH
                               ) A
                         GROUP BY SCM_SITE_ID, DIVISION_ID, PLANT_ID, ITEM_ID, MONTH
                      ) TT
                      /*  20190408 활성화 수율 */
                    , ( SELECT T.PLANT_ID || '-A' AS SCM_SITE_ID
                             , T.DIVISION_ID
                             , T.PLANT_ID
                             , T.ITEM_ID
                               /*  수율 0또는 NULL은 1로 처리함 */
                             , MAX(CASE WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) <= 0 THEN 1
                                        WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) >= 1 THEN 1
                                        ELSE NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1)
                                   END
                                  ) AS YIELD
                          FROM SCM_MST_FORMATION_YIELD_SN T
                         WHERE T.DIVISION_ID = P_DIVISION_ID
                               /*    AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6) */
                           AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) <> 'P' /*  2018.07.23 정상 라인 정보 */
                         GROUP BY T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID/* , t.month */
                      ) FT
                WHERE TT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND TT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND TT.ITEM_ID(+)     = LT.SCP_EXC_ITEM_ID
                  AND FT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND FT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND FT.ITEM_ID(+)     = LT.SCP_EXC_ITEM_ID
               ) XX
            ON ( XX.DIVISION_ID   = AA.DIVISION_ID
             AND XX.PLANT_SITE_ID = AA.PLANT_SITE_ID
             AND XX.ITEM_ID       = AA.ITEM_ID )
          WHEN MATCHED THEN
        UPDATE
           SET AA.LT_FORMATION          = CASE WHEN AA.DIVISION_ID IN ('81', '81_HM', '81_ST', '40') THEN AA.LT_FORMATION ELSE XX.LT END
                                         /*  2025.05.09   kimcd PJ2024A332 E20250403-001452 */
                                         /*  81, 81_HM, 81_ST, 40 은 lead time 갱신 제외 */
               /*  20190408 특성 수율 별도 처리 */
             , AA.FORMATION_YIELD       = NVL(XX.FORMATION_YIELD, 1)                         /*  활성화 수율 */
             , AA.CHAR_YIELD            = NVL(XX.CHAR_YIELD, 1)                              /*  특성 수율 */
             , AA.FORMATION_TOTAL_YIELD = NVL(XX.FORMATION_YIELD, 1) * NVL(XX.CHAR_YIELD, 1) /*  */
             , AA.LAST_UPDATED_BY       = 'COPY : Line'
             , AA.LAST_UPDATE_DATE      = SYSDATE;

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := ' UPDATE EXC ' || V_TABLE_ID;
        V_DESCRIPTION := 'COPY : Line...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------------- */
        /*  3-1. SCP_MST_FORMATION : INSERT : EXC 품목 정상 라인 */
        /* --------------------------------------------------------- */

        INSERT
          INTO SCP_MST_FORMATION
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , ATTRIBUTE1 /*  20190408 char_yield / formation_total_yield 추가 */
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT XX.DIVISION_ID
             , XX.PLANT_SITE_ID
             , XX.ITEM_ID
             , XX.LT
               /*  20190408 특성 수율 별도 처리 */
             , NVL(XX.FORMATION_YIELD, 1)                         /*  활성화 수율 */
             , NVL(XX.CHAR_YIELD, 1)                              /*  특성 수율 */
             , NVL(XX.FORMATION_YIELD, 1) * NVL(XX.CHAR_YIELD, 1) /*  */
             , XX.ATTRIBUTE1
             , 'COPY : Line'    AS CREATED_BY
             , SYSDATE AS CREATION_DATE
             , 'COPY : Line'    AS LAST_UPDATED_BY
             , SYSDATE AS LAST_UPDATE_DATE
          FROM (
               SELECT DISTINCT LT.DIVISION_ID
                    , LT.SCM_SITE_ID AS PLANT_SITE_ID
                    , LT.CELL_ASSY_ITEM_ID AS ITEM_ID
                    , LT.LT
                    , NVL(FT.YIELD, 1) AS FORMATION_YIELD
                    , NVL(TT.YIELD, 1) AS CHAR_YIELD
                    , 0 AS ATTRIBUTE1 /*  활성화 추가 LT */
                 FROM ( SELECT B.DIVISION_ID
                             , B.SCM_SITE_ID
                             , MAX(B.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID
                             , B.CELL_ASSY_ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                             , CEIL(MIN(B.STANDARD_LT_DAY)) AS LT /*  올림 처리 */
                               /* , FLOOR(MIN(b.standard_lt_day)) AS lt -- 내림 처리  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경 */
                          FROM GT_SCP_MST_EXC_FORM_LINE B
                         GROUP BY B.DIVISION_ID, B.SCM_SITE_ID, B.CELL_ASSY_ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                        HAVING CEIL(MIN(B.STANDARD_LT_DAY)) > 0
                               /* HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경 */
                      ) LT
                      /*  특성 수율 */
                    , ( SELECT SCM_SITE_ID
                             , DIVISION_ID
                             , PLANT_ID
                             , ITEM_ID
                             , MONTH
                             , MAX(YIELD) YIELD
                        /* -- PJ20209642 변경
                         FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                                       END  AS scm_site_id
                        */
                          FROM ( SELECT T.PLANT_SITE_ID AS SCM_SITE_ID
                                      , OP.FLOW_ID
                                      , T.DIVISION_ID
                                      , T.PLANT_ID
                                      , T.ITEM_ID
                                      , T.MONTH    /*  yield 존재 구간 */
                                        /*  수율 0또는 NULL은 1로 처리함 */
                                      , MAX(CASE WHEN NVL(T.YIELD, 1) <= 0 THEN 1
                                                 WHEN NVL(T.YIELD, 1) >= 1 THEN 1
                                                 ELSE NVL(T.YIELD, 1)
                                            END
                                           ) AS YIELD /*  누적수율은 곱해야 하나 일단 MAX 값으로 처리함 */
                                   FROM SCM_MST_YIELD_VER_H_V   T /*  PJ20209642 변경 */
                                        /* FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK) */
                                      , SCM_MST_OPERATION_FLOW_V OP
                                  WHERE T.DIVISION_ID  = P_DIVISION_ID
                                    AND T.DIVISION_ID  = OP.DIVISION_ID
                                    AND T.COMPANY_ID   = OP.COMPANY_ID
                                    AND T.SITE_ID      = OP.SITE_ID
                                    AND T.OPERATION_ID = OP.OPERATION_ID
                                    /* AND    t.operation_id      = 'F6000' */
                                    AND T.OPERATION_ID IN (SELECT SEGMENT1 AS OPERATION_ID
                                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                            WHERE LOOKUP_TYPE = 'OPERATION_CHAR'
                                                              AND SEGMENT3    = 'Y' /*  Tact Time / yield 적용 대상 공정 */
                                                              AND VALID_YN    = 'Y'
                                                          ) /*  20181113 수정 */
                                    AND T.MONTH        = SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)
                                    AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) <> 'P' /*  2018.07.23 정상 라인 정보 */
                                  GROUP BY T.PLANT_SITE_ID, OP.FLOW_ID, T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID, T.MONTH
                               ) A
                         GROUP BY SCM_SITE_ID, DIVISION_ID, PLANT_ID, ITEM_ID, MONTH
                      ) TT
                      /*  20190408 활성화 수율 */
                    , ( SELECT T.PLANT_ID || '-A' AS SCM_SITE_ID
                             , T.DIVISION_ID
                             , T.PLANT_ID
                             , T.ITEM_ID
                               /*   , t.month    -- yield 존재 구간 */
                               /*  수율 0또는 NULL은 1로 처리함 */
                             , MAX(CASE WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) <= 0 THEN 1
                                        WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) >= 1 THEN 1
                                        ELSE NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1)
                                   END
                                  ) AS YIELD
                               /*        , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1 */
                               /* WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1 */
                               /*                   ELSE ISNULL(t.formation_total_yield, 1) */
                               /*              END */
                               /*             ) AS yield */
                          FROM SCM_MST_FORMATION_YIELD_SN T
                         WHERE T.DIVISION_ID = P_DIVISION_ID
                               /*    AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6) */
                           AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) <> 'P' /*  2018.07.23 정상 라인 정보 */
                         GROUP BY T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID/* , t.month */
                      ) FT
                WHERE TT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND TT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND TT.ITEM_ID(+)     = LT.SCP_EXC_ITEM_ID
                  AND FT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND FT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND FT.ITEM_ID(+)     = LT.SCP_EXC_ITEM_ID
               ) XX
         WHERE 1 = 1
           AND NOT EXISTS (SELECT 1
                             FROM SCP_MST_FORMATION X
                            WHERE X.DIVISION_ID   = XX.DIVISION_ID
                              AND X.PLANT_SITE_ID = XX.PLANT_SITE_ID
                              AND X.ITEM_ID       = XX.ITEM_ID
                          );

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT EXC ' || V_TABLE_ID;
        V_DESCRIPTION := 'COPY : Line...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------------- */
        /*  3-2. SCP_MST_FORMATION : INSERT : EXC Pilot 라인 - 정상 라인에 없는 정보만 Insert 됨 */
        /* --------------------------------------------------------- */

        INSERT
          INTO SCP_MST_FORMATION
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , ATTRIBUTE1 /*  20190408 char_yield / formation_total_yield 추가 */
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT XX.DIVISION_ID
             , XX.PLANT_SITE_ID
             , XX.ITEM_ID
             , XX.LT
               /*  20190408 특성 수율 별도 처리 */
             , NVL(XX.FORMATION_YIELD, 1)                         /*  활성화 수율 */
             , NVL(XX.CHAR_YIELD, 1)                              /*  특성 수율 */
             , NVL(XX.FORMATION_YIELD, 1) * NVL(XX.CHAR_YIELD, 1) /*  */
             , XX.ATTRIBUTE1
             , 'COPY : Pilot'    AS CREATED_BY
             , SYSDATE AS CREATION_DATE
             , 'COPY : Pilot'    AS LAST_UPDATED_BY
             , SYSDATE AS LAST_UPDATE_DATE
          FROM (
               SELECT DISTINCT LT.DIVISION_ID
                    , LT.SCM_SITE_ID AS PLANT_SITE_ID
                    , LT.CELL_ASSY_ITEM_ID AS ITEM_ID
                    , LT.LT
                    , NVL(FT.YIELD, 1) AS FORMATION_YIELD
                    , NVL(TT.YIELD, 1) AS CHAR_YIELD
                    , 0 AS ATTRIBUTE1 /*  활성화 추가 LT */
                 FROM ( SELECT B.DIVISION_ID
                             , B.SCM_SITE_ID
                             , MAX(B.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID
                             , B.CELL_ASSY_ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                             , CEIL(MIN(B.STANDARD_LT_DAY)) AS LT /*  올림 처리 */
                               /* , FLOOR(MIN(b.standard_lt_day)) AS lt -- 내림 처리  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경 */
                          FROM GT_SCP_MST_EXC_FORM_PILOT B
                         GROUP BY B.DIVISION_ID, B.SCM_SITE_ID, B.CELL_ASSY_ITEM_ID
                               /*  2018.08.22  Formation L/T 올림 처리 */
                        HAVING CEIL(MIN(B.STANDARD_LT_DAY)) > 0
                               /* HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경 */
                      ) LT
                      /*  특성 수율 */
                    , ( SELECT SCM_SITE_ID
                             , DIVISION_ID
                             , PLANT_ID
                             , ITEM_ID
                             , MONTH
                             , MAX(YIELD) YIELD
                        /* -- PJ20209642 변경
                         FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                                            WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                                       END  AS scm_site_id
                        */
                          FROM ( SELECT T.PLANT_SITE_ID AS SCM_SITE_ID
                                      , OP.FLOW_ID
                                      , T.DIVISION_ID
                                      , T.PLANT_ID
                                      , T.ITEM_ID
                                      , T.MONTH    /*  yield 존재 구간 */
                                        /*  수율 0또는 NULL은 1로 처리함 */
                                      , MAX(CASE WHEN NVL(T.YIELD, 1) <= 0 THEN 1
                                                 WHEN NVL(T.YIELD, 1) >= 1 THEN 1
                                                 ELSE NVL(T.YIELD, 1)
                                            END
                                           ) AS YIELD /*  누적수율은 곱해야 하나 일단 MAX 값으로 처리함 */
                                   FROM SCM_MST_YIELD_VER_H_V   T /*  PJ20209642 변경 */
                                        /* FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK) */
                                      , SCM_MST_OPERATION_FLOW_V OP
                                  WHERE T.DIVISION_ID  = P_DIVISION_ID
                                    AND T.DIVISION_ID  = OP.DIVISION_ID
                                    AND T.COMPANY_ID   = OP.COMPANY_ID
                                    AND T.SITE_ID      = OP.SITE_ID
                                    AND T.OPERATION_ID = OP.OPERATION_ID
                                    /* AND    t.operation_id      = 'F6000' */
                                    AND T.OPERATION_ID IN (SELECT SEGMENT1 AS OPERATION_ID
                                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                            WHERE LOOKUP_TYPE = 'OPERATION_CHAR'
                                                              AND SEGMENT3    = 'Y' /*  Tact Time / yield 적용 대상 공정 */
                                                              AND VALID_YN    = 'Y'
                                                          ) /*  20181113 수정 */
                                    AND T.MONTH        = SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)
                                    AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) = 'P' /*  2018.07.23 Pilot 라인 정보 */
                                  GROUP BY T.PLANT_SITE_ID, OP.FLOW_ID, T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID, T.MONTH
                               ) A
                         GROUP BY SCM_SITE_ID, DIVISION_ID, PLANT_ID, ITEM_ID, MONTH
                      ) TT
                      /*  20190408 활성화 수율 */
                    , ( SELECT T.PLANT_ID || '-A' AS SCM_SITE_ID
                             , T.DIVISION_ID
                             , T.PLANT_ID
                             , T.ITEM_ID
                               /*   , t.month    -- yield 존재 구간 */
                               /*  수율 0또는 NULL은 1로 처리함 */
                             , MAX(CASE WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) <= 0 THEN 1
                                        WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) >= 1 THEN 1
                                        ELSE NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1)
                                   END
                                  ) AS YIELD
                               /*        , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1 */
                               /* WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1 */
                               /*                   ELSE ISNULL(t.formation_total_yield, 1) */
                               /*              END */
                               /*             ) AS yield */
                          FROM SCM_MST_FORMATION_YIELD_SN T
                         WHERE T.DIVISION_ID = P_DIVISION_ID
                               /*    AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6) */
                           AND SUBSTR(T.LINE_ID, LENGTH(T.LINE_ID)-1, 1) = 'P' /*  2018.07.23 Pilot 라인 정보 */
                         GROUP BY T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID/* , t.month */
                      ) FT
                WHERE TT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND TT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND TT.ITEM_ID(+)     = LT.SCP_EXC_ITEM_ID
                  AND FT.DIVISION_ID(+) = LT.DIVISION_ID
                  AND FT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
                  AND FT.ITEM_ID(+)     = LT.SCP_EXC_ITEM_ID
               ) XX
         WHERE 1 = 1
           AND NOT EXISTS (SELECT 1
                             FROM SCP_MST_FORMATION X
                            WHERE X.DIVISION_ID   = XX.DIVISION_ID
                              AND X.PLANT_SITE_ID = XX.PLANT_SITE_ID
                              AND X.ITEM_ID       = XX.ITEM_ID
                          );

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT EXC ' || V_TABLE_ID;
        V_DESCRIPTION := 'COPY : Pilot...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /*  2025.09.27   kimcd          PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : */
        /*                                소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완 */
        /*                                활성화 관련 반제품은 Cell Assy로 변환하여 정보 형성 */
        /*                              추가 완료 */

        /* --------------------------------------------------------- */
        /*  4-1. SCP_MST_FORMATION : Default 입력 */
        /* --------------------------------------------------------- */
        INSERT
          INTO SCP_MST_FORMATION
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , ATTRIBUTE1 /*  20190408 char_yield / formation_total_yield 추가 */
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT DISTINCT LT.DIVISION_ID
             , LT.SCM_SITE_ID
             , LT.ITEM_ID
               /*  2018.05.31 소형 14일, 나머지 21일로 적용 */
               /*  20190423 [CSR ID:3979414] 소형 TCO Model은 DEFALUT 활성화 LT = 0 처리 */
             , CASE WHEN LT.DIVISION_ID = '40' AND TCO_CELL_YN = 'Y' THEN 0   /*  TCO Model은 Default 0 */
                    WHEN LT.DIVISION_ID = '40' AND TCO_CELL_YN = 'N' THEN 14  /*  Cell Model은 Default 14 */
                    ELSE 21
               END AS LT
               /* , CASE WHEN lt.division_id = '40' THEN 14 */
               /*        ELSE 21 */
               /*   END              AS lt */
               /*  20190408 특성 수율 별도 처리 */
             , NVL(FT.YIELD, 1) AS FORMATION_YIELD       /*  활성화 수율 */
             , NVL(TT.YIELD, 1) AS CHAR_YIELD            /*  특성 수율 */
             , NVL(FT.YIELD, 1) * NVL(TT.YIELD, 1) AS FORMATION_TOTAL_YIELD
               /* , ISNULL(tt.yield, 1) AS formation_yield -- 2018.06.19   Default Yield 처리 추가 */
             , 0 AS ATTRIBUTE1 /*  활성화 추가 LT */
             , 'DEFAULT' AS CREATED_BY
             , SYSDATE   AS CREATION_DATE
             , 'DEFAULT' AS LAST_UPDATED_BY
             , SYSDATE   AS LAST_UPDATE_DATE
          FROM ( SELECT DISTINCT SI.DIVISION_ID
                      , SI.SCM_SITE_ID
                      , SI.ITEM_ID
                      , S.SITE_ID
                   FROM SCM_MST_SITE_ITEM  SI
                      , SCM_MST_SITE       S
                      , SCP_MST_FINAL_ITEM I
                  WHERE SI.DIVISION_ID    = S.DIVISION_ID
                    AND SI.SCM_SITE_ID    = S.SCM_SITE_ID
                    AND SI.DIVISION_ID    = I.DIVISION_ID
                    AND SI.ITEM_ID        = I.ITEM_ID
                    AND SI.VALID_YN       = 'Y'
                    AND SI.DIVISION_ID    = P_DIVISION_ID
                    AND S.SITE_TYPE       = 'PLANT'
                    AND S.OPERATION_GROUP = 'A'
                    AND S.OSP_YN         <> 'Y'
                    AND RTRIM(S.ATTRIBUTE9) IS NULL /*  [PJ2025F254][LGES] JV법인 ESS 혼용 생산 시스템 개선 : 가상 사이트는 제외 (copy에서 생성) */
                                                    /*  원본 ISNULL(s.attribute9, '') = '' : Oracle 은 빈문자열이 NULL 이라 RTRIM(col) IS NULL 로 재현 */
                        /*  20230602  PJ20230691  활성화 대응 */
                        /* AND    SUBSTRING(si.item_id,2,1) = 'C'  --cell biz */
                    AND I.OPERATION_GROUP = 'A' /* cell */
                    AND I.ATTRIBUTE8      = 'CA1' /*  20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy */
                  MINUS
                 SELECT F.DIVISION_ID
                      , F.PLANT_SITE_ID AS SCM_SITE_ID
                      , F.ITEM_ID
                      , S.SITE_ID
                   FROM SCP_MST_FORMATION F
                      , SCM_MST_SITE      S
                  WHERE F.DIVISION_ID     = S.DIVISION_ID
                    AND F.PLANT_SITE_ID   = S.SCM_SITE_ID
                    AND F.DIVISION_ID     = P_DIVISION_ID
                    AND S.SITE_TYPE       = 'PLANT'
                    AND S.OPERATION_GROUP = 'A'
               ) LT
               /*  2018.06.19   Default Yield 처리 추가 */
               /*  특성 수율 */

             , ( SELECT SCM_SITE_ID
                      , DIVISION_ID
                      , PLANT_ID
                      , ITEM_ID
                      , MONTH
                      , MAX(YIELD) YIELD
                 /* -- PJ20209642 변경
                  FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                                END  AS scm_site_id
                 */
                   FROM ( SELECT T.PLANT_SITE_ID AS SCM_SITE_ID
                               , OP.FLOW_ID
                               , T.DIVISION_ID
                               , T.PLANT_ID
                               , T.ITEM_ID
                               , T.MONTH    /*  yield 존재 구간 */
                                 /*  수율 0또는 NULL은 1로 처리함 */
                               , MAX(CASE WHEN NVL(T.YIELD, 1) <= 0 THEN 1
                                          WHEN NVL(T.YIELD, 1) >= 1 THEN 1
                                          ELSE NVL(T.YIELD, 1)
                                     END
                                    ) AS YIELD /*  누적수율은 곱해야 하나 일단 MAX 값으로 처리함 */
                            FROM SCM_MST_YIELD_VER_H_V   T /*  PJ20209642 변경 */
                                 /* FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK) */
                               , SCM_MST_OPERATION_FLOW_V OP
                           WHERE T.DIVISION_ID  = P_DIVISION_ID
                             AND T.DIVISION_ID  = OP.DIVISION_ID
                             AND T.COMPANY_ID   = OP.COMPANY_ID
                             AND T.SITE_ID      = OP.SITE_ID
                             AND T.OPERATION_ID = OP.OPERATION_ID
                             /* AND    t.operation_id      = 'F6000' */
                             AND T.OPERATION_ID IN (SELECT SEGMENT1 AS OPERATION_ID
                                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                     WHERE LOOKUP_TYPE = 'OPERATION_CHAR'
                                                       AND SEGMENT3    = 'Y' /*  Tact Time / yield 적용 대상 공정 */
                                                       AND VALID_YN    = 'Y'
                                                   ) /*  20181113 수정 */
                             AND T.MONTH        = SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)
                           GROUP BY T.PLANT_SITE_ID, OP.FLOW_ID, T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID, T.MONTH
                        ) A
                  GROUP BY SCM_SITE_ID, DIVISION_ID, PLANT_ID, ITEM_ID, MONTH
               ) TT
               /*  20190408 활성화 수율 */
             , ( SELECT T.PLANT_ID || '-A' AS SCM_SITE_ID
                      , T.DIVISION_ID
                      , T.PLANT_ID
                      , T.ITEM_ID
                        /*   , t.month    -- yield 존재 구간 */
                        /*  수율 0또는 NULL은 1로 처리함 */
                      , MAX(CASE WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) <= 0 THEN 1
                                 WHEN NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1) >= 1 THEN 1
                                 ELSE NVL(NVL(T.USER_FORMATION_TOTAL_YIELD, T.FORMATION_TOTAL_YIELD), 1)
                            END
                           ) AS YIELD
                        /*        , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1 */
                        /* WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1 */
                        /*                   ELSE ISNULL(t.formation_total_yield, 1) */
                        /*              END */
                        /*             ) AS yield */
                   FROM SCM_MST_FORMATION_YIELD_SN T
                  WHERE T.DIVISION_ID = P_DIVISION_ID
                        /*    AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6) */
                  GROUP BY T.DIVISION_ID, T.PLANT_ID, T.ITEM_ID/* , t.month */
               ) FT
               /*  20190423 [CSR ID:3979414] 소형 TCO Model은 DEFALUT 활성화 LT = 0 처리 */
             , ( SELECT DIVISION_ID
                      , ITEM_ID
                      , MAX(FN_SCM_SYS_NVL(TCO_CELL_YN, 'N')) AS TCO_CELL_YN
                   FROM SCP_MST_FINAL_ITEM FI
                  WHERE FI.DIVISION_ID = '40' /*  소형만 적용  -- @p_division_id */
                  GROUP BY DIVISION_ID, ITEM_ID
               ) FI
         WHERE TT.DIVISION_ID(+) = LT.DIVISION_ID
           AND TT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
           AND TT.ITEM_ID(+)     = LT.ITEM_ID
           AND FT.DIVISION_ID(+) = LT.DIVISION_ID
           AND FT.SCM_SITE_ID(+) = LT.SCM_SITE_ID
           AND FT.ITEM_ID(+)     = LT.ITEM_ID
           AND FI.DIVISION_ID(+) = LT.DIVISION_ID
           AND FI.ITEM_ID(+)     = LT.ITEM_ID
        ;

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'DEFAULT...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------------- */
        /*  5-1. SCP_MST_FORMATION : CA1 -> CP Copy */
        /*   20230911 E20230908-001596  CA1 만 생성 후 CP 는 CA1 기준으로 Copy */
        /* --------------------------------------------------------- */
        /*  CA1 외 삭제 */
        DELETE
          FROM SCP_MST_FORMATION X
         WHERE 1 = 1
           AND X.DIVISION_ID = P_DIVISION_ID
           AND NOT EXISTS (SELECT 1
                             FROM SCP_MST_FINAL_ITEM FI
                            WHERE FI.ITEM_ID    = X.ITEM_ID
                              AND FI.ATTRIBUTE8 = 'CA1'
                          );

        /*  CA1 -> CP Copy */
        INSERT
          INTO SCP_MST_FORMATION
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
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
             , ATTRIBUTE10 )
        SELECT F.DIVISION_ID
             , F.PLANT_SITE_ID
             , M.ITEM_ID_PROD
             , F.LT_FORMATION
             , F.FORMATION_YIELD
             , F.CHAR_YIELD
             , F.FORMATION_TOTAL_YIELD
             , F.SSP_MODIFY_YIELD
             , F.CREATED_BY
             , F.CREATION_DATE
             , F.LAST_UPDATED_BY
             , F.LAST_UPDATE_DATE
             , F.ATTRIBUTE1
             , F.ATTRIBUTE2
             , F.ATTRIBUTE3
             , F.ATTRIBUTE4
             , F.ATTRIBUTE5
             , F.ATTRIBUTE6
             , F.ATTRIBUTE7
             , F.ATTRIBUTE8
             , F.ATTRIBUTE9
             , F.ATTRIBUTE10
          FROM SCP_MST_FORMATION F
             , ( SELECT C.DIVISION_ID
                      , C.ITEM_ID_ASSY
                      , MIN(C.ITEM_ID_PROD) AS ITEM_ID_PROD
                   FROM SCP_MST_CELL_PROD_ASSY_MAP C
                        /* INNER JOIN scp_mst_final_item f WITH(NOLOCK) */
                        /* ON  c.division_id  = f.division_id */
                        /* AND c.item_id_prod = f.item_id */
                        /* AND f.ATTRIBUTE8   = 'CP' */
                  WHERE C.DIVISION_ID = P_DIVISION_ID
                    AND C.CELL_TYPE   = 'CA1' /*  Cell 생산 계획 */
                    AND C.VALID_YN    = 'Y'
                  GROUP BY C.DIVISION_ID, C.ITEM_ID_ASSY
               ) M
         WHERE F.DIVISION_ID = M.DIVISION_ID
           AND F.ITEM_ID     = M.ITEM_ID_ASSY;

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'CA1 -> CP Copy...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* ---------------------------------------------------------------------------------------------------------------------------- */
        /*  6. Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화 */
        /* ---------------------------------------------------------------------------------------------------------------------------- */

        /* --------------------------------------------------- */
        /*  6.1 가상 Plant 사이트 대상 데이터 추출 */
        /* --------------------------------------------------- */


        DELETE
          FROM GT_SCP_MST_FORM_VIRTUAL_SITE;

        INSERT
          INTO GT_SCP_MST_FORM_VIRTUAL_SITE
             ( VS_DIVISION_ID
             , VS_PLANT_SITE_ID
             , VS_PLANT_ID
             , RS_DIVISION_ID
             , RS_PLANT_SITE_ID
             , RS_PLANT_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , ATTRIBUTE1
             , RN )
        SELECT VS.DIVISION_ID AS VS_DIVISION_ID
             , VS.SCM_SITE_ID AS VS_PLANT_SITE_ID
             , VS.PLANT_ID    AS VS_PLANT_ID
             , RS.DIVISION_ID AS RS_DIVISION_ID
             , RS.SCM_SITE_ID AS RS_PLANT_SITE_ID
             , RS.PLANT_ID    AS RS_PLANT_ID
             , RF.ITEM_ID
             , CAST(RF.LT_FORMATION          AS NUMBER(20,10)) AS LT_FORMATION
             , CAST(RF.FORMATION_YIELD       AS NUMBER(20,10)) AS FORMATION_YIELD
             , CAST(RF.CHAR_YIELD            AS NUMBER(20,10)) AS CHAR_YIELD
             , CAST(RF.FORMATION_TOTAL_YIELD AS NUMBER(20,10)) AS FORMATION_TOTAL_YIELD
             , CAST(RF.SSP_MODIFY_YIELD      AS NUMBER(20,10)) AS SSP_MODIFY_YIELD
             , RF.ATTRIBUTE1
             , ROW_NUMBER() OVER (PARTITION BY VS.DIVISION_ID, VS.SCM_SITE_ID, RF.ITEM_ID
                                      ORDER BY RF.LAST_UPDATE_DATE DESC) AS RN
          FROM SCM_MST_PLANT_SN   VP
             , SCM_MST_SITE       VS
             , SCM_MST_SITE       RS
             , SCP_MST_FORMATION  RF
         WHERE 1 = 1
           AND VS.DIVISION_ID   = VP.DIVISION_ID
           AND VS.PLANT_ID      = VP.PLANT_ID
           AND VS.SITE_TYPE     = 'PLANT'
           AND VS.VALID_YN      = 'Y'
           AND RS.SCM_SITE_ID   = VS.ATTRIBUTE9
           AND RS.PLANT_ID      = VP.LINK_PLANT_ID
           AND RS.SITE_TYPE     = 'PLANT'
           AND RS.VALID_YN      = 'Y'
           AND RF.DIVISION_ID   = RS.DIVISION_ID
           AND RF.PLANT_SITE_ID = RS.SCM_SITE_ID
           AND RS.DIVISION_ID   = P_DIVISION_ID /*  Real plant 기준 */
           AND VP.PLANT_TYPE    = 'VIRTUAL';

        /* --------------------------------------------------- */
        /*  6.2 가상 Plant 사이트 대상 이력 생성 (Update대상) */
        /* --------------------------------------------------- */
        INSERT
          INTO SCP_MST_FORMATION_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , HISTORY_CREATION_DATE )
        SELECT SEQ1_SCP_MST_FORMATION_H.NEXTVAL AS HISTORY_SEQ
             , TG.DIVISION_ID
             , TG.PLANT_SITE_ID
             , TG.ITEM_ID
             , TG.LT_FORMATION
             , TG.FORMATION_YIELD
             , TG.CHAR_YIELD
             , TG.FORMATION_TOTAL_YIELD
             , TG.SSP_MODIFY_YIELD
             , TG.CREATED_BY
             , TG.CREATION_DATE
             , TG.LAST_UPDATED_BY
             , TG.LAST_UPDATE_DATE
             , TG.ATTRIBUTE1
             , SYSDATE AS HISTORY_CREATION_DATE
          FROM SCP_MST_FORMATION           TG
             , GT_SCP_MST_FORM_VIRTUAL_SITE VF
         WHERE VF.VS_DIVISION_ID   = TG.DIVISION_ID
           AND VF.VS_PLANT_SITE_ID = TG.PLANT_SITE_ID
           AND VF.ITEM_ID          = TG.ITEM_ID
           AND VF.RN               = 1
           AND ( NVL(VF.LT_FORMATION, 0)          <> NVL(TG.LT_FORMATION, 0)
              OR NVL(VF.FORMATION_YIELD, 0)       <> NVL(TG.FORMATION_YIELD, 0)
              OR NVL(VF.CHAR_YIELD, 0)            <> NVL(TG.CHAR_YIELD, 0)
              OR NVL(VF.FORMATION_TOTAL_YIELD, 0) <> NVL(TG.FORMATION_TOTAL_YIELD, 0)
              OR NVL(VF.SSP_MODIFY_YIELD, 0)      <> NVL(TG.SSP_MODIFY_YIELD, 0)
              OR NVL(VF.ATTRIBUTE1, ' ')          <> NVL(TG.ATTRIBUTE1, ' ') );

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT INTO SCP_MST_FORMATION_H';
        V_DESCRIPTION := '6.2 가상 Plant 대상 데이터 이력 저장 (Update대상) ' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------- */
        /*  6.3 가상 Plant 사이트 대상 데이터 Update */
        /* --------------------------------------------------- */
        UPDATE SCP_MST_FORMATION TG
           SET (TG.LT_FORMATION, TG.FORMATION_YIELD, TG.CHAR_YIELD, TG.FORMATION_TOTAL_YIELD
              , TG.SSP_MODIFY_YIELD, TG.ATTRIBUTE1, TG.LAST_UPDATE_DATE, TG.LAST_UPDATED_BY) =
               (SELECT VF.LT_FORMATION
                     , VF.FORMATION_YIELD
                     , VF.CHAR_YIELD
                     , VF.FORMATION_TOTAL_YIELD
                     , VF.SSP_MODIFY_YIELD
                     , VF.ATTRIBUTE1
                     , SYSDATE
                     , 'COPY : Virtual'
                  FROM GT_SCP_MST_FORM_VIRTUAL_SITE VF
                 WHERE VF.VS_DIVISION_ID   = TG.DIVISION_ID
                   AND VF.VS_PLANT_SITE_ID = TG.PLANT_SITE_ID
                   AND VF.ITEM_ID          = TG.ITEM_ID
                   AND VF.RN               = 1
               )
         WHERE EXISTS (SELECT 1
                         FROM GT_SCP_MST_FORM_VIRTUAL_SITE VF
                        WHERE VF.VS_DIVISION_ID   = TG.DIVISION_ID
                          AND VF.VS_PLANT_SITE_ID = TG.PLANT_SITE_ID
                          AND VF.ITEM_ID          = TG.ITEM_ID
                          AND VF.RN               = 1
                          AND ( NVL(VF.LT_FORMATION, 0)          <> NVL(TG.LT_FORMATION, 0)
                             OR NVL(VF.FORMATION_YIELD, 0)       <> NVL(TG.FORMATION_YIELD, 0)
                             OR NVL(VF.CHAR_YIELD, 0)            <> NVL(TG.CHAR_YIELD, 0)
                             OR NVL(VF.FORMATION_TOTAL_YIELD, 0) <> NVL(TG.FORMATION_TOTAL_YIELD, 0)
                             OR NVL(VF.SSP_MODIFY_YIELD, 0)      <> NVL(TG.SSP_MODIFY_YIELD, 0)
                             OR NVL(VF.ATTRIBUTE1, ' ')          <> NVL(TG.ATTRIBUTE1, ' ') )
                      );

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'UPDATE SCP_MST_FORMATION';
        V_DESCRIPTION := '6.3 가상 Plant 대상 데이터 Update ' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* --------------------------------------------------- */
        /*  6.4 가상 Plant 사이트 대상 데이터 insert */
        /* --------------------------------------------------- */
        INSERT
          INTO SCP_MST_FORMATION
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1 )
        SELECT VF.VS_DIVISION_ID
             , VF.VS_PLANT_SITE_ID
             , VF.ITEM_ID
             , VF.LT_FORMATION
             , VF.FORMATION_YIELD
             , VF.CHAR_YIELD
             , VF.FORMATION_TOTAL_YIELD
             , VF.SSP_MODIFY_YIELD
             , 'COPY : Virtual' AS CREATED_BY
             , SYSDATE          AS CREATION_DATE
             , 'COPY : Virtual' AS LAST_UPDATED_BY
             , SYSDATE          AS LAST_UPDATE_DATE
             , VF.ATTRIBUTE1
          FROM GT_SCP_MST_FORM_VIRTUAL_SITE VF
         WHERE 1 = 1
           AND VF.RN = 1
           AND NOT EXISTS (SELECT 1
                             FROM SCP_MST_FORMATION TG
                            WHERE TG.DIVISION_ID   = VF.VS_DIVISION_ID
                              AND TG.PLANT_SITE_ID = VF.VS_PLANT_SITE_ID
                              AND TG.ITEM_ID       = VF.ITEM_ID
                          );

        /* TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT SCP_MST_FORMATION';
        V_DESCRIPTION := '6.4 가상 Plant 대상 데이터 insert ' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* ---------------------------------------------------------------------------------------------------------------------------- */
        /*  6. End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화 */
        /* ---------------------------------------------------------------------------------------------------------------------------- */

        DBMS_OUTPUT.PUT_LINE('프로시저 종료');

        /* --------------------------------------------------------- */
        /*  9. 종료 처리 */
        /* --------------------------------------------------------- */

        IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
            COMMIT;
        END IF;


        DELETE
          FROM GT_SCP_MST_FORMATION_PILOT;


        DELETE
          FROM GT_SCP_MST_FORMATION_LINE;

        /*  2025.09.27   kimcd          PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : */
        /*                                소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완 */
        /*                                추가된 임시 테이블 삭제 시작 */

        DELETE
          FROM GT_SCP_EXC_ITEM_ASSY_MAP;


        DELETE
          FROM GT_SCP_MST_EXC_FORM_PILOT;


        DELETE
          FROM GT_SCP_MST_EXC_FORM_LINE;
        /*  2025.09.27   kimcd          PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : */
        /*                                소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완 */
        /*                                추가된 임시 테이블 삭제 종료 */

        /*  원본 IF OBJECT_ID('TEMPDB..#SCP_MST_FORMATION_VIRTUAL_SITE') IS NOT NULL DROP TABLE #SCP_MST_FORMATION_VIRTUAL_SITE -- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 임시테이블 삭제 */
        DELETE
          FROM GT_SCP_MST_FORM_VIRTUAL_SITE;

        /* --------------------------------------------------------- */
        /*  실행 Logic END -- */
        /* --------------------------------------------------------- */

        /*  TXN LOG */
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD') || ' : ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;

        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

    EXCEPTION
        WHEN OTHERS THEN

            IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
                ROLLBACK;
            END IF;

            /*  ERROR LOG */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
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

    /*  종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );


END PR_SCP_MST_FORMATION_COPY_FROM_FP;