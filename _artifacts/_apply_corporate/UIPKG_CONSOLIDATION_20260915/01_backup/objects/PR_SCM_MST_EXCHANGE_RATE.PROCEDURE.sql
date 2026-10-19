-- SOURCE-FRESH: SCM_MGR.PR_SCM_MST_EXCHANGE_RATE PROCEDURE LAST_DDL=2026-09-02 17:30:37 FETCHED=2026-09-15 18:50 DB=ZIOUI1
-- STEP 1 BACKUP (원복용 원문 · STATUS=VALID)
SET DEFINE OFF
CREATE OR REPLACE PROCEDURE SCM_MGR."PR_SCM_MST_EXCHANGE_RATE" 
(
      P_BATCH_YN  VARCHAR2 DEFAULT 'Y'  /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가하여 배치수행/화면수행 구분 */
)
/*
    * Program ID   : PR_SCM_MST_EXCHANGE_RATE
    * Description  : Chempion 환율 I/F Procedure
    * PARAMETER    : N/A
    * DESCRIPTION  : Chempion 환율 I/F
    * I/F Table    : XIF_GSC_MOVE_EXCHANGE_RATE_SN
    * Program History
    *===================================================================================================
    *   Date       In Charge      Description
    *===================================================================================================
    * 2021.05.13   P.C.I          PJ20209642R Chempion 환율 I/F
    * 2022.03.25   sclee          PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
    * 2022.05.11   HWI1993        GM JV 수정
    * 2022.11.17   kdw2819        [C20221116-000471]환율정보 수신 배치 오류
    * 2022.11.28   chano0612      [C20221124-000290]환율 IF관련 수정 요청 건
    * 2025.06.24   kjiyoon        [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율팝업 적용 - 화면 호출용 프로시저 수행 성공/실패 output 추가
    * 2025.07.03   kjiyoon        [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가
    * 2025.09.15   김준규           IT20250117A NERP ROLLIN 3차 현재 CNY를 RMB로 변경 저장하는 것을 CNY 그대로 저장변경
    * 2026.03.24   김준규           [PJ20264226] NextSCM Pilot 설계 및 개발
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
    */
 AS
    /* ------------------------------------------------------------------------- */
    C_DIVISION_ID       VARCHAR2(30 CHAR);
    C_SCENARIO_TYPE_CD  VARCHAR2(06 CHAR);
    C_PLN_PERIOD_YYYYMM VARCHAR2(06 CHAR);
    C_CURRENCY_CD       VARCHAR2(15 CHAR);
    C_IF_SEQ            NUMBER(16, 0);
    V_RECEIVE_CNT       NUMBER(16, 0);
    V_BATCH_USER        VARCHAR2(150 CHAR) := 'scm_batch';
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;
    N_HISTORY_SEQ       NUMBER;
    V_IFSEQNO           VARCHAR2(30 CHAR);
    V_IN_PARA_DATA      VARCHAR2(4000 CHAR);
    V_RESULT_CURSOR     SYS_REFCURSOR;
    CUR_E               SYS_REFCURSOR;

    CURSOR CUR_D IS
        SELECT DIVISION_ID
          FROM GT_SMER_I_DIVISION;
