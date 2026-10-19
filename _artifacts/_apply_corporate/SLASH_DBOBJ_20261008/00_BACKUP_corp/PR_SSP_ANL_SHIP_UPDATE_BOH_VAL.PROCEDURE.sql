PROCEDURE PR_SSP_ANL_SHIP_UPDATE_BOH_VAL
(
    P_DIVISION_ID       IN  VARCHAR2
  , P_ITEM_ID           IN  VARCHAR2
  , P_FROM_SITE         IN  VARCHAR2
  , P_YYYYMMDD          IN  VARCHAR2
  , P_USER_ID           IN  VARCHAR2 DEFAULT 'ssp_batch'
)
IS
    /*
     * Program ID   : PR_SSP_ANL_SHIP_UPDATE_BOH_VAL
     * Description  : CONFIRM수량 변경 시 해당 날짜 이후 BOH, BALANCE UPDATE.
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.25   ZIONEX         [PJ202650304] MSSQL -> Oracle 전환
     *
     * [전환 규칙]
     * - AS-IS #tmp_SSP_ANL_SHIP_UPDATE_BOH -> GT_SSP_ANL_SHIP_UPDATE_BOH (시작할 때 DELETE 로 비운다)
     * - AS-IS WITH 절은 인라인 뷰로 옮겼다.
     * - AS-IS UPDATE ... FROM ... JOIN 은 Oracle 상관 서브쿼리 갱신으로 옮겼다.
     * - AS-IS 는 자기 이름의 처리 단위를 열고 닫지만 MSSQL 에서 안쪽 단위를 닫아도 실제 확정은 바깥에서
     *   일어난다. 이 프로시저는 화면 저장이 부르므로 여기서 확정하지 않고 되돌림 지점만 잡아 둔다.
     */
    C_PROGRAM_NAME          CONSTANT VARCHAR2(150 CHAR) := 'PR_SSP_ANL_SHIP_UPDATE_BOH_VAL';
    C_TABLE_ID              CONSTANT VARCHAR2(150 CHAR) := 'SSP_ANL_SHIP_PLAN';
    V_BATCH_USER            VARCHAR2(150 CHAR) := P_USER_ID;
    V_LOG_COUNT             NUMBER := 0;
    V_EVENT_DATE            DATE;
    V_START_TIME            DATE := SYSDATE;
    V_EXEC_TIME             VARCHAR2(10 CHAR) := '';
    V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR) := '';
    V_SEQ                   NUMBER := 0;
    V_YYYYMMDD_LASTDAY      VARCHAR2(8 CHAR) := '';    /* BOH계산을 위한 전일 날짜 */
