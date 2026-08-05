PROCEDURE           "DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION"
(
    P_DIVISION_ID     IN VARCHAR2,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION
 * Description  : SCM_MST_FUTURE_PRICE Data Conversion
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 22    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180720 KHSONG 주석처리 전체를 다시 계산함
 * 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021.05.13	P.C.I		[PJ20209642R] Chempion 환율 적용
 * 2022.10.24	ROSIA27		[C20221024-000510]DM UI 소스 정리 요청
 * 2025.03.25	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_SELLING_PRICE 재생성
 * 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
-- Weekly Cutoff 시에 이 로직이 수행되어야 함.
AS

    -- 당주 월요일 - 7일 (MSSQL: DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')))
    v_cutoff_yyyymmdd  VARCHAR2(8 CHAR);

    -- LOG 용 변수 설정
    v_log_type         VARCHAR2(30 CHAR); -- START/END/ERROR/...
    n_log_count        PLS_INTEGER := 0;
    v_log_message      VARCHAR2(1000 CHAR);
    v_description      VARCHAR2(500 CHAR);
    d_event_date       DATE;
    n_merge_count1     PLS_INTEGER := 0;
    n_merge_count2     PLS_INTEGER := 0;

    V_PROC_INPUT       VARCHAR2(4000 CHAR);
    V_BACKTRACE        VARCHAR2(4000 CHAR);
    V_SQL_CODE         VARCHAR2(100 CHAR);
    V_SQL_ERRMSG       VARCHAR2(1000 CHAR);
    V_LOG_TYPE_E       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE_E    VARCHAR2(4000 CHAR);
    V_DESCRIPTION_E    VARCHAR2(4000 CHAR);

BEGIN

    -- 당주 월요일 - 7일 계산
    v_cutoff_yyyymmdd := TO_CHAR(TRUNC(SYSDATE, 'IW') - 7, 'YYYYMMDD');

    -- 시작 LOG  (START)
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := 'DIVISION_ID : ' || P_DIVISION_ID;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    -- GTT TRUNCATE
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F020_FUTURE_PRICE_TEMP2';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F020_CFM_SELLING_PRICE_TEMP2';

    -- =====================================================================================
    -- STEP 1: #FUTURE_PRICE_TEMP1 → WITH절, #FUTURE_PRICE_TEMP2 → GTT INSERT
    -- =====================================================================================
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_F020_FUTURE_PRICE_TEMP2
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY)
    WITH FUTURE_PRICE_TEMP1 AS (
        SELECT /*+ FULL(F) PARALLEL(F,4) */
               DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY
        FROM   SCM_MST_FUTURE_PRICE F
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    YYYYMMDD   >= v_cutoff_yyyymmdd  -- 당주 월요일이후 데이터만 대상으로함
        AND    MEASURE     = 'LOC'
    )
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, ROUND(PRICE, 3) AS PRICE, CREATED_BY
    FROM (
        SELECT A.DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, A.YYYYMMDD, A.CURRENCY
             , CASE WHEN A.CURRENCY = 'KRW' THEN 'KRW'
                    WHEN A.CURRENCY = 'USD' THEN 'USD'
                    ELSE 'KRW' END                                        AS MEASURE
             , DOM_EXP, FCST_TYPE, INCOTERMS
             , CASE WHEN A.CURRENCY = 'KRW' THEN PRICE
                    WHEN A.CURRENCY = 'USD' THEN PRICE
                    ELSE PRICE * NVL(B.EXCHANGE_PRICE, 1) END             AS PRICE
             , A.CREATED_BY
        FROM   FUTURE_PRICE_TEMP1 A
        LEFT OUTER JOIN DM_MST_EXCHANGE_RATE B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND SUBSTR(A.YYYYMMDD, 1, 6) || '01' = B.YYYYMMDD
            AND B.CURRENCY      = 'KRW'
            AND A.CURRENCY      = B.UNIT_CURRENCY

        UNION ALL

        SELECT A.DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, A.YYYYMMDD, A.CURRENCY
             , CASE WHEN A.CURRENCY = 'KRW' THEN 'USD'
                    WHEN A.CURRENCY = 'USD' THEN 'KRW'
                    ELSE 'USD' END                                        AS MEASURE
             , DOM_EXP, FCST_TYPE, INCOTERMS
             , CASE WHEN A.CURRENCY = 'KRW' THEN NVL(PRICE / NVL(B.EXCHANGE_PRICE, 1), 0)
                    WHEN A.CURRENCY = 'USD' THEN NVL(PRICE * NVL(B.EXCHANGE_PRICE, 1), 0)
                    ELSE NVL(
                            (A.PRICE * NVL(
                                (SELECT DMER.EXCHANGE_PRICE
                                 FROM   DM_MST_EXCHANGE_RATE DMER
                                 WHERE  DMER.DIVISION_ID   = A.DIVISION_ID
                                 AND    DMER.YYYYMMDD      = SUBSTR(A.YYYYMMDD, 1, 6) || '01'
                                 AND    DMER.UNIT_CURRENCY  = A.CURRENCY
                                 AND    DMER.CURRENCY       = 'KRW'), 1))
                            / NVL(B.EXCHANGE_PRICE, 1), 0)
               END                                                        AS PRICE
             , A.CREATED_BY
        FROM   FUTURE_PRICE_TEMP1 A
        LEFT OUTER JOIN DM_MST_EXCHANGE_RATE B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND SUBSTR(A.YYYYMMDD, 1, 6) || '01' = B.YYYYMMDD
            AND B.CURRENCY       = 'KRW'
            AND B.UNIT_CURRENCY  = 'USD'
    ) C
    WHERE PRICE > 0;

    COMMIT;

    --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

    -- GTT 통계 수집
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME => 'SCM_MGR', TABNAME => 'GT_F020_FUTURE_PRICE_TEMP2',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE
    );

    -- =====================================================================================
    -- STEP 2: MERGE INTO SCM_MST_FUTURE_PRICE
    -- =====================================================================================
    MERGE INTO SCM_MST_FUTURE_PRICE A
    USING GT_F020_FUTURE_PRICE_TEMP2 B
    ON (    A.DIVISION_ID   = B.DIVISION_ID
        AND A.PROJECT_CODE  = B.PROJECT_CODE
        AND A.SCM_SITE_ID   = B.SCM_SITE_ID
        AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
        AND A.ITEM_ID       = B.ITEM_ID
        AND A.YYYYMMDD      = B.YYYYMMDD
        AND A.CURRENCY      = B.CURRENCY
        AND A.MEASURE       = B.MEASURE
        AND A.DOM_EXP       = B.DOM_EXP
        AND A.FCST_TYPE     = B.FCST_TYPE
        AND A.INCOTERMS     = B.INCOTERMS
       )
    WHEN MATCHED THEN
        UPDATE SET A.PRICE            = B.PRICE,
                   A.CREATION_DATE    = SYSDATE,
                   A.LAST_UPDATED_BY  = 'SYSTEM',
                   A.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE,
                DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
                ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        VALUES (B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.YYYYMMDD, B.CURRENCY, B.MEASURE,
                B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE, B.CREATED_BY, SYSDATE, 'SYSTEM', SYSDATE,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

    n_merge_count1 := SQL%ROWCOUNT;

    -- =====================================================================================
    -- STEP 3: [PJ2025-50017] #CFM_SELLING_PRICE_TEMP1 → WITH절, TEMP2 → GTT INSERT
    -- =====================================================================================
    --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_F020_CFM_SELLING_PRICE_TEMP2
    (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE)
    WITH CFM_SELLING_PRICE_TEMP1 AS (
        SELECT /*+ FULL(F) PARALLEL(F,4) */
               DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE
        FROM   DM_PLN_CFM_SELLING_PRICE F
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    YYYYMMDD   >= v_cutoff_yyyymmdd  -- 당주 월요일이후 데이터만 대상으로함
        AND    MEASURE     = 'LOC'
    )
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, ROUND(PRICE, 3) AS PRICE, CREATED_BY, CREATION_DATE
    FROM (
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY
             , CASE WHEN A.CURRENCY = 'KRW' THEN 'KRW'
                    WHEN A.CURRENCY = 'USD' THEN 'USD'
                    ELSE 'KRW' END                                        AS MEASURE
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN A.CURRENCY = 'KRW' THEN A.PRICE
                    WHEN A.CURRENCY = 'USD' THEN A.PRICE
                    ELSE A.PRICE * NVL(B.EXCHANGE_PRICE, 1) END           AS PRICE
             , A.CREATED_BY, A.CREATION_DATE
        FROM   CFM_SELLING_PRICE_TEMP1 A
        LEFT OUTER JOIN DM_MST_EXCHANGE_RATE B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND SUBSTR(A.YYYYMMDD, 1, 6) || '01' = B.YYYYMMDD
            AND B.CURRENCY      = 'KRW'
            AND A.CURRENCY      = B.UNIT_CURRENCY

        UNION ALL

        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY
             , CASE WHEN A.CURRENCY = 'KRW' THEN 'USD'
                    WHEN A.CURRENCY = 'USD' THEN 'KRW'
                    ELSE 'USD' END                                        AS MEASURE
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN A.CURRENCY = 'KRW' THEN NVL(A.PRICE / NVL(B.EXCHANGE_PRICE, 1), 0)
                    WHEN A.CURRENCY = 'USD' THEN NVL(A.PRICE * NVL(B.EXCHANGE_PRICE, 1), 0)
                    ELSE NVL(
                            (A.PRICE * NVL(
                                (SELECT DMER.EXCHANGE_PRICE
                                 FROM   DM_MST_EXCHANGE_RATE DMER
                                 WHERE  DMER.DIVISION_ID   = A.DIVISION_ID
                                 AND    DMER.YYYYMMDD      = SUBSTR(A.YYYYMMDD, 1, 6) || '01'
                                 AND    DMER.UNIT_CURRENCY  = A.CURRENCY
                                 AND    DMER.CURRENCY       = 'KRW'), 1))
                            / NVL(B.EXCHANGE_PRICE, 1), 0)
               END                                                        AS PRICE
             , A.CREATED_BY, A.CREATION_DATE
        FROM   CFM_SELLING_PRICE_TEMP1 A
        LEFT OUTER JOIN DM_MST_EXCHANGE_RATE B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND SUBSTR(A.YYYYMMDD, 1, 6) || '01' = B.YYYYMMDD
            AND B.CURRENCY       = 'KRW'
            AND B.UNIT_CURRENCY  = 'USD'
    ) C
    WHERE PRICE > 0;

    COMMIT;

    --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

    -- GTT 통계 수집
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME => 'SCM_MGR', TABNAME => 'GT_F020_CFM_SELLING_PRICE_TEMP2',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE
    );

    -- =====================================================================================
    -- STEP 4: [PJ2025-50017] MERGE INTO DM_PLN_CFM_SELLING_PRICE
    -- =====================================================================================
    MERGE INTO DM_PLN_CFM_SELLING_PRICE A
    USING GT_F020_CFM_SELLING_PRICE_TEMP2 B
    ON (    A.DIVISION_ID      = B.DIVISION_ID
        AND A.PROJECT_CODE     = B.PROJECT_CODE
        AND A.END_CUSTOMER     = B.END_CUSTOMER
        AND A.SCM_SITE_ID      = B.SCM_SITE_ID
        AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
        AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
        AND A.ITEM_ID          = B.ITEM_ID
        AND A.YYYYMMDD         = B.YYYYMMDD
        AND A.CURRENCY         = B.CURRENCY
        AND A.MEASURE          = B.MEASURE
        AND A.DOM_EXP          = B.DOM_EXP
        AND A.FCST_TYPE        = B.FCST_TYPE
        AND A.INCOTERMS        = B.INCOTERMS
       )
    WHEN MATCHED THEN
        UPDATE SET A.PRICE            = B.PRICE,
                   A.LAST_UPDATED_BY  = 'EXCHANGE_RATE',
                   A.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID,
                ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS,
                PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID,
                B.ITEM_ID, B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS,
                B.PRICE, B.CREATED_BY, B.CREATION_DATE, 'EXCHANGE_RATE', SYSDATE);

    n_merge_count2 := SQL%ROWCOUNT;
    --[PJ2025-50017] 소형 매출계획 동기화 개선 Start - DM_PLN_CFM_MKT_DEMAND_PLAN 의 MKT_AMT 업데이트

    COMMIT;

    -- 종료 LOG
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := 'merge_count1: ' || TO_CHAR(n_merge_count1) || ' / merge_count2: ' || TO_CHAR(n_merge_count2);
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류.
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_merge_count1 + n_merge_count2) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        -- EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        ROLLBACK;
        V_LOG_TYPE_E    := 'ERROR';
        V_LOG_MESSAGE_E := 'EXCEPTION';
        V_DESCRIPTION_E := '';
        V_SQL_CODE      := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG    := SQLERRM;
        V_PROC_INPUT    :=
            JSON_OBJECT(
                'P_DIVISION_ID' VALUE P_DIVISION_ID
            );
        V_BACKTRACE     := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE_E, n_log_count, V_LOG_MESSAGE_E,
                V_DESCRIPTION_E, SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION;