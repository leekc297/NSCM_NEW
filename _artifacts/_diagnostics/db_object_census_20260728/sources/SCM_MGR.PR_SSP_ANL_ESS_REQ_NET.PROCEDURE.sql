PROCEDURE "PR_SSP_ANL_ESS_REQ_NET"

(
      P_DM_REQ_NO    IN VARCHAR2
    , P_DIVISION_ID  IN VARCHAR2
    , R_ERROR_MSG    OUT VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SSP_ANL_ESS_REQ_NET
 * Description  :
 * OutTable     : PR_SSP_ANL_ESS_REQ_NET
 * Execute      : EXEC PR_SSP_ANL_ESS_REQ_NET
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 20210317      SSP Pjt.       Create
 * 20241001      KHJ            NERP_SSP
 * 2026.07.06    ZIONEX         [PJ202650304] NextSCM Migration
 * ============================================================ */
AS

    /* [LOG 용 변수 설정] */
    V_BATCH_USER      VARCHAR2(150 CHAR) := 'ssp_batch';
    V_PROGRAM_NAME    VARCHAR2(150 CHAR) := 'PR_SSP_ANL_ESS_REQ_NET';
    V_LOG_TYPE        VARCHAR2(30 CHAR);
    N_LOG_COUNT     INTEGER := 0;
    V_LOG_MESSAGE     VARCHAR2(1000 CHAR);
    V_DESCRIPTION     VARCHAR2(500 CHAR); /* 상세설명 */
    V_TABLE_ID        VARCHAR2(150 CHAR) := 'SSP_ANL_ESS_REQ_NET'; /* 테이블 필수 */
    D_EVENT_DATE      TIMESTAMP;
    V_INSERT_CNT      INTEGER := 0;
    V_INSERT_SUM      INTEGER := 0;

    /* [조회 및 제어용 변수 - v_ 접두사 정리] */
    /* 밑에 주석 변수들은 AS-IS에서도 안 쓰고 있다. */
/* p_language				    VARCHAR2(10 CHAR)	:= 'KO'; */
/* v_msp_check                VARCHAR2(3 CHAR)		:= '-'; */
/* v_wsp_check                VARCHAR2(3 CHAR)		:= '-'; */
/* v_from_yyyymmdd            VARCHAR2(8 CHAR); */
/* v_to_yyyymmdd              VARCHAR2(8); */
    V_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR);
    V_DIVISION_ID         VARCHAR2(10 CHAR);
    V_DM_REQ_NO           VARCHAR2(60 CHAR);
    V_STORAGE_ID          VARCHAR2(10 CHAR) := FN_GET_LOOKUP_VALUE('PR_SSP_ANL_ESS_REQ_NET', 'STORAGE_6006');

    INX                   INTEGER := 0;
    MAX_NUM               INTEGER := 0;

    L_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR);
    L_DIVISION_ID           VARCHAR2(10 CHAR);
    L_DM_REQ_NO             VARCHAR2(60 CHAR);
    L_ITEM_ID               VARCHAR2(50 CHAR);
    L_PLAN_QTY              NUMBER(20, 10);
    L_INV_QTY               NUMBER(20, 10);
    L_REMAIN_QTY            NUMBER(20, 10);
    L_INV_ALLO_QTY          NUMBER(20, 10);