BEGIN
    /* 시작 LOG */
    V_EVENT_DATE := SYSDATE;
    PR_SCP_SYS_LOG_BATCH(C_PROGRAM_NAME, 'START', V_LOG_COUNT, '########## Start of procedure ##########'
                       , C_PROGRAM_NAME || ': SHIP_PLAN INSERT LOGIC', V_EVENT_DATE, V_BATCH_USER);

    V_YYYYMMDD_LASTDAY := TO_CHAR(TO_DATE(P_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');

    SAVEPOINT SP_TX_SH;

    /* -----------------------------------------------------------------------------------------------
       0. 임시 테이블 비우기
       ----------------------------------------------------------------------------------------------- */
    DELETE FROM GT_SSP_ANL_SHIP_UPDATE_BOH;

    /* -----------------------------------------------------------------------------------------------
       1. 최근 PLAN 정보 확인
       ----------------------------------------------------------------------------------------------- */
    SELECT MAX(PLAN_START_YYYYMMDD)
         , MAX(PLAN_SEQ)
      INTO V_PLAN_START_YYYYMMDD
         , V_SEQ
      FROM SSP_PLAN_VERSION_V
     WHERE PLAN_TYPE           = 'SP'
       AND DIVISION_ID         = P_DIVISION_ID
       AND CONFIRM_FLAG        = 'Y'
       AND PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
                                    FROM SSP_PLAN_VERSION_V T
                                   WHERE T.DIVISION_ID  = P_DIVISION_ID
                                     AND T.PLAN_TYPE    = 'SP'
                                     AND T.CONFIRM_FLAG = 'Y');

    /* BOH계산을 위한 전일 날짜가 PLAN_START_DATE 보다 작으면 PLAN_START_DATE로 SET UP */
    IF V_YYYYMMDD_LASTDAY < V_PLAN_START_YYYYMMDD THEN
        V_YYYYMMDD_LASTDAY := V_PLAN_START_YYYYMMDD;
    END IF;

    /* -----------------------------------------------------------------------------------------------
       2. 변경날짜 이후 BOH 산출
       ----------------------------------------------------------------------------------------------- */
    INSERT INTO GT_SSP_ANL_SHIP_UPDATE_BOH
    (
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
    SELECT IA.DIVISION_ID
         , IA.PLAN_START_YYYYMMDD
         , IA.PLAN_TYPE
         , IA.SEQ
         , IA.ITEM_ID
         , IA.FROM_SITE
         , '-'                                       AS TO_SITE
         , 'BOH'                                     AS MEASURE
         , IA.YYYYMMDD
         , '-'                                       AS BOD_ID
         , (SELECT NVL(SUM(CASE X.MEASURE WHEN 'SHIP_CONFIRM' THEN -1 * NVL(X.QTY, 0)
                                          WHEN 'PROD_PLAN'    THEN      NVL(X.QTY, 0)
                                          ELSE 0.0
                                     END), 0)
              FROM SSP_ANL_SHIP_PLAN X
             WHERE X.DIVISION_ID         = IA.DIVISION_ID
               AND X.PLAN_START_YYYYMMDD = IA.PLAN_START_YYYYMMDD
               AND X.PLAN_TYPE           = IA.PLAN_TYPE
               AND X.SEQ                 = IA.SEQ
               AND X.ITEM_ID             = IA.ITEM_ID
               AND X.FROM_SITE           = IA.FROM_SITE
               AND X.MEASURE            IN ('PROD_PLAN', 'SHIP_CONFIRM')
               AND X.YYYYMMDD           >= V_YYYYMMDD_LASTDAY
               AND X.YYYYMMDD            < IA.YYYYMMDD) + NVL(XA.QTY, 0)   AS QTY
         , '-'                                       AS INCOTERMS
         , '-'                                       AS TRANSPORT_MODE
         , '-'                                       AS PROJECT_CODE
         , '-'                                       AS FCST_TYPE
         , '-'                                       AS CONFIRM_ID
      FROM (SELECT DISTINCT DIVISION_ID                     /* 변경날짜 이후 계획 · 확정이 있는 날 */
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , ITEM_ID
                 , FROM_SITE
                 , YYYYMMDD
              FROM SSP_ANL_SHIP_PLAN
             WHERE DIVISION_ID         = P_DIVISION_ID
               AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND PLAN_TYPE           = 'SP'
               AND SEQ                 = V_SEQ
               AND MEASURE            IN ('PROD_PLAN', 'SHIP_CONFIRM')
               AND YYYYMMDD           >= V_YYYYMMDD_LASTDAY
               AND ITEM_ID             = P_ITEM_ID
               AND FROM_SITE           = P_FROM_SITE)                 IA
         , (SELECT B.DIVISION_ID                              /* 전일 BOH */
                 , B.PLAN_START_YYYYMMDD
                 , B.PLAN_TYPE
                 , B.SEQ
                 , B.ITEM_ID
                 , B.FROM_SITE
                 , SUM(B.QTY)                                 AS QTY
              FROM SSP_ANL_SHIP_PLAN B
             WHERE B.DIVISION_ID         = P_DIVISION_ID
               AND B.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND B.PLAN_TYPE           = 'SP'
               AND B.SEQ                 = V_SEQ
               AND B.YYYYMMDD            = V_YYYYMMDD_LASTDAY
               AND B.MEASURE             = 'BOH'
               AND B.ITEM_ID             = P_ITEM_ID
               AND B.FROM_SITE           = P_FROM_SITE
             GROUP BY B.DIVISION_ID
                    , B.PLAN_START_YYYYMMDD
                    , B.PLAN_TYPE
                    , B.SEQ
                    , B.ITEM_ID
                    , B.FROM_SITE)                            XA
     WHERE XA.DIVISION_ID(+)         = IA.DIVISION_ID
       AND XA.PLAN_START_YYYYMMDD(+) = IA.PLAN_START_YYYYMMDD
       AND XA.PLAN_TYPE(+)           = IA.PLAN_TYPE
       AND XA.SEQ(+)                 = IA.SEQ
       AND XA.ITEM_ID(+)             = IA.ITEM_ID
       AND XA.FROM_SITE(+)           = IA.FROM_SITE
       AND IA.DIVISION_ID            = P_DIVISION_ID
       AND IA.ITEM_ID                = P_ITEM_ID
       AND IA.FROM_SITE              = P_FROM_SITE;

    /* -----------------------------------------------------------------------------------------------
       3. UPDATE BOH
       ----------------------------------------------------------------------------------------------- */
    UPDATE SSP_ANL_SHIP_PLAN P
       SET P.QTY              = (SELECT C.QTY
                                   FROM GT_SSP_ANL_SHIP_UPDATE_BOH C
                                  WHERE C.DIVISION_ID         = P.DIVISION_ID
                                    AND C.PLAN_START_YYYYMMDD = P.PLAN_START_YYYYMMDD
                                    AND C.PLAN_TYPE           = P.PLAN_TYPE
                                    AND C.SEQ                 = P.SEQ
                                    AND C.ITEM_ID             = P.ITEM_ID
                                    AND C.FROM_SITE           = P.FROM_SITE
                                    AND C.TO_SITE             = P.TO_SITE
                                    AND C.YYYYMMDD            = P.YYYYMMDD
                                    AND C.BOD_ID              = P.BOD_ID
                                    AND C.INCOTERMS           = P.INCOTERMS
                                    AND C.TRANSPORT_MODE      = P.TRANSPORT_MODE
                                    AND C.PROJECT_CODE        = P.PROJECT_CODE
                                    AND C.FCST_TYPE           = P.FCST_TYPE
                                    AND C.MEASURE             = P.MEASURE
                                    AND NVL(C.CONFIRM_ID, '-') = NVL(P.CONFIRM_ID, '-'))
         , P.LAST_UPDATED_BY  = V_BATCH_USER
         , P.LAST_UPDATE_DATE = SYSDATE
     WHERE P.MEASURE             = 'BOH'
       AND P.PLAN_TYPE           = 'SP'
       AND P.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
       AND P.SEQ                 = V_SEQ
       AND P.DIVISION_ID         = P_DIVISION_ID
       AND P.ITEM_ID             = P_ITEM_ID
       AND P.FROM_SITE           = P_FROM_SITE
       AND P.YYYYMMDD           >= V_YYYYMMDD_LASTDAY
       AND EXISTS (SELECT 1
                     FROM GT_SSP_ANL_SHIP_UPDATE_BOH C
                    WHERE C.DIVISION_ID         = P.DIVISION_ID
                      AND C.PLAN_START_YYYYMMDD = P.PLAN_START_YYYYMMDD
                      AND C.PLAN_TYPE           = P.PLAN_TYPE
                      AND C.SEQ                 = P.SEQ
                      AND C.ITEM_ID             = P.ITEM_ID
                      AND C.FROM_SITE           = P.FROM_SITE
                      AND C.TO_SITE             = P.TO_SITE
                      AND C.YYYYMMDD            = P.YYYYMMDD
                      AND C.BOD_ID              = P.BOD_ID
                      AND C.INCOTERMS           = P.INCOTERMS
                      AND C.TRANSPORT_MODE      = P.TRANSPORT_MODE
                      AND C.PROJECT_CODE        = P.PROJECT_CODE
                      AND C.FCST_TYPE           = P.FCST_TYPE
                      AND C.MEASURE             = P.MEASURE
                      AND NVL(C.CONFIRM_ID, '-') = NVL(P.CONFIRM_ID, '-'));

    /* -----------------------------------------------------------------------------------------------
       4. UPDATE BALANCE
       ----------------------------------------------------------------------------------------------- */
    UPDATE SSP_ANL_SHIP_PLAN B
       SET B.QTY              = (SELECT SUM(CASE WHEN P.MEASURE = 'BOH'          THEN P.QTY ELSE 0 END)
                                      - SUM(CASE WHEN P.MEASURE = 'SHIP_CONFIRM' THEN P.QTY ELSE 0 END)
                                   FROM SSP_ANL_SHIP_PLAN P
                                  WHERE P.MEASURE            IN ('SHIP_CONFIRM', 'BOH')
                                    AND P.DIVISION_ID         = P_DIVISION_ID
                                    AND P.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                    AND P.PLAN_TYPE           = 'SP'
                                    AND P.SEQ                 = V_SEQ
                                    AND P.ITEM_ID             = P_ITEM_ID
                                    AND P.FROM_SITE           = P_FROM_SITE
                                    AND P.YYYYMMDD           >= V_YYYYMMDD_LASTDAY
                                    AND P.YYYYMMDD            = B.YYYYMMDD)
         , B.LAST_UPDATED_BY  = V_BATCH_USER
         , B.LAST_UPDATE_DATE = SYSDATE
     WHERE B.DIVISION_ID         = P_DIVISION_ID
       AND B.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
       AND B.PLAN_TYPE           = 'SP'
       AND B.MEASURE             = 'BALANCE'
       AND B.SEQ                 = V_SEQ
       AND B.ITEM_ID             = P_ITEM_ID
       AND B.FROM_SITE           = P_FROM_SITE
       AND B.YYYYMMDD           >= V_YYYYMMDD_LASTDAY
       AND B.TO_SITE             = '-'
       AND B.BOD_ID              = '-'
       AND B.INCOTERMS           = '-'
       AND B.TRANSPORT_MODE      = '-'
       AND B.PROJECT_CODE        = '-'
       AND B.FCST_TYPE           = '-'
       AND EXISTS (SELECT 1
                     FROM SSP_ANL_SHIP_PLAN P
                    WHERE P.MEASURE            IN ('SHIP_CONFIRM', 'BOH')
                      AND P.DIVISION_ID         = P_DIVISION_ID
                      AND P.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                      AND P.PLAN_TYPE           = 'SP'
                      AND P.SEQ                 = V_SEQ
                      AND P.ITEM_ID             = P_ITEM_ID
                      AND P.FROM_SITE           = P_FROM_SITE
                      AND P.YYYYMMDD           >= V_YYYYMMDD_LASTDAY
                      AND P.YYYYMMDD            = B.YYYYMMDD);

    V_LOG_COUNT := SQL%ROWCOUNT;

    /* TXN LOG */
    V_EVENT_DATE := SYSDATE;
    PR_SCP_SYS_LOG_BATCH(C_PROGRAM_NAME, 'TXN', V_LOG_COUNT, 'INSERT INTO ' || C_TABLE_ID
                       , 'Process Complete...' || ':' || TO_CHAR(V_EVENT_DATE, 'YYYYMMDD'), V_EVENT_DATE, V_BATCH_USER);

    V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0') || ':'
                || LPAD(TO_CHAR(MOD(ROUND((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0');

    /* 종료 LOG */
    V_EVENT_DATE := SYSDATE;
    PR_SCP_SYS_LOG_BATCH(C_PROGRAM_NAME, 'END', V_LOG_COUNT, '########## END of procedure ##########'
                       , '[' || C_PROGRAM_NAME || '][' || V_EXEC_TIME || ']', V_EVENT_DATE, V_BATCH_USER);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO SP_TX_SH;

        V_EVENT_DATE := SYSDATE;
        PR_SCP_SYS_LOG_BATCH(C_PROGRAM_NAME, 'ERROR', V_LOG_COUNT, SUBSTR(SQLERRM, 1, 1000)
                           , C_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                           , V_EVENT_DATE, V_BATCH_USER);
END PR_SSP_ANL_SHIP_UPDATE_BOH_VAL;