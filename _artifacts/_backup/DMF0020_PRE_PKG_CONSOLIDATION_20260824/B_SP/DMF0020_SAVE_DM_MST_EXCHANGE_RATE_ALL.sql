-- [BACKUP 2026-08-24] SCM_MGR.DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL (PROCEDURE, INVALID)
-- 원본 LAST_DDL = 2026-07-21 16:38:57

CREATE OR REPLACE PROCEDURE           "DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL"
(
    P_ACTIVE_FLAG       IN VARCHAR2,
    P_DIVISION_ID       IN VARCHAR2,
    P_YYYYMMDD          IN VARCHAR2,
    P_CURRENCY          IN VARCHAR2,
    P_UNIT_CURRENCY     IN VARCHAR2,
    P_EXCHANGE_PRICE    IN VARCHAR2,
    P_CREATED_BY        IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL
 * Description  : DMF0020_SalesFuturePricePopUp ('DM_MST_EXCHANGE_RATE' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20180807 KHSONG Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180807 KHSONG Split 구조변경
 * 20221025	ROSIA27	[C20221024-000510]DM UI 소스 정리 요청
 * 2026.03.17  jcnam   [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

    v_delimiter      VARCHAR2(1 CHAR) := '^';  -- 데이터 구분자
    v_max_cnt        PLS_INTEGER := 0;
    v_exists         PLS_INTEGER;

    -- LOG 용 변수 설정
    v_log_type       VARCHAR2(30 CHAR); -- START/END/ERROR/...
    n_log_count      PLS_INTEGER := 0;
    v_log_message    VARCHAR2(1000 CHAR);
    v_description    VARCHAR2(500 CHAR);
    d_event_date     DATE;
    n_delete_count   PLS_INTEGER := 0;
    n_merge_count    PLS_INTEGER := 0;

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE_E     VARCHAR2(100 CHAR);
    V_LOG_MESSAGE_E  VARCHAR2(4000 CHAR);
    V_DESCRIPTION_E  VARCHAR2(4000 CHAR);

BEGIN

    -- 시작 LOG  (START)
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    -- GTT TRUNCATE
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F020_EXCHANGE_RATE';

    --###############################################  GTT에 split후 insert (START)
    -- MSSQL WHILE 루프 → Oracle 집합 기반 INSERT
    -- '^' 구분자로 분리된 각 파라미터를 REGEXP_SUBSTR로 파싱하여 한번에 INSERT

    -- 레코드 수 계산 (DIVISION_ID 기준)
    SELECT REGEXP_COUNT(P_DIVISION_ID, '\^') + 1
    INTO   v_max_cnt
    FROM   DUAL;

    INSERT INTO SCM_MGR.GT_F020_EXCHANGE_RATE
    (ACTIVE_FLAG, DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, LAST_UPDATED_BY)
    SELECT TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,     '[^\^]+', 1, LEVEL)) AS ACTIVE_FLAG
         , TRIM(REGEXP_SUBSTR(P_DIVISION_ID,     '[^\^]+', 1, LEVEL)) AS DIVISION_ID
         , TRIM(REGEXP_SUBSTR(P_YYYYMMDD,        '[^\^]+', 1, LEVEL)) AS YYYYMMDD
         , TRIM(REGEXP_SUBSTR(P_CURRENCY,        '[^\^]+', 1, LEVEL)) AS CURRENCY
         , TRIM(REGEXP_SUBSTR(P_UNIT_CURRENCY,   '[^\^]+', 1, LEVEL)) AS UNIT_CURRENCY
         , TRIM(REGEXP_SUBSTR(P_EXCHANGE_PRICE,  '[^\^]+', 1, LEVEL)) AS EXCHANGE_PRICE
         , TRIM(REGEXP_SUBSTR(P_CREATED_BY,      '[^\^]+', 1, LEVEL)) AS CREATED_BY
         , TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY, '[^\^]+', 1, LEVEL)) AS LAST_UPDATED_BY
    FROM   DUAL
    CONNECT BY LEVEL <= v_max_cnt;

    COMMIT;

    --###############################################  GTT에 split후 insert (END)

    -- 20180806 KHSONG Division_id Null Validation 추가
    BEGIN
        SELECT 1
        INTO   v_exists
        FROM   DUAL
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F020_EXCHANGE_RATE R
            WHERE  NOT EXISTS (
                       SELECT 1
                       FROM   SCM_MST_DIVISION D
                       WHERE  D.DIVISION_ID = R.DIVISION_ID
                   )
        );

        -- Division 값이 존재하지 않는 레코드가 있음
        v_log_type    := 'INVALID';
        v_log_message := '########## END of procedure ##########';
        v_description := 'Division 값이 존재하지 않습니다.';
        d_event_date  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, v_description AS EVENT FROM DUAL;
        RETURN;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- 모든 Division이 유효함 → 정상 진행
    END;

    -- GTT 통계 수집
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_F020_EXCHANGE_RATE',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1',
        NO_INVALIDATE    => FALSE
    );

    --===================================================================================== delete start
    DELETE FROM DM_MST_EXCHANGE_RATE
    WHERE  EXISTS (
               SELECT 1
               FROM   GT_F020_EXCHANGE_RATE R
               WHERE  R.ACTIVE_FLAG                       = 'D'
               AND    DM_MST_EXCHANGE_RATE.DIVISION_ID    = R.DIVISION_ID
               AND    DM_MST_EXCHANGE_RATE.YYYYMMDD       = R.YYYYMMDD
               AND    DM_MST_EXCHANGE_RATE.CURRENCY       = R.CURRENCY
               AND    DM_MST_EXCHANGE_RATE.UNIT_CURRENCY  = R.UNIT_CURRENCY
           );

    n_delete_count := SQL%ROWCOUNT;
    --===================================================================================== delete end

    --===================================================================================== update, insert start
    MERGE INTO DM_MST_EXCHANGE_RATE A
    USING (
            SELECT DIVISION_ID
                 , YYYYMMDD
                 , CURRENCY
                 , UNIT_CURRENCY
                 , MAX(EXCHANGE_PRICE)  AS EXCHANGE_PRICE
                 , MAX(CREATED_BY)      AS CREATED_BY
                 , MAX(LAST_UPDATED_BY) AS LAST_UPDATED_BY
            FROM   GT_F020_EXCHANGE_RATE
            WHERE  ACTIVE_FLAG <> 'D'   -- DELETE값이 아닌경우만
            GROUP BY DIVISION_ID
                   , YYYYMMDD
                   , CURRENCY
                   , UNIT_CURRENCY
          ) B
    ON (
            A.DIVISION_ID   = B.DIVISION_ID
        AND A.YYYYMMDD      = B.YYYYMMDD
        AND A.CURRENCY      = B.CURRENCY
        AND A.UNIT_CURRENCY = B.UNIT_CURRENCY
       )
    WHEN MATCHED THEN
        UPDATE SET
            A.EXCHANGE_PRICE   = TO_NUMBER(B.EXCHANGE_PRICE),
            A.CREATED_BY       = B.CREATED_BY,
            A.CREATION_DATE    = SYSDATE,
            A.LAST_UPDATED_BY  = B.LAST_UPDATED_BY,
            A.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (
            DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY,
            EXCHANGE_PRICE, CREATED_BY, CREATION_DATE,
            LAST_UPDATED_BY, LAST_UPDATE_DATE
        )
        VALUES (
            B.DIVISION_ID, B.YYYYMMDD, B.CURRENCY, B.UNIT_CURRENCY,
            TO_NUMBER(B.EXCHANGE_PRICE), B.CREATED_BY, SYSDATE,
            B.LAST_UPDATED_BY, SYSDATE
        );

    n_merge_count := SQL%ROWCOUNT;
    --===================================================================================== update, insert end

    COMMIT;

    -- 종료 LOG
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류.
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_delete_count + n_merge_count) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE_E    := 'ERROR';
        V_LOG_MESSAGE_E := 'EXCEPTION';
        V_DESCRIPTION_E := '';
        V_SQL_CODE      := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG    := SQLERRM;
        V_PROC_INPUT    :=
            JSON_OBJECT(
                'P_ACTIVE_FLAG'     VALUE SUBSTR(P_ACTIVE_FLAG, 1, 500),
                'P_DIVISION_ID'     VALUE SUBSTR(P_DIVISION_ID, 1, 500),
                'P_YYYYMMDD'        VALUE SUBSTR(P_YYYYMMDD, 1, 500),
                'P_CURRENCY'        VALUE SUBSTR(P_CURRENCY, 1, 500),
                'P_UNIT_CURRENCY'   VALUE SUBSTR(P_UNIT_CURRENCY, 1, 500),
                'P_EXCHANGE_PRICE'  VALUE SUBSTR(P_EXCHANGE_PRICE, 1, 500),
                'P_CREATED_BY'      VALUE P_CREATED_BY,
                'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
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

END DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL;
/