BEGIN
    /* GT_PRSSP_ANL_ESS_REQ_NET 초기화 */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSSP_ANL_ESS_REQ_NET';

    IF P_DIVISION_ID IS NULL THEN
        V_DIVISION_ID := '82';
    ELSE
        V_DIVISION_ID := P_DIVISION_ID;
    END IF;

    /* [플랜 시작일 조회] */
    SELECT X.ATTRIBUTE1
      INTO V_PLAN_START_YYYYMMDD
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL X
     WHERE X.LOOKUP_TYPE = 'SSP_ANL_ESS_PLAN'
       AND X.SEGMENT1    = V_DIVISION_ID
       AND X.VALID_YN    = 'Y';

    V_DM_REQ_NO := P_DM_REQ_NO;

    INSERT
      INTO GT_PRSSP_ANL_ESS_REQ_NET
         ( PLAN_START_YYYYMMDD
         , DIVISION_ID
         , DM_REQ_NO
         , ITEM_ID
         , PLAN_QTY
         , INV_QTY
         , REMAIN_QTY )
    SELECT V_PLAN_START_YYYYMMDD
         , R.DIVISION_ID
         , R.DM_REQ_NO
         , R.ITEM_ID
         , R.PLAN_QTY
         , NVL(S.INV_QTY, 0)    AS INV_QTY
         , NVL(S.REMAIN_QTY, 0) AS REMAIN_QTY
      FROM SSP_ANL_ESS_REQ   R
         , SSP_ANL_ESS_STOCK S
     WHERE R.DIVISION_ID            = S.DIVISION_ID(+)
       AND R.ITEM_ID                = S.ITEM_ID(+)
       AND S.PLAN_START_YYYYMMDD(+) = V_PLAN_START_YYYYMMDD
       AND S.STORAGE_ID(+)          = V_STORAGE_ID
       AND R.DM_REQ_NO              = V_DM_REQ_NO
     ORDER BY R.DIVISION_ID
            , R.DM_REQ_NO
            , R.ITEM_ID;

    SELECT 1
         , COUNT(*)
      INTO INX
         , MAX_NUM
      FROM GT_PRSSP_ANL_ESS_REQ_NET;

    IF MAX_NUM = 0 THEN
        RETURN;
    END IF;

    /* ------------------------------------------------------------------------- */
    /* START LOG */
    /* ------------------------------------------------------------------------- */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME||' : ' ||V_TABLE_ID||' INSERT LOGIC';
    D_EVENT_DATE := SYSTIMESTAMP;

    PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

    WHILE INX <= MAX_NUM
    LOOP
        BEGIN

            SELECT PLAN_START_YYYYMMDD
                 , DIVISION_ID
                 , DM_REQ_NO
                 , ITEM_ID
                 , PLAN_QTY
                 , INV_QTY
                 , REMAIN_QTY
              INTO L_PLAN_START_YYYYMMDD
                 , L_DIVISION_ID
                 , L_DM_REQ_NO
                 , L_ITEM_ID
                 , L_PLAN_QTY
                 , L_INV_QTY
                 , L_REMAIN_QTY
              FROM GT_PRSSP_ANL_ESS_REQ_NET
             WHERE TID = INX;

            IF L_REMAIN_QTY >= L_PLAN_QTY THEN
                L_INV_ALLO_QTY := CASE WHEN (L_REMAIN_QTY - L_PLAN_QTY) > L_INV_QTY THEN L_REMAIN_QTY - L_INV_QTY ELSE L_PLAN_QTY END;
                L_REMAIN_QTY := L_REMAIN_QTY - L_INV_ALLO_QTY;
            ELSE
                L_INV_ALLO_QTY := L_REMAIN_QTY;
                L_REMAIN_QTY := 0;
            END IF;

            INSERT
              INTO SSP_ANL_ESS_REQ_NET
                 ( PLAN_START_YYYYMMDD
                 , DIVISION_ID
                 , DM_REQ_NO
                 , ITEM_ID
                 , PLAN_QTY
                 , INV_ALLO_QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            VALUES ( L_PLAN_START_YYYYMMDD
                   , L_DIVISION_ID
                   , L_DM_REQ_NO
                   , L_ITEM_ID
                   , L_PLAN_QTY
                   , L_INV_ALLO_QTY
                   , V_BATCH_USER
                   , SYSTIMESTAMP
                   , V_BATCH_USER
                   , SYSTIMESTAMP );

            UPDATE SSP_ANL_ESS_STOCK
               SET REMAIN_QTY            = L_REMAIN_QTY
             WHERE PLAN_START_YYYYMMDD   = L_PLAN_START_YYYYMMDD
               AND DIVISION_ID           = L_DIVISION_ID
               AND ITEM_ID               = L_ITEM_ID
               AND STORAGE_ID            = V_STORAGE_ID;

            UPDATE SSP_ANL_ESS_REQ
               SET NET_YN     = 'Y'
             WHERE DM_REQ_NO  = L_DM_REQ_NO
               AND ITEM_ID    = L_ITEM_ID;

            V_INSERT_CNT := SQL%ROWCOUNT;
            V_INSERT_SUM := V_INSERT_SUM + V_INSERT_CNT;

            EXCEPTION WHEN OTHERS THEN
                /* --------------------------------------------------------- */
                /* ERROR LOG */
                /* --------------------------------------------------------- */
                V_LOG_TYPE := 'ERROR';
                V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
                V_DESCRIPTION := 'ERROR_LINE : ' ||TO_CHAR(REGEXP_SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 'line ([0-9]+)', 1, 1, NULL, 1));
                D_EVENT_DATE := SYSTIMESTAMP;

                PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

                R_ERROR_MSG := SUBSTR(SQLERRM, 1, 1000);
                RETURN;

        END;

        INX := INX + 1;

    END LOOP;

    /* ------------------------------------------------------------------------- */
    /* TXN LOG */
    /* ------------------------------------------------------------------------- */
    V_LOG_TYPE := 'TXN';    /* 로그타입 */
    N_LOG_COUNT := V_INSERT_CNT; /* SQL%ROWCOUNT; */
    V_LOG_MESSAGE := 'INSERT INTO '|| V_TABLE_ID;
    V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' [DIVISION]: ' || L_DIVISION_ID;
    D_EVENT_DATE := SYSTIMESTAMP;

    PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

    /* ------------------------------------------------------------------------- */
    /* END LOG */
    /* ------------------------------------------------------------------------- */
    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE := SYSTIMESTAMP;

    PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_INSERT_SUM, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

    R_ERROR_MSG := 'OK';

    RETURN;

END;