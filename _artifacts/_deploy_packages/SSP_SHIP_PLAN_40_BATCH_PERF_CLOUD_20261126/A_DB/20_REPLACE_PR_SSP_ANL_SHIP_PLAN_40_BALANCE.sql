-- SOURCE-FRESH: SCM_MGR.PR_SSP_ANL_SHIP_PLAN_40_BALANCE PROCEDURE LAST_DDL=2026-11-26 11:26:06 FETCHED=2026-11-26 11:26 DB=ZIOUI1
/* PR_SSP_ANL_SHIP_PLAN_40_BALANCE : 1단계 INSP_WIP, 3단계 WH_STOCK 행마다 재조회를 누적합으로 (E20261126-BALCUM) + dynamic_sampling 2 (E20261126-DS2)
 * 클라우드 원문이 사내 기준본과 같을 때만(줄 수 855, SUM(ORA_HASH(TEXT)) 1950206246293) 사내 적용본으로 교체.
 * 이미 반영(두 표식 있음)이면 SKIP. 원문이 다르면 -20011 로 중단(원문 무변경). 컴파일 실패면 원문 복원.
 * SCM_MGR 접속, 전체 실행(F5). Output 창 문구 확인 */
SET SERVEROUTPUT ON SIZE UNLIMITED
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;
DECLARE
    c_name CONSTANT VARCHAR2(128) := 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE';
    v_new  CLOB;
    v_old  CLOB;
    v_cnt  NUMBER;
    v_hash NUMBER;
    v_m1   NUMBER;
    v_m2   NUMBER;
    v_st   VARCHAR2(30);
    PROCEDURE ap(c IN OUT NOCOPY CLOB, t VARCHAR2) IS
    BEGIN
        IF t IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(t), t); END IF;
    END;
BEGIN
    SELECT COUNT(*), SUM(ORA_HASH(TEXT))
         , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-BALCUM') > 0 THEN 1 END)
         , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-DS2') > 0 THEN 1 END)
      INTO v_cnt, v_hash, v_m1, v_m2
      FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = c_name AND TYPE = 'PROCEDURE';
    IF v_m1 > 0 AND v_m2 > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  ' || c_name || ' 이미 반영됨');
        RETURN;
    END IF;
    IF v_cnt <> 855 OR v_hash <> 1950206246293 THEN
        RAISE_APPLICATION_ERROR(-20011, c_name || ' : 클라우드 원문이 사내 기준본과 다름(줄 ' || v_cnt || ', 해시 ' || v_hash || '). 원문 무변경. 클라우드 원문 전달 필요');
    END IF;
    DBMS_LOB.CREATETEMPORARY(v_old, TRUE);
    ap(v_old, 'CREATE OR REPLACE ');
    FOR r IN (SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = c_name AND TYPE = 'PROCEDURE' ORDER BY LINE) LOOP
        ap(v_old, r.TEXT);
    END LOOP;
    DBMS_LOB.CREATETEMPORARY(v_new, TRUE);
    ap(v_new, 'CREATE OR REPLACE ');
    ap(v_new, q'~PROCEDURE "PR_SSP_ANL_SHIP_PLAN_40_BALANCE"
/*
 * Program ID   : PR_SSP_ANL_SHIP_PLAN_40_BALANCE
 * Description  : 전일자 CUTOFF : CONFIRM수량 변경 시 해당 날짜 이후 BOH, BALANCE UPDATE.
 * OutTable     :
 * Execute      : EXEC PR_SSP_ANL_SHIP_PLAN_40_BALANCE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 <MEASURE>
	[S]SHIP_REQ(Shipment Request)    : MKT 담당자가 출하요청한 수량
	[S]SHIP_CONFIRM(Shipment Confirm): 출하 확정 수량
	[S]POSTP_PLAN(Post Process Plan) : 활성화 후 공정에서 필요로 Barecell 소요량(남경)
	[P]WH_IN(WH in Plan)             : 제품 창고 인계 계획,Production과 동일(사용자 수정 가능)
	[P]PROD_PLAN(Production)         : 조립실적+계획(활성화 L/T, 수율 적용)
	[P]PROD_DATE(Production Date)    : 조립완료일(실적완료일)
	[P]LOT(Lot)                      : SUBSTRIN(LOT_ID, 4,4)
	[P]INCO_WIP(Incomming WIP)       : 활성화 Aging 후 일자별 특성검사 가능재고로 넘어 올 수량(Remain Lead Time 기준 향후 특성검사가능 재고)
	[P]INSP_WIP(Inspection WIP)      : 특성 검사 가능 재고  당일 Inspection WIP : 전일 Inspection WIP + 당일 Incomming WIP - 전일 WH in Plan
    [I]MES_FCS_HOLD(Hold Stock)      : MES/FCS 재고중 출하불가 LOT수량(LOT_ID날짜에 L/T 고려)
	[I]MES_FCS_RELEASE(Release Stock): MES/FCS 재고중 출하불가 LOT수량에 대해 사용자가 지정된 Release 일자의 LOT수량
	[I]WH_STOC(Warehouse Stock)      : 당일 WH_STOC = OWMS 가용수량 , 익일 WH_STOC = 전일 WH_STOC + 전일WH_IN - 전일SHIP_CONFIRM - 전일POSTP_PLAN - 전일 MES_FCS_HOLD수량 + 전일 MES_FCS_RELEASE수량
	[I]BALANCE(Balance)              : 당일 Balance :  당일Warehouse Stock - 당일 Shipment Confirm -당일 POSTP_PLAN
 -------------------------------------------------------------------------------------------------------------------------------------------------
 * 2021.11.01   SSP Pjt.       Create.
 * 2022.05.11   SSP Pjt.       cutoff 0값 제거
 * 2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
 */
AS

    /* LOG 용 변수 설정 */
    V_BATCH_USER            VARCHAR2(150 CHAR) := 'ssp_batch';
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE';
    V_LOG_TYPE              VARCHAR2(30 CHAR);           /* START/END/ERROR/... */
    N_LOG_COUNT             INTEGER := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);          /* ▶ 상세설명 */
    V_TABLE_ID              VARCHAR2(150 CHAR) := 'SSP_ANL_SHIP_PLAN_40';  /* ▶ 테이블 필수 */
    D_EVENT_DATE            DATE;

    /* 임시 실행시간 확인용 */
    V_START_TIME            DATE;
    V_EXEC_TIME             VARCHAR2(10 CHAR) := '';      /* '[00:00]' */
    V_TOTAL_SEC             NUMBER;

    V_DIVISION_ID           VARCHAR2(30 CHAR) := '40';
    V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR) := '';
    V_PLAN_TYPE             VARCHAR2(50 CHAR) := 'SP';
    V_SEQ                   INTEGER := 1;

    V_DATA_START_YYYYMMDD   VARCHAR2(8 CHAR) := '';       /* BOH계산을 위한 기준 일자 */

    V_ERR_MSG               VARCHAR2(1000 CHAR);
BEGIN
    /* [E20261126-DS2] GTT(통계 없음) 행 수 추정용. 클라우드 optimizer_dynamic_sampling = 0 (2026-11-26 확인) */
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';
    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' SHIP_PLAN UPDATE LOGIC';
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );

    V_START_TIME := SYSDATE;


    BEGIN

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 0. temp 테이블 생성 : (Oracle: GTT GT_SSP_SHIP_UPD_BOH_40, 시작 시 DELETE 로 초기화) */
        /* ------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_SSP_SHIP_UPD_BOH_40;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 0. 최근 PLAN 정보 확인 : */
        /* ------------------------------------------------------------------------------------------------------------- */
        SELECT MAX(PLAN_START_YYYYMMDD)
             , MAX(PLAN_TYPE)
             , MAX(PLAN_SEQ)
          INTO V_PLAN_START_YYYYMMDD
             , V_PLAN_TYPE
             , V_SEQ
          FROM SSP_PLAN_VERSION_V
         WHERE 1 = 1
           AND DIVISION_ID          = V_DIVISION_ID
           AND PLAN_TYPE            = V_PLAN_TYPE
           AND CONFIRM_FLAG         = 'Y'
           AND PLAN_START_YYYYMMDD = (
                                     SELECT MAX(PLAN_START_YYYYMMDD)
                                       FROM SSP_PLAN_VERSION_V T
                                      WHERE T.DIVISION_ID  = V_DIVISION_ID
                                        AND T.PLAN_TYPE    = 'SP'
                                        AND T.CONFIRM_FLAG = 'Y'
                                        AND T.PLAN_START_YYYYMMDD < TO_CHAR(SYSDATE, 'YYYYMMDD')
                                     );

        /* WH_IN 및 BALANCE계산은 PLAN_START_YYYYMMDD 기준으로 수행 */
        V_DATA_START_YYYYMMDD := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 'YYYYMMDD');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 1. 변경날짜 이후  INSP_WIP  산출 : */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_SHIP_UPD_BOH_40 (
               DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , ITEM_ID
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , YYYYMMDD
             , BOD_ID
             , QTY
             , INCOTERMS
             , TRANSPORT_MODE
             , PROJECT_CODE
             , FCST_TYPE
             , CONFIRM_ID
             )
        WITH INSP AS (   /* INCO_WIP(Incomming WIP)의 BOH */
             SELECT DISTINCT
                    DIVISION_ID
                  , PLAN_START_YYYYMMDD
                  , PLAN_TYPE
                  , SEQ
                  , ITEM_ID
                  , FROM_SITE
                  , SUM(QTY) AS QTY
               FROM SSP_ANL_SHIP_PLAN_40
              WHERE 1 = 1
                AND DIVISION_ID          = V_DIVISION_ID
                AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                AND PLAN_TYPE            = V_PLAN_TYPE
                AND SEQ                  = V_SEQ
                AND YYYYMMDD             = V_DATA_START_YYYYMMDD
                AND MEASURE              = 'INCO_WIP'
              GROUP BY
                    DIVISION_ID
                  , PLAN_START_YYYYMMDD
                  , PLAN_TYPE
                  , SEQ
                  , ITEM_ID
                  , FROM_SITE
             )
           , Z AS (   /* [E20261126-BALCUM] 일자별 누적합을 Z 에서 1회 계산 */
             SELECT DIVISION_ID
                  , PLAN_START_YYYYMMDD
                  , PLAN_TYPE
                  , SEQ
                  , ITEM_ID
                  , FROM_SITE
                  , YYYYMMDD
                  , SUM(SUM(CASE WHEN MEASURE = 'INCO_WIP' AND YYYYMMDD > V_DATA_START_YYYYMMDD THEN NVL(QTY, 0) ELSE 0 END))
                        OVER (PARTITION BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE
                              ORDER BY YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)          AS INCO_CUM_QTY   /* 당일까지 INCO_WIP 합 */
                  , NVL(SUM(SUM(CASE WHEN MEASURE = 'WH_IN' THEN NVL(QTY, 0) ELSE 0 END))
                        OVER (PARTITION BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE
                              ORDER BY YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0)   AS WHIN_PREV_QTY  /* 전일까지 WH_IN 합 */
               FROM SSP_ANL_SHIP_PLAN_40
              WHERE 1 = 1
                AND DIVISION_ID          = V_DIVISION_ID
                AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                AND PLAN_TYPE            = V_PLAN_TYPE
                AND SEQ                  = V_SEQ
                AND YYYYMMDD            >= V_DATA_START_YYYYMMDD
                AND MEASURE              IN ( 'INCO_WIP' ,'WH_IN')
              GROUP BY
                    DIVISION_ID
                  , PLAN_START_YYYYMMDD
                  , PLAN_TYPE
                  , SEQ
                  , ITEM_ID
                  , FROM_SITE
                  , YYYYMMDD
             )
          SELECT
                 Z.DIVISION_ID
               , Z.PLAN_START_YYYYMMDD
               , Z.PLAN_TYPE
               , Z.SEQ
               , Z.ITEM_ID
               , Z.FROM_SITE
               , '-'        AS TO_SITE
               , 'INSP_WIP' AS MEASURE
               , Z.YYYYMMDD
               , '-'        AS BOD_ID
               , NVL(INSP.QTY,0)  /* INCO_WIP의 BOH */
                 +
                 /* [E20261126-BALCUM] 당일까지 INCO_WIP의 합 (종전 : Z 행마다 SSP_ANL_SHIP_PLAN_40 재조회) */
                 Z.INCO_CUM_QTY
                 +
                 /* 전일까지 WH_IN의 합 * -1 */
                 Z.WHIN_PREV_QTY * -1
               , '-'   AS INCOTERMS
               , '-'   AS TRANSPORT_MODE
               , '-'   AS PROJECT_CODE
               , '-'   AS FCST_TYPE
               , '-'   AS CONFIRM_ID
            FROM Z
               , INSP
           WHERE 1 = 1
             AND Z.DIVISION_ID          = INSP.DIVISION_ID(+)
             AND Z.PLAN_START_YYYYMMDD  = INSP.PLAN_START_YYYYMMDD(+)
             AND Z.PLAN_TYPE            = INSP.PLAN_TYPE(+)
             AND Z.SEQ                  = INSP.SEQ(+)
             AND Z.ITEM_ID              = INSP.ITEM_ID(+)
             AND Z.FROM_SITE            = INSP.FROM_SITE(+)
                ;

        /* TCO 모델은 WH_IN과 관계없이 전부 0으로 SETTING (2019.04.19 Requested by 김광희) 해당내용 변경시 PR_SSP_ANL_SHIP_PLAN_40 동시 변경필요 */
        UPDATE GT_SSP_SHIP_UPD_BOH_40 P
           SET P.QTY = 0
         WHERE P.MEASURE = 'INSP_WIP'
           AND EXISTS (
               SELECT 1
                 FROM SCP_MST_FINAL_ITEM F
                WHERE F.ITEM_ID      = P.ITEM_ID
                  AND F.DIVISION_ID  = P.DIVISION_ID
                  AND F.TCO_CELL_YN  = 'Y'
               )
            ;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2. UPDATE  INSP_WIP */
        /* ------------------------------------------------------------------------------------------------------------- */
        UPDATE SSP_ANL_SHIP_PLAN_40 P
           SET P.QTY  = (
                        SELECT C.QTY
                          FROM GT_SSP_SHIP_UPD_BOH_40 C
                         WHERE P.DIVISION_ID          = C.DIVISION_ID
                           AND P.PLAN_START_YYYYMMDD  = C.PLAN_START_YYYYMMDD
                           AND P.PLAN_TYPE            = C.PLAN_TYPE
                           AND P.SEQ                  = C.SEQ
                           AND P.ITEM_ID              = C.ITEM_ID
                           AND P.FROM_SITE            = C.FROM_SITE
                           AND P.TO_SITE              = C.TO_SITE
                           AND P.YYYYMMDD             = C.YYYYMMDD
                           AND P.BOD_ID               = C.BOD_ID
                           AND P.INCOTERMS            = C.INCOTERMS
                           AND P.TRANSPORT_MODE       = C.TRANSPORT_MODE
                           AND P.PROJECT_CODE         = C.PROJECT_CODE
                           AND P.FCST_TYPE            = C.FCST_TYPE
                           AND P.MEASURE              = C.MEASURE
                           AND NVL(P.CONFIRM_ID,'-')  = NVL(C.CONFIRM_ID,'-')
                        )
             , P.LAST_UPDATED_BY  = V_BATCH_USER
             , P.LAST_UPDATE_DATE = SYSTIMESTAMP
         WHERE 1 = 1
           AND P.DIVISION_ID          = V_DIVISION_ID
           AND P.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND P.PLAN_TYPE            = V_PLAN_TYPE
           AND P.SEQ                  = V_SEQ
           AND P.YYYYMMDD            >= V_DATA_START_YYYYMMDD
           AND P.MEASURE              = 'INSP_WIP'
           AND EXISTS (
               SELECT 1
                 FROM GT_SSP_SHIP_UPD_BOH_40 C
                WHERE P.DIVISION_ID          = C.DIVISION_ID
                  AND P.PLAN_START_YYYYMMDD  = C.PLAN_START_YYYYMMDD
                  AND P.PLAN_TYPE            = C.PLAN_TYPE
                  AND P.SEQ                  = C.SEQ
                  AND P.ITEM_ID              = C.ITEM_ID
                  AND P.FROM_SITE            = C.FROM_SITE
                  AND P.TO_SITE              = C.TO_SITE
                  AND P.YYYYMMDD             = C.YYYYMMDD
                  AND P.BOD_ID               = C.BOD_ID
                  AND P.INCOTERMS            = C.INCOTERMS
                  AND P.TRANSPORT_MODE       = C.TRANSPORT_MODE
                  AND P.PROJECT_CODE         = C.PROJECT_CODE
                  AND P.FCST_TYPE            = C.FCST_TYPE
                  AND P.MEASURE              = C.MEASURE
                  AND NVL(P.CONFIRM_ID,'-')  = NVL(C.CONFIRM_ID,'-')
               )
        ;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 3. 변경날짜 이후  WH_STOCK  산출 : */
        /*      당일 WH_STOC = OWMS 가용수량 */
        /*      익일 WH_STOC = 전일 WH_STOC + 전일WH_IN - 전일SHIP_CONFIRM - 전일POSTP_PLAN - 전일 MES_FCS_HOLD수량(MES/FCS) + 전일 MES_FCS_RELEASE수량(MES/FCS 사용자설정) */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_SHIP_UPD_BOH_40 (
               DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , ITEM_ID
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , YYYYMMDD
             , BOD_ID
             , QTY
             , INCOTERMS
             , TRANSPORT_MODE
             , PROJECT_CODE
             , FCST_TYPE
             , CONFIRM_ID
             )
        WITH BOH AS (   /* 수행시 최신 시점의 OWMS 재고정보 + B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 재고 수량 적용 (<--SSP_ANL_TCO_STOCK_C) */
             SELECT A.DIVISION_ID
                  , A.PLAN_START_YYYYMMDD
                  , A.PLAN_TYPE
                  , A.SEQ
                  , A.FROM_SITE
                  , A.ITEM_ID
                  , SUM(A.QTY)   AS QTY
               FROM (
                    SELECT A.DIVISION_ID
                         , A.PLAN_START_YYYYMMDD
                         , A.PLAN_TYPE
                         , A.SEQ
                         , A.FROM_SITE
                         , A.ITEM_ID
                         , (CASE WHEN NVL(C.SEGMENT3, '-') = 'P' THEN SUM(A.LOT_QTY_MES) ELSE 0 END) AS QTY

                      FROM SSP_ANL_MES_FCS_STOCK_40_C A
                           LEFT OUTER JOIN SCP_MST_FINAL_ITEM B
                        ON B.DIVISION_ID       = A.DIVISION_ID
                       AND B.ITEM_ID           = A.ITEM_ID
                           LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C
                        ON C.LOOKUP_TYPE       = 'CELL_TYPE_CODE'
                       AND C.VALID_YN          = 'Y'
                       AND C.SEGMENT1          = B.CELL_TYPE_GROUP_CODE
                     WHERE 1 = 1
                       AND A.DIVISION_ID         = V_DIVISION_ID
                       AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                       AND A.PLAN_TYPE           = V_PLAN_TYPE
                       AND A.SEQ                 = V_SEQ
                       AND A.AVAILABLE_YN <> 'N'
                       AND NVL(A.CHANGE_STATUS, '-') <> 'D'
                     GROUP BY
                           A.DIVISION_ID
                         , A.PLAN_START_YYYYMMDD
                         , A.PLAN_TYPE
                         , A.SEQ
                         , A.FROM_SITE
                         , A.ITEM_ID
                         , C.SEGMENT3

                     UNION ALL

                    SELECT A.DIVISION_ID
                         , A.PLAN_START_YYYYMMDD
                         , A.PLAN_TYPE
                         , A.SEQ
                         , A.FROM_SITE
                         , A.ITEM_ID
                         , SUM(A.AVAILABLE_QTY) AS QTY
                      FROM SSP_ANL_OWMS_STOCK_C A
                     WHERE 1 = 1
                       AND A.DIVISION_ID         = V_DIVISION_ID
                       AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                       AND A.PLAN_TYPE           = V_PLAN_TYPE
                       AND A.SEQ                 = V_SEQ
                     GROUP BY
                           A.DIVISION_ID
                         , A.PLAN_START_YYYYMMDD
                         , A.PLAN_TYPE
                         , A.SEQ
                         , A.FROM_SITE
                         , A.ITEM_ID

                    UNION ALL

                    /* STORAGE ID : B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 외주 재고 */
                    SELECT T.DIVISION_ID           AS DIVISION_ID
                         , T.PLAN_START_YYYYMMDD    AS PLAN_START_YYYYMMDD
                         , T.PLAN_TYPE              AS PLAN_TYPE
                         , T.SEQ                    AS SEQ
                         , T.SCM_SITE_ID            AS FROM_SITE
                         , T.ITEM_ID                AS ITEM_ID
                         , ROUND(SUM(T.QTY),0) AS  QTY
                      FROM SSP_ANL_TCO_STOCK_C T
                     GROUP BY
                           T.DIVISION_ID
                         , T.PLAN_START_YYYYMMDD
                         , T.PLAN_TYPE
                         , T.SEQ
                         , T.ITEM_ID
                         , T.SCM_SITE_ID
                    ) A
              WHERE 1 = 1
              GROUP BY
                    A.DIVISION_ID
                  , A.PLAN_START_YYYYMMDD
                  , A.PLAN_TYPE
                  , A.SEQ
                  , A.FROM_SITE
                  , A.ITEM_ID
             )
           , Z AS (   /* [E20261126-BALCUM] 전일까지 수량 변동 누적합을 Z 에서 1회 계산 */
             SELECT DIVISION_ID
                  , PLAN_START_YYYYMMDD
                  , PLAN_TYPE
                  , SEQ
                  , ITEM_ID
                  , FROM_SITE
                  , YYYYMMDD
                  , NVL(SUM(SUM(CASE MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * NVL(QTY, 0)
                                             WHEN 'POSTP_PLAN'      THEN -1 * NVL(QTY, 0)
                                             WHEN 'MES_FCS_HOLD'    THEN -1 * NVL(QTY, 0)
                                             WHEN 'WH_IN'           THEN      NVL(QTY, 0)
                                             WHEN 'MES_FCS_RELEASE' THEN      NVL(QTY, 0)
                                ELSE 0.0
                                END))
                        OVER (PARTITION BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE
                              ORDER BY YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0)   AS WHSTK_PREV_QTY  /* 전일까지 WH_IN, SHIP_CONFIRM 등 */
               FROM SSP_ANL_SHIP_PLAN_40
              WHERE 1 = 1
                AND DIVISION_ID         = V_DIVISION_ID         /* '81' */
                AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD /* '20180429' */
                AND PLAN_TYPE           = V_PLAN_TYPE           /* 'SP' */
                AND SEQ                 = V_SEQ                 /* '3' */
                AND MEASURE IN ( 'SHIP_CONFIRM' ,'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
                AND YYYYMMDD            >= V_DATA_START_YYYYMMDD
              GROUP BY
                    DIVISION_ID
                  , PLAN_START_YYYYMMDD
                  , PLAN_TYPE
                  , SEQ
                  , ITEM_ID
                  , FROM_SITE
                  , YYYYMMDD
             )
           , HD AS (   /* [E20261126-BALCUM] HOLD 재고 일자별 1회 집계 (종전 : Z 행마다 HOLD x 달력 재조회) */
             SELECT H.FROM_SITE
                  , H.ITEM_ID
                  , C.BASIS_YYYYMMDD
                  , SUM(H.HOLD_QTY) AS HOLD_QTY
               FROM SSP_ANL_HOLD_STOCK H
                  , SCM_SYS_CALENDAR_M C
              WHERE H.DIVISION_ID         = V_DIVISION_ID
                AND H.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                AND H.PLAN_TYPE           = V_PLAN_TYPE
                AND H.SEQ                 = V_SEQ
                AND C.BASIS_YYYYMMDD     >= H.HOLD_YYYYMMDD
                AND C.BASIS_YYYYMMDD     <= H.RELEASE_YYYYMMDD
                AND C.BASIS_YYYYMMDD     >= V_DATA_START_YYYYMMDD
                AND C.BASIS_YYYYMMDD     <= (SELECT MAX(Z2.YYYYMMDD) FROM Z Z2)
              GROUP BY
                    H.FROM_SITE
                  , H.ITEM_ID
                  , C.BASIS_YYYYMMDD
             )
        SELECT
               Z.DIVISION_ID
             , Z.PLAN_START_YYYYMMDD
             , Z.PLAN_TYPE
             , Z.SEQ
             , Z.ITEM_ID
             , Z.FROM_SITE
             , '-'         AS TO_SITE
             , 'WH_STOCK'  AS MEASURE
             , Z.YYYYMMDD
             , '-'         AS BOD_ID
             , /* CASE WHEN CONVERT(NVARCHAR(8), getdate(), 112) < Z.YYYYMMDD THEN */
               CASE WHEN V_PLAN_START_YYYYMMDD < Z.YYYYMMDD THEN
                    CASE WHEN (NVL(B.SEGMENT3, '-') = 'P') THEN
                              Z.WHSTK_PREV_QTY   /* [E20261126-BALCUM] 전일까지 WH_IN, SHIP_CONFIRM 등 (종전 : 행마다 재조회) */
                    ELSE
                              Z.WHSTK_PREV_QTY   /* [E20261126-BALCUM] 전일까지 WH_IN, SHIP_CONFIRM 등 (종전 : 행마다 재조회) */
                    END
               ELSE 0
               END
               +
               NVL(BOH.QTY,0)
               -
               /* 2020.09.09 KBK : 'DCP', 'MDP', 'MIP', 'MTP' 처리 */
               CASE WHEN V_DATA_START_YYYYMMDD <= Z.YYYYMMDD THEN
                    CASE WHEN NVL(B.SEGMENT3, '-') = 'P' THEN NVL(B.WH_IN_QTY2, 0)
                    ELSE 0
                    END
               ELSE 0
               END
               -
               NVL(HD.HOLD_QTY, 0)   /* HOLD재고 제외 [E20261126-BALCUM] */ AS QTY
             , '-'         AS INCOTERMS
             , '-'         AS TRANSPORT_MODE
             , '-'         AS PROJECT_CODE
             , '-'         AS FCST_TYPE
             , '-'         AS CONFIRM_ID
          FROM Z
             , BOH
             , HD
             , (
                               SELECT A.DIVISION_ID
                                    , A.PLAN_START_YYYYMMDD
                                    , A.PLAN_TYPE
                                    , A.SEQ
                                    , A.ITEM_ID
                                    , A.FROM_SITE
                                    , SUM(A.QTY)   AS WH_IN_QTY2
                                    , C.SEGMENT3

                                 FROM SSP_ANL_SHIP_PLAN_40 A
                                      LEFT OUTER JOIN SCP_MST_FINAL_ITEM B
                                   ON B.DIVISION_ID = A.DIVISION_ID
                                  AND B.ITEM_ID = A.ITEM_ID
                                      JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C
                                   ON C.LOOKUP_TYPE         = 'CELL_TYPE_CODE'
                                  AND C.VALID_YN            = 'Y'
                                  AND C.SEGMENT3            = 'P'
                                  AND C.SEGMENT1            = B.CELL_TYPE_GROUP_CODE
                                      JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D
                                   ON D.LOOKUP_TYPE         = 'POUCH_WH_IN_DAY'
                                  AND D.SEGMENT1            = SUBSTR(A.ITEM_ID, 1, 3)
                                  AND D.VALID_YN            = 'Y'
                                WHERE 1 = 1
                                  AND A.DIVISION_ID         = V_DIVISION_ID
                                  AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                  AND A.PLAN_TYPE           = V_PLAN_TYPE
                                  AND A.SEQ                 = V_SEQ
                                  AND A.MEASURE             = 'WH_IN'
                                  AND A.YYYYMMDD            > V_DATA_START_YYYYMMDD
                                  AND A.YYYYMMDD            <= TO_CHAR(TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD') + TO_NUMBER(D.SEGMENT2), 'YYYYMMDD')
                                GROUP BY
                                      A.DIVISION_ID
                                    , A.PLAN_START_YYYYMMDD
                                    , A.PLAN_TYPE
                                    , A.SEQ
                                    , A.ITEM_ID
                                    , A.FROM_SITE
                                    , C.SEGMENT3
               )  B
         WHERE 1 = 1
           AND Z.DIVISION_ID         = BOH.DIVISION_ID(+)
           AND Z.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD(+)
           AND Z.PLAN_TYPE           = BOH.PLAN_TYPE(+)
           AND Z.SEQ                 = BOH.SEQ(+)
           AND Z.ITEM_ID             = BOH.ITEM_ID(+)
           AND Z.FROM_SITE           = BOH.FROM_SITE(+)
           AND B.DIVISION_ID(+)          = Z.DIVISION_ID
           AND B.PLAN_START_YYYYMMDD(+)  = Z.PLAN_START_YYYYMMDD
           AND B.PLAN_TYPE(+)            = Z.PLAN_TYPE
           AND B.SEQ(+)                  = Z.SEQ
           AND B.ITEM_ID(+)              = Z.ITEM_ID
           AND B.FROM_SITE(+)            = Z.FROM_SITE
           AND HD.FROM_SITE(+)           = Z.FROM_SITE
           AND HD.ITEM_ID(+)             = Z.ITEM_ID
           AND HD.BASIS_YYYYMMDD(+)      = Z.YYYYMMDD
        ;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 4. UPDATE  WH_STOCK */
        /* ------------------------------------------------------------------------------------------------------------- */
        UPDATE SSP_ANL_SHIP_PLAN_40 P
           SET P.QTY  = (
                        SELECT C.QTY
                          FROM GT_SSP_SHIP_UPD_BOH_40 C
                         WHERE P.DIVISION_ID          = C.DIVISION_ID
                           AND P.PLAN_START_YYYYMMDD  = C.PLAN_START_YYYYMMDD
                           AND P.PLAN_TYPE            = C.PLAN_TYPE
                           AND P.SEQ                  = C.SEQ
                           AND P.ITEM_ID              = C.ITEM_ID
                           AND P.FROM_SITE            = C.FROM_SITE
                           AND P.TO_SITE              = C.TO_SITE
                           AND P.YYYYMMDD             = C.YYYYMMDD
                           AND P.BOD_ID               = C.BOD_ID
                           AND P.INCOTERMS            = C.INCOTERMS
                           AND P.TRANSPORT_MODE       = C.TRANSPORT_MODE
                           AND P.PROJECT_CODE         = C.PROJECT_CODE
                           AND P.FCST_TYPE            = C.FCST_TYPE
                           AND P.MEASURE              = C.MEASURE
                           AND NVL(P.CONFIRM_ID,'-')  = NVL(C.CONFIRM_ID,'-')
                        )
             , P.LAST_UPDATED_BY  = V_BATCH_USER
             , P.LAST_UPDATE_DATE = SYSTIMESTAMP
         WHERE 1 = 1
           AND P.DIVISION_ID          = V_DIVISION_ID
           AND P.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND P.PLAN_TYPE            = V_PLAN_TYPE
           AND P.SEQ                  = V_SEQ
           AND P.MEASURE              = 'WH_STOCK'
           AND P.YYYYMMDD            >= V_DATA_START_YYYYMMDD
           AND EXISTS (
               SELECT 1
                 FROM GT_SSP_SHIP_UPD_BOH_40 C
                WHERE P.DIVISION_ID          = C.DIVISION_ID
                  AND P.PLAN_START_YYYYMMDD  = C.PLAN_START_YYYYMMDD
                  AND P.PLAN_TYPE            = C.PLAN_TYPE
                  AND P.SEQ                  = C.SEQ
                  AND P.ITEM_ID              = C.ITEM_ID
                  AND P.FROM_SITE            = C.FROM_SITE
                  AND P.TO_SITE              = C.TO_SITE
                  AND P.YYYYMMDD             = C.YYYYMMDD
                  AND P.BOD_ID               = C.BOD_ID
                  AND P.INCOTERMS            = C.INCOTERMS
~');
    ap(v_new, q'~                  AND P.TRANSPORT_MODE       = C.TRANSPORT_MODE
                  AND P.PROJECT_CODE         = C.PROJECT_CODE
                  AND P.FCST_TYPE            = C.FCST_TYPE
                  AND P.MEASURE              = C.MEASURE
                  AND NVL(P.CONFIRM_ID,'-')  = NVL(C.CONFIRM_ID,'-')
               )
        ;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 5. UPDATE BALANCE */
        /* ------------------------------------------------------------------------------------------------------------- */
        UPDATE SSP_ANL_SHIP_PLAN_40 B
           SET B.QTY = (
                       SELECT BAL.QTY
                         FROM (
                              SELECT P.DIVISION_ID
                                   , P.PLAN_START_YYYYMMDD
                                   , P.PLAN_TYPE
                                   , P.SEQ
                                   , P.ITEM_ID
                                   , P.FROM_SITE
                                   , '-'             AS TO_SITE
                                   , 'BALANCE'       AS MEASURE
                                   , P.YYYYMMDD
                                   , '-'             AS BOD_ID
                                   , SUM(CASE WHEN P.MEASURE ='WH_STOCK'     THEN P.QTY ELSE 0 END )
                                   - SUM(CASE WHEN P.MEASURE ='SHIP_CONFIRM' THEN P.QTY ELSE 0 END )
                                   - SUM(CASE WHEN P.MEASURE ='POSTP_PLAN'   THEN P.QTY ELSE 0 END ) AS QTY
                                   , '-'             AS INCOTERMS
                                   , '-'             AS TRANSPORT_MODE
                                   , '-'             AS PROJECT_CODE
                                   , '-'             AS FCST_TYPE
                                   , '-'             AS CONFIRM_ID
                                FROM  SSP_ANL_SHIP_PLAN_40 P
                               WHERE 1 = 1
                                 AND P.DIVISION_ID          = V_DIVISION_ID
                                 AND P.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                                 AND P.PLAN_TYPE            = V_PLAN_TYPE
                                 AND P.SEQ                  = V_SEQ
                                 AND P.MEASURE              IN ('WH_STOCK', 'SHIP_CONFIRM', 'POSTP_PLAN')
                                 AND P.YYYYMMDD             >= V_DATA_START_YYYYMMDD
                               GROUP BY
                                     P.DIVISION_ID
                                   , P.PLAN_START_YYYYMMDD
                                   , P.PLAN_TYPE
                                   , P.SEQ
                                   , P.ITEM_ID
                                   , P.FROM_SITE
                                   , P.YYYYMMDD
                              ) BAL
                        WHERE BAL.DIVISION_ID          = B.DIVISION_ID
                          AND BAL.PLAN_START_YYYYMMDD  = B.PLAN_START_YYYYMMDD
                          AND BAL.PLAN_TYPE            = B.PLAN_TYPE
                          AND BAL.SEQ                  = B.SEQ
                          AND BAL.ITEM_ID              = B.ITEM_ID
                          AND BAL.FROM_SITE            = B.FROM_SITE
                          AND BAL.TO_SITE              = B.TO_SITE
                          AND BAL.YYYYMMDD             = B.YYYYMMDD
                          AND BAL.BOD_ID               = B.BOD_ID
                          AND BAL.INCOTERMS            = B.INCOTERMS
                          AND BAL.TRANSPORT_MODE       = B.TRANSPORT_MODE
                          AND BAL.PROJECT_CODE         = B.PROJECT_CODE
                          AND BAL.FCST_TYPE            = B.FCST_TYPE
                       )
             , B.LAST_UPDATED_BY  = V_BATCH_USER
             , B.LAST_UPDATE_DATE = SYSTIMESTAMP
         WHERE 1 = 1
           AND B.DIVISION_ID          = V_DIVISION_ID
           AND B.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND B.PLAN_TYPE            = V_PLAN_TYPE
           AND B.SEQ                  = V_SEQ
           AND B.MEASURE              = 'BALANCE'
           AND B.YYYYMMDD            >= V_DATA_START_YYYYMMDD
           AND EXISTS (
               SELECT 1
                 FROM (
                      SELECT P.DIVISION_ID
                           , P.PLAN_START_YYYYMMDD
                           , P.PLAN_TYPE
                           , P.SEQ
                           , P.ITEM_ID
                           , P.FROM_SITE
                           , '-'             AS TO_SITE
                           , P.YYYYMMDD
                           , '-'             AS BOD_ID
                           , '-'             AS INCOTERMS
                           , '-'             AS TRANSPORT_MODE
                           , '-'             AS PROJECT_CODE
                           , '-'             AS FCST_TYPE
                        FROM  SSP_ANL_SHIP_PLAN_40 P
                       WHERE 1 = 1
                         AND P.DIVISION_ID          = V_DIVISION_ID
                         AND P.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                         AND P.PLAN_TYPE            = V_PLAN_TYPE
                         AND P.SEQ                  = V_SEQ
                         AND P.MEASURE              IN ('WH_STOCK', 'SHIP_CONFIRM', 'POSTP_PLAN')
                         AND P.YYYYMMDD             >= V_DATA_START_YYYYMMDD
                       GROUP BY
                             P.DIVISION_ID
                           , P.PLAN_START_YYYYMMDD
                           , P.PLAN_TYPE
                           , P.SEQ
                           , P.ITEM_ID
                           , P.FROM_SITE
                           , P.YYYYMMDD
                      ) BAL
                WHERE BAL.DIVISION_ID          = B.DIVISION_ID
                  AND BAL.PLAN_START_YYYYMMDD  = B.PLAN_START_YYYYMMDD
                  AND BAL.PLAN_TYPE            = B.PLAN_TYPE
                  AND BAL.SEQ                  = B.SEQ
                  AND BAL.ITEM_ID              = B.ITEM_ID
                  AND BAL.FROM_SITE            = B.FROM_SITE
                  AND BAL.TO_SITE              = B.TO_SITE
                  AND BAL.YYYYMMDD             = B.YYYYMMDD
                  AND BAL.BOD_ID               = B.BOD_ID
                  AND BAL.INCOTERMS            = B.INCOTERMS
                  AND BAL.TRANSPORT_MODE       = B.TRANSPORT_MODE
                  AND BAL.PROJECT_CODE         = B.PROJECT_CODE
                  AND BAL.FCST_TYPE            = B.FCST_TYPE
               )
        ;

        /* ----------------------------------------------------------- */
        /* 실행 Logic END */
        /* ----------------------------------------------------------- */

        IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
            COMMIT;
        END IF;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 6. 0값 제거 */
        /* ------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM  SSP_ANL_SHIP_PLAN_40
        WHERE 1 = 1
        AND DIVISION_ID          = V_DIVISION_ID
        AND PLAN_START_YYYYMMDD   = V_PLAN_START_YYYYMMDD
        AND PLAN_TYPE            = V_PLAN_TYPE
        AND SEQ                  = V_SEQ
        AND QTY                  = 0
        ;

        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';    /* ▶ 로그타입 */

        N_LOG_COUNT   := 1;
        V_LOG_MESSAGE := 'INSERT INTO '||V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSTIMESTAMP;

        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );


        COMMIT;


    EXCEPTION
        WHEN OTHERS THEN

            IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
                ROLLBACK;
            END IF;

            /* ERROR LOG */
            V_ERR_MSG     := SQLERRM;
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := V_ERR_MSG;
            /* MSSQL STR(ERROR_LINE()) -> Oracle 에러 위치는 FORMAT_ERROR_BACKTRACE 로 캡. VARCHAR2(500) 초과 방지 SUBSTR */
            V_DESCRIPTION := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSTIMESTAMP;
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
    V_TOTAL_SEC := ROUND((CAST(SYSTIMESTAMP AS DATE) - V_START_TIME) * 86400);

    V_EXEC_TIME := CASE WHEN LENGTH(TO_CHAR(TRUNC(V_TOTAL_SEC / 60))) > 2 THEN NULL
                        ELSE LPAD(TO_CHAR(TRUNC(V_TOTAL_SEC / 60)), 2, '0') || ':' ||
                            LPAD(TO_CHAR(MOD(V_TOTAL_SEC, 60)), 2, '0')
                   END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '['||V_PROGRAM_NAME||']['|| V_EXEC_TIME ||']';
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );


END;~');
    BEGIN
        EXECUTE IMMEDIATE v_new;
    EXCEPTION
        WHEN OTHERS THEN NULL;   /* ORA-24344 컴파일 오류는 아래 STATUS 로 판정 */
    END;
    SELECT STATUS INTO v_st FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = c_name AND OBJECT_TYPE = 'PROCEDURE';
    IF v_st <> 'VALID' THEN
        BEGIN EXECUTE IMMEDIATE v_old; EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20012, c_name || ' : 컴파일 실패로 원문 복원함. ALL_ERRORS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY ' || c_name || ' · ' || v_st);
END;
/
