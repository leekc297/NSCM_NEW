CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT" 
(
    P_ACTIVE_FLAG           IN  VARCHAR2,
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_YYYYMMDD              IN  VARCHAR2,
    P_CURRENCY              IN  VARCHAR2,
    P_UNIT_CURRENCY         IN  VARCHAR2,
    P_EXCHANGE_PRICE        IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_LAST_UPDATED_BY       IN  VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
 /*==================================================================================================================
 * Program ID   : DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT
 * Description  : DM_PLN_SALES_REPORT_EXCHANGE_C TABLE INSERT/UPDATE/DELETE
 * Program History
 *==================================================================================================================
 *   Date       In Charge		Description
 *==================================================================================================================
 * 2020/03/26	P.C.I			Initial Release [PJ20200138]
 * 2020/09/09	P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020/09/21	HWI1993			[C20200909-000188] ESS 용도
 * 2021/02/05	P.C.I			[C20210205-000093] Sales Amt USD 업데이트 수정
 * 2025/12/02	JSSBAE			[E20251126-001120]_Currency Code 관리 개선 (하드코딩 → Lookup 관리)
 * 2026.03.23   jcnam           [PJ20264226] NextSCM Pilot 설계 및 개발
 *================================================================================================================*/
IS
    ------------------------------------------------------------------------------------------------------------------
    -- 스플릿관련 변수
    ------------------------------------------------------------------------------------------------------------------
    v_active_flag       VARCHAR2(10 CHAR);
    v_division_id       VARCHAR2(50 CHAR);
    v_version_no        VARCHAR2(100 CHAR);
    v_YYYYMMDD          VARCHAR2(8 CHAR);
    v_CURRENCY          VARCHAR2(10 CHAR);
    v_UNIT_CURRENCY     VARCHAR2(10 CHAR);
    v_EXCHANGE_PRICE    VARCHAR2(100 CHAR);
    v_CREATED_BY        VARCHAR2(100 CHAR);
    v_LAST_UPDATED_BY   VARCHAR2(100 CHAR);

    V_CUTOFF_TYPE       VARCHAR2(20 CHAR);
    V_CUTOFF_YYYYMMDD   VARCHAR2(8 CHAR);

    v_row_count         PLS_INTEGER;
    v_exists            PLS_INTEGER;

    ------------------------------------------------------------------------------------------------------------------
    -- LOG 용 변수 설정 (STRAT)
    ------------------------------------------------------------------------------------------------------------------
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;
    ------------------------------------------------------------------------------------------------------------------
    -- LOG 용 변수 설정 (END)
    ------------------------------------------------------------------------------------------------------------------

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    ------------------------------------------------------------------------------------------------------------------
    -- GTT 초기화 (프로시저 시작 시, 이전에 일반 테이블 DML 없으므로 TRUNCATE 허용)
    ------------------------------------------------------------------------------------------------------------------
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_0044_RESULTS';

    ------------------------------------------------------------------------------------------------------------------
    -- 시작 LOG  (START)
    ------------------------------------------------------------------------------------------------------------------
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    ------------------------------------------------------------------------------------------------------------------
    -- 시작 LOG  (END)
    ------------------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------------
    -- 트랜잭션 (START)
    ------------------------------------------------------------------------------------------------------------------

    --###############################################  GT_0044_RESULTS 테이블에 split후 insert (START)
    INSERT INTO SCM_MGR.GT_0044_RESULTS
    (
        ACTIVE_FLAG,
        DIVISION_ID,
        VERSION_NO,
        YYYYMMDD,
        CURRENCY,
        UNIT_CURRENCY,
        EXCHANGE_PRICE,
        CREATED_BY,
        LAST_UPDATED_BY
    )
    SELECT
        TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,      '[^^]+', 1, LVL)) AS ACTIVE_FLAG,
        TRIM(REGEXP_SUBSTR(P_DIVISION_ID,      '[^^]+', 1, LVL)) AS DIVISION_ID,
        TRIM(REGEXP_SUBSTR(P_VERSION_NO,       '[^^]+', 1, LVL)) AS VERSION_NO,
        TRIM(REGEXP_SUBSTR(P_YYYYMMDD,         '[^^]+', 1, LVL)) AS YYYYMMDD,
        TRIM(REGEXP_SUBSTR(P_CURRENCY,         '[^^]+', 1, LVL)) AS CURRENCY,
        TRIM(REGEXP_SUBSTR(P_UNIT_CURRENCY,    '[^^]+', 1, LVL)) AS UNIT_CURRENCY,
        TRIM(REGEXP_SUBSTR(P_EXCHANGE_PRICE,   '[^^]+', 1, LVL)) AS EXCHANGE_PRICE,
        TRIM(REGEXP_SUBSTR(P_CREATED_BY,       '[^^]+', 1, LVL)) AS CREATED_BY,
        TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY,  '[^^]+', 1, LVL)) AS LAST_UPDATED_BY
    FROM (
        SELECT LEVEL AS LVL
        FROM   DUAL
        CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^^]+', 1, LEVEL) IS NOT NULL
    );

    --###############################################   GT_0044_RESULTS 테이블에 split후 insert (END)

    -- Division_id Null Validation
    BEGIN
        SELECT 1
        INTO   v_exists
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_0044_RESULTS R
            WHERE  NOT EXISTS (
                SELECT 1
                FROM   SCM_MGR.SCM_MST_DIVISION D
                WHERE  D.DIVISION_ID = R.DIVISION_ID
            )
        );

        -- 유효하지 않은 DIVISION_ID 존재
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := 'Division 값이 존재하지 않습니다.';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- 모든 DIVISION_ID가 유효함, 계속 진행
    END;

    -- 마지막 행의 v_division_id, v_version_no 를 가져옴 (CUTOFF 조회용)
    SELECT DIVISION_ID, VERSION_NO
    INTO   v_division_id, v_version_no
    FROM   (
        SELECT DIVISION_ID, VERSION_NO
        FROM   SCM_MGR.GT_0044_RESULTS
        ORDER BY ROWID DESC
    )
    WHERE  ROWNUM = 1;

    SELECT CUTOFF_TYPE, CUTOFF_YYYYMMDD
    INTO   V_CUTOFF_TYPE, V_CUTOFF_YYYYMMDD
    FROM   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
    WHERE  DIVISION_ID = v_division_id
    AND    VERSION_NO  = v_version_no
    AND    ROWNUM      = 1;

    UPDATE SCM_MGR.GT_0044_RESULTS
    SET    CUTOFF_TYPE      = V_CUTOFF_TYPE,
           CUTOFF_YYYYMMDD  = V_CUTOFF_YYYYMMDD;

    -- GTT를 다른 테이블과 JOIN 하므로 통계 수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_0044_RESULTS', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_0044_RESULTS',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1'
    );

    --===================================================================================== delete start
    DELETE
    FROM   SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C T
    WHERE  EXISTS (
        SELECT 1
        FROM   SCM_MGR.GT_0044_RESULTS R
        WHERE  R.ACTIVE_FLAG     = 'D'
        AND    T.DIVISION_ID     = R.DIVISION_ID
        AND    T.VERSION_NO      = R.VERSION_NO
        AND    T.YYYYMMDD        = R.YYYYMMDD
        AND    T.CURRENCY        = R.CURRENCY
        AND    T.UNIT_CURRENCY   = R.UNIT_CURRENCY
    );

    n_delete_count := SQL%ROWCOUNT;
    --===================================================================================== delete end

    --===================================================================================== update, insert start
    MERGE INTO SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C A
    USING (
        SELECT
            DIVISION_ID,
            VERSION_NO,
            CUTOFF_TYPE,
            CUTOFF_YYYYMMDD,
            YYYYMMDD,
            CURRENCY,
            UNIT_CURRENCY,
            MAX(EXCHANGE_PRICE)  AS EXCHANGE_PRICE,
            MAX(CREATED_BY)      AS CREATED_BY,
            MAX(LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.GT_0044_RESULTS
        WHERE  ACTIVE_FLAG <> 'D'   -- DELETE값이 아닌경우만
        GROUP BY
            DIVISION_ID,
            VERSION_NO,
            CUTOFF_TYPE,
            CUTOFF_YYYYMMDD,
            YYYYMMDD,
            CURRENCY,
            UNIT_CURRENCY
    ) B
    ON (
            A.DIVISION_ID     = B.DIVISION_ID
        AND A.VERSION_NO      = B.VERSION_NO
        AND A.CUTOFF_TYPE     = B.CUTOFF_TYPE
        AND A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
        AND A.YYYYMMDD        = B.YYYYMMDD
        AND A.CURRENCY        = B.CURRENCY
        AND A.UNIT_CURRENCY   = B.UNIT_CURRENCY
    )
    WHEN MATCHED THEN
        UPDATE SET
            A.EXCHANGE_PRICE   = B.EXCHANGE_PRICE,
            A.CREATED_BY       = B.CREATED_BY,
            A.CREATION_DATE    = SYSDATE,
            A.LAST_UPDATED_BY  = B.LAST_UPDATED_BY,
            A.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (
            DIVISION_ID,
            VERSION_NO,
            CUTOFF_TYPE,
            CUTOFF_YYYYMMDD,
            YYYYMMDD,
            CURRENCY,
            UNIT_CURRENCY,
            EXCHANGE_PRICE,
            CREATED_BY,
            CREATION_DATE,
            LAST_UPDATED_BY,
            LAST_UPDATE_DATE
        )
        VALUES (
            B.DIVISION_ID,
            B.VERSION_NO,
            B.CUTOFF_TYPE,
            B.CUTOFF_YYYYMMDD,
            B.YYYYMMDD,
            B.CURRENCY,
            B.UNIT_CURRENCY,
            B.EXCHANGE_PRICE,
            B.CREATED_BY,
            SYSDATE,
            B.LAST_UPDATED_BY,
            SYSDATE
        );

    n_merge_count := SQL%ROWCOUNT;
    --===================================================================================== update, insert end

    --===================================================================================== Sales Report update start

    --KRW
    MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    USING (
        SELECT
            A2.ROWID AS RID,
            NVL(ROUND(C2.QTY * TO_NUMBER(B2.EXCHANGE_PRICE), 3), 0) AS NEW_QTY
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A2
        JOIN   SCM_MGR.GT_0044_RESULTS B2
            ON  A2.VERSION_NO   = B2.VERSION_NO
            AND A2.DIVISION_ID  = B2.DIVISION_ID
            AND A2.YYYYMMDD LIKE SUBSTR(B2.YYYYMMDD, 1, 6) || '%'
            AND B2.CURRENCY     = 'KRW'
            AND B2.UNIT_CURRENCY = A2.CURRENCY
        JOIN   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C2
            ON  A2.VERSION_NO      = C2.VERSION_NO
            AND A2.DIVISION_ID     = C2.DIVISION_ID
            AND A2.DEPARTMENT_ID   = C2.DEPARTMENT_ID
            AND A2.DEPT_ID         = C2.DEPT_ID
            AND A2.END_CUST_REPORT = C2.END_CUST_REPORT
            AND A2.CUST_REPORT     = C2.CUST_REPORT
            AND A2.PRODUCT_GROUP   = C2.PRODUCT_GROUP
            AND A2.PROJECT_CODE    = C2.PROJECT_CODE
            AND A2.SCM_SITE_ID     = C2.SCM_SITE_ID
            AND A2.ITEM_ID         = C2.ITEM_ID
            AND A2.YYYYMMDD        = C2.YYYYMMDD
            AND A2.CURRENCY        = C2.CURRENCY
            AND A2.COMPANY_ID      = C2.COMPANY_ID
            AND C2.MEASURE         = 'SalesAmt_LOC'
        WHERE  A2.MEASURE      = 'SalesAmt_KRW'
        AND    A2.DIVISION_ID  = B2.DIVISION_ID
        AND    A2.VERSION_NO   = B2.VERSION_NO
        AND    A2.CURRENCY    <> 'KRW'
    ) SRC
    ON (A.ROWID = SRC.RID)
    WHEN MATCHED THEN
        UPDATE SET
            A.QTY              = SRC.NEW_QTY,
            A.LAST_UPDATED_BY  = 'EXCHANGE_PRICE',
            A.LAST_UPDATE_DATE = SYSDATE;

    n_merge_count := n_merge_count + SQL%ROWCOUNT;

    --USD
    MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    USING (
        SELECT
            A2.ROWID AS RID,
            NVL(ROUND(C2.QTY * (CASE
                --[E20251126-001120]_환율정보 RMB -> CNY로 변경 원소스 주석처리 후 소스 수정 (START)
                --WHEN A2.CURRENCY = 'RMB' THEN D2.KRW_RMB_PRICE
                WHEN A2.CURRENCY = 'CNY' THEN D2.KRW_CNY_PRICE
                --[E20251126-001120]_환율정보 RMB -> CNY로 변경 원소스 주석처리 후 소스 수정 (END)
                WHEN A2.CURRENCY = 'EUR' THEN D2.KRW_EUR_PRICE
                WHEN A2.CURRENCY = 'JPY' THEN D2.KRW_JPY_PRICE
                ELSE 1
            END) / D2.KRW_USD_PRICE, 3), 0) AS NEW_QTY  --[C20210205-000093] Sales Amt USD 업데이트 수정 (D.KRW_USD_PRICE-> 1)
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A2
        JOIN   SCM_MGR.GT_0044_RESULTS B2
            ON  A2.VERSION_NO   = B2.VERSION_NO
            AND A2.DIVISION_ID  = B2.DIVISION_ID
            AND A2.YYYYMMDD LIKE SUBSTR(B2.YYYYMMDD, 1, 6) || '%'
            AND B2.CURRENCY     = 'KRW'
            AND A2.CURRENCY     = CASE WHEN A2.CURRENCY = 'KRW' THEN B2.CURRENCY ELSE B2.UNIT_CURRENCY END --[C20210205-000093] Sales Amt USD 업데이트 수정
            --AND B2.UNIT_CURRENCY = A2.CURRENCY--[C20210205-000093] Sales Amt USD 업데이트 수정
        JOIN   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C2
            ON  A2.VERSION_NO      = C2.VERSION_NO
            AND A2.DIVISION_ID     = C2.DIVISION_ID
            AND A2.DEPARTMENT_ID   = C2.DEPARTMENT_ID
            AND A2.DEPT_ID         = C2.DEPT_ID
            AND A2.END_CUST_REPORT = C2.END_CUST_REPORT
            AND A2.CUST_REPORT     = C2.CUST_REPORT
            AND A2.PRODUCT_GROUP   = C2.PRODUCT_GROUP
            AND A2.PROJECT_CODE    = C2.PROJECT_CODE
            AND A2.SCM_SITE_ID     = C2.SCM_SITE_ID
            AND A2.ITEM_ID         = C2.ITEM_ID
            AND A2.YYYYMMDD        = C2.YYYYMMDD
            AND A2.CURRENCY        = C2.CURRENCY
            AND A2.COMPANY_ID      = C2.COMPANY_ID
            AND C2.MEASURE         = 'SalesAmt_LOC'
        JOIN   (
            SELECT DIVISION_ID, VERSION_NO, YYYYMMDD, CURRENCY,
                --[E20251126-001120]_환율정보 RMB -> CNY로 변경 원소스 주석처리 후 소스 수정 (START)
                --SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'RMB' THEN EXCHANGE_PRICE END) AS KRW_RMB_PRICE,
                SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'CNY' THEN TO_NUMBER(EXCHANGE_PRICE) END) AS KRW_CNY_PRICE,
                --[E20251126-001120]_환율정보 RMB -> CNY로 변경 원소스 주석처리 후 소스 수정 (END)
                SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'EUR' THEN TO_NUMBER(EXCHANGE_PRICE) END) AS KRW_EUR_PRICE,
                SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'JPY' THEN TO_NUMBER(EXCHANGE_PRICE) END) AS KRW_JPY_PRICE,
                SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'USD' THEN TO_NUMBER(EXCHANGE_PRICE) END) AS KRW_USD_PRICE
            FROM   SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C E
            WHERE  E.DIVISION_ID = v_division_id
            AND    E.VERSION_NO  = v_version_no
            AND    CURRENCY      = 'KRW'
            GROUP BY DIVISION_ID, VERSION_NO, YYYYMMDD, CURRENCY
        ) D2
            ON  A2.VERSION_NO   = D2.VERSION_NO
            AND A2.DIVISION_ID  = D2.DIVISION_ID
            AND A2.YYYYMMDD LIKE SUBSTR(D2.YYYYMMDD, 1, 6) || '%'
        WHERE  A2.MEASURE      = 'SalesAmt_USD'
        AND    A2.DIVISION_ID  = B2.DIVISION_ID
        AND    A2.VERSION_NO   = B2.VERSION_NO
        AND    A2.CURRENCY    <> 'USD'
    ) SRC
    ON (A.ROWID = SRC.RID)
    WHEN MATCHED THEN
        UPDATE SET
            A.QTY              = SRC.NEW_QTY,
            A.LAST_UPDATED_BY  = 'EXCHANGE_PRICE',
            A.LAST_UPDATE_DATE = SYSDATE;

    n_merge_count := n_merge_count + SQL%ROWCOUNT;
    --===================================================================================== Sales Report update end

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    -- N_LOG_COUNT := n_delete_count + n_merge_count;
    N_LOG_COUNT := n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_ACTIVE_FLAG'     VALUE P_ACTIVE_FLAG,
            'P_DIVISION_ID'     VALUE P_DIVISION_ID,
            'P_VERSION_NO'      VALUE P_VERSION_NO,
            'P_YYYYMMDD'        VALUE P_YYYYMMDD,
            'P_CURRENCY'        VALUE P_CURRENCY,
            'P_UNIT_CURRENCY'   VALUE P_UNIT_CURRENCY,
            'P_EXCHANGE_PRICE'  VALUE P_EXCHANGE_PRICE,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT;