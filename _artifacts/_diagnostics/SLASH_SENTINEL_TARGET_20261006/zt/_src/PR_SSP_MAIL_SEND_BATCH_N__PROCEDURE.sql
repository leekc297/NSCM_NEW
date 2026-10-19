PROCEDURE PR_SSP_MAIL_SEND_BATCH_N
(
    P_COMPANY_ID1   IN  VARCHAR2
  , P_LOG_MESSGE    OUT VARCHAR2
)
/*
 * Program ID   : PR_SSP_MAIL_SEND_BATCH_N
 * Description  : SSP Mail 발송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/10/17   mcthej		  Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 * 2019/10/23   mcthej		  Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT - REAL DATA로 수정
 * 2019/10/28   mcThej          BOH = BOH + MES_TOTAL - (MES_OQC_NG + MES_QMS/MES_HOLD)
 * 2020/01/21   juhlee          [C20200121-000352]  ESS Packer출하 적용
 *                               - [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V)
 *                               - [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외)
 *                               - [C20200121-000352]-3 : Production Plan Measure에 Paker생산계획 추가(SCP_ANL_PRODUCTION_PLAN 의 PROD_PLAN_AMEND measure)
 * 2020/03/17   juhlee	        BOH 수량에 CMA_BMA 제외 (requested by 김광희)
 * 2020/07/09   juhlee         [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 전극 제외
 * 2022/02/08   SSP Pjt.       SSP_DNM_MES_STOCK_81_82 -> SSP_DNM_GMES_STOCK_81_82
 * 2022/04/01   SSP Pjt.       JV DIVISION_ID 적용
 * 2023/10/10   jilee          @v_body_contents 강제 삭제 문구 제외
 * 2026.07.06   ZIONEX      [PJ202650304] NextSCM Migration
 */
