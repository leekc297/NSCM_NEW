CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_BP_REPORT_EXCHANGE_RATE_CREATE" 
(
    P_DIVISION_ID         IN VARCHAR2,
    P_VERSION_NO          IN VARCHAR2,
    P_ACTION_TYPE         IN VARCHAR2,        -- T:Transfer, C:Cancel
    P_YYYY                IN VARCHAR2,
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : DMF0044_BP_REPORT_EXCHANGE_RATE_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE - 사업계획통화환율
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191101 KYH    환율 AVG 계산이 틀려서 null 로 변경함
 * 20191106 KYH		월별환율에 NULL 처리 추가
 * 20191118 hwi1993 파라미터 추가, Cancel 기능 추가, 데이터타입 변경
 * 2026.03.18   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
IS

    /* ── 로컬 변수 ── */
    V_YYYY              VARCHAR2(4 CHAR);
    V_USER_ID           VARCHAR2(10 CHAR) := 'mdf_batch';
    N_DELETE_COUNT      PLS_INTEGER := 0;
    N_MERGE_COUNT       PLS_INTEGER := 0;

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 병렬 DML 활성화 ── */
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    /* ── GTT 세션 레벨 통계 수집 설정 ── */
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_EXCHANGE_C', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    ---------------------------------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
    ---------------------------------------------------------------------------------------------------------------------------
    DELETE FROM DM_MOBILE_REPORT_EXCHANGE_RATE
    WHERE  1 = 1
    AND    DIVISION_ID = P_DIVISION_ID
    AND    VERSION_NO  = P_VERSION_NO;

    N_DELETE_COUNT := SQL%ROWCOUNT;
    ---------------------------------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (END)
    ---------------------------------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------------------------------
    --                                                                         요청VERSION COPY (BEGIN)
    ---------------------------------------------------------------------------------------------------------------------------
    IF P_ACTION_TYPE = 'T' THEN  -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리

        /* ── GTT 초기화 및 적재 ── */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F044_EXCHANGE_C';

        INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_F044_EXCHANGE_C
             ( DIVISION_ID, VERSION_NO, CURRENCY, UNIT_CURRENCY, YYYYMMDD, EXCHANGE_PRICE )
        SELECT DISTINCT DIVISION_ID, VERSION_NO, CURRENCY, UNIT_CURRENCY, YYYYMMDD, EXCHANGE_PRICE
        FROM   DM_BP_EXCHANGE_RATE_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = SUBSTR(P_VERSION_NO, 8, 18);

        -- COMMIT;

        /* ── GTT 통계 수집 ── */
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname          => 'SCM_MGR',
            tabname          => 'GT_F044_EXCHANGE_C',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
            method_opt       => 'FOR ALL COLUMNS SIZE 1'
        );

        /* ── 연도 루프: (year-1, year, year+1) ── */
        FOR rec IN (
            SELECT TO_CHAR(TO_NUMBER(P_YYYY) - 1) AS YYYY FROM DUAL
            UNION ALL
            SELECT P_YYYY AS YYYY FROM DUAL
            UNION ALL
            SELECT TO_CHAR(TO_NUMBER(P_YYYY) + 1) AS YYYY FROM DUAL
        )
        LOOP
            V_YYYY := rec.YYYY;

            INSERT INTO DM_MOBILE_REPORT_EXCHANGE_RATE
                 ( DIVISION_ID
                 , VERSION_NO
                 , YYYY
                 , SP_BP_TYPE
                 , CURRENCY
                 , UNIT_CURRENCY
                 , MM01
                 , MM02
                 , MM03
                 , MM04
                 , MM05
                 , MM06
                 , MM07
                 , MM08
                 , MM09
                 , MM10
                 , MM11
                 , MM12
                 , ORI_VERSION_NO
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            SELECT DIVISION_ID
                 , P_VERSION_NO
                 , V_YYYY        AS YYYY
                 , 'BP'          AS SP_BP_TYPE
                 , CURRENCY
                 , UNIT_CURRENCY
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '01' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM01
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '02' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM02
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '03' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM03
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '04' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM04
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '05' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM05
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '06' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM06
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '07' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM07
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '08' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM08
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '09' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM09
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '10' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM10
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '11' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM11
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '12' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM12
                 , SUBSTR(P_VERSION_NO, 8, 18) AS ORI_VERSION_NO
                 , V_USER_ID    AS CREATED_BY
                 , SYSDATE      AS CREATION_DATE
                 , V_USER_ID    AS LAST_UPDATED_BY
                 , SYSDATE      AS LAST_UPDATE_DATE
              FROM SCM_MGR.GT_F044_EXCHANGE_C
             WHERE 1 = 1
               --AND DIVISION_ID = P_DIVISION_ID
               --AND VERSION_NO  = P_VERSION_NO
               AND YYYYMMDD LIKE V_YYYY || '%'
            GROUP BY DIVISION_ID
                 , VERSION_NO
                 , CURRENCY
                 , UNIT_CURRENCY;

            N_MERGE_COUNT := N_MERGE_COUNT + SQL%ROWCOUNT;

        END LOOP;

    END IF;
    ---------------------------------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (END)
    ---------------------------------------------------------------------------------------------------------------------------

    /* ── 활성 트랜잭션 존재 여부 확인 후 COMMIT (Case 38) ── */
    IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
        COMMIT;
    END IF;

    -- N_LOG_COUNT := N_DELETE_COUNT + N_MERGE_COUNT;
    N_LOG_COUNT := N_MERGE_COUNT;


    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — DML 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(N_DELETE_COUNT) || ' / merge_count: ' || TO_CHAR(N_MERGE_COUNT);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 병렬 DML 비활성화 ── */
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 병렬 DML 비활성화
        BEGIN EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML'; EXCEPTION WHEN OTHERS THEN NULL; END;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_VERSION_NO'   VALUE P_VERSION_NO,
            'P_ACTION_TYPE'  VALUE P_ACTION_TYPE,
            'P_YYYY'         VALUE P_YYYY
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
        RAISE;
END DMF0044_BP_REPORT_EXCHANGE_RATE_CREATE;
/