BEGIN

    /* ------------------------------------------------------------------------- */
    /* LOG 용 변수 설정 */
    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := ('P_BATCH_YN = ' || NVL(P_BATCH_YN, 'X')); /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가 */
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* GTT 초기화 : TRUNCATE 는 DDL 이라 암시 COMMIT 이 발생해 상위 트랜잭션의 ROLLBACK 을 무력화한다 -> DELETE 사용 */
    DELETE FROM GT_SMER_I_DIVISION;

    /* 자동차, ESS, 소형 작업 */
    /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가 START */
    /* 기존로직 주석처리 */
    /* INSERT +NO_PARALLEL INTO GT_SMER_I_DIVISION (division_id) */
    /* SELECT DIVISION_ID */
    /* FROM SCM_MST_DIVISION */
    /* WHERE ATTRIBUTE3 IN ('40','81', '82' ) */
    IF P_BATCH_YN = 'Y' THEN
        /* 대상 사업부 */
        INSERT
          INTO GT_SMER_I_DIVISION
             ( DIVISION_ID )
        SELECT DIVISION_ID
          FROM SCM_MST_DIVISION
         WHERE ATTRIBUTE3 IN ('81', '82');

        /* 대상 IF 환율 */

        /* CUR_E CURSOR LOCAL FOR */
        OPEN CUR_E FOR
        SELECT SCENARIO_TYPE_CD
             , PLN_PERIOD_YYYYMM
             , CURRENCY_CD
             , IF_SEQ
          FROM (SELECT E.SCENARIO_TYPE_CD
                     , E.PLN_PERIOD_YYYYMM
                     , E.CURRENCY_CD
                     , E.IF_SEQ
                  FROM XIF_GSC_MOVE_EXCHANGE_RATE_SN E
                 WHERE NVL(E.TRANSF_FLAG, 'N') = 'N'
                   AND SCENARIO_TYPE_CD IN ('ML', 'RF') /* [C20221124-000290] SCENARIO_TYPE_CD를 ML, RF만 등록한다.. */
                 GROUP BY E.SCENARIO_TYPE_CD, E.PLN_PERIOD_YYYYMM, E.CURRENCY_CD, E.IF_SEQ) X
         ORDER BY PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ, SCENARIO_TYPE_CD;
    ELSE
        /* 대상 사업부 */
        INSERT
          INTO GT_SMER_I_DIVISION
             ( DIVISION_ID )
        SELECT DIVISION_ID
          FROM SCM_MST_DIVISION
         WHERE ATTRIBUTE3 IN ('40');

        /* 대상 IF 환율 */

        /* CUR_E CURSOR LOCAL FOR */
        OPEN CUR_E FOR
        SELECT SCENARIO_TYPE_CD
             , PLN_PERIOD_YYYYMM
             , CURRENCY_CD
             , IF_SEQ
          FROM (SELECT E.SCENARIO_TYPE_CD
                     , E.PLN_PERIOD_YYYYMM
                     , E.CURRENCY_CD
                     , E.IF_SEQ
                  FROM XIF_GSC_MOVE_EXCHANGE_RATE_SN E
                 WHERE E.TRANSF_DATE = (SELECT MAX(A.TRANSF_DATE)
                                          FROM XIF_GSC_MOVE_EXCHANGE_RATE_SN A
                                         WHERE 1 = 1
                                           AND A.SCENARIO_TYPE_CD IN ('ML', 'RF'))
                   AND SCENARIO_TYPE_CD IN ('ML', 'RF') /* [C20221124-000290] SCENARIO_TYPE_CD를 ML, RF만 등록한다.. */
                 GROUP BY E.SCENARIO_TYPE_CD, E.PLN_PERIOD_YYYYMM, E.CURRENCY_CD, E.IF_SEQ) X
         ORDER BY PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ, SCENARIO_TYPE_CD;
    END IF;

    /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가 END */
    /* DELETE FROM DM_MST_EXCHANGE_RATE WHERE YYYYMMDD BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, 0), 'YYYYMMDD') || '01' AND TO_CHAR(ADD_MONTHS(SYSDATE, 12), 'YYYYMMDD') || '01' */
    /* [C20221124-000290] DM_MST_EXCHANGE_RATE 에 존재하는 기존 데이터를 삭제한다. */
    /* 위로 로직 이동해서 아래 CURSOR 주석처리 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가 */
    /* CURSOR 환율 정보 수신 (KEY : SCENARIO_TYPE_CD, PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ) */

    /* CUR_E CURSOR LOCAL FOR */
    /* select SCENARIO_TYPE_CD, PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ */
    /* from ( select E.SCENARIO_TYPE_CD */
    /*           , E.PLN_PERIOD_YYYYMM */
    /*           , E.CURRENCY_CD */
    /*           , E.IF_SEQ */
    /*       from XIF_GSC_MOVE_EXCHANGE_RATE_SN E */

    /*       AND SCENARIO_TYPE_CD IN ('ML', 'RF') [C20221124-000290] SCENARIO_TYPE_CD를 ML, RF만 등록한다.. */
    /*       group by E.SCENARIO_TYPE_CD */
    /*           , E.PLN_PERIOD_YYYYMM */
    /*           , E.CURRENCY_CD */
    /*           , E.IF_SEQ */
    /*           ) x */
    /* ORDER BY PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ, SCENARIO_TYPE_CD */
    /* CURSOR 환율 정보 수신 (KEY : SCENARIO_TYPE_CD, PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ) */

    /* CUR_D CURSOR FOR */

    NULL;

    /* ------------------------------------------------------------------------- */

    /* Start 환율 Cursor */
    V_RECEIVE_CNT := 0;

    FETCH CUR_E
        INTO C_SCENARIO_TYPE_CD, C_PLN_PERIOD_YYYYMM, C_CURRENCY_CD, C_IF_SEQ;
    WHILE (CUR_E%FOUND) LOOP
        /* ----------------------------------------------------------------- */
        /* * IT20250117A NERP ROLLIN 3차 현재 CNY를 RMB로 변경 저장하는 것을 CNY 그대로 저장변경 시작 */
        /* 변경전 상태 USING ( SELECT B.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, REPLACE(A.UNIT_CURRENCY, 'CNY', 'RMB') UNIT_CURRENCY, A.EXCHANGE_PRICE */
        MERGE INTO DM_MST_EXCHANGE_RATE DME
        USING (SELECT B.DIVISION_ID
                    , A.YYYYMMDD
                    , A.CURRENCY
                    , /*REPLACE(A.UNIT_CURRENCY, 'CNY', 'RMB')*/ A.UNIT_CURRENCY AS UNIT_CURRENCY
                    , A.EXCHANGE_PRICE
                 FROM (SELECT PLN_YYYYMM || '01' AS YYYYMMDD
                            , 'KRW' AS CURRENCY
                            , CURRENCY_CD UNIT_CURRENCY
                            , KRW_CNVT_RATE EXCHANGE_PRICE
                         FROM XIF_GSC_MOVE_EXCHANGE_RATE_SN
                        WHERE SCENARIO_TYPE_CD = C_SCENARIO_TYPE_CD
                          AND PLN_PERIOD_YYYYMM = C_PLN_PERIOD_YYYYMM
                          AND CURRENCY_CD = C_CURRENCY_CD
                          AND IF_SEQ = C_IF_SEQ
                        UNION ALL
                       SELECT PLN_YYYYMM || '01' AS YYYYMMDD
                            , 'USD' AS CURRENCY
                            , CURRENCY_CD UNIT_CURRENCY
                            , USD_CNVT_RATE EXCHANGE_PRICE
                         FROM XIF_GSC_MOVE_EXCHANGE_RATE_SN
                        WHERE SCENARIO_TYPE_CD = C_SCENARIO_TYPE_CD
                          AND PLN_PERIOD_YYYYMM = C_PLN_PERIOD_YYYYMM
                          AND CURRENCY_CD = C_CURRENCY_CD
                          AND IF_SEQ = C_IF_SEQ
                        UNION ALL
                       SELECT PLN_YYYYMM || '01' AS YYYYMMDD
                            , 'EUR' AS CURRENCY
                            , CURRENCY_CD UNIT_CURRENCY
                            , EUR_CNVT_RATE EXCHANGE_PRICE
                         FROM XIF_GSC_MOVE_EXCHANGE_RATE_SN
                        WHERE SCENARIO_TYPE_CD = C_SCENARIO_TYPE_CD
                          AND PLN_PERIOD_YYYYMM = C_PLN_PERIOD_YYYYMM
                          AND CURRENCY_CD = C_CURRENCY_CD
                          AND IF_SEQ = C_IF_SEQ) A
                    , GT_SMER_I_DIVISION B) XXX
        /* * IT20250117A NERP ROLLIN 3차 현재 CNY를 RMB로 변경 저장하는 것을 CNY 그대로 저장변경 종료 */
        ON (DME.DIVISION_ID = XXX.DIVISION_ID AND DME.YYYYMMDD = XXX.YYYYMMDD AND DME.CURRENCY = XXX.CURRENCY AND DME.UNIT_CURRENCY = XXX.UNIT_CURRENCY)
        WHEN MATCHED THEN
            UPDATE SET DME.EXCHANGE_PRICE = XXX.EXCHANGE_PRICE
                     , DME.LAST_UPDATED_BY = 'SYSTEM'
                     , DME.LAST_UPDATE_DATE = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT
                 ( DIVISION_ID
                 , YYYYMMDD
                 , CURRENCY
                 , UNIT_CURRENCY
                 , EXCHANGE_PRICE
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            VALUES ( XXX.DIVISION_ID
                   , XXX.YYYYMMDD
                   , XXX.CURRENCY
                   , XXX.UNIT_CURRENCY
                   , XXX.EXCHANGE_PRICE
                   , 'SYSTEM'
                   , SYSDATE
                   , 'SYSTEM'
                   , SYSDATE );
        /* ----------------------------------------------------------------- */
        /* 배치일때만 업데이트하도록 조건추가 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가 */
        IF P_BATCH_YN = 'Y' THEN
            /* I/F Table TRANSF_FLAG 변경 */
            UPDATE XIF_GSC_MOVE_EXCHANGE_RATE_SN
               SET TRANSF_FLAG = 'Y'
             WHERE SCENARIO_TYPE_CD = C_SCENARIO_TYPE_CD
               AND PLN_PERIOD_YYYYMM = C_PLN_PERIOD_YYYYMM
               AND CURRENCY_CD = C_CURRENCY_CD
               AND IF_SEQ = C_IF_SEQ;
        END IF;

        V_RECEIVE_CNT := V_RECEIVE_CNT + 1;
        /* ----------------------------------------------------------------- */
        FETCH CUR_E
            INTO C_SCENARIO_TYPE_CD, C_PLN_PERIOD_YYYYMM, C_CURRENCY_CD, C_IF_SEQ;
    END LOOP;
    CLOSE CUR_E;

    /* End  환율 Cursor */
    /* Start  Sales Price, Sales Plan Cursor */
    /* select 'V_RECEIVE_CNT', V_RECEIVE_CNT */
    IF (V_RECEIVE_CNT > 0) THEN

        OPEN CUR_D;
        FETCH CUR_D
            INTO C_DIVISION_ID;
        WHILE (CUR_D%FOUND) LOOP

            /* select 'C_DIVISION_ID', C_DIVISION_ID */
            /* Sales Price Update */
            PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION(C_DIVISION_ID, V_RESULT_CURSOR);   /* [E20260824-PKGCONSOL] 단독 SP -> PKG 내부 프로시저. 시그니처 동일(2-arg) 실측 확인 */

            /* Sales Plan Update */
            PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW(C_DIVISION_ID, 'EXCHANGE_RATE');

            FETCH CUR_D
                INTO C_DIVISION_ID;
        END LOOP;
        CLOSE CUR_D;

    END IF;
    /* End  Sales Price, Sales Plan Cursor */
    /* 트랜잭션 종료 */
    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;
    NULL; /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율팝업 적용 */


EXCEPTION
    WHEN OTHERS THEN

        /* ERROR LOG */
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || TO_CHAR(NULL);
        D_EVENT_DATE  := SYSTIMESTAMP;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        NULL;
        /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율팝업 적용 */


        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
/