AS
    V_P_COMPANY_ID           VARCHAR2(10 CHAR);
    V_PLAN_START_YYYYMMDD    VARCHAR2(8 CHAR);
    V_FROM_YYYYMMDD          VARCHAR2(8 CHAR);
    V_TO_YYYYMMDD            VARCHAR2(8 CHAR);
    V_SITE_FROM_YYYYMMDD     VARCHAR2(8 CHAR);
    V_SITE_TO_YYYYMMDD       VARCHAR2(8 CHAR);
    V_BOH_YYYYMMDD           VARCHAR2(8 CHAR);
    V_STOCK_YYYYMMDD         VARCHAR2(8 CHAR);
    V_PROGRAM_ID             VARCHAR2(50 CHAR);
    V_SHEET_NAME             VARCHAR2(50 CHAR);


    V_D1                     VARCHAR2(8 CHAR);
    V_D2                     VARCHAR2(8 CHAR);
    V_D3                     VARCHAR2(8 CHAR);
    V_D4                     VARCHAR2(8 CHAR);
    V_D5                     VARCHAR2(8 CHAR);

    V_FROMSITE_CNT           NUMBER;
    V_FROMSITE_TMPCNT        NUMBER;
    V_RECEIVER_CNT           NUMBER;
    V_RECEIVER_TMPCNT        NUMBER;


    V_HEAD_CONT              CLOB;
    V_BODY_CONT              CLOB;
    V_TABLE_BODY             CLOB;

    V_BODY_CONTENTS          VARCHAR2(1000 CHAR);
    V_MAIL_TITLE             VARCHAR2(200 CHAR);
    V_TO_MAIL                VARCHAR2(400 CHAR);
    V_MAIL_RECEIVER          VARCHAR2(100 CHAR);
    V_CNT                    NUMBER;


    V_DIVISION_ID            VARCHAR2(100 CHAR);
    V_COMPANY_ID             VARCHAR2(100 CHAR);
    V_FROM_SITE_DESCRIPTION  VARCHAR2(100 CHAR);
    V_ITEM_ID                VARCHAR2(100 CHAR);
    V_NICK_NAME              VARCHAR2(100 CHAR);

    /* LOG 용 변수 */
    V_PROGRAM_NAME           VARCHAR2(150 CHAR) := 'PR_SSP_MAIL_SEND_BATCH_N';
    V_LOG_TYPE               VARCHAR2(30 CHAR);
    N_LOG_COUNT              INTEGER := 0;
    V_LOG_MESSAGE            VARCHAR2(1000 CHAR);
    V_DESCRIPTION            VARCHAR2(500 CHAR);
    D_EVENT_DATE             DATE;
    V_ERRMSG                 VARCHAR2(1000 CHAR);


    FUNCTION FMT_MONEY(P IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
        IF P IS NULL THEN
            RETURN NULL;
        END IF;
        /* [2026-10-07] 포맷마스크 자리수 확장 (사용자 승인).
         * TO_CHAR 는 값이 마스크 자리수를 넘으면 오류가 아니라 '###...###' 을 돌려준다.
         * 원본 MSSQL 은 CONVERT(VARCHAR, MONEY, 1) 로 제한이 없어(MONEY 상한 15자리) 큰 값에서 출력이 갈렸다.
         * 마스크를 넓혀도 12자리 이하 결과는 그대로다(FM 이 선행 0·공백을 지운다) — 회귀 위험 없음. */
        RETURN REPLACE(TO_CHAR(P, 'FM999,999,999,999,990.00'), '.00', '');
    END FMT_MONEY;
BEGIN
    V_P_COMPANY_ID := P_COMPANY_ID1;
    V_PROGRAM_ID   := 'SSP0021';
    V_SHEET_NAME   := 'Shipment Plan';

    /* Cutoff 전 Date 추출 */
    SELECT MAX(PLAN_START_YYYYMMDD)
      INTO V_PLAN_START_YYYYMMDD
      FROM SSP_MST_SHIP_PLAN_SCHEDULE
     WHERE 1 = 1
       AND ERP_STOCK_CUTOFF_YN = 'Y'
       AND OWMS_STOCK_CUTOFF_YN = 'Y'
       AND CURRENT_PLAN_DATE_YN = 'Y'
       AND COMPANY_ID = V_P_COMPANY_ID;

    V_FROM_YYYYMMDD  := V_PLAN_START_YYYYMMDD;
    V_TO_YYYYMMDD    := TO_CHAR(TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD') + 55, 'YYYYMMDD');  /* FROM +55일 */
    V_BOH_YYYYMMDD   := TO_CHAR(TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD') - 1,  'YYYYMMDD');  /* FROM -1일 */
    V_STOCK_YYYYMMDD := TO_CHAR(TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD') - 3,  'YYYYMMDD');  /* FROM -3일 */

    /* GTT 초기화(ON COMMIT PRESERVE ROWS 이므로 세션 잔존 방지) */
    DELETE FROM GT_SSP0021_BOH;
    DELETE FROM GT_SSP0021_ROW;
    DELETE FROM GT_SSP0021_RAW;
    DELETE FROM GT_SSP0021_R01;
    DELETE FROM GT_SSP0021_R02;
    DELETE FROM GT_SSP0021_MAIL;

    BEGIN
        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* ========================= 1. SHIPMENT BOH ========================= */
        INSERT INTO GT_SSP0021_BOH (DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, BOH_TYPE, BOH_QTY, SEQ)
        WITH MST_STOCK AS
        (
            SELECT DIVISION_ID, COMPANY_ID, SCM_SITE_ID, ITEM_ID, SSP_QTY, SCM_QTY, CUTOFF_DATE
                 , SITE_ID, STORAGE_ID, PLANT_ID, OPERATION_ID, STOCK_TYPE
              FROM SCM_DNM_STOCK_V
             WHERE 1 = 1
               AND COMPANY_ID = V_P_COMPANY_ID
               AND CUTOFF_DATE > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')   /* 현재일 - 3 */
               AND CUTOFF_DATE = TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD')
        ),
        /* [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) */
        PACKER_STOCK AS
        (
            SELECT DIVISION_ID, COMPANY_ID, SCM_SITE_ID, ITEM_ID, SSP_QTY, CUTOFF_DATE
              FROM SSP_DNM_ESS_PACKER_STOCK_V
             WHERE 1 = 1
               AND COMPANY_ID = V_P_COMPANY_ID
               AND CUTOFF_DATE > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')   /* 현재일 - 3 */
               AND CUTOFF_DATE = TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD')
        )
      , MST_LOCATION AS
        (
            SELECT TT0.DIVISION_ID, TT0.STORAGE_ID, TT0.SCM_SITE_ID, TT0.LOCATION_CODE, TT0.PLANT_ID, TT1.COMPANY_ID, TT0.VALID_YN
              FROM SSP_MST_LOCATION_V TT0
             INNER JOIN SCM_MST_SITE TT1
                ON TT0.DIVISION_ID = TT1.DIVISION_ID  AND TT0.SCM_SITE_ID = TT1.SCM_SITE_ID
               AND TT0.PLANT_ID = TT1.PLANT_ID        AND TT1.COMPANY_ID = V_P_COMPANY_ID
               AND TT1.VALID_YN = 'Y'                 AND TT1.SITE_TYPE = 'PLANT'
             WHERE 1 = 1
               AND TT0.VALID_YN = 'Y'
               AND TT1.COMPANY_ID = V_P_COMPANY_ID
               AND TT0.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING', 'CMA_BMA')
             GROUP BY TT0.DIVISION_ID, TT0.STORAGE_ID, TT0.SCM_SITE_ID, TT0.LOCATION_CODE, TT0.PLANT_ID, TT1.COMPANY_ID, TT0.VALID_YN
        )
        SELECT DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, BOH_TYPE, SUM(BOH_QTY) AS BOH_QTY, SEQ
          FROM
          (
              SELECT DIVISION_ID, FROM_SITE, ITEM_ID, BOH_TYPE, YYYYMMDD, SUM(BOH_QTY) AS BOH_QTY, SEQ
                FROM
                (
                    /* BOH : 5s */
                    SELECT T0.DIVISION_ID     AS DIVISION_ID
                         , T0.SCM_SITE_ID     AS FROM_SITE
                         , T0.ITEM_ID         AS ITEM_ID
                         , 'BOH'              AS BOH_TYPE
                         , TO_CHAR(T0.CUTOFF_DATE, 'YYYYMMDD') AS YYYYMMDD
                         , T0.SSP_QTY         AS BOH_QTY
                         , 1                  AS SEQ
                      FROM MST_STOCK T0
                     INNER JOIN MST_LOCATION T1
                        ON T0.DIVISION_ID = T1.DIVISION_ID    AND T0.STORAGE_ID = T1.STORAGE_ID
                       AND T0.PLANT_ID = T1.PLANT_ID          AND T0.COMPANY_ID = T1.COMPANY_ID
                       AND T0.SCM_SITE_ID = T1.SCM_SITE_ID
                       AND T1.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS')   /* 특성완료 이후 창고 */
                     WHERE 1 = 1
                    UNION ALL
                    /* MES TOTAL - (OQC_NG + QMS/MES_HOLD) */
                    SELECT T0.DIVISION_ID
                         , T0.FROM_SITE
                         , T0.ITEM_ID
                         , 'BOH'              AS BOH_TYPE
                         , T0.YYYYMMDD
                         , NVL(SUM(TOTAL) - (SUM(OQC_NG) + SUM(QMS_MES_HOLD)), 0) AS BOH_QTY
                         , 1                  AS SEQ
                      FROM
                      (
                          SELECT S.DIVISION_ID
                               , S.FROM_SITE
                               , S.ITEM_ID
                               , V_BOH_YYYYMMDD AS YYYYMMDD
                               , CASE WHEN S.AVAILABLE_YN = 'N' AND S.OQC_INSP_RESULT = 'N' THEN SUM(NVL(S.LOT_QTY, 0)) ELSE 0 END AS OQC_NG
                               , CASE WHEN S.AVAILABLE_YN = 'N' AND (S.QMS_HOLD_YN = 'Y' OR S.MES_HOLD_YN = 'Y') THEN SUM(NVL(S.LOT_QTY, 0)) ELSE 0 END AS QMS_MES_HOLD
                               , SUM(NVL(S.LOT_QTY, 0)) AS TOTAL
                            FROM SSP_DNM_GMES_STOCK_81_82 S
                            JOIN SCM_MST_DIVISION D
                              ON S.DIVISION_ID = D.DIVISION_ID
                           WHERE 1 = 1
                             AND S.COMPANY_ID = V_P_COMPANY_ID
                             AND D.ATTRIBUTE3 IN ('81', '82')
                             AND S.YYYYMMDD = V_PLAN_START_YYYYMMDD
                           GROUP BY S.DIVISION_ID, S.FROM_SITE, S.ITEM_ID, S.YYYYMMDD, S.AVAILABLE_YN, S.OQC_INSP_RESULT, S.MES_HOLD_YN, S.QMS_HOLD_YN
                      ) T0
                     GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD
                    UNION ALL
                    /* [C20200121-000352]-1 : ESS PACKER 재고 - BOH MEASURE */
                    SELECT T0.DIVISION_ID     AS DIVISION_ID
                         , T0.SCM_SITE_ID     AS FROM_SITE
                         , T0.ITEM_ID         AS ITEM_ID
                         , 'BOH'              AS BOH_TYPE
                         , TO_CHAR(T0.CUTOFF_DATE, 'YYYYMMDD') AS YYYYMMDD
                         , NVL(T0.SSP_QTY, 0) AS BOH_QTY
                         , 1                  AS SEQ
                      FROM PACKER_STOCK T0
                     WHERE 1 = 1
                       AND T0.COMPANY_ID = V_P_COMPANY_ID
                ) T0
               GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.BOH_TYPE, T0.YYYYMMDD, T0.SEQ
          ) TMP_BOH
         GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, BOH_TYPE, SEQ;

        /* ========================= 2. DATA ROW DATE ========================= */
        INSERT INTO GT_SSP0021_ROW (DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, PROJECT_CODE, MEASURE, SEQ, YYYYMMDD, QTY, CONFIRM_DAY, REQUESTOR)
        SELECT T0.DIVISION_ID
             , T0.ITEM_ID
             , T0.FROM_SITE
             , T0.TO_SITE
             , T0.PROJECT_CODE
             , T0.MEASURE
             , T0.SEQ
             , T0.YYYYMMDD
             , SUM(T0.QTY) AS QTY
             , CASE WHEN (T1.SHIP_FROZEN - 1) > 0 THEN (T1.SHIP_FROZEN - 1) ELSE 0 END AS CONFIRM_DAY
             , T0.REQUESTOR
          FROM
          (
              /* 2-1. Ship Req : 출하 요청(Plant향 Ship Req) / DM_PLN_SHIPMENT_REQ / MEASURE = 'SHIP_REQ' */
              SELECT T0.DIVISION_ID       AS DIVISION_ID
                   , T0.ITEM_ID           AS ITEM_ID
                   , T0.PLANT_SITE_ID     AS FROM_SITE
                   , T0.SCM_SITE_ID       AS TO_SITE
                   , T0.PROJECT_CODE      AS PROJECT_CODE
                   , 'SHIP_REQ'           AS MEASURE
                   , T0.YYYYMMDD          AS YYYYMMDD
                   , T0.QTY               AS QTY
                   , 1                    AS SEQ
                   , T0.LAST_UPDATED_BY   AS REQUESTOR
                FROM DM_PLN_SHIPMENT_REQ T0
               INNER JOIN SCM_MST_SITE ST1
                  ON T0.PLANT_SITE_ID = ST1.SCM_SITE_ID
                 AND T0.DIVISION_ID = ST1.DIVISION_ID
                 AND ST1.COMPANY_ID = V_P_COMPANY_ID
                 AND ST1.SITE_TYPE = 'PLANT'          AND ST1.VALID_YN = 'Y'
                JOIN SCM_MST_DIVISION D
                  ON T0.DIVISION_ID = D.DIVISION_ID
               WHERE 1 = 1
                 AND ST1.COMPANY_ID = V_P_COMPANY_ID
                 AND D.ATTRIBUTE3 IN ('81', '82')
                 AND T0.MEASURE = 'SHIP_REQ'
                 AND T0.YYYYMMDD >= V_FROM_YYYYMMDD
                 AND T0.YYYYMMDD <= V_TO_YYYYMMDD
                 AND T0.QTY > 0
              UNION ALL
              /* 2-2. Ship Plan : 출하 계획 / ssp_anl_ship_confirm + 확정구간 이후 Ship Req 합 / MEASURE = 'SHIP_PLAN' */
              SELECT T0.DIVISION_ID     AS DIVISION_ID
                   , T0.ITEM_ID         AS ITEM_ID
                   , T0.FROM_SITE       AS FROM_SITE
                   , T0.TO_SITE         AS TO_SITE
                   , T0.PROJECT_CODE    AS PROJECT_CODE
                   , T0.MEASURE         AS MEASURE
                   , T0.YYYYMMDD        AS YYYYMMDD
                   , NVL(SUM(T0.QTY), 0) AS QTY
                   , T0.SEQ             AS SEQ
                   , T0.REQUESTOR
                FROM
                (
                    /* 2) SSP(Daily) Plant향 Shipment Plan */
                    SELECT T0.DIVISION_ID
                         , T0.ITEM_ID
                         , T0.FROM_SITE
                         , T0.TO_SITE
                         , T0.PROJECT_CODE
                         , 'SHIP_PLAN'   AS MEASURE
                         , T0.YYYYMMDD
                         , T0.QTY
                         , 2             AS SEQ
                         , T0.REQUESTOR
                      FROM SSP_ANL_SHIP_CONFIRM T0
                      JOIN SCM_MST_DIVISION D
                        ON T0.DIVISION_ID = D.DIVISION_ID
                     WHERE 1 = 1
                       AND D.ATTRIBUTE3 IN ('81', '82')
                       AND T0.CHANGE_TYPE = 'C'
                       AND T0.BIZ_TYPE = 'E'   /* [PJ20199555] 전극 제외 */
                       AND T0.QTY > 0
                       AND T0.FROM_SITE_COMPANY_ID = V_P_COMPANY_ID
                       AND T0.YYYYMMDD >= V_FROM_YYYYMMDD
                       AND T0.YYYYMMDD <= V_TO_YYYYMMDD
                    UNION ALL
                    /* 확정구간 이후 Ship Req 수량 합 */
                    SELECT DIVISION_ID
                         , ITEM_ID
                         , FROM_SITE
                         , TO_SITE
                         , PROJECT_CODE
                         , MEASURE
                         , YYYYMMDD
                         , QTY
                         , SEQ
                         , NULL AS REQUESTOR
                      FROM
                      (
                          SELECT T0.DIVISION_ID     AS DIVISION_ID
                               , T0.ITEM_ID         AS ITEM_ID
                               , T0.PLANT_SITE_ID   AS FROM_SITE
                               , T0.SCM_SITE_ID     AS TO_SITE
                               , T0.PROJECT_CODE    AS PROJECT_CODE
                               , 'SHIP_PLAN'        AS MEASURE
                               , T0.YYYYMMDD        AS YYYYMMDD
                               , T0.QTY             AS QTY
                               , 2                  AS SEQ
                               , CASE WHEN NVL(FS.SHIP_FROZEN, 0) > 0 THEN TO_CHAR(TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD') + NVL(FS.SHIP_FROZEN, 0), 'YYYYMMDD') ELSE V_FROM_YYYYMMDD END AS FROZEN_YYYYMMDD   /* Ship Frozen구간 다음일자 */
                            FROM DM_PLN_SHIPMENT_REQ T0
                            JOIN SCM_MST_DIVISION D
                              ON T0.DIVISION_ID = D.DIVISION_ID
                           INNER JOIN SCM_MST_SITE FS
                              ON T0.PLANT_SITE_ID = FS.SCM_SITE_ID
                             AND T0.DIVISION_ID = FS.DIVISION_ID
                             AND FS.COMPANY_ID = V_P_COMPANY_ID
                             AND FS.SITE_TYPE = 'PLANT'
                             AND FS.VALID_YN = 'Y'
                           WHERE 1 = 1
                             AND FS.COMPANY_ID = V_P_COMPANY_ID
                             AND D.ATTRIBUTE3 IN ('81', '82')
                             AND T0.MEASURE = 'SHIP_REQ'
                             AND T0.YYYYMMDD >= V_FROM_YYYYMMDD
                             AND T0.YYYYMMDD <= V_TO_YYYYMMDD
                             AND T0.QTY > 0
                      ) T1
                     WHERE 1 = 1
                       AND YYYYMMDD > FROZEN_YYYYMMDD
                ) T0
               GROUP BY T0.DIVISION_ID, T0.ITEM_ID, T0.FROM_SITE, T0.TO_SITE, T0.PROJECT_CODE, T0.MEASURE, T0.YYYYMMDD, T0.SEQ, T0.REQUESTOR
              UNION ALL
              /* 2-4. PROD_PLAN : 생산 계획 / SSP_DNM_FP_PLAN_FROZEN / MEASURE = 'PROD_PLAN' */
              SELECT T0.DIVISION_ID
                   , T0.ITEM_ID
                   , T0.SCM_SITE_ID     AS FROM_SITE
                   , NULL               AS TO_SITE
                   , NULL               AS PROJECT_CODE
                   , 'PROD_PLAN'        AS MEASURE
                   , T0.PLAN_DATE       AS YYYYMMDD
                   , T0.PLAN_QTY        AS QTY
                   , 4                  AS SEQ
                   , NULL               AS REQUESTOR
                FROM SSP_DNM_FP_PLAN_FROZEN T0
               WHERE 1 = 1
                 AND T0.DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ('81', '82'))
                 /* [E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리 (2026-10-06 반영)
                  * MSSQL 원본은 2026-08-11 에 'PL500' 을 추가했는데 Oracle 변환본에 미반영이었다.
                  * 원본 AND T0.operation_id IN ('P5500','P9500','F5300','F5500','F5600','F6000') */
                 AND T0.OPERATION_ID IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000', 'PL500')
                 AND T0.PLAN_QTY > 0
                 AND T0.COMPANY_ID = V_P_COMPANY_ID
                 AND T0.PLAN_DATE >= V_FROM_YYYYMMDD
                 AND T0.PLAN_DATE <= V_TO_YYYYMMDD
                 AND T0.SITE_ID IN (SELECT DISTINCT SITE_ID
                                      FROM SCM_MST_SITE
                                     WHERE 1 = 1
                                       AND COMPANY_ID = V_P_COMPANY_ID
                                       AND SITE_TYPE = 'PLANT'
                                       AND VALID_YN = 'Y')
              UNION ALL
              /* [C20200121-000352]-3 : Packer 생산계획(SCP_ANL_PRODUCTION_PLAN 의 PROD_PLAN_AMEND) */
              SELECT P.DIVISION_ID
                   , P.ITEM_ID
                   , P.SCM_SITE_ID      AS FROM_SITE
                   , NULL               AS TO_SITE
                   , NULL               AS PROJECT_CODE
                   , 'PROD_PLAN'        AS MEASURE
                   , P.YYYYMMDD         AS YYYYMMDD
                   , P.QTY              AS QTY
                   , 4                  AS SEQ
                   , NULL               AS REQUESTOR
                FROM SCP_ANL_PRODUCTION_PLAN P
                JOIN
                (
                    SELECT A.DIVISION_ID
                         , A.PLAN_START_YYYYMMDD
                         , A.PLAN_TYPE
                         , A.PLAN_SEQ    AS SEQ
                      FROM SCP_PLAN_VERSION_V A
                     WHERE A.DIVISION_ID = '82'   /* ESS(82)만 적용 */
                       AND A.PLAN_CYCLE = 'WEEKLY'
                       AND A.PLAN_TYPE NOT IN ('TE', 'TM')
                     ORDER BY A.PLAN_START_YYYYMMDD DESC, A.PLAN_TYPE_ORDER DESC, A.PLAN_SEQ DESC
                     FETCH FIRST 1 ROWS ONLY
                ) V
                  ON V.DIVISION_ID = P.DIVISION_ID
                 AND V.PLAN_START_YYYYMMDD = P.PLAN_START_YYYYMMDD
                 AND V.PLAN_TYPE = P.PLAN_TYPE
                 AND V.SEQ = P.SEQ
                JOIN SCM_MST_SITE S
                  ON S.DIVISION_ID = P.DIVISION_ID
                 AND S.SCM_SITE_ID = P.SCM_SITE_ID
                 AND S.SITE_TYPE = 'PLANT'
                 AND S.VALID_YN = 'Y'
               WHERE P.DIVISION_ID = '82'   /* ESS(82)만 적용 */
                 AND S.COMPANY_ID = V_P_COMPANY_ID
                 AND P.MEASURE = 'PROD_PLAN_AMEND'
                 AND P.QTY > 0
                 AND P.YYYYMMDD >= V_FROM_YYYYMMDD
                 AND P.YYYYMMDD <= V_TO_YYYYMMDD
          ) T0
         INNER JOIN SCM_MST_SITE T1
            ON T1.COMPANY_ID = V_P_COMPANY_ID
           AND T0.DIVISION_ID = T1.DIVISION_ID
           AND T0.FROM_SITE = T1.SCM_SITE_ID
           AND T1.SITE_TYPE = 'PLANT'
           AND T1.VALID_YN = 'Y'
           AND T1.SHIP_FROZEN > 0
         WHERE 1 = 1
         GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.TO_SITE, T0.PROJECT_CODE, T0.ITEM_ID, T0.YYYYMMDD, T0.MEASURE, T0.SEQ, T1.SHIP_FROZEN, T0.REQUESTOR;

        /* ========================= 3. ITEM별 MEASURE 및 날짜 생성 → RAW ========================= */
        INSERT INTO GT_SSP0021_RAW
        (
            DIVISION_ID, FROM_SITE, TO_SITE, PROJECT_CODE, ITEM_ID, MEASURE, MEASURE_NAME, SEQ
          , CONFIRM_DAY, YYYYMMDD, QTY, REQUESTOR
        )
        SELECT T0.DIVISION_ID
             , T0.FROM_SITE
             , T1.TO_SITE
             , T1.PROJECT_CODE
             , T0.ITEM_ID
             , T0.MEASURE
             , T0.MEASURE_NAME
             , T0.SEQ
             , T0.CONFIRM_DAY
             , T0.YYYYMMDD
             , NVL(T1.QTY, 0) AS QTY
             , T1.REQUESTOR
          FROM
          (
              SELECT TT0.DIVISION_ID
                   , TT0.FROM_SITE
                   , TT0.ITEM_ID
                   , TT0.CONFIRM_DAY
                   , TT1.COLUMN_NAME       AS MEASURE
                   , TT1.COLUMN_LABEL_NAME AS MEASURE_NAME
                   , CASE WHEN TT1.COLUMN_NAME = 'PROD_PLAN' THEN 4 ELSE TT1.SORT_ORDER_NO END AS SEQ
                   , TT2.YYYYMMDD
                FROM GT_SSP0021_ROW TT0
                LEFT JOIN SCM_MST_SHEET_MEASURE TT1
                  ON TT1.PROGRAM_ID = V_PROGRAM_ID
                 AND TT1.SHEET_NAME = V_SHEET_NAME
                LEFT OUTER JOIN
                (
                    SELECT BASIS_YYYYMMDD AS YYYYMMDD
                         , ISO_WEEK
                      FROM SCM_SYS_CALENDAR_M
                     WHERE BASIS_YYYYMMDD >= V_FROM_YYYYMMDD AND BASIS_YYYYMMDD <= V_TO_YYYYMMDD
                ) TT2
                  ON TT2.YYYYMMDD >= V_FROM_YYYYMMDD AND TT2.YYYYMMDD <= V_TO_YYYYMMDD
               GROUP BY TT0.DIVISION_ID, TT0.FROM_SITE, TT0.ITEM_ID, TT1.COLUMN_NAME, TT1.COLUMN_LABEL_NAME, TT1.SORT_ORDER_NO, TT2.YYYYMMDD, TT0.CONFIRM_DAY
          ) T0
          LEFT OUTER JOIN GT_SSP0021_ROW T1
            ON T0.DIVISION_ID = T1.DIVISION_ID    AND T0.FROM_SITE = T1.FROM_SITE
           AND T0.ITEM_ID = T1.ITEM_ID            AND T0.MEASURE = T1.MEASURE
           AND T0.YYYYMMDD = T1.YYYYMMDD
          LEFT OUTER JOIN GT_SSP0021_BOH T2
            ON T0.DIVISION_ID = T2.DIVISION_ID    AND T0.FROM_SITE = T2.FROM_SITE
           AND T0.ITEM_ID = T2.ITEM_ID            AND T0.SEQ = T2.SEQ
         WHERE 1 = 1
           AND T0.MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'PROD_PLAN');

        /* ========================= 2-3. INTN_MOVEMENT ========================= */
        INSERT INTO GT_SSP0021_RAW
        (
            DIVISION_ID, FROM_SITE, ITEM_ID, MEASURE, MEASURE_NAME, SEQ, CONFIRM_DAY, YYYYMMDD, QTY
        )
        SELECT T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.MEASURE, T0.MEASURE_NAME, T0.SEQ, T0.CONFIRM_DAY, T0.YYYYMMDD, SUM(T0.QTY) AS QTY
          FROM
          (
              SELECT T0.DIVISION_ID
                   , T0.FROM_SITE
                   , T0.ITEM_ID
                   , 'INTN_MOVEMENT'    AS MEASURE
                   , 'Internal movement' AS MEASURE_NAME
                   , 3                  AS SEQ
                   , T0.CONFIRM_DAY
                   , T0.YYYYMMDD
                   , SUM(NVL(T1.QTY, 0)) AS QTY
                FROM GT_SSP0021_RAW T0
                LEFT OUTER JOIN
                (
                    SELECT P.DIVISION_ID
                         , FS.SCM_SITE_ID   AS FROM_SITE
                         , P.ITEM_ID
                         , TO_CHAR(P.PLAN_DATE, 'YYYYMMDD') AS YYYYMMDD
                         , NVL(P.QTY, 0)    AS QTY
                      FROM SCM_DNM_CELL_INHOUSE_PLAN_SN P
                     INNER JOIN SCM_MST_SITE FS
                        ON P.DIVISION_ID = FS.DIVISION_ID
                       AND P.PLANT_ID = FS.PLANT_ID
                       AND FS.COMPANY_ID = V_P_COMPANY_ID
                       AND FS.SITE_TYPE = 'PLANT'
                       AND FS.VALID_YN = 'Y'
                     WHERE 1 = 1
                       AND P.COMPANY_ID = V_P_COMPANY_ID
                       AND P.CATEGORY = 'MOVING'
                       AND P.PLAN_DATE >= TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD')
                       AND P.PLAN_DATE <= TO_DATE(V_TO_YYYYMMDD, 'YYYYMMDD')
                       AND P.QTY > 0
                ) T1
                  ON T0.DIVISION_ID = T1.DIVISION_ID    AND T0.FROM_SITE = T1.FROM_SITE
                 AND T0.ITEM_ID = T1.ITEM_ID            AND T0.YYYYMMDD = T1.YYYYMMDD
                 AND T0.MEASURE = 'SHIP_PLAN'
               GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD, T0.MEASURE, T0.SEQ, T0.CONFIRM_DAY
          ) T0
         GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.MEASURE, T0.MEASURE_NAME, T0.SEQ, T0.CONFIRM_DAY, T0.YYYYMMDD;

        /* ========================= 4-1. WH_STOCK ========================= */
        INSERT INTO GT_SSP0021_RAW
        (
            DIVISION_ID, FROM_SITE, ITEM_ID, MEASURE, MEASURE_NAME, SEQ, CONFIRM_DAY, YYYYMMDD, QTY
        )
        WITH WH_STOCK AS
        (
            SELECT DIVISION_ID
                 , FROM_SITE
                 , ITEM_ID
                 , TO_CHAR(TO_DATE(YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD') AS YYYYMMDD
                 , BOH_QTY AS BOH_QTY
              FROM GT_SSP0021_BOH
             WHERE 1 = 1
               AND BOH_TYPE = 'BOH'
               AND YYYYMMDD = V_BOH_YYYYMMDD
        )
      , DEDUPLICATION AS
        (
            SELECT DIVISION_ID
                 , FROM_SITE
                 , ITEM_ID
                 , YYYYMMDD
                 , CONFIRM_DAY
              FROM GT_SSP0021_RAW
             GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, CONFIRM_DAY
        )
        SELECT T0.DIVISION_ID
             , T0.FROM_SITE
             , T0.ITEM_ID
             , 'WH_STOCK'        AS MEASURE
             , 'Warehouse Stock' AS MEASURE_NAME
             , 5                 AS SEQ
             , T0.CONFIRM_DAY
             , T0.YYYYMMDD
             , (
                   SELECT NVL(
                              SUM(
                                  CASE
                                      WHEN TT0.MEASURE = 'SHIP_PLAN' THEN -1 * NVL(TT0.QTY, 0)
                                      WHEN TT0.MEASURE = 'INTN_MOVEMENT' THEN -1 * NVL(TT0.QTY, 0)
                                      WHEN TT0.MEASURE = 'PROD_PLAN' THEN NVL(TT0.QTY, 0)
                                  ELSE 0.0
                                  END)
                            , 0)
                     FROM GT_SSP0021_RAW TT0
                    WHERE 1 = 1
                      AND TT0.DIVISION_ID = T0.DIVISION_ID
                      AND TT0.FROM_SITE = T0.FROM_SITE
                      AND TT0.ITEM_ID = T0.ITEM_ID
                      AND TT0.MEASURE IN ('SHIP_PLAN', 'PROD_PLAN', 'INTN_MOVEMENT')
                      AND TT0.YYYYMMDD < T0.YYYYMMDD
               )
               + NVL(T1.BOH_QTY, 0) AS QTY
          FROM DEDUPLICATION T0
          LEFT OUTER JOIN WH_STOCK T1
            ON T0.DIVISION_ID = T1.DIVISION_ID    AND T0.FROM_SITE = T1.FROM_SITE
           AND T0.ITEM_ID = T1.ITEM_ID
         WHERE 1 = 1;

        /* ========================= 4-2. BALANCE ========================= */
        INSERT INTO GT_SSP0021_RAW
        (
            DIVISION_ID, FROM_SITE, ITEM_ID, MEASURE, MEASURE_NAME, SEQ, CONFIRM_DAY, YYYYMMDD, QTY
        )
        SELECT DIVISION_ID
             , FROM_SITE
             , ITEM_ID
             , 'BALANCE' AS MEASURE
             , 'Balance' AS MEASURE_NAME
             , 6 AS SEQ
             , CONFIRM_DAY
             , YYYYMMDD
             , NVL(
                   SUM(
                       CASE WHEN MEASURE = 'SHIP_PLAN' THEN -1 * NVL(QTY, 0)
                            WHEN MEASURE = 'WH_STOCK' THEN NVL(QTY, 0)
                       ELSE 0 END
                   ), 0) AS QTY
          FROM GT_SSP0021_RAW
         WHERE 1 = 1
           AND MEASURE IN ('SHIP_PLAN', 'WH_STOCK')
         GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, CONFIRM_DAY;


        INSERT INTO GT_SSP0021_R01
        (
            DIVISION_ID, FROM_SITE, TO_SITE, PROJECT_CODE, ITEM_ID, MEASURE, MEASURE_NAME, SEQ, CONFIRM_DAY, YYYYMMDD, QTY, REQUESTOR
        )
        SELECT T0.DIVISION_ID
             , T0.FROM_SITE
             , T0.TO_SITE
             , T0.PROJECT_CODE
             , T0.ITEM_ID
             , T0.MEASURE
             , T0.MEASURE_NAME
             , T0.SEQ
             , TO_CHAR(TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD') + NVL(T0.CONFIRM_DAY, 0), 'YYYYMMDD') AS CONFIRM_DAY
             , T0.YYYYMMDD
             , T0.QTY
             , T0.REQUESTOR
          FROM GT_SSP0021_RAW T0
         INNER JOIN SCM_MST_SITE FS
            ON FS.DIVISION_ID = T0.DIVISION_ID
           AND FS.SCM_SITE_ID = T0.FROM_SITE
           AND FS.OPERATION_GROUP <> 'E'   /* 전극 제외 [PJ20199555] */
         INNER JOIN SCM_SYS_CALENDAR_M T1
            ON T0.YYYYMMDD = T1.BASIS_YYYYMMDD
         WHERE T0.DIVISION_ID <> '40';      /* 소형 제외 */


        INSERT INTO GT_SSP0021_R02
        (
            TYPE, RN, MAIL_RECEIVER, DIVISION_ID, FROM_SITE, ITEM_ID, MEASURE, MEASURE_NAME, SEQ, YYYYMMDD, QTY
        )
        WITH RESULT_DATA AS
        (
            SELECT DENSE_RANK() OVER (ORDER BY T0.CONFIRM_DAY) AS RN
                 , T0.DIVISION_ID
                 , T0.FROM_SITE
                 , T0.TO_SITE
                 , T0.PROJECT_CODE
                 , T0.ITEM_ID
                 , T0.MEASURE
                 , T0.MEASURE_NAME
                 , T0.SEQ
                 , T0.CONFIRM_DAY
                 , T0.YYYYMMDD
                 , T0.QTY
                 , T0.REQUESTOR
              FROM GT_SSP0021_R01 T0
             WHERE 1 = 1
               AND T0.YYYYMMDD > T0.CONFIRM_DAY
               AND T0.YYYYMMDD <= TO_CHAR(TO_DATE(T0.CONFIRM_DAY, 'YYYYMMDD') + 5, 'YYYYMMDD')
               AND EXISTS
                   (
                       SELECT *
                         FROM GT_SSP0021_R01 B
                        WHERE 1 = 1
                          AND B.MEASURE = 'BALANCE'
                          AND B.YYYYMMDD > B.CONFIRM_DAY
                          AND B.YYYYMMDD <= TO_CHAR(TO_DATE(B.CONFIRM_DAY, 'YYYYMMDD') + 5, 'YYYYMMDD')
                          AND B.QTY < 0
                          AND B.DIVISION_ID = T0.DIVISION_ID
                          AND B.DIVISION_ID != '40'
                          AND B.FROM_SITE = T0.FROM_SITE
                          AND B.ITEM_ID = T0.ITEM_ID
                   )
               AND EXISTS
                   (
                       SELECT *
                         FROM GT_SSP0021_R01 B
                        WHERE 1 = 1
                          AND B.MEASURE IN ('SHIP_PLAN', 'SHIP_REQ')
                          AND B.YYYYMMDD > B.CONFIRM_DAY
                          AND B.YYYYMMDD <= TO_CHAR(TO_DATE(B.CONFIRM_DAY, 'YYYYMMDD') + 5, 'YYYYMMDD')
                          AND B.QTY > 0
                          AND B.DIVISION_ID = T0.DIVISION_ID
                          AND B.DIVISION_ID != '40'
                          AND B.FROM_SITE = T0.FROM_SITE
                          AND B.ITEM_ID = T0.ITEM_ID
                   )
               AND T0.DIVISION_ID != '40'
        )
        SELECT MAX(TYPE) AS TYPE
             , T0.RN
             , T0.MAIL_RECEIVER
             , T0.DIVISION_ID
             , T0.FROM_SITE
             , T0.ITEM_ID
             , T0.MEASURE
             , T0.MEASURE_NAME
             , T0.SEQ
             , T0.YYYYMMDD
             , SUM(T0.QTY) AS QTY
          FROM
          (
              SELECT DISTINCT
                     XX.TYPE
                   , XX.RN
                   , XX.MAIL_RECEIVER
                   , XX.DIVISION_ID
                   , XX.FROM_SITE
                   , XX.ITEM_ID
                   , XX.MEASURE
                   , XX.MEASURE_NAME
                   , XX.SEQ
                   , XX.YYYYMMDD
                   , XX.QTY
                FROM
                (
                    /* 1) WARNING_MAIL_SEND lookup */
                    SELECT '-'              AS TYPE
                         , X.RN
                         , M.SEGMENT2       AS MAIL_RECEIVER
                         , X.DIVISION_ID
                         , X.FROM_SITE
                         , X.ITEM_ID
                         , X.MEASURE
                         , X.MEASURE_NAME
                         , X.SEQ
                         , X.YYYYMMDD
                         , X.QTY
                      FROM RESULT_DATA X
                      JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M
                        ON M.LOOKUP_TYPE = 'WARNING_MAIL_SEND'
                       AND M.VALID_YN = 'Y'
                       AND M.SEGMENT3 = CASE WHEN M.SEGMENT3 = 'ALL' THEN 'ALL' ELSE X.FROM_SITE END
                    UNION ALL
                    /* 2) 법인간 거래 - TYPE = 'SCP' */
                    SELECT '-'              AS TYPE
                         , X.RN
                         , M.SEGMENT2       AS MAIL_RECEIVER
                         , X.DIVISION_ID
                         , X.FROM_SITE
                         , X.ITEM_ID
                         , X.MEASURE
                         , X.MEASURE_NAME
                         , X.SEQ
                         , X.YYYYMMDD
                         , X.QTY
                      FROM RESULT_DATA X
                      JOIN SCM_MST_SITE S
                        ON S.DIVISION_ID = X.DIVISION_ID
                       AND S.SCM_SITE_ID = X.TO_SITE
                       AND S.SITE_TYPE = 'PLANT'
                      JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M
                        ON M.LOOKUP_TYPE = 'WARNING_MAIL_SEND'
                       AND M.VALID_YN = 'Y'
                       AND M.SEGMENT1 = 'SCP'
                       AND M.SEGMENT3 = CASE WHEN M.SEGMENT3 = 'ALL' THEN 'ALL' ELSE X.FROM_SITE END
                    UNION ALL
                    /* 3) MKT OWNER (DIVISION_ID, ITEM_ID, TO_SITE) */
                    SELECT '-'              AS TYPE
                         , X.RN
                         , U.MKT_USER       AS MAIL_RECEIVER
                         , X.DIVISION_ID
                         , X.FROM_SITE
                         , X.ITEM_ID
                         , X.MEASURE
                         , X.MEASURE_NAME
                         , X.SEQ
                         , X.YYYYMMDD
                         , X.QTY
                      FROM RESULT_DATA X
                      JOIN
                      (
                          SELECT B.MKT_USER
                               , A.DIVISION_ID
                               , A.FROM_SITE
                               , A.ITEM_ID
                            FROM
                            (
                                SELECT DIVISION_ID
                                     , FROM_SITE
                                     , TO_SITE
                                     , ITEM_ID
                                     , PROJECT_CODE
                                  FROM RESULT_DATA
                                 WHERE 1 = 1
                                   AND MEASURE IN ('SHIP_PLAN', 'SHIP_REQ')
                            ) A
                            INNER JOIN SSP_MKT_USER_V B
                               ON B.DIVISION_ID = A.DIVISION_ID
                              AND B.TO_SITE = A.TO_SITE
                              AND B.ITEM_ID = A.ITEM_ID
                              AND B.PROJECT_CODE = A.PROJECT_CODE
                            GROUP BY B.MKT_USER, A.DIVISION_ID, A.FROM_SITE, A.ITEM_ID
                      ) U
                        ON U.DIVISION_ID = X.DIVISION_ID
                       AND U.FROM_SITE = X.FROM_SITE
                       AND U.ITEM_ID = X.ITEM_ID
                     GROUP BY X.RN, U.MKT_USER, X.DIVISION_ID, X.FROM_SITE, X.ITEM_ID, X.MEASURE, X.MEASURE_NAME, X.SEQ, X.YYYYMMDD, X.QTY
                    UNION ALL
                    /* 4) REQUESTOR */
                    SELECT '-'              AS TYPE
                         , X.RN
                         , P.REQUESTOR      AS MAIL_RECEIVER
                         , X.DIVISION_ID    AS DIVISION_ID
                         , X.FROM_SITE      AS FROM_SITE
                         , X.ITEM_ID        AS ITEM_ID
                         , X.MEASURE
                         , X.MEASURE_NAME
                         , X.SEQ
                         , X.YYYYMMDD
                         , X.QTY
                      FROM RESULT_DATA X
                      JOIN
                      (
                          SELECT REQUESTOR
                               , DIVISION_ID
                               , FROM_SITE
                               , ITEM_ID
                            FROM RESULT_DATA A
                           WHERE 1 = 1
                             AND MEASURE IN ('SHIP_PLAN', 'SHIP_REQ')
                             AND REQUESTOR IS NOT NULL
                           GROUP BY REQUESTOR, DIVISION_ID, FROM_SITE, ITEM_ID
                      ) P
                        ON P.DIVISION_ID = X.DIVISION_ID
                       AND P.FROM_SITE = X.FROM_SITE
                       AND P.ITEM_ID = X.ITEM_ID
/* 2026.09.30 AJS 수정 (START) */
--                     INNER JOIN TB_FX_USER U
--                        ON P.REQUESTOR = U.USERID
--                       AND U.USEYN = 'Y'
                     INNER JOIN SCM_ADM_USER_M U
                        ON P.REQUESTOR = U.USER_ID
                       AND U.USE_YN = 'Y'
/* 2026.09.30 AJS 수정 (END) */
                     WHERE 1 = 1
                ) XX
          ) T0
         WHERE 1 = 1
         GROUP BY T0.RN, T0.MAIL_RECEIVER, T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.MEASURE, T0.MEASURE_NAME, T0.SEQ, T0.YYYYMMDD;

        /* ========================= 6. FROM_SITE / RECEIVER 루프 → 메일 발송 ========================= */
        V_FROMSITE_TMPCNT := 0;
        SELECT MAX(RN) INTO V_FROMSITE_CNT FROM GT_SSP0021_R02;

        WHILE V_FROMSITE_TMPCNT < V_FROMSITE_CNT LOOP   /* FROM_SITE LOOP (NULL이면 종료) */
            DELETE FROM GT_SSP0021_MAIL;
            V_FROMSITE_TMPCNT := V_FROMSITE_TMPCNT + 1;

            /* FROM_YYYYMMDD / TO_YYYYMMDD (5일 윈도우) */
            SELECT MIN(YYYYMMDD) INTO V_SITE_FROM_YYYYMMDD FROM GT_SSP0021_R02 WHERE 1 = 1 AND RN = V_FROMSITE_TMPCNT;
            V_SITE_TO_YYYYMMDD := TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 4, 'YYYYMMDD');
            V_D1 := V_SITE_FROM_YYYYMMDD;
            V_D2 := TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD');
            V_D3 := TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 2, 'YYYYMMDD');
            V_D4 := TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 3, 'YYYYMMDD');
            V_D5 := TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 4, 'YYYYMMDD');


            INSERT INTO GT_SSP0021_MAIL
            (
                SITE_SEQ, REC_SEQ, ITEM_SEQ, MAIL_RECEIVER, DIVISION_ID, COMPANY_ID, FROM_SITE_DESCRIPTION
              , ITEM_ID, NICK_NAME, MEASURE_NAME, SEQ, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
            )
            SELECT RN AS SITE_SEQ
                 , DENSE_RANK() OVER (PARTITION BY RN ORDER BY RN, MAIL_RECEIVER) AS REC_SEQ
                 , DENSE_RANK() OVER (PARTITION BY RN, MAIL_RECEIVER ORDER BY RN, MAIL_RECEIVER, ITEM_ID) AS ITEM_SEQ
                 , MAIL_RECEIVER
                 , DIVISION_ID
                 , V_P_COMPANY_ID AS COMPANY_ID
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(DIVISION_ID, FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                 , ITEM_ID
                 , FN_GET_ITEM_NICKNAME(DIVISION_ID, ITEM_ID) AS NICK_NAME
                 , MEASURE_NAME
                 , SEQ
                 , SUM(CASE WHEN YYYYMMDD = V_D1 THEN QTY END) AS SEGMENT1
                 , SUM(CASE WHEN YYYYMMDD = V_D2 THEN QTY END) AS SEGMENT2
                 , SUM(CASE WHEN YYYYMMDD = V_D3 THEN QTY END) AS SEGMENT3
                 , SUM(CASE WHEN YYYYMMDD = V_D4 THEN QTY END) AS SEGMENT4
                 , SUM(CASE WHEN YYYYMMDD = V_D5 THEN QTY END) AS SEGMENT5
              FROM GT_SSP0021_R02
             WHERE 1 = 1
               AND RN = V_FROMSITE_TMPCNT
             GROUP BY RN, MAIL_RECEIVER, DIVISION_ID, FROM_SITE, ITEM_ID, MEASURE_NAME, SEQ;

            V_RECEIVER_TMPCNT := 0;
            SELECT MAX(REC_SEQ) INTO V_RECEIVER_CNT FROM GT_SSP0021_MAIL WHERE 1 = 1 AND SITE_SEQ = V_FROMSITE_TMPCNT;

            WHILE V_RECEIVER_TMPCNT < V_RECEIVER_CNT LOOP
                /* HEAD CONT */
                V_HEAD_CONT := '<tr>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'Div' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'Company' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'From Site' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'Model' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'Nick Name' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'Measure' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 0, 'YYYY-MM-DD') || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYY-MM-DD') || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 2, 'YYYY-MM-DD') || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 3, 'YYYY-MM-DD') || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 4, 'YYYY-MM-DD') || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '</tr>';

                /* [2026-10-07] 비운영에서는 제목에 'DEV Oracle 개발서버 ' 를 붙인다 (사용자 결정 가).
                 * 원본 MSSQL 은 이 건을 SCM_ADM_MAIL_SEND(행 17) 경유로 보내고 Oracle 행 17 에 같은 분기가 있는데,
                 * Oracle 은 PKG_SEND_MAIL 을 직접 불러(계보 평탄화) 그 표시가 빠졌다.
                 * 발송 동작은 원본 그대로 두고 식별만 되살린다 — 행 10·17 과 같은 판정식이다. */
                IF SYS_CONTEXT('USERENV', 'DB_NAME') NOT LIKE 'OCGSCMP%' THEN
                    V_MAIL_TITLE := 'DEV Oracle 개발서버 '||'[SSP_Early Warning] Shipping Schedule Nagative value';
                ELSE
                    V_MAIL_TITLE := '[SSP_Early Warning] Shipping Schedule Nagative value';
                END IF;
                V_BODY_CONTENTS := 'The Negative stock vlaue of shipping schedule based on the shipment request. Please refer to the table below and adjust the shipping request.'
                                   || CHR(10) || 'Thank you' || CHR(10) || 'Best regards.';
                V_BODY_CONT := EMPTY_CLOB();

                V_RECEIVER_TMPCNT := V_RECEIVER_TMPCNT + 1;
                V_CNT := 0;

                SELECT MAX(MAIL_RECEIVER)
                  INTO V_MAIL_RECEIVER
                  FROM GT_SSP0021_MAIL
                 WHERE 1 = 1
                   AND SITE_SEQ = V_FROMSITE_TMPCNT
                   AND REC_SEQ = V_RECEIVER_TMPCNT;

                V_TO_MAIL := V_MAIL_RECEIVER || '@lgensol.com';


                FOR R IN (
                    SELECT MAIL_RECEIVER, DIVISION_ID, COMPANY_ID, FROM_SITE_DESCRIPTION, ITEM_ID, NICK_NAME, MEASURE_NAME
                         , SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                      FROM GT_SSP0021_MAIL
                     WHERE 1 = 1
                       AND SITE_SEQ = V_FROMSITE_TMPCNT
                       AND REC_SEQ = V_RECEIVER_TMPCNT
                     ORDER BY MAIL_RECEIVER, DIVISION_ID, COMPANY_ID, FROM_SITE_DESCRIPTION, ITEM_ID, ITEM_SEQ
                ) LOOP

                    V_DIVISION_ID := R.DIVISION_ID;
                    V_COMPANY_ID := R.COMPANY_ID;
                    V_FROM_SITE_DESCRIPTION := R.FROM_SITE_DESCRIPTION;
                    V_ITEM_ID := R.ITEM_ID;
                    V_NICK_NAME := R.NICK_NAME;

                    IF V_CNT = 0 THEN
                        V_BODY_CONT := V_BODY_CONT || '<tr>';
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=''6''>' || REPLACE(R.DIVISION_ID, CHR(10), ' ') || '</td>';
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=''6''>' || REPLACE(R.COMPANY_ID, CHR(10), ' ') || '</td>';
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=''6''>' || REPLACE(R.FROM_SITE_DESCRIPTION, CHR(10), ' ') || '</td>';
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=''6''>' || REPLACE(R.ITEM_ID, CHR(10), ' ') || '</td>';
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=''6''>' || REPLACE(R.NICK_NAME, CHR(10), ' ') || '</td>';
                    END IF;
                    V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(R.MEASURE_NAME, CHR(10), ' ') || '</td>';
                    V_CNT := V_CNT + 1;

                    IF V_CNT = 6 THEN
                        V_CNT := 0;
                    END IF;

                    IF R.MEASURE_NAME = 'BALANCE' AND SIGN(R.SEGMENT1) = -1 THEN
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''> <font color = ''red''> ' || REPLACE(FMT_MONEY(R.SEGMENT1), CHR(10), ' ') || '</font></td>';
                    ELSE
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''>' || REPLACE(FMT_MONEY(R.SEGMENT1), CHR(10), ' ') || '</td>';
                    END IF;

                    IF R.MEASURE_NAME = 'BALANCE' AND SIGN(R.SEGMENT2) = -1 THEN
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''> <font color = ''red''> ' || REPLACE(FMT_MONEY(R.SEGMENT2), CHR(10), ' ') || '</font></td>';
                    ELSE
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''>' || REPLACE(FMT_MONEY(R.SEGMENT2), CHR(10), ' ') || '</td>';
                    END IF;

                    IF R.MEASURE_NAME = 'BALANCE' AND SIGN(R.SEGMENT3) = -1 THEN
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''> <font color = ''red''> ' || REPLACE(FMT_MONEY(R.SEGMENT3), CHR(10), ' ') || '</font></td>';
                    ELSE
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''>' || REPLACE(FMT_MONEY(R.SEGMENT3), CHR(10), ' ') || '</td>';
                    END IF;

                    IF R.MEASURE_NAME = 'BALANCE' AND SIGN(R.SEGMENT4) = -1 THEN
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''> <font color = ''red''> ' || REPLACE(FMT_MONEY(R.SEGMENT4), CHR(10), ' ') || '</font></td>';
                    ELSE
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''>' || REPLACE(FMT_MONEY(R.SEGMENT4), CHR(10), ' ') || '</td>';
                    END IF;

                    IF R.MEASURE_NAME = 'BALANCE' AND SIGN(R.SEGMENT5) = -1 THEN
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''> <font color = ''red''> ' || REPLACE(FMT_MONEY(R.SEGMENT5), CHR(10), ' ') || '</font></td>';
                    ELSE
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''>' || REPLACE(FMT_MONEY(R.SEGMENT5), CHR(10), ' ') || '</td>';
                    END IF;
                    V_BODY_CONT := V_BODY_CONT || '</tr>';
                END LOOP;

                V_TABLE_BODY := ' <html>
									<head>
											<title>Untitled Document</title>
											<style>
												* {margin:0;padding:0;}
												body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
												table {border-collapse:collapse;width:100%;}
												table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
												table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
												table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}
												table tbody td {padding:6px 8px;font-size:12px}
												table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
												.hori-table table thead td {text-align:center;padding:3px;}
												.hori-table table tbody td {text-align:center;padding:3px;}
												.vertical-table, .hori-table {margin-bottom:20px;}
											</style>
											</head>
											<body>' || '</br>' ||
													'<b>' || REPLACE(V_BODY_CONTENTS, CHR(10), '<br>') || '</b>' ||
													'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">' ||
												'<table style=''border-top:2px solid #c8294b; width:1000px;''>
												<thead>' || V_HEAD_CONT || '</thead>
												<tbody>' || V_BODY_CONT || '</tbody>
												</div>
											</body>
									</html>';


                PKG_SEND_MAIL.P_SEND_MAIL(V_TO_MAIL, V_MAIL_TITLE, DBMS_LOB.SUBSTR(V_TABLE_BODY, 32767, 1), 'Y');

                /* MAIL 발송 LOG 저장 */
                SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG(
                    'MAIL', 0 , V_PROGRAM_NAME, V_DIVISION_ID, V_COMPANY_ID, V_FROM_SITE_DESCRIPTION,
                    V_ITEM_ID, V_NICK_NAME, '', '', '', '', '', V_TO_MAIL);
            END LOOP;
        END LOOP;


        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);


        DELETE FROM GT_SSP0021_BOH;
        DELETE FROM GT_SSP0021_ROW;
        DELETE FROM GT_SSP0021_RAW;
        DELETE FROM GT_SSP0021_R01;
        DELETE FROM GT_SSP0021_R02;
        DELETE FROM GT_SSP0021_MAIL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERRMSG := SUBSTR(SQLERRM, 1, 1000);

            /* 에러 로그 적재(원본 패턴 : scm_sys_log_batch 직접 INSERT) */
            INSERT INTO SCM_SYS_LOG_BATCH
            (
                PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
              , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY
            )
            VALUES
            (
                V_PROGRAM_NAME, 'ERROR', NULL, V_ERRMSG, NULL
              , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME
            );

            /* MAIL 발송 LOG 저장(ERROR) */
            SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG(
                'ERROR', 0 , V_PROGRAM_NAME, 'MAIN ERROR', '', '', '', '', '', '', '', '', V_ERRMSG, '');


            DBMS_OUTPUT.PUT_LINE('F');
            DBMS_OUTPUT.PUT_LINE('[' || TO_CHAR(SQLCODE) || ']' || SQLERRM);

            P_LOG_MESSGE := V_ERRMSG;
            RETURN;
    END;
END PR_SSP_MAIL_SEND_BATCH_N;