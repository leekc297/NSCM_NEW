CREATE OR REPLACE PACKAGE BODY           "PKG_DMF0044" IS

PROCEDURE P_DMF0044_BP_REPORT_DEPT_CREATE
(
    P_DIVISION_ID         IN VARCHAR2,
    P_VERSION_NO          IN VARCHAR2,
    P_ACTION_TYPE         IN VARCHAR2,        -- T:Transfer, C:Cancel
    P_YYYY                IN VARCHAR2,
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : DMF0044_BP_REPORT_DEPT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191022    KYH			[CSR ID:4103445] 컬럼통합. attribute1, 2 --> attribute1
 * 20191023 kyh    Department_Name 가져오는 로직을 Sales Report 와 동일하게 Lookup 을 보도록 수정
 * 20191118 hwi1993 파라미터, 데이터타입 변경 및 Cancel 기능 추가
 * 2026.03.18   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
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
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_REPORT_C', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    ---------------------------------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
    ---------------------------------------------------------------------------------------------------------------------------
    DELETE FROM DM_MOBILE_REPORT_DEPT
    WHERE  1 = 1
    AND    DIVISION_ID = P_DIVISION_ID
    AND    VERSION_NO  = P_VERSION_NO;

    N_DELETE_COUNT := SQL%ROWCOUNT;
    ---------------------------------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (END)
    ---------------------------------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (BEGIN)
    ---------------------------------------------------------------------------------------------------------------------------
    IF P_ACTION_TYPE = 'T' THEN  -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리

        /* ── GTT 초기화 및 적재 ── */
        DELETE FROM SCM_MGR.GT_F044_REPORT_C;

        INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_F044_REPORT_C
             ( DATA_TYPE, DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPT_ID,
               CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, ATTRIBUTE1,
               MEASURE, YYYYMM, QTY )
        SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPT_ID,
               CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, ATTRIBUTE1,
               MEASURE, YYYYMM, QTY
        FROM   DM_PLN_BP_FCST_REPORT_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        -- COMMIT;

        /* ── GTT 통계 수집 ── */
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname          => 'SCM_MGR',
            tabname          => 'GT_F044_REPORT_C',
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

            INSERT INTO DM_MOBILE_REPORT_DEPT
                 ( DIVISION_ID
                 , VERSION_NO
                 , YYYY
                 , SP_BP_TYPE
                 , UPPER_DEPT_NAME
                 , DEPT_NAME
                 , CUST_INFO
                 , PRODUCT_NAME
                 , PRODUCT_DETAIL
                 , MEASURE
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
                 , SORT_NO
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            SELECT A.DIVISION_ID
                 , A.VERSION_NO
                 , A.YYYY
                 , A.SP_BP_TYPE
                 , NVL(A.DEPARTMENT_NAME, '-') AS DEPARTMENT_NAME
                 , nvl(A.DEPT_NAME,'-') AS DEPT_NAME
                 , A.CUST_REPORT     AS CUST_INFO
                 --, CASE WHEN A.DATA_TYPE = '1' THEN A.CUST_REPORT ELSE A.END_CUST_REPORT END AS CUST_INFO
                 , A.PRODUCT_NAME
                 , nvl(A.PRODUCT_DETAIL,'-') AS PRODUCT_DETAIL
                 , A.MEASURE
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '01' THEN QTY ELSE 0 END) AS MM01
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '02' THEN QTY ELSE 0 END) AS MM02
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '03' THEN QTY ELSE 0 END) AS MM03
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '04' THEN QTY ELSE 0 END) AS MM04
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '05' THEN QTY ELSE 0 END) AS MM05
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '06' THEN QTY ELSE 0 END) AS MM06
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '07' THEN QTY ELSE 0 END) AS MM07
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '08' THEN QTY ELSE 0 END) AS MM08
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '09' THEN QTY ELSE 0 END) AS MM09
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '10' THEN QTY ELSE 0 END) AS MM10
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '11' THEN QTY ELSE 0 END) AS MM11
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '12' THEN QTY ELSE 0 END) AS MM12
                 , P_VERSION_NO AS ORI_VERSION_NO
                 , ROW_NUMBER() OVER(ORDER BY CASE WHEN A.DEPARTMENT_NAME IS NULL OR A.DEPARTMENT_NAME = '기타' THEN '?' ELSE A.DEPARTMENT_NAME END
                                             , CASE WHEN A.DEPT_NAME = 'MDF' THEN '?' ELSE A.DEPT_NAME END
                                             , A.DEPT_NAME
                                             , B.DISPLAY_SEQ
                                             , A.MEASURE) AS SORT_NO
                 , V_USER_ID    AS CREATED_BY
                 , SYSDATE      AS CREATION_DATE
                 , V_USER_ID    AS LAST_UPDATED_BY
                 , SYSDATE      AS LAST_UPDATE_DATE
              FROM (SELECT C.DATA_TYPE
                         , C.DIVISION_ID
                         , C.VERSION_NO
                         , V_YYYY        AS YYYY
                         , 'BP'          AS SP_BP_TYPE
                         -- 20191023 kyh
                         , NVL((SELECT SEGMENT2
                                FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
                                AND C.DEPARTMENT_ID = SEGMENT1), '')
                            AS DEPARTMENT_NAME
                         , NVL((SELECT SEGMENT2
                                FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                WHERE LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'
                                AND C.DEPT_ID = SEGMENT1), '')
                            AS DEPT_NAME
                         , C.CUST_REPORT
                         , C.END_CUST_REPORT
                         , C.PRODUCT_GROUP AS PRODUCT_NAME
                         , NVL(C.ATTRIBUTE1, '') AS PRODUCT_DETAIL
                         , CASE WHEN C.MEASURE = 'Business_Plan' THEN 'RTF' ELSE C.MEASURE END AS MEASURE
                         , C.YYYYMM
                         , C.QTY
                      FROM SCM_MGR.GT_F044_REPORT_C C
                     WHERE 1 = 1
                       AND C.DIVISION_ID = P_DIVISION_ID
                       AND C.VERSION_NO  = P_VERSION_NO
                       AND C.MEASURE IN ('Business_Plan', 'SalesAmt_KRW')
                       AND C.YYYYMM LIKE V_YYYY || '%'
                    ) A
                    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
                      ON A.CUST_REPORT = B.SEGMENT1
                     AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
             GROUP BY A.DATA_TYPE
                 , A.DIVISION_ID
                 , A.VERSION_NO
                 , A.YYYY
                 , A.SP_BP_TYPE
                 , A.DEPARTMENT_NAME
                 , A.DEPT_NAME
                 , A.CUST_REPORT
                 --, CASE WHEN A.DATA_TYPE = '1' THEN A.CUST_REPORT ELSE A.END_CUST_REPORT END
                 , A.PRODUCT_NAME
                 , A.PRODUCT_DETAIL
                 , B.DISPLAY_SEQ
                 , A.MEASURE;

            N_MERGE_COUNT := N_MERGE_COUNT + SQL%ROWCOUNT;

        END LOOP;

    END IF;
    ---------------------------------------------------------------------------------------------------------------------------
    --     요청VERSION COPY (END)
    ---------------------------------------------------------------------------------------------------------------------------

    /* ── 활성 트랜잭션 존재 여부 확인 후 COMMIT (Case 38) ── */
    IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
        COMMIT;
    END IF;

    N_LOG_COUNT := N_DELETE_COUNT + N_MERGE_COUNT;

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
END P_DMF0044_BP_REPORT_DEPT_CREATE;


PROCEDURE P_DMF0044_BP_REPORT_EXCHANGE_RATE_CREATE
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
        DELETE FROM SCM_MGR.GT_F044_EXCHANGE_C;

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
END P_DMF0044_BP_REPORT_EXCHANGE_RATE_CREATE;


PROCEDURE P_DMF0044_BP_REPORT_PRODUCT_CREATE
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
 * Program ID   : DMF0044_BP_REPORT_PRODUCT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191118 hwi1993 파라미터 추가, 데이터타입 변경 및 cancel 기능 추가
 * 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
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
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_REPORT_C', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    ---------------------------------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
    ---------------------------------------------------------------------------------------------------------------------------
    DELETE FROM DM_MOBILE_REPORT_PRODUCT
    WHERE  1 = 1
    AND    DIVISION_ID = P_DIVISION_ID
    AND    VERSION_NO  = P_VERSION_NO;

    N_DELETE_COUNT := SQL%ROWCOUNT;
    ---------------------------------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (END)
    ---------------------------------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (BEGIN)
    ---------------------------------------------------------------------------------------------------------------------------
    IF P_ACTION_TYPE = 'T' THEN  -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리

        /* ── GTT 초기화 및 적재 (GT_F044_REPORT_C 재사용) ── */
        DELETE FROM SCM_MGR.GT_F044_REPORT_C;

        INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_F044_REPORT_C
             ( DATA_TYPE, DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPT_ID,
               CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, ATTRIBUTE1,
               MEASURE, YYYYMM, QTY )
        SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPT_ID,
               CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, ATTRIBUTE1,
               MEASURE, YYYYMM, QTY
        FROM   DM_PLN_BP_FCST_REPORT_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        -- COMMIT;

        /* ── GTT 통계 수집 ── */
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname          => 'SCM_MGR',
            tabname          => 'GT_F044_REPORT_C',
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

            INSERT INTO DM_MOBILE_REPORT_PRODUCT
                 ( DIVISION_ID
                 , VERSION_NO
                 , YYYY
                 , SP_BP_TYPE
                 , PRODUCT_NAME
                 , PRODUCT_DETAIL
                 , MEASURE
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
                 , SORT_NO
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            SELECT A.DIVISION_ID
                 , A.VERSION_NO
                 , V_YYYY        AS YYYY
                 , 'BP'          AS SP_BP_TYPE
                 , A.PRODUCT_GROUP AS PRODUCT_NAME
                 , NVL(A.ATTRIBUTE1,'-') AS PRODUCT_DETAIL
                 , CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '01' THEN A.QTY ELSE 0 END) AS MM01
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '02' THEN A.QTY ELSE 0 END) AS MM02
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '03' THEN A.QTY ELSE 0 END) AS MM03
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '04' THEN A.QTY ELSE 0 END) AS MM04
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '05' THEN A.QTY ELSE 0 END) AS MM05
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '06' THEN A.QTY ELSE 0 END) AS MM06
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '07' THEN A.QTY ELSE 0 END) AS MM07
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '08' THEN A.QTY ELSE 0 END) AS MM08
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '09' THEN A.QTY ELSE 0 END) AS MM09
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '10' THEN A.QTY ELSE 0 END) AS MM10
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '11' THEN A.QTY ELSE 0 END) AS MM11
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '12' THEN A.QTY ELSE 0 END) AS MM12
                 , P_VERSION_NO AS ORI_VERSION_NO
                 , B.DISPLAY_SEQ AS SORT_NO
                 , V_USER_ID    AS CREATED_BY
                 , SYSDATE      AS CREATION_DATE
                 , V_USER_ID    AS LAST_UPDATED_BY
                 , SYSDATE      AS LAST_UPDATE_DATE
              FROM SCM_MGR.GT_F044_REPORT_C A
              LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
                ON A.PRODUCT_GROUP = B.SEGMENT1
               AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
             WHERE 1 = 1
               AND A.DIVISION_ID = P_DIVISION_ID
               AND A.VERSION_NO  = P_VERSION_NO
               AND A.MEASURE IN ('Business_Plan', 'SalesAmt_KRW')
               AND A.YYYYMM LIKE V_YYYY || '%'
             GROUP BY A.DIVISION_ID
                 , A.VERSION_NO
                 , A.PRODUCT_GROUP
                 , A.ATTRIBUTE1
                 , A.MEASURE
                 , B.DISPLAY_SEQ;

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
END P_DMF0044_BP_REPORT_PRODUCT_CREATE;


PROCEDURE P_DMF0044_GET_COPY_VERSION_POPUP
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    P_VERSION_TYPE    IN VARCHAR2,
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DM0035_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/06/03  JYE       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.18   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
/*                                                                                                  */
/****************************************************************************************************/
/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
IS

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

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    OPEN O_RC1 FOR
    WITH SPLIT_DIVISION AS (
        SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL)) AS TOKEN
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
    ),
    SPLIT_VERSION_TYPE AS (
        SELECT TRIM(REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL)) AS TOKEN
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL
    ),
    SPLIT_VERSION_NO AS (
        SELECT TRIM(REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL)) AS TOKEN
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL) IS NOT NULL
    )
    SELECT T1.VERSION_NO AS CODE, T1.VERSION_NO, T1.VERSION_DESCRIPTION, T1.VERSION_TYPE, T1.VER_CRE_SEQ, T1.YYYYMMDD, MAX(T1.CREATED_BY) AS CREATED_BY, MAX(T1.CREATION_DATE) AS CREATION_DATE,
            NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM   DM_MST_VERSION T1
    INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
    ON T1.DIVISION_ID = T2.UNIT_ID

    WHERE  (T1.YYYYMMDD >= P_START_YYYYMMDD AND T1.YYYYMMDD <= P_END_YYYYMMDD)
    AND    T1.DIVISION_ID IN (SELECT TOKEN FROM SPLIT_DIVISION)
    AND    T1.VERSION_TYPE IN (SELECT TOKEN FROM SPLIT_VERSION_TYPE)
    AND    EXISTS (SELECT 1 FROM SPLIT_VERSION_NO P WHERE T1.VERSION_NO LIKE P.TOKEN || '%')
    GROUP BY T1.VERSION_NO, T1.VERSION_NO, T1.VERSION_DESCRIPTION, T1.VERSION_TYPE, T1.VER_CRE_SEQ, T1.YYYYMMDD, NVL(T2.EDIT_YN,'N')
    ORDER BY CODE DESC, T1.VERSION_NO DESC;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
            'P_CREATED_BY'     VALUE P_CREATED_BY,
            'P_DIVISION_ID'    VALUE P_DIVISION_ID,
            'P_VERSION_TYPE'   VALUE P_VERSION_TYPE,
            'P_VERSION_NO'     VALUE P_VERSION_NO,
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID

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
END P_DMF0044_GET_COPY_VERSION_POPUP;


PROCEDURE P_DMF0044_GET_MEASURE
(
    P_DATA_TYPE       IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_GET_MDF_REPORTS_DATA
 * Description  :  MDF Reports 메인 데이터 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/01/20	HWI1993		Initial Release -- COMMON 을 사용하지 않기 위해 새로 생성함. ( COMMON 의 DMF0044_MDF_MEASURE_ETC 와 동일 )
 * 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
*/
IS

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

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    OPEN O_RC1 FOR
    SELECT
            COLUMN_NAME  AS CODE
            , COLUMN_LABEL_NAME  AS NAME
            , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM SCM_MST_SHEET_MEASURE T1
        INNER JOIN (SELECT * -- EDIT_YN
         FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
         WHERE USER_ID = P_USER_ID
         AND MNU_ID = P_MNU_ID
         AND UNIT_TP_CD = 'D') T2
         ON T2.UNIT_ID in (
             SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
             FROM   DUAL
             CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
         )

    WHERE  1 = 1
    AND    PROGRAM_ID  = 'DMF0044'
    AND    SHEET_NAME  = 'MDF Reports'
    AND    COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC')
    ORDER BY SORT_ORDER_NO;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DATA_TYPE' VALUE P_DATA_TYPE,
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
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
END P_DMF0044_GET_MEASURE;


PROCEDURE P_DMF0044_GET_SALES_REPORTS_DATA
(
    P_DIVISION_ID         IN VARCHAR2,
    P_MDF_TYPE            IN VARCHAR2,
    P_YYYY                IN VARCHAR2,
    P_SP_VERSION_NO       IN VARCHAR2,
    P_DATA_TYPE           IN VARCHAR2,
    P_USER_GROUP          IN VARCHAR2,
    P_CREATED_BY          IN VARCHAR2,

    P_USER_ID             IN VARCHAR2, -- For EditYn
    P_MNU_ID              IN VARCHAR2, -- For EditYn

    O_RC1                 OUT SYS_REFCURSOR,
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
/*=====================================================================================================================================================
 * Program ID   : DMF0044_GET_SALES_REPORTS_DATA
 * Description  : Sales Reports 메인 데이터 조회
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge	Description
 *=====================================================================================================================================================
 * 2019/05/28	JYE			Initial Release
 * 2020/01/08	hwi1993		RTF 추가, Measure 테이블 참조
 * 2020/01/17	HWI1993		PROJECT_CODE, SCM_SITE_ID, APPLICATION 추가
 * 2020/01/22	HWI1993		BizType, DMS_SALES, DMS_CUSTOMER 추가
 * 2020/02/03	HWI1993		SalesAmt_USD 추가
 * 2020/02/10	HWI1993		특정 버전에 대해 Timeout 나는 경우가 있어서 with recompile 추가
 * 2020/02/13	HWI1993		company_id 가져오는 로직 변경
 * 2020/02/19	P.C.I  		company_id, sold to cust(report) 정렬
 * 2020/03/12	HWI1993		컬럼 3개 추가, 정렬 수정, DEPARTMENT_NAME 및 DEPT_NAME 을 LOOKUP 에서 가져오도록 변경
 * 2020/03/13	HWI1993		country 추가, 정렬순서 수정, PROJECT_CODE, SCM_SITE_ID 추가(주석제거)-컷오프 데이터 저장시 필요함
 * 2020/03/13	KHSONG      C20200103-000586 권한그룹을 LOOKUP관리
 * 2020/03/16	HWI1993		SOLDTO_CODE 추가
 * 2020/04/27	HWI1993		BP TABLE 제거, ETC 추가
 * 2020/06/03	HWI1993		소형에서 조회시 PIVOT 처리할 때 NULL 과 공백이 섞여있어서 PIVOT 이 안되는 경우가 있어서 ISNULL 처리함
 * 2020/07/09	HWI1993		C20200618-000336 소형SoldTo 적용
 * 2020/09/21	HWI1993		[C20200909-000188] [ESS영업관리팀] GDW 용도별 매출 수정 (프로젝트 코드 S 주택용/상업용 분리)
 * 2021/01/26   P.C.I		[C20210125-000207] 40사업부 RTF Measure, CELL_MODEL_INFO 컬럼 추가
 * 2021/07/23	HWI1993		상반기과제 - 소형 마스터 정비
 * 2022/01/21	rosia27		[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2022/01/27	hwi1993		[C20211025-000405] SalesReport키추가 - CUST_GROUP_DTL 컬럼 추가
 * 2022/04/13   HWI1993     GM JV 작업
 * 2024/03/13   kcw3408		DM 프로시저 속도개선
 * 2024/05/09	JSSBAE		[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2024/08/26	JSSBAE		[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가
 * 2024/09/12	JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024/11/15	KANG.H.J	[PJ2024-50611] 소형 매출 프로세스 개선
 * 2026.03.23   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발

VAR RC1 REFCURSOR
VAR RC2 REFCURSOR
exec DMF0044_GET_SALES_REPORTS_DATA('40', 'REPORT_SP_W', '2026', 'R_S_20250609_V001_C', '2', 'ADMIN', 'hjkang.lges', :rc1, :rc2)
print rc1
print rc2


 *===================================================================================================================================================*/
IS

    V_PROD              VARCHAR2(4000 CHAR) := '';
    V_SQL               VARCHAR2(32767 CHAR) := '';
    V_GROUP_ID          VARCHAR2(100 CHAR) := '';
    V_TEAM_ID           VARCHAR2(100 CHAR) := '';
    V_USER_MEA_CNT      PLS_INTEGER := 0;

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

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── GTT 초기화 (일반 테이블 DML 존재하므로 DELETE 사용) ── */
    DELETE FROM SCM_MGR.GT_F044_SELECT_MEASURE;
    DELETE FROM SCM_MGR.GT_F044_PJT;
    DELETE FROM SCM_MGR.GT_F044_DM_MST_ITEM_SINGLE_V;
    DELETE FROM SCM_MGR.GT_F044_T;

    /* ── GTT 통계 설정 (JOIN 사용) ── */
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_SELECT_MEASURE', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_PJT', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_DM_MST_ITEM_SINGLE_V', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_T', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

    ---------------------------------------------------------------------------------
    --            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    BEGIN
        SELECT 1
        INTO   V_USER_MEA_CNT
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
            AND    VALID_YN = 'Y'
            AND    SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
            AND    SEGMENT1 = P_USER_GROUP
        );
        V_GROUP_ID := 'ADMIN';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_GROUP_ID := '';
    END;
    ---------------------------------------------------------------------------------
    --            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    -- 팀 권한
    BEGIN
        SELECT DEPT_ID
        INTO   V_TEAM_ID
        FROM   SCM_ADM_USER_M
        WHERE  USER_ID = P_CREATED_BY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_TEAM_ID := '';
    END;

    V_USER_MEA_CNT := 0;

    -- MEASURE JOIN 처리용
    -- 사용자메저 처리
    BEGIN
        SELECT 1
        INTO   V_USER_MEA_CNT
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MST_TITLESET_USER U
            WHERE  U.PROGRAM_ID = 'DMF0044'
            AND    U.SHEET_NAME = 'MDF Reports'
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
            AND    U.USER_ID    = P_CREATED_BY
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_USER_MEA_CNT := 0;
    END;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT P_CREATED_BY
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'M'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , ''
             , P_CREATED_BY
             , SYSDATE   -- 2026-07-30 정정: DATE 컬럼에 문자열 대입 → ORA-01861
             , P_CREATED_BY
             , SYSDATE   -- 2026-07-30 정정: 동일
        FROM   SCM_MST_SHEET_MEASURE C
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = 'DMF0044'
        AND    C.SHEET_NAME  = 'MDF Reports'
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

    /* ── GT_F044_SELECT_MEASURE 적재 ── */
    INSERT INTO SCM_MGR.GT_F044_SELECT_MEASURE
        (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE, SORT_ORDER_NO)
    SELECT U.PROGRAM_ID
         , U.SHEET_NAME
         , U.USER_ID
         , U.COLUMN_NAME AS MEASURE
         , U.SORT_ORDER_NO
    FROM SCM_MST_TITLESET_USER U
    WHERE 1 = 1
    AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND U.PROGRAM_ID   = 'DMF0044'
    AND U.USER_ID      = P_CREATED_BY;

    /* ── GT_F044_PJT 적재 ── */
    INSERT INTO SCM_MGR.GT_F044_PJT
        (DIVISION_ID, PROJECT_CODE, PROJECT_NAME, PRODUCT_GROUP_NAME)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_NAME, A.PRODUCT_GROUP_NAME
    FROM SCM_MST_PROJECT A
    JOIN (
        SELECT PROJECT_CODE, MAX(PROJECT_VER_SEQ) AS SEQ
        FROM SCM_MST_PROJECT
        WHERE DIVISION_ID = P_DIVISION_ID
        GROUP BY PROJECT_CODE
    ) B ON A.PROJECT_CODE = B.PROJECT_CODE AND A.PROJECT_VER_SEQ = B.SEQ
    WHERE A.DIVISION_ID = P_DIVISION_ID;

    /* ── GT_F044_DM_MST_ITEM_SINGLE_V 적재 ── */
    --[E20240920-000300]_SCM.DM 화면 조회 속도 개선
    --[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가
    INSERT INTO SCM_MGR.GT_F044_DM_MST_ITEM_SINGLE_V
        (DIVISION_ID, ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME,
         FORECAST_INFO_BIZ_TYPE, ENERGE, ENERGE_WH, ENERGE_KWH)
    WITH ITEM_A AS (
        SELECT T1.DIVISION_ID
             , T1.ITEM_ID
             , MAX(T1.ITEM_NAME)            AS ITEM_NAME
             , MAX(T1.ITEM_CLASS)           AS ITEM_CLASS
             , MAX(T1.ITEM_CLASS_NAME)      AS ITEM_CLASS_NAME
             , MAX(T1.NICK_NAME)            AS NICK_NAME
             , MAX(T1.ENERGE)               AS ENERGE
        FROM SCM_MST_ITEM_SN T1
        WHERE T1.DIVISION_ID = P_DIVISION_ID
        GROUP BY T1.DIVISION_ID, T1.ITEM_ID
    ),
    ITEM_B AS (
        SELECT DIVISION_ID
             , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
             , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
        FROM SCM_MST_ITEM_SN
        WHERE DIVISION_ID = P_DIVISION_ID
        GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
    ),
    ITEM_JOINED AS (
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.ITEM_CLASS
             , A.ITEM_NAME
             , A.ITEM_CLASS_NAME
             , A.NICK_NAME
             , B.FORECAST_INFO_BIZ_TYPE
             , A.ENERGE
        FROM ITEM_A A
        INNER JOIN ITEM_B B
            ON A.DIVISION_ID = B.DIVISION_ID
           AND SUBSTR(A.ITEM_ID, 1, 12) = B.ITEM_ID
    )
    SELECT DIVISION_ID, ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME
         , FORECAST_INFO_BIZ_TYPE, ENERGE
         , ENERGE AS ENERGE_WH
         , CASE WHEN REGEXP_LIKE(ENERGE, '^\d+\.?\d*$') THEN TO_CHAR(ROUND(TO_NUMBER(ENERGE) / 1000, 7)) ELSE NULL END AS ENERGE_KWH
    FROM ITEM_JOINED;

    /* ── GTT 통계 수집 ── */
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_F044_SELECT_MEASURE', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_F044_PJT', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_F044_DM_MST_ITEM_SINGLE_V', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    -- 단계1. 데이터 쿼리 ########################################################
    -- CUTOFF_DATA
    IF P_DATA_TYPE <> '2' THEN
        INSERT INTO SCM_MGR.GT_F044_T
             ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
             , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
             , END_CUSTOMER, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
             , ITEM_ID, NICK_NAME, DOM_EXP, FCST_TYPE, INCOTERMS
             , MEASURE, PLANT_SITE_ID, COMPANY_ID, YYYYMM, CURRENCY
             , QTY, EDIT_FLAG, APP, SOLDTO_CUST_REPORT, DMS_CUSTOMER
             , BIZ_TYPE_NAME40, APPLICATION_GR, PRODUCT_DETAILS, CELL_MODEL_INFO, CELL_MODEL, DISPLAY_SEQ1
             , DISPLAY_SEQ2, COUNTRY_CODE, SOLDTO_CODE, ITEM_NAME, PROJECT_NAME
             , CELL_PER_CAR, MODULE_PER_CAR, MODEL_TYPE
             , SOLDTO_COUNTRY, SHIPTO_COUNTRY, CELL_NAME, ITEM_USE, CUST_GROUP_DTL
             , CELL_PROD_SITE	--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
             , ENERGE_WH		--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
             , ENERGE_KWH		--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
             )
        SELECT
            R.DATA_TYPE, R.DIVISION_ID, R.VERSION_NO, R.CUTOFF_TYPE, R.CUTOFF_YYYYMMDD
            , R.DEPARTMENT_ID
            , CASE WHEN R.DEPARTMENT_NAME IS NOT NULL THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS DEPARTMENT_NAME
            , R.DEPT_ID
            , CASE WHEN R.DEPT_NAME IS NOT NULL THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END AS DEPT_NAME
            , R.END_CUST_REPORT
            , CASE WHEN R.DIVISION_ID LIKE '81%' AND R.CUTOFF_TYPE LIKE 'REPORT_BP%' THEN R.END_CUST_REPORT
                    ELSE NVL(ST.END_CUSTOMER, '') END AS END_CUSTOMER
            , R.CUST_REPORT
            , CASE WHEN R.DIVISION_ID = '40' THEN R.PRODUCT_GROUP
                   WHEN R.DIVISION_ID LIKE '81%' THEN PJT.PRODUCT_GROUP_NAME
                   END AS PRODUCT_GROUP
            , CASE WHEN LENGTH(R.PROJECT_CODE) > 1 THEN R.PROJECT_CODE ELSE '' END AS PROJECT_CODE
            , R.SCM_SITE_ID, R.ITEM_ID
            , CASE WHEN R.NICK_NAME IS NOT NULL THEN R.NICK_NAME ELSE SINGLE.NICK_NAME END, NULL AS DOM_EXP, R.FCST_TYPE, R.INCOTERMS
            , R.MEASURE, R.PLANT_SITE_ID, R.COMPANY_ID
            , 'M_' || SUBSTR(R.YYYYMMDD, 1, 6) AS YYYYMM, R.CURRENCY, SUM(R.QTY) AS QTY
            , CASE WHEN (V_GROUP_ID = 'ADMIN') AND (DATA_TYPE = '2') THEN 'Y' ELSE 'N' END AS EDIT_FLAG
            , CASE WHEN R.APPLICATION IS NOT NULL THEN R.APPLICATION ELSE SI.APPLICATION END AS APP
            , CASE WHEN R.SOLDTO_CUST_REPORT IS NOT NULL THEN R.SOLDTO_CUST_REPORT ELSE NVL(SI.ATTRIBUTE1, '') END AS SOLDTO_CUST_REPORT
            , NVL(SI.ATTRIBUTE2, '') AS DMS_CUSTOMER
            , CASE WHEN R.FORECAST_INFO_BIZ_TYPE IS NOT NULL THEN R.FORECAST_INFO_BIZ_TYPE ELSE SINGLE.FORECAST_INFO_BIZ_TYPE END AS BIZ_TYPE_NAME40
            , CASE WHEN R.APPLICATION_GR IS NOT NULL THEN R.APPLICATION_GR ELSE LU.ATTRIBUTE1 END AS APPLICATION_GR
            , CASE WHEN R.PRODUCT_DETAILS IS NOT NULL THEN R.PRODUCT_DETAILS ELSE LU.ATTRIBUTE4 END AS PRODUCT_DETAILS
            , NVL(R.FORECAST_INFO_CELL_MODEL, '') AS CELL_MODEL_INFO --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
            , NVL(R.ATTRIBUTE3, '') AS CELL_MODEL --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
            , LK1.DISPLAY_SEQ AS DISPLAY_SEQ1, LK2.DISPLAY_SEQ AS DISPLAY_SEQ2
            , ST.COUNTRY
            , CS.SOLDTO_CODE
            , SINGLE.ITEM_NAME
            -- 자동차
            , PJT.PROJECT_NAME, SI.CELL_PER_CAR, CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE ELSE NULL END AS MODULE_PER_CAR
            , CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' THEN 'Cell'
                   WHEN SINGLE.ITEM_CLASS_NAME LIKE '%PACK%' THEN 'Pack'
                   WHEN SINGLE.ITEM_CLASS_NAME LIKE '%MODULE%' THEN 'Module'
                   END AS MODEL_TYPE
            -- ESS
            , NVL(SUBSTR(CS.SOLDTO_CODE, 1, 2), '') AS SOLDTO_COUNTRY
            , NVL(SUBSTR(CS.SHIPTO_CODE, 1, 2), '') AS SHIPTO_COUNTRY
            , NVL(SI.ATTRIBUTE9, '') AS CELL_NAME
            -- C20200909-000188
            , CASE WHEN LK3.SEGMENT1 IS NOT NULL THEN LK3.SEGMENT2
                    ELSE NVL(SUBSTR(R.PROJECT_CODE, 1, 1), '') END AS ITEM_USE
            , R.CUST_GROUP_DTL
            , NVL(LK4.ATTRIBUTE1, '') AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
            , SINGLE.ENERGE_WH		--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
            , SINGLE.ENERGE_KWH		--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
        FROM DM_PLN_SALES_PLAN_REPORT_C R
        LEFT JOIN SCM_MST_SITE_ITEM SI
            ON R.DIVISION_ID = SI.DIVISION_ID
                AND R.PROJECT_CODE = SI.PROJECT_CODE
                AND R.SCM_SITE_ID = SI.SCM_SITE_ID
                AND R.ITEM_ID = SI.ITEM_ID
        LEFT JOIN SCM_MGR.GT_F044_DM_MST_ITEM_SINGLE_V SINGLE
            ON SI.DIVISION_ID = SINGLE.DIVISION_ID AND SI.ITEM_ID = SINGLE.ITEM_ID
        -- LOOKUP 26.03.20
        LEFT JOIN (SELECT DISTINCT SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, ATTRIBUTE1, ATTRIBUTE4
                   FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE LOOKUP_TYPE = 'SALES_SITE_REPORT_GROUP') LU
            ON R.DIVISION_ID = LU.SEGMENT1
           AND R.PROJECT_CODE = LU.SEGMENT2
           AND R.SCM_SITE_ID = LU.SEGMENT3
           AND R.ITEM_ID = LU.SEGMENT4
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON R.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT' || CASE WHEN R.DIVISION_ID = '40' THEN '' ELSE '_' || R.DIVISION_ID END
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON R.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' || CASE WHEN R.DIVISION_ID = '40' THEN '' ELSE '_' || R.DIVISION_ID END
        LEFT OUTER JOIN SCM_MST_SITE ST ON R.SCM_SITE_ID = ST.SCM_SITE_ID AND R.DIVISION_ID = ST.DIVISION_ID
        LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER CS ON R.DIVISION_ID = CS.DIVISION_ID AND R.SCM_SITE_ID = CS.SCM_SITE_ID AND CS.REP_YN = 'Y' AND CS.VALID_YN = 'Y'
        LEFT OUTER JOIN SCM_MGR.GT_F044_PJT PJT ON R.DIVISION_ID = PJT.DIVISION_ID AND R.PROJECT_CODE = PJT.PROJECT_CODE
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 ON R.PROJECT_CODE = LK3.SEGMENT1 AND LK3.LOOKUP_TYPE = 'DM_ITEM_USE_EX'
        --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
        LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK4 ON R.CELL_PROD_SITE = LK4.SEGMENT1 AND LK4.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'		--[PJ2024-50611] 소형 매출 프로세스 개선
        WHERE R.DIVISION_ID = P_DIVISION_ID
            AND R.CUTOFF_TYPE = P_MDF_TYPE
            AND SUBSTR(R.YYYYMMDD, 1, 4) = P_YYYY
            AND R.VERSION_NO = P_SP_VERSION_NO
        GROUP BY
            R.DATA_TYPE, R.DIVISION_ID, R.VERSION_NO, R.CUTOFF_TYPE, R.CUTOFF_YYYYMMDD, R.DEPARTMENT_ID
            , CASE WHEN R.DEPARTMENT_NAME IS NOT NULL THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END
            , R.DEPT_ID
            , CASE WHEN R.DEPT_NAME IS NOT NULL THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END, R.END_CUST_REPORT
            , ST.END_CUSTOMER, R.CUST_REPORT, R.PRODUCT_GROUP
            , CASE WHEN LENGTH(R.PROJECT_CODE) > 1 THEN R.PROJECT_CODE ELSE '' END, R.SCM_SITE_ID
            , R.ITEM_ID, R.FCST_TYPE, R.INCOTERMS, R.MEASURE, R.PLANT_SITE_ID, R.COMPANY_ID, R.CURRENCY
            , CASE WHEN R.NICK_NAME IS NOT NULL THEN R.NICK_NAME ELSE SINGLE.NICK_NAME END
            , SUBSTR(R.YYYYMMDD, 1, 6)
            , CASE WHEN R.APPLICATION IS NOT NULL THEN R.APPLICATION ELSE SI.APPLICATION END
            , CASE WHEN R.SOLDTO_CUST_REPORT IS NOT NULL THEN R.SOLDTO_CUST_REPORT ELSE NVL(SI.ATTRIBUTE1, '') END
            , NVL(SI.ATTRIBUTE2, '')
            , CASE WHEN R.FORECAST_INFO_BIZ_TYPE IS NOT NULL THEN R.FORECAST_INFO_BIZ_TYPE ELSE SINGLE.FORECAST_INFO_BIZ_TYPE END
            , CASE WHEN R.APPLICATION_GR IS NOT NULL THEN R.APPLICATION_GR ELSE LU.ATTRIBUTE1 END
            , CASE WHEN R.PRODUCT_DETAILS IS NOT NULL THEN R.PRODUCT_DETAILS ELSE LU.ATTRIBUTE4 END
            , NVL(R.FORECAST_INFO_CELL_MODEL, '') --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
            , NVL(R.ATTRIBUTE3, '') --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
            , LK1.SEGMENT2, LK2.SEGMENT2, LK1.DISPLAY_SEQ, LK2.DISPLAY_SEQ
            , ST.COUNTRY, CS.SOLDTO_CODE, PJT.PROJECT_NAME, SI.CELL_PER_CAR
            , CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE ELSE NULL END
            , SUBSTR(CS.SOLDTO_CODE, 1, 2), SUBSTR(CS.SHIPTO_CODE, 1, 2), SI.ATTRIBUTE9
            , CASE WHEN LK3.SEGMENT1 IS NOT NULL THEN LK3.SEGMENT2
                    ELSE NVL(SUBSTR(R.PROJECT_CODE, 1, 1), '') END
            , SINGLE.ITEM_NAME
            , CASE WHEN R.DIVISION_ID = '40' THEN R.PRODUCT_GROUP
                   WHEN R.DIVISION_ID LIKE '81%' THEN PJT.PRODUCT_GROUP_NAME
                   END
            , CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' THEN 'Cell'
                   WHEN SINGLE.ITEM_CLASS_NAME LIKE '%PACK%' THEN 'Pack'
                   WHEN SINGLE.ITEM_CLASS_NAME LIKE '%MODULE%' THEN 'Module'
                   END
            , CASE WHEN R.DIVISION_ID LIKE '81%' AND R.CUTOFF_TYPE LIKE 'REPORT_BP%' THEN R.END_CUST_REPORT ELSE NVL(ST.END_CUSTOMER, '') END
            , R.CUST_GROUP_DTL
            , LK4.ATTRIBUTE1 --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
            , SINGLE.ENERGE_WH		--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
            , SINGLE.ENERGE_KWH		--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
        ;
    END IF;

    IF P_DATA_TYPE <> '1' THEN
        INSERT INTO SCM_MGR.GT_F044_T
             ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
             , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
             , END_CUSTOMER, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
             , ITEM_ID, NICK_NAME, DOM_EXP, FCST_TYPE, INCOTERMS
             , MEASURE, PLANT_SITE_ID, COMPANY_ID, YYYYMM, CURRENCY
             , QTY, EDIT_FLAG, APP, SOLDTO_CUST_REPORT, DMS_CUSTOMER
             , BIZ_TYPE_NAME40, APPLICATION_GR, PRODUCT_DETAILS, CELL_MODEL_INFO, CELL_MODEL, DISPLAY_SEQ1
             , DISPLAY_SEQ2, COUNTRY_CODE, SOLDTO_CODE, ITEM_NAME, PROJECT_NAME
             , CELL_PER_CAR, MODULE_PER_CAR, MODEL_TYPE
             , SOLDTO_COUNTRY, SHIPTO_COUNTRY, CELL_NAME, ITEM_USE, CUST_GROUP_DTL
             , CELL_PROD_SITE		--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
             , ENERGE_WH			--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
             , ENERGE_KWH			--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
             )
        SELECT
            '2' AS DATA_TYPE, R.DIVISION_ID, R.VERSION_NO, R.CUTOFF_TYPE, R.CUTOFF_YYYYMMDD
            , R.DEPARTMENT_ID
            , CASE WHEN R.DEPARTMENT_NAME IS NOT NULL THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS DEPARTMENT_NAME
            , R.DEPT_ID
            , CASE WHEN R.DEPT_NAME IS NOT NULL THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END AS DEPT_NAME
            , R.END_CUST_REPORT
            , NVL(R.END_CUSTOMER, '') AS END_CUSTOMER
            , R.CUST_REPORT
            , CASE WHEN R.DIVISION_ID = '40' THEN R.PRODUCT_GROUP
                   WHEN R.DIVISION_ID LIKE '81%' THEN PJT.PRODUCT_GROUP_NAME
                   END AS PRODUCT_GROUP
            , R.PROJECT_CODE, R.SCM_SITE_ID
            , R.ITEM_ID
            , CASE WHEN R.NICK_NAME IS NOT NULL THEN R.NICK_NAME ELSE SINGLE.NICK_NAME END AS NICK_NAME
            , NULL AS DOM_EXP, R.FCST_TYPE, R.INCOTERMS
            , R.MEASURE, R.PLANT_SITE_ID, R.COMPANY_ID, 'M_' || SUBSTR(R.YYYYMMDD, 1, 6) AS YYYYMM, R.CURRENCY
            , SUM(R.QTY) AS QTY, CASE WHEN (V_GROUP_ID = 'ADMIN') THEN 'Y' ELSE 'N' END AS EDIT_FLAG
            , R.APPLICATION AS APP, R.SOLDTO_CUST_REPORT, NVL(SI.ATTRIBUTE2, '') AS DMS_CUSTOMER
            , R.BIZ_TYPE AS BIZ_TYPE, R.APPLICATION_GR AS APPLICATION_GR, R.PRODUCT_DETAILS AS PRODUCT_DETAILS
            , NVL(R.CELL_MODEL_INFO, '') AS CELL_MODEL_INFO--, SI.REPORT_GROUP6 AS CELL_MODEL_INFO --[C20210125-000207] ETC Report에서 입력한 40사업부 CELL_MODEL_INFO 적용
            , NVL(R.ATTRIBUTE3, '') AS CELL_MODEL --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
            , LK1.DISPLAY_SEQ AS DISPLAY_SEQ1
            , LK2.DISPLAY_SEQ AS DISPLAY_SEQ2, R.COUNTRY_CODE, R.SOLDTO_CODE
            , NULL AS ITEM_NAME, NVL(LK3.SEGMENT3, PJT.PROJECT_NAME) AS PROJECT_NAME
            , SI.CELL_PER_CAR, CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE END AS MODULE_PER_CAR
            , CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' THEN 'Cell'
                   WHEN SINGLE.ITEM_CLASS_NAME LIKE '%PACK%' THEN 'Pack'
                   WHEN SINGLE.ITEM_CLASS_NAME LIKE '%MODULE%' THEN 'Module'
                   END AS MODEL_TYPE
            , NVL(R.SOLDTO_COUNTRY, '') AS SOLDTOCOUNTRY, NVL(R.SHIPTO_COUNTRY, '') AS SHIPTOCOUNTRY
            , NVL(SI.ATTRIBUTE9, '') AS CELL_NAME
            , NVL(R.ITEM_USE, '') AS ITEM_USE
            , R.CUST_GROUP_DTL
            --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
            , '' AS CELL_PROD_SITE
            , SINGLE.ENERGE_WH		--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
            , SINGLE.ENERGE_KWH		--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
        FROM DM_PLN_SALES_ETC_REPORT_C R
        LEFT JOIN SCM_MST_SITE_ITEM SI
            ON R.DIVISION_ID = SI.DIVISION_ID
                AND R.PROJECT_CODE = SI.PROJECT_CODE
                AND R.SCM_SITE_ID = SI.SCM_SITE_ID
                AND R.ITEM_ID = SI.ITEM_ID
        LEFT JOIN SCM_MGR.GT_F044_DM_MST_ITEM_SINGLE_V SINGLE
            ON SI.DIVISION_ID = SINGLE.DIVISION_ID
                AND SI.ITEM_ID = SINGLE.ITEM_ID
        -- LOOKUP 26.03.20
        LEFT JOIN (SELECT DISTINCT SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, ATTRIBUTE1, ATTRIBUTE4
                   FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE LOOKUP_TYPE = 'SALES_SITE_REPORT_GROUP') LU
            ON R.DIVISION_ID = LU.SEGMENT1
           AND R.PROJECT_CODE = LU.SEGMENT2
           AND R.SCM_SITE_ID = LU.SEGMENT3
           AND R.ITEM_ID = LU.SEGMENT4
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON R.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT' || CASE WHEN R.DIVISION_ID = '40' THEN '' ELSE '_' || R.DIVISION_ID END
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON R.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' || CASE WHEN R.DIVISION_ID = '40' THEN '' ELSE '_' || R.DIVISION_ID END
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 ON R.PROJECT_CODE = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_ETC_PROJECT' AND LK3.SEGMENT1 = R.DIVISION_ID
        LEFT OUTER JOIN SCM_MST_SITE ST ON R.SCM_SITE_ID = ST.SCM_SITE_ID AND R.DIVISION_ID = ST.DIVISION_ID
        LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER CS ON R.DIVISION_ID = CS.DIVISION_ID AND R.SCM_SITE_ID = CS.SCM_SITE_ID AND CS.REP_YN = 'Y' AND CS.VALID_YN = 'Y'
        LEFT OUTER JOIN SCM_MGR.GT_F044_PJT PJT ON R.DIVISION_ID = PJT.DIVISION_ID AND R.PROJECT_CODE = PJT.PROJECT_CODE
        LEFT OUTER JOIN SCM_MGR.GT_F044_DM_MST_ITEM_SINGLE_V ITEM_V ON R.DIVISION_ID = ITEM_V.DIVISION_ID AND R.ITEM_ID = ITEM_V.ITEM_ID
        WHERE R.DIVISION_ID = P_DIVISION_ID
            AND R.CUTOFF_TYPE = P_MDF_TYPE
            AND SUBSTR(R.YYYYMMDD, 1, 4) = P_YYYY
            AND R.VERSION_NO = P_SP_VERSION_NO
        GROUP BY
            R.DIVISION_ID, R.VERSION_NO, R.CUTOFF_TYPE, R.CUTOFF_YYYYMMDD
            , R.DEPARTMENT_ID, R.DEPT_ID, R.END_CUST_REPORT
            , R.END_CUST_REPORT
            , R.CUST_REPORT, R.PROJECT_CODE, R.SCM_SITE_ID
            , R.ITEM_ID, CASE WHEN R.NICK_NAME IS NOT NULL THEN R.NICK_NAME ELSE SINGLE.NICK_NAME END
            , R.FCST_TYPE, R.INCOTERMS
            , R.MEASURE, R.PLANT_SITE_ID, R.COMPANY_ID, SUBSTR(R.YYYYMMDD, 1, 6), R.CURRENCY
            , R.APPLICATION, R.SOLDTO_CUST_REPORT, NVL(SI.ATTRIBUTE2, '')
            , R.BIZ_TYPE, R.APPLICATION_GR, R.PRODUCT_DETAILS
            , R.CELL_MODEL_INFO --, SI.REPORT_GROUP6 --[C20210125-000207] ETC Report에서 입력한 40사업부 CELL_MODEL_INFO 적용
            , R.ATTRIBUTE3
            , LK1.DISPLAY_SEQ
            , LK2.DISPLAY_SEQ, R.COUNTRY_CODE, R.SOLDTO_CODE, NVL(LK3.SEGMENT3, PJT.PROJECT_NAME)
            , R.END_CUSTOMER
            , SI.CELL_PER_CAR, CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE END
            , R.SOLDTO_COUNTRY, R.SHIPTO_COUNTRY
            , SI.ATTRIBUTE9, R.ITEM_USE
            , CASE WHEN R.DIVISION_ID = '40' THEN R.PRODUCT_GROUP
                       WHEN R.DIVISION_ID LIKE '81%' THEN PJT.PRODUCT_GROUP_NAME
                       END
            , CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' THEN 'Cell'
                       WHEN SINGLE.ITEM_CLASS_NAME LIKE '%PACK%' THEN 'Pack'
                       WHEN SINGLE.ITEM_CLASS_NAME LIKE '%MODULE%' THEN 'Module'
                       END
            , CASE WHEN R.DEPT_NAME IS NOT NULL THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END
            , CASE WHEN R.DEPARTMENT_NAME IS NOT NULL THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END
            , R.CUST_GROUP_DTL
            , SINGLE.ENERGE_WH		--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
            , SINGLE.ENERGE_KWH		--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
            , LU.ATTRIBUTE1    -- LOOKUP 26.03.20
            , LU.ATTRIBUTE4    -- LOOKUP 26.03.20
        ;
    END IF;

    /* ── GT_F044_T 통계 수집 ── */
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_F044_T', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    -- 단계3. PIVOT 기간 쿼리 ########################################################
    V_PROD := '';
    FOR rec IN (
        SELECT DISTINCT BASIS_YYYYMM
        FROM SCM_SYS_CALENDAR_M
        WHERE CALENDAR_YYYY = P_YYYY
        ORDER BY BASIS_YYYYMM
    )
    LOOP
        -- 2026-07-30 정정: 별칭이 없으면 PIVOT 결과 컬럼명에 따옴표가 포함된다('M_202601')
        V_PROD := V_PROD || '''M_' || rec.BASIS_YYYYMM || ''' AS "M_' || rec.BASIS_YYYYMM || '",';
    END LOOP;

    IF V_PROD IS NOT NULL AND LENGTH(V_PROD) > 0 THEN
        V_PROD := RTRIM(V_PROD, ',');
    END IF;

    -- 단계4. 실행 쿼리 ########################################################
    V_SQL := '
SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, NVL(END_CUST_REPORT, '''') AS END_CUST_REPORT
     , END_CUSTOMER, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NVL(NICK_NAME, '''') AS NICK_NAME, DOM_EXP, FCST_TYPE, INCOTERMS
     , MEASURE, PLANT_SITE_ID, COMPANY_ID, CURRENCY, NVL(APP, '''') AS APPLICATION, EDIT_FLAG, SOLDTO_CUST_REPORT, DMS_CUSTOMER, BIZ_TYPE_NAME40, APPLICATION_GR
     , PRODUCT_DETAILS, CELL_MODEL_INFO, CELL_MODEL, COUNTRY_CODE, SOLDTO_CODE, PROJECT_NAME, CELL_PER_CAR, MODULE_PER_CAR
     -- ESS
     , SOLDTO_COUNTRY, SHIPTO_COUNTRY, CELL_NAME, ITEM_USE, ITEM_NAME, MODEL_TYPE, SORT_ORDER_NO, CUST_GROUP_DTL, CELL_PROD_SITE
     , ENERGE_WH				--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
     , ENERGE_KWH			--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
     ,' || V_PROD || '
FROM (
        SELECT A.*, B.SORT_ORDER_NO
        FROM SCM_MGR.GT_F044_T A
        JOIN SCM_MGR.GT_F044_SELECT_MEASURE B ON A.MEASURE = B.MEASURE

        INNER JOIN (
            SELECT *
              FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
             WHERE USER_ID = ''' || P_USER_ID || '''
               AND MNU_ID  = ''' || P_MNU_ID || '''
               AND UNIT_TP_CD = ''D''
        ) T2
        ON A.DIVISION_ID = T2.UNIT_ID


    ) T
PIVOT (SUM(QTY) FOR YYYYMM IN (' || V_PROD || ')
) PVT
ORDER BY DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DISPLAY_SEQ1, DISPLAY_SEQ2, CUST_REPORT, END_CUST_REPORT, CUST_GROUP_DTL
       , NVL(PROJECT_CODE, ''''), NVL(PROJECT_NAME, ''''), NVL(FCST_TYPE, ''''), SOLDTO_CODE, SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, NICK_NAME, PRODUCT_DETAILS, CELL_MODEL_INFO
       , CURRENCY, COMPANY_ID, CELL_PROD_SITE, BIZ_TYPE_NAME40, APPLICATION_GR, NVL(APP, '''')
    --, CASE WHEN MEASURE IN (''LOC'') THEN 1
    --		WHEN LENGTH(MEASURE) = 3 THEN 2
    --		WHEN ( MEASURE LIKE ''RTF%'' OR MEASURE = ''Business_Plan'') THEN 3
    --		WHEN MEASURE IN (''SalesAmt_LOC'') THEN 4
    --		ELSE 5
    --		END
    , SORT_ORDER_NO
';

    dbms_output.put_line(v_sql);

    OPEN O_RC1 FOR V_SQL;

    /* ── COMMIT (종료 직전 1회) ── */
    COMMIT;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회+DML 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'    VALUE P_DIVISION_ID,
            'P_MDF_TYPE'       VALUE P_MDF_TYPE,
            'P_YYYY'           VALUE P_YYYY,
            'P_SP_VERSION_NO'  VALUE P_SP_VERSION_NO,
            'P_DATA_TYPE'      VALUE P_DATA_TYPE,
            'P_USER_GROUP'     VALUE P_USER_GROUP,
            'P_CREATED_BY'     VALUE P_CREATED_BY,
            'P_USER_ID'        VALUE P_USER_ID,
            'P_MNU_ID'         VALUE P_MNU_ID
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
END P_DMF0044_GET_SALES_REPORTS_DATA;


PROCEDURE P_DMF0044_GET_SALES_VERSION_POPUP
(
    P_DIVISION_ID     IN VARCHAR2,
    P_SDT             IN VARCHAR2,
    P_EDT             IN VARCHAR2,
    P_VERSION_TYPE    IN VARCHAR2,
    P_DESCRIPTION     IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*************************************************************************************************
 Program ID  : [DMF0044_GET_MDF_VERSION_POPUP]
 Description : Procedure 작성 가이드
 Usage       : Procedure 작성 시 참조하세요!
 Parameter   :

--------------------------------------------------------------------------------------------------
 Date        In Charge    Description
--------------------------------------------------------------------------------------------------
 2019/05/27  JYE
 20191121		HWI1993		DMF0044_GET_SALES_VERSION_POPUP, DMF0044_GET_COPY_VERSION_POPUP 팝업 통합
							기존 팝업의 기능을 유지하기 위해 @p_Description 파라미터를 받아서 상황에 따라 VERSION_NO 또는 DESCRIPTION 에 걸어줌

 2020/06/10	hwi1993		날짜 검색조건을 yyyymmdd(CutoffDate) 에서 Creation_date 로 변경
 20200714     P.C.I       [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외(화요일에 Sales Paln Cutoff 제외하고 생성된 SP Version)
 20200722     P.C.I       [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외 원복
 2021/07/03	HWI1993		하반기과제 속도개선 - 데이터 이동보관 처리
 DMF0044_GET_SALES_VERSION_POPUP '40', '20200501', '20200630', 'report_sp_w', ''
 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
***************************************************************************************************/
IS

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

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    IF P_VERSION_TYPE LIKE 'REPORT%' THEN

        OPEN O_RC1 FOR
        SELECT
            T1.DIVISION_ID, VERSION_NO, ORI_VERSION_NO AS ORI_VERSION
            , VERSION_DESCRIPTION, VERSION_TYPE
            , SEND_YN, VER_CRE_SEQ
            , CASE WHEN ATTRIBUTE1 = 'CP' AND REGEXP_LIKE(ATTRIBUTE2, '^\d{8}$') THEN SUBSTR(ATTRIBUTE2, 1, 4) || '-' || SUBSTR(ATTRIBUTE2, 5, 2) || '-' || SUBSTR(ATTRIBUTE2, 7, 2) ELSE NULL END AS YYYYMMDD
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY AS UPDATED_BY, LAST_UPDATE_DATE AS UPDATE_DATE
            , CASE WHEN MV_PLAN_YYYYMM IS NOT NULL THEN SUBSTR(MV_PLAN_YYYYMM, 1, 4) || '-' || SUBSTR(MV_PLAN_YYYYMM, 5, 2) ELSE '' END AS MV_PLAN_YYYYMM
            , NVL(T2.EDIT_YN,'N') AS EDIT_YN
        FROM DM_MDF_VERSION T1
            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON T1.DIVISION_ID = T2.UNIT_ID

        WHERE
            T1.DIVISION_ID = P_DIVISION_ID
            --AND YYYYMMDD BETWEEN @p_sdt AND @p_edt
            AND CREATION_DATE >= FN_CHAR_TO_DATE(P_SDT)
            AND CREATION_DATE < FN_CHAR_TO_DATE(P_EDT) + 1
            AND VERSION_TYPE = P_VERSION_TYPE
            AND VERSION_DESCRIPTION LIKE '%' || P_DESCRIPTION || '%'
            AND SEND_YN <> 'D'
        ORDER BY CREATION_DATE DESC, VERSION_NO;

    ELSE

        OPEN O_RC1 FOR
        -- DIVISION_ID 를 넣어서 중복이 없으므로 GROUP BY 를 하지 않음.
        WITH SPLIT_DESC AS (
            SELECT TRIM(REGEXP_SUBSTR(P_DESCRIPTION, '[^,]+', 1, LEVEL)) AS TOKEN
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(P_DESCRIPTION, '[^,]+', 1, LEVEL) IS NOT NULL
        )
        SELECT T1.DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE
            , NULL AS REPORT_DATE, NULL AS SEND_YN
            , NULL AS YYYYMMDD
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY AS UPDATED_BY, LAST_UPDATE_DATE AS UPDATE_DATE
            , NVL(T2.EDIT_YN,'N') AS EDIT_YN
        FROM DM_MST_VERSION T1
            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON T1.DIVISION_ID = T2.UNIT_ID

        WHERE (YYYYMMDD >= P_SDT AND YYYYMMDD <= P_EDT)
          AND T1.DIVISION_ID = P_DIVISION_ID
          AND VERSION_TYPE = P_VERSION_TYPE
          AND EXISTS (SELECT 1 FROM SPLIT_DESC P WHERE VERSION_NO LIKE P.TOKEN || '%')
          --AND CREATED_BY <> 'WITHOUT_SP_W' -- [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외
          AND (ATTRIBUTE1 IS NULL OR ATTRIBUTE1 <> 'MOVE')
        ORDER BY TO_CHAR(CREATION_DATE, 'YYYYMMDD') DESC, VERSION_NO;

    END IF;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_SDT'          VALUE P_SDT,
            'P_EDT'          VALUE P_EDT,
            'P_VERSION_TYPE' VALUE P_VERSION_TYPE,
            'P_DESCRIPTION'  VALUE P_DESCRIPTION,
            'P_USER_ID'      VALUE P_USER_ID,
            'P_MNU_ID'       VALUE P_MNU_ID
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
END P_DMF0044_GET_SALES_VERSION_POPUP;


PROCEDURE P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP
(
    P_DIVISION_ID     IN VARCHAR2,
    P_YEAR            IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : [DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2020/03/23  P.C.I        Initial Release [prepare] Sales Report Exchange Rate Popup              */
/* 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
/*                                                                                                  */
/****************************************************************************************************/
IS

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

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    /* Case 17: CASE WHEN @p_division_id = 'ALL' 패턴 → UNION ALL 분기 */
    OPEN O_RC1 FOR
    SELECT
        T1.DIVISION_ID
        , CURRENCY
        , UNIT_CURRENCY
        , CURRENCY || '/' || UNIT_CURRENCY AS CURRENCY_UNITCURRENCY
        , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM DM_PLN_SALES_REPORT_EXCHANGE_C T1
        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID
    WHERE  YYYYMMDD LIKE P_YEAR || '%'
    AND    VERSION_NO = P_VERSION_NO
    AND    P_DIVISION_ID <> 'ALL'
    AND    T1.DIVISION_ID IN (
               SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL)) AS TOKEN
               FROM DUAL
               CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    GROUP BY T1.DIVISION_ID, CURRENCY, UNIT_CURRENCY, EDIT_YN

    UNION ALL

    SELECT
        T1.DIVISION_ID
        , CURRENCY
        , UNIT_CURRENCY
        , CURRENCY || '/' || UNIT_CURRENCY AS CURRENCY_UNITCURRENCY
        , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM DM_PLN_SALES_REPORT_EXCHANGE_C T1
        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID
    WHERE  YYYYMMDD LIKE P_YEAR || '%'
    AND    VERSION_NO = P_VERSION_NO
    AND    P_DIVISION_ID = 'ALL'
    GROUP BY T1.DIVISION_ID, CURRENCY, UNIT_CURRENCY, EDIT_YN;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_YEAR'        VALUE P_YEAR,
            'P_CREATED_BY'  VALUE P_CREATED_BY,
            'P_VERSION_NO'  VALUE P_VERSION_NO,
            'P_USER_ID'     VALUE P_USER_ID,
            'P_MNU_ID'      VALUE P_MNU_ID
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
END P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP;


PROCEDURE P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA
(
    P_DIVISION_ID     IN VARCHAR2,
    P_YEAR            IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : [DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA]                                      */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2020/03/23  P.C.I        Initial Release [prepare] Sales Report Exchange Rate Popup              */
/* 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                 */
/*                                                                                                  */
/****************************************************************************************************/
IS

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

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    /* Case 17: CASE WHEN @p_division_id = 'ALL' 패턴 → UNION ALL 분기 */
    OPEN O_RC1 FOR
    SELECT
        T1.DIVISION_ID
        , CURRENCY
        , UNIT_CURRENCY
        , 'D' || YYYYMMDD AS YYYYMMDD
        , EXCHANGE_PRICE
        , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM DM_PLN_SALES_REPORT_EXCHANGE_C T1
    INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
    ON T1.DIVISION_ID = T2.UNIT_ID
    WHERE  YYYYMMDD LIKE P_YEAR || '%'
    AND    VERSION_NO = P_VERSION_NO
    AND    P_DIVISION_ID <> 'ALL'
    AND    T1.DIVISION_ID IN (
               SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL)) AS TOKEN
               FROM DUAL
               CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )

    UNION ALL

    SELECT
        T1.DIVISION_ID
        , CURRENCY
        , UNIT_CURRENCY
        , 'D' || YYYYMMDD AS YYYYMMDD
        , EXCHANGE_PRICE
        , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM DM_PLN_SALES_REPORT_EXCHANGE_C T1
    INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
    ON T1.DIVISION_ID = T2.UNIT_ID
    WHERE  YYYYMMDD LIKE P_YEAR || '%'
    AND    T1.VERSION_NO = P_VERSION_NO
    AND    P_DIVISION_ID = 'ALL';

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_YEAR'        VALUE P_YEAR,
            'P_CREATED_BY'  VALUE P_CREATED_BY,
            'P_VERSION_NO'  VALUE P_VERSION_NO,
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID

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
END P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA;


PROCEDURE P_DMF0044_GET_TEXTBOX
(
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RC2             OUT SYS_REFCURSOR,
    O_RC3             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*************************************************************************************************
* Program ID  : DMF0044_GET_TEXTBOX
* Description : Procedure 작성 가이드
* Usage       : TextBox 를 열 때 사용. 생성된 VERSION_NO 를 조회할 때에는 날짜와 13개의 DESCRIPTION 받음.
* Parameter   :
*
*------------------------------------------------------------------------------------------------
* Date        In Charge    Description
*------------------------------------------------------------------------------------------------
* 2021-09-15   ROSIA27		[과제] TEXTBOX
* 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
***************************************************************************************************/
IS

    V_YYYYMMDD        VARCHAR2(8 CHAR);

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

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 결과셋 1: DESCRIPTION 컬럼 조회 (O_RC1) ── */
    OPEN O_RC1 FOR
    SELECT
        DESCRIPTION1
        , DESCRIPTION2
        , DESCRIPTION3
        , DESCRIPTION4
        , DESCRIPTION5
        , DESCRIPTION6
        , DESCRIPTION7
        , DESCRIPTION8
        , DESCRIPTION9
        , DESCRIPTION10
        , DESCRIPTION11
        , DESCRIPTION12
        , DESCRIPTION13
    FROM DM_MDF_VERSION T1
    INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID
    WHERE
        T1.DIVISION_ID = '82'
        AND VERSION_NO = P_VERSION_NO;

    /* ── YYYYMMDD 변수 조회 ── */
    BEGIN
        SELECT YYYYMMDD
        INTO   V_YYYYMMDD
        FROM   DM_MDF_VERSION
        WHERE  DIVISION_ID = '82'
        AND    VERSION_NO = P_VERSION_NO;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_YYYYMMDD := NULL;
    END;

    /* ── 결과셋 2: YYYYMMDD (O_RC2) ── */
    OPEN O_RC2 FOR
    SELECT V_YYYYMMDD AS YYYYMMDD FROM DUAL;

    /* ── 결과셋 3: MONDAY 계산 (O_RC3) ── */
    /* CONVERT(CHAR(11), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@YYYYMMDD, 'MON')), 120) */
    /* → TO_CHAR(FN_NEXT_DAY(V_YYYYMMDD, 'MON') - 7, 'YYYY-MM-DD') */
    OPEN O_RC3 FOR
    SELECT TO_CHAR(FN_NEXT_DAY(V_YYYYMMDD, 'MON') - 7, 'YYYY-MM-DD') AS MONDAY FROM DUAL;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_VERSION_NO' VALUE P_VERSION_NO,
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
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
END P_DMF0044_GET_TEXTBOX;


PROCEDURE P_DMF0044_GET_VERSION_POPUP
(
    P_START_YYYYMMDD    IN  VARCHAR2,
    P_END_YYYYMMDD      IN  VARCHAR2,
    P_CREATED_BY        IN  VARCHAR2,
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_TYPE      IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_USER_ID           IN  VARCHAR2, -- For EditYn
    P_MNU_ID            IN  VARCHAR2, -- For EditYn

    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DM0035_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.23   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                 */
/*                                                                                                  */
/****************************************************************************************************/
/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
IS
    -- Case 41: 프로그램명 (패키지 대응)
    V_PROGRAM_NAME  VARCHAR2(200 CHAR);

    -- EXCEPTION 블록 필수 변수
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
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- EXEC SCM0002_GET_VERSIONBYWATERFALLPOPUP @p_start_yyyymmdd='20180313', @p_end_yyyymmdd='20180913', @p_created_by='20140001', @p_division_id='82', @p_version_type='SP_D,SP_W,SP_M,', @p_version_no=''

    OPEN O_RC1 FOR
    SELECT 'SP_Z_CURRENT' AS CODE,
           'Current' AS VERSION_NO,
           'Current' AS VERSION_DESCRIPTION,
           CAST(NULL AS VARCHAR2(30 CHAR)) AS VERSION_TYPE,
           CAST(NULL AS VARCHAR2(30 CHAR)) AS VER_CRE_SEQ,
           CAST(NULL AS VARCHAR2(8 CHAR))  AS YYYYMMDD,
           CAST(NULL AS VARCHAR2(50 CHAR)) AS CREATED_BY,
           SYSDATE AS CREATION_DATE,
           'N' AS EDIT_YN
    FROM   DUAL

    UNION ALL

    SELECT VERSION_NO AS CODE,
           VERSION_NO,
           VERSION_DESCRIPTION,
           TO_CHAR(VERSION_TYPE) AS VERSION_TYPE,
           TO_CHAR(VER_CRE_SEQ) AS VER_CRE_SEQ,
           YYYYMMDD,
           MAX(CREATED_BY) AS CREATED_BY,
           MAX(CREATION_DATE) AS CREATION_DATE,

           NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM   SCM_MGR.DM_MST_VERSION T1
            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON T1.DIVISION_ID = T2.UNIT_ID

    WHERE  YYYYMMDD >= P_START_YYYYMMDD
    AND    YYYYMMDD <= P_END_YYYYMMDD
    AND    T1.DIVISION_ID IN (
               SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL)) AS TOKEN
               FROM   DUAL
               CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    AND    VERSION_TYPE IN (
               SELECT TRIM(REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL)) AS TOKEN
               FROM   DUAL
               CONNECT BY REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    AND    EXISTS (
               SELECT 1
               FROM   (
                   SELECT TRIM(REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL)) AS TOKEN
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL) IS NOT NULL
               ) P
               WHERE  VERSION_NO LIKE P.TOKEN || '%'
           )
    GROUP BY VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, EDIT_YN
    ORDER BY CODE DESC, VERSION_NO DESC;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
            'P_CREATED_BY'     VALUE P_CREATED_BY,
            'P_DIVISION_ID'    VALUE P_DIVISION_ID,
            'P_VERSION_TYPE'   VALUE P_VERSION_TYPE,
            'P_VERSION_NO'     VALUE P_VERSION_NO,
            'P_USER_ID'        VALUE P_USER_ID,
            'P_MNU_ID'         VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_GET_VERSION_POPUP;


PROCEDURE P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE
(
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_ACTION_TYPE       IN  VARCHAR2,   -- T:Transfer, C:Cancel
    P_YYYY              IN  VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE - 사업계획통화환율
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191101 KYH    환율 AVG 계산이 틀려서 null 로 변경함
 * 20191106 KYH		월별 데이터에 널처리 추가함
 * 20191118 hwi1993 파라미터 추가 및 데이터타입 변경 및 Cancel 기능 추가
 * 20200603 hwi1993	source table 변경
 * 2020/09/21	HWI1993	[C20200909-000188] [ESS영업관리팀] GDW 용도별 매출 수정 (프로젝트 코드 S 주택용/상업용 분리)
 * 2026.03.24   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
IS
    -- Case 41: 프로그램명 (패키지 대응)
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);

    -- LOG 용 변수 설정
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;

    -- local 변수선언
    v_user_id           VARCHAR2(10 CHAR) := 'mdf_batch';

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -----------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
    -----------------------------------------------------------------------------------------------------
    DELETE FROM SCM_MGR.DM_MOBILE_REPORT_EXCHANGE_RATE
    WHERE  DIVISION_ID = P_DIVISION_ID
    AND    VERSION_NO  = P_VERSION_NO;

    n_delete_count := SQL%ROWCOUNT;

    -----------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (END)
    -----------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (BEGIN)
    -----------------------------------------------------------------------------------------------------
    IF P_ACTION_TYPE = 'T' THEN -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리

        -- CURSOR 루프 대신 3개 연도(yyyy-1, yyyy, yyyy+1)를 CROSS JOIN으로 한번에 처리
        INSERT INTO SCM_MGR.DM_MOBILE_REPORT_EXCHANGE_RATE
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
        SELECT E.DIVISION_ID
             , P_VERSION_NO
             , Y.YYYY
             , 'SP'          AS SP_BP_TYPE
             , E.CURRENCY
             , E.UNIT_CURRENCY
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '01' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM01
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '02' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM02
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '03' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM03
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '04' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM04
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '05' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM05
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '06' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM06
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '07' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM07
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '08' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM08
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '09' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM09
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '10' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM10
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '11' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM11
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '12' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM12
             , NVL((SELECT V.ORI_VERSION_NO FROM SCM_MGR.DM_MDF_VERSION V
                WHERE V.VERSION_NO = P_VERSION_NO AND V.DIVISION_ID = P_DIVISION_ID AND ROWNUM = 1), '-') AS ORI_VERSION_NO
             , v_user_id     AS CREATED_BY
             , SYSDATE       AS CREATION_DATE
             , v_user_id     AS LAST_UPDATED_BY
             , SYSDATE       AS LAST_UPDATE_DATE
        FROM   SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C E
        CROSS JOIN (
            SELECT TO_CHAR(TO_NUMBER(P_YYYY) - 1) AS YYYY FROM DUAL
            UNION ALL
            SELECT P_YYYY AS YYYY FROM DUAL
            UNION ALL
            SELECT TO_CHAR(TO_NUMBER(P_YYYY) + 1) AS YYYY FROM DUAL
        ) Y
        WHERE  E.DIVISION_ID = P_DIVISION_ID
        AND    E.VERSION_NO  = P_VERSION_NO
        AND    E.YYYYMMDD LIKE Y.YYYY || '%'
        GROUP BY E.DIVISION_ID
             , E.VERSION_NO
             , Y.YYYY
             , E.CURRENCY
             , E.UNIT_CURRENCY;

        n_merge_count := SQL%ROWCOUNT;

    END IF;

    -----------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (END)
    -----------------------------------------------------------------------------------------------------

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    N_LOG_COUNT := n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_VERSION_NO'  VALUE P_VERSION_NO,
            'P_ACTION_TYPE' VALUE P_ACTION_TYPE,
            'P_YYYY'        VALUE P_YYYY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE;


PROCEDURE P_DMF0044_SAVE_BIZ_PLAN_VERSION_COPY
(
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_VERSION_DESCRIPTION   IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_ACTION_TYPE           IN  VARCHAR2,   -- D:삭제, CR: 생성, CP:복사
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_SAVE_BIZ_PLAN_VERSION_COPY
 * Description  : Sales REPORT 개발 (DM_PLN_BP_FCST_C -> DM_PLN_BP_FCST_REPORT_C) VERSION COPY PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190709 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20190917 JSYOUN  마지막 버전의 data_type = '2'인 데이터 copy
 * 20191022 KYH			[CSR ID:4103445] 컬럼통합. REPORT_GROUP4, 5 --> REPORT_GROUP4
 * 20200113 HWI1993 COPY, DELETE 기능 추가
 * 20200116 hwi1993 company_id 추가
 * 20200129 hwi1993 SalesAmt_USD 메저 추가
 * 20200211 HWI1993	부서 없는 데이터 삭제
 * 20200326 P.C.I   [PREPARE] 환율 정보 copy
 * 2026.03.23   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발

 VAR RC1 REFCURSOR;
EXEC DMF0044_SAVE_BIZ_PLAN_VERSION_COPY( '40', 'SP_W_20260310_V003', 'SALES_PLAN WEEKLY CUTOFF', 'system', 'CR', :RC1);
PRINT RC1;

 */
IS
    -- Case 41: 프로그램명 (패키지 대응)
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);

    -- LOG 용 변수 설정
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;
    v_created_by        VARCHAR2(50 CHAR) := 'mdf_batch';
    V_ORI_VERSION       VARCHAR2(30 CHAR);

    v_rp_version        VARCHAR2(2 CHAR);
    v_version_x         VARCHAR2(50 CHAR);
    v_exists            PLS_INTEGER;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- GTT 초기화 (프로시저 시작 시, 이전에 일반 테이블 DML 없으므로 TRUNCATE 허용)
    DELETE FROM SCM_MGR.GT_0044_BP_FCST_01;
    DELETE FROM SCM_MGR.GT_0044_BP_FCST_02;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -----------------------------------------------------------------------------------------------------
    --                                                                                 Validation (BEGIN)
    -----------------------------------------------------------------------------------------------------
    BEGIN
        SELECT 1 INTO v_exists FROM DUAL
        WHERE EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_DIVISION WHERE DIVISION_ID = P_DIVISION_ID);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := 'Division 값이 존재하지 않습니다.';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
    END;

    -- 기능과 버전이 안맞는 경우 ( 생성 : SP_W, BP_M 만 가능, 복사, 삭제 : REPORT_로 시작하는 버전만 가능 )
    IF P_ACTION_TYPE IN ('CP', 'D') THEN
        BEGIN
            SELECT 1 INTO v_exists FROM DUAL
            WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_MDF_VERSION
                          WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := 'VERSION 값이 존재하지 않습니다.';
                D_EVENT_DATE  := SYSDATE;
                BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
        END;
    END IF;

    IF P_ACTION_TYPE = 'CR' THEN
        BEGIN
            SELECT 1 INTO v_exists FROM DUAL
            WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_MST_VERSION
                          WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := 'VERSION 값이 존재하지 않습니다.';
                D_EVENT_DATE  := SYSDATE;
                BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
        END;
    END IF;

    -- 삭제인데, Send_YN 이 Y 인 경우
    IF P_ACTION_TYPE = 'D' THEN
        BEGIN
            SELECT 1 INTO v_exists FROM DUAL
            WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_MDF_VERSION
                          WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO AND SEND_YN = 'Y');
            -- SEND_YN = 'Y' 존재 → 삭제 불가
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := 'VERSION 값이 존재하지 않습니다.';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL; -- SEND_YN = 'Y' 없으면 정상 진행
        END;
    END IF;
    -----------------------------------------------------------------------------------------------------
    --                                                                                 Validation (END)
    -----------------------------------------------------------------------------------------------------


    -----------------------------------------------------------------------------------------------------
    --     MDF VERSION MST INSERT (BEGIN)
    -----------------------------------------------------------------------------------------------------

    -- 신규생성이나 복사일 경우
    IF P_ACTION_TYPE = 'CR' THEN

        BEGIN
            SELECT MAX(SUBSTR(VERSION_NO, 28, 2))
            INTO   v_rp_version
            FROM   SCM_MGR.DM_MDF_VERSION
            WHERE  DIVISION_ID    = P_DIVISION_ID
            AND    ORI_VERSION_NO = P_VERSION_NO;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rp_version := NULL;
        END;

        IF v_rp_version IS NULL OR v_rp_version = '' THEN
            v_rp_version := '01';
        ELSE
            v_rp_version := LPAD(TO_CHAR(TO_NUMBER(v_rp_version) + 1), 2, '0');
            -- jcnam 임시 테스트 코드: to_number 변환 오류 시 디폴트 값 01
            -- v_rp_version := LPAD(TO_CHAR(NVL(TO_NUMBER(v_rp_version DEFAULT 0 ON CONVERSION ERROR), 0) + 1), 2, '0');
        END IF;

        -- 최종 버전 셋팅
        v_version_x := 'REPORT_' || P_VERSION_NO || '_R' || v_rp_version;

        --dbms_output.put_line('v_version_x:'||v_version_x);


        INSERT INTO SCM_MGR.DM_MDF_VERSION
        (DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, SEND_YN, YYYYMMDD,
         VER_CRE_SEQ, ORI_VERSION_NO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5)
        SELECT P_DIVISION_ID,
               v_version_x AS VERSION_NO,
               P_VERSION_DESCRIPTION,
               'REPORT_' || VERSION_TYPE AS VERSION_TYPE,
               'N', YYYYMMDD, VER_CRE_SEQ, VERSION_NO,
               P_CREATED_BY, SYSDATE, P_CREATED_BY, SYSDATE,
               NULL, NULL, NULL, NULL, NULL
        FROM   SCM_MGR.DM_MST_VERSION
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        n_merge_count := SQL%ROWCOUNT;

        --dbms_output.put_line('DM_MDF_VERSION-----------------------');
        --dbms_output.put_line('n_merge_count:'||n_merge_count);


        --[PREPARE] 환율 정보 copy
        INSERT INTO SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE,
         CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT DIVISION_ID, v_version_x AS VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE,
               CREATED_BY, CREATION_DATE, P_CREATED_BY, SYSDATE,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        FROM   SCM_MGR.DM_BP_EXCHANGE_RATE_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        n_merge_count := n_merge_count +  SQL%ROWCOUNT;

        --dbms_output.put_line('DM_PLN_SALES_REPORT_EXCHANGE_C-----------------------');
        --dbms_output.put_line('n_merge_count:'||n_merge_count);


    ELSIF P_ACTION_TYPE = 'CP' THEN

        SELECT ORI_VERSION_NO
        INTO   V_ORI_VERSION
        FROM   SCM_MGR.DM_MDF_VERSION
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = SUBSTR(P_VERSION_NO, 1, 29)
        AND    ROWNUM = 1;

        BEGIN
            SELECT MAX(SUBSTR(VERSION_NO, 28, 2))
            INTO   v_rp_version
            FROM   SCM_MGR.DM_MDF_VERSION
            WHERE  DIVISION_ID    = P_DIVISION_ID
            AND    ORI_VERSION_NO = V_ORI_VERSION;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rp_version := NULL;
        END;

        IF v_rp_version IS NULL OR v_rp_version = '' THEN
            v_rp_version := '01';
        ELSE
            v_rp_version := LPAD(TO_CHAR(TO_NUMBER(v_rp_version) + 1), 2, '0');
        END IF;

        -- 최종 버전 셋팅
        v_version_x := SUBSTR('REPORT_' || REPLACE(P_VERSION_NO, 'REPORT_', ''), 1, 25) || '_R' || v_rp_version;

        INSERT INTO SCM_MGR.DM_MDF_VERSION
        (DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, SEND_YN, YYYYMMDD,
         VER_CRE_SEQ, ORI_VERSION_NO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5)
        SELECT P_DIVISION_ID,
               v_version_x AS VERSION_NO,
               P_VERSION_DESCRIPTION,
               'REPORT_' || VERSION_TYPE AS VERSION_TYPE,
               'N', YYYYMMDD,
               VER_CRE_SEQ, VERSION_NO, P_CREATED_BY, SYSDATE, P_CREATED_BY, SYSDATE,
               NULL, NULL, NULL, NULL, NULL
        FROM   SCM_MGR.DM_MST_VERSION
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = V_ORI_VERSION;

        n_merge_count := SQL%ROWCOUNT;

        --[PREPARE] 환율 정보 copy
        INSERT INTO SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE,
         CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT DIVISION_ID, v_version_x AS VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE,
               CREATED_BY, CREATION_DATE, P_CREATED_BY, SYSDATE,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        FROM   SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

    ELSE  -- 삭제일 경우

        UPDATE SCM_MGR.DM_MDF_VERSION
        SET    SEND_YN = 'D'
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        DELETE FROM SCM_MGR.DM_PLN_BP_FCST_REPORT_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        --[PREPARE] 환율 정보 Delete
        DELETE FROM SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

    END IF;
    -----------------------------------------------------------------------------------------------------
    --                                                                     MDF VERSION MST INSERT (END)
    -----------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (BEGIN)
    -----------------------------------------------------------------------------------------------------


    IF P_ACTION_TYPE = 'CR' THEN

        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_0044_BP_FCST_01
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD,
         PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,
         FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID,
         YYYYMM, QTY, OWNER)
        SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD,
               A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
               A.FCST_TYPE, A.INCOTERMS, A.CURRENCY, A.MEASURE, A.PLANT_SITE_ID,
               A.YYYYMM, SUM(A.QTY) AS QTY,
               (SELECT TRIM(SUBSTR(B.OWNER, 1, NVL(NULLIF(INSTR(B.OWNER, ','), 0), LENGTH(B.OWNER) + 1) - 1))
                FROM   SCM_MGR.SCM_MST_SITE_ITEM B
                WHERE  B.DIVISION_ID  = A.DIVISION_ID
                AND    B.PROJECT_CODE = A.PROJECT_CODE
                AND    B.SCM_SITE_ID  = A.SCM_SITE_ID
                AND    B.ITEM_ID      = A.ITEM_ID
                AND    ROWNUM = 1
               ) AS OWNER  -- 멀티OWNER인경우 1명만 추출
        FROM   SCM_MGR.DM_PLN_BP_FCST_C A
        WHERE  A.VERSION_NO   = P_VERSION_NO
        AND    A.MEASURE IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD', 'Business_Plan')
        AND    A.DIVISION_ID  = P_DIVISION_ID
        GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD,
                 A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
                 A.FCST_TYPE, A.INCOTERMS, A.CURRENCY, A.MEASURE, A.PLANT_SITE_ID,
                 A.YYYYMM;

        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        INSERT INTO SCM_MGR.GT_0044_BP_FCST_02
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD,
         PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,
         FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID,
         YYYYMM, QTY, OWNER,
         DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME,
         CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, ATTRIBUTE1, COMPANY_ID)
        SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD,
               A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
               A.FCST_TYPE, A.INCOTERMS, A.CURRENCY, A.MEASURE, A.PLANT_SITE_ID,
               A.YYYYMM, A.QTY, A.OWNER,
               NVL((SELECT DU.UPPER_DEPT_ID
                    FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DU
                    WHERE DU.VALID_YN = 'Y'
                    AND   DU.DEPT_ID = (SELECT SU.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU WHERE A.OWNER = SU.USER_ID AND ROWNUM = 1)
                    AND   ROWNUM = 1), '-') AS DEPARTMENT_ID,
               NVL((SELECT DU2.DEPT_NAME_KO
                    FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DU2
                    WHERE DU2.VALID_YN = 'Y'
                    AND   DU2.DEPT_ID = (SELECT DU3.UPPER_DEPT_ID
                                         FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DU3
                                         WHERE DU3.VALID_YN = 'Y'
                                         AND   DU3.DEPT_ID = (SELECT SU2.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU2 WHERE A.OWNER = SU2.USER_ID AND ROWNUM = 1)
                                         AND   ROWNUM = 1)
                    AND   ROWNUM = 1), '-') AS DEPARTMENT_NAME,
               NVL((SELECT SU3.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU3 WHERE A.OWNER = SU3.USER_ID AND ROWNUM = 1), '-') AS DEPT_ID,
               NVL((SELECT DU4.DEPT_NAME_KO
                    FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DU4
                    WHERE DU4.VALID_YN = 'Y'
                    AND   DU4.DEPT_ID = (SELECT SU4.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU4 WHERE A.OWNER = SU4.USER_ID AND ROWNUM = 1)
                    AND   ROWNUM = 1), '-') AS DEPT_NAME,
               NVL(LU.ATTRIBUTE2, '-')  AS CUST_REPORT,       -- Cust. (Report)
               NVL(SI.ATTRIBUTE2, '-')     AS END_CUST_REPORT,   -- End Cust.(Report)
               NVL(LU.ATTRIBUTE3, '-')  AS PRODUCT_GROUP,     -- Product Gr.(Report)
               CASE WHEN NVL(LU.ATTRIBUTE4, '-') <> '-' THEN NVL(LU.ATTRIBUTE4, '-') ELSE NVL(LU.ATTRIBUTE5, '-') END AS ATTRIBUTE1,  -- Pouch Gr.(Report)
               --, NVL(LU.ATTRIBUTE5,'-')    AS ATTRIBUTE2       -- Cyl Gr. (Report)
               NVL(B.COMPANY_ID, '-') AS COMPANY_ID
        FROM   SCM_MGR.GT_0044_BP_FCST_01 A
        LEFT JOIN SCM_MGR.SCM_MST_SITE_ITEM SI
            ON  A.DIVISION_ID  = SI.DIVISION_ID
            AND A.SCM_SITE_ID  = SI.SCM_SITE_ID
            AND A.PROJECT_CODE = SI.PROJECT_CODE
            AND A.ITEM_ID      = SI.ITEM_ID
            AND SI.VALID_YN    = 'Y'
        LEFT JOIN (SELECT * FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'SALES_SITE_REPORT_GROUP') LU
            ON  A.DIVISION_ID  = LU.SEGMENT1    -- PK컬럼1
            AND A.PROJECT_CODE = LU.SEGMENT2    -- PK컬럼2
            AND A.SCM_SITE_ID  = LU.SEGMENT3    -- PK컬럼3
            AND A.ITEM_ID      = LU.SEGMENT4    -- PK컬럼4
        LEFT JOIN SCM_MGR.SCM_MST_SITE B
            ON  A.DIVISION_ID  = B.DIVISION_ID
            AND A.SCM_SITE_ID  = B.SCM_SITE_ID;

        -- Dept_ID 나 Department_ID 가 없는 건들 삭제
        DELETE FROM SCM_MGR.GT_0044_BP_FCST_02 WHERE DEPARTMENT_ID = '-' OR DEPT_ID = '-';

        -- GTT를 다른 테이블과 JOIN 하므로 통계 수집
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_0044_BP_FCST_02', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname => 'SCM_MGR', tabname => 'GT_0044_BP_FCST_02',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
        );

        INSERT INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C
             (DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE,
              CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
              DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
              PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP,
              FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
              YYYYMM, CURRENCY, QTY, CREATED_BY,
              CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID)
        SELECT '1' AS DATA_TYPE, NVL(A.DIVISION_ID, '-'), v_version_x AS VERSION_NO, 'REPORT_' || A.CUTOFF_TYPE AS CUTOFF_TYPE,
               NVL(A.CUTOFF_YYYYMMDD, '-'), NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'),
               NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-'), NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'),
               NVL(A.PROJECT_CODE, '-'), '-' AS PROJECT_NAME, NVL(MAX(A.SCM_SITE_ID), '-'), NVL(A.ITEM_ID, '-'), NVL(MAX(A.DOM_EXP), '-'),
               NVL(MAX(A.FCST_TYPE), '-'), NVL(MAX(A.INCOTERMS), '-'), NVL(A.MEASURE, '-'), NVL(MAX(A.PLANT_SITE_ID), '-'),
               NVL(A.YYYYMM, '-'), NVL(A.CURRENCY, '-'), NVL(SUM(QTY), 0) AS QTY, v_created_by,
               SYSDATE, v_created_by, SYSDATE, MAX(A.ATTRIBUTE1), NVL(A.COMPANY_ID, '-')
        FROM   SCM_MGR.GT_0044_BP_FCST_02 A
        GROUP BY A.DIVISION_ID, A.CUTOFF_TYPE,
                 A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
                 A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
                 A.PROJECT_CODE, A.ITEM_ID, A.MEASURE,
                 A.YYYYMM, A.CURRENCY, A.COMPANY_ID;

        n_merge_count := n_merge_count + SQL%ROWCOUNT;

        -- UNIT Price ( LOC ) 를 생성해준다. ( 월단위 )
        -- RTF 가 있는 품목들에 대해서 Unit Price ( LOC ) 를 만들어준다. SalesAmt_LOC / RTF = Unit Price ( LOCAL )

        INSERT INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C
             (DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE,
              CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
              DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
              PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP,
              FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
              YYYYMM, CURRENCY, QTY, CREATED_BY,
              CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID)
        SELECT '1' AS DATA_TYPE, NVL(A.DIVISION_ID, '-'), v_version_x AS VERSION_NO, 'REPORT_' || A.CUTOFF_TYPE AS CUTOFF_TYPE,
               NVL(A.CUTOFF_YYYYMMDD, '-'), NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'),
               NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-'), NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'),
               NVL(A.PROJECT_CODE, '-'), '-' AS PROJECT_NAME, NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-'), NVL(A.DOM_EXP, '-'),
               NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-') AS INCOTERMS, 'LOC' AS MEASURE, NVL(A.PLANT_SITE_ID, '-'),
               NVL(A.YYYYMM, '-'), NVL(A.CURRENCY, '-'),
               NVL(CASE WHEN B.QTY <> 0 THEN ROUND(A.QTY / B.QTY, 0) ELSE 0 END, 0),
               v_created_by,
               SYSDATE, v_created_by, SYSDATE, A.ATTRIBUTE1, NVL(A.COMPANY_ID, '-')
        FROM   SCM_MGR.GT_0044_BP_FCST_02 A
        JOIN   SCM_MGR.GT_0044_BP_FCST_02 B
            ON  A.DIVISION_ID     = B.DIVISION_ID
            AND A.DEPARTMENT_ID   = B.DEPARTMENT_ID
            AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
            AND A.DEPT_ID         = B.DEPT_ID
            AND A.DEPT_NAME       = B.DEPT_NAME
            AND A.END_CUST_REPORT = B.END_CUST_REPORT
            AND A.CUST_REPORT     = B.CUST_REPORT
            AND A.PRODUCT_GROUP   = B.PRODUCT_GROUP
            AND A.PROJECT_CODE    = B.PROJECT_CODE
            AND A.SCM_SITE_ID    = B.SCM_SITE_ID
            AND A.ITEM_ID        = B.ITEM_ID
            AND A.YYYYMM         = B.YYYYMM
            AND A.COMPANY_ID     = B.COMPANY_ID
            AND A.CURRENCY       = B.CURRENCY
        WHERE  A.MEASURE = 'SalesAmt_LOC'
        AND    B.MEASURE = 'Business_Plan';

        n_merge_count := n_merge_count + SQL%ROWCOUNT;

        -----------------------------------------------------------------------------------------------------
        --                                                                           요청VERSION COPY (END)
        -----------------------------------------------------------------------------------------------------

        -----------------------------------------------------------------------------------------------------
        --                                 20190917 JSYOUN  마지막 버전의 data_type = '2'인 데이터 copy (START)
        -----------------------------------------------------------------------------------------------------
        INSERT INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C
             (DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE,
              CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
              DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
              PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP,
              FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
              YYYYMM, CURRENCY, QTY, CREATED_BY,
              CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID)
        SELECT NVL(A.DATA_TYPE, '-'), NVL(A.DIVISION_ID, '-'), v_version_x, NVL(A.CUTOFF_TYPE, '-'),
               NVL(A.CUTOFF_YYYYMMDD, '-'), NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'),
               NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-'), NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'),
               NVL(A.PROJECT_CODE, '-'), NVL(MAX(A.PROJECT_NAME), '-'), NVL(MAX(A.SCM_SITE_ID), '-'), NVL(A.ITEM_ID, '-'), NVL(MAX(DOM_EXP), '-'),
               NVL(MAX(A.FCST_TYPE), '-'), NVL(MAX(A.INCOTERMS), '-'), NVL(A.MEASURE, '-'), NVL(MAX(A.PLANT_SITE_ID), '-'),
               NVL(YYYYMM, '-'), NVL(CURRENCY, '-'), NVL(SUM(QTY), 0), NVL(MAX(A.CREATED_BY), '-'),
               MAX(A.CREATION_DATE), NVL(MAX(A.LAST_UPDATED_BY), '-'), MAX(A.LAST_UPDATE_DATE), MAX(A.ATTRIBUTE1),
               NVL(NVL(A.COMPANY_ID, B.COMPANY_ID), '-')
        FROM   SCM_MGR.DM_PLN_BP_FCST_REPORT_C A
        LEFT JOIN SCM_MGR.SCM_MST_SITE B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND A.SCM_SITE_ID = B.SCM_SITE_ID
        WHERE  A.DIVISION_ID = P_DIVISION_ID
        AND    A.VERSION_NO  = (SELECT MAX(VERSION_NO)
                                FROM   SCM_MGR.DM_PLN_BP_FCST_REPORT_C
                                WHERE  CUTOFF_TYPE = 'REPORT_BP_M'
                                AND    DATA_TYPE   = '2')
        AND    A.CUTOFF_TYPE = 'REPORT_BP_M'
        AND    A.DATA_TYPE   = '2'
        GROUP BY A.DATA_TYPE, A.DIVISION_ID, A.CUTOFF_TYPE,
                 A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
                 A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
                 A.PROJECT_CODE, A.ITEM_ID, A.MEASURE,
                 A.YYYYMM, A.CURRENCY, NVL(NVL(A.COMPANY_ID, B.COMPANY_ID), '-');

        n_merge_count := n_merge_count + SQL%ROWCOUNT;


    ELSIF P_ACTION_TYPE = 'CP' THEN

        -- PK 변경전의 DATA 를 COPY 하는 경우때문에 GROUP BY  처리함
        INSERT INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C
             (DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE,
              CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
              DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
              PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP,
              FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
              YYYYMM, CURRENCY, QTY, CREATED_BY,
              CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID)
        SELECT NVL(A.DATA_TYPE, '-'), NVL(A.DIVISION_ID, '-'), v_version_x, NVL(A.CUTOFF_TYPE, '-'),
               NVL(A.CUTOFF_YYYYMMDD, '-'), NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'),
               NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-'), NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'),
               NVL(A.PROJECT_CODE, '-'), NVL(MAX(A.PROJECT_NAME), '-'), NVL(MAX(A.SCM_SITE_ID), '-'), NVL(A.ITEM_ID, '-'), NVL(MAX(DOM_EXP), '-'),
               NVL(MAX(A.FCST_TYPE), '-'), NVL(MAX(A.INCOTERMS), '-'), NVL(A.MEASURE, '-'), NVL(MAX(A.PLANT_SITE_ID), '-'),
               NVL(YYYYMM, '-'), NVL(CURRENCY, '-'), NVL(SUM(QTY), 0), NVL(MAX(A.CREATED_BY), '-'),
               MAX(A.CREATION_DATE), NVL(MAX(A.LAST_UPDATED_BY), '-'), MAX(A.LAST_UPDATE_DATE), MAX(A.ATTRIBUTE1),
               NVL(A.COMPANY_ID, '-')
        FROM   SCM_MGR.DM_PLN_BP_FCST_REPORT_C A
        WHERE  A.DIVISION_ID = P_DIVISION_ID
        AND    A.VERSION_NO  = P_VERSION_NO
        GROUP BY A.DATA_TYPE, A.DIVISION_ID, A.CUTOFF_TYPE,
                 A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
                 A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
                 A.PROJECT_CODE, A.ITEM_ID, A.MEASURE,
                 A.YYYYMM, A.CURRENCY, A.COMPANY_ID;

        n_merge_count := SQL%ROWCOUNT;
        -- dbms_output.put_line('-----------------------P_DIVISION_ID:'||P_DIVISION_ID||', P_VERSION_NO:'||P_VERSION_NO);
        -- dbms_output.put_line('-----------------------CP8--'||n_merge_count);


    END IF;
    -----------------------------------------------------------------------------------------------------
    --                                 20190917 JSYOUN  마지막 버전의 data_type = '2'인 데이터 copy (END)
    -----------------------------------------------------------------------------------------------------

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    N_LOG_COUNT := n_merge_count;
    -- N_LOG_COUNT := n_delete_count + n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'         VALUE P_DIVISION_ID,
            'P_VERSION_NO'          VALUE P_VERSION_NO,
            'P_VERSION_DESCRIPTION' VALUE P_VERSION_DESCRIPTION,
            'P_CREATED_BY'          VALUE P_CREATED_BY,
            'P_ACTION_TYPE'         VALUE P_ACTION_TYPE
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_SAVE_BIZ_PLAN_VERSION_COPY;


PROCEDURE P_DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT
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
    DELETE FROM SCM_MGR.GT_0044_RESULTS;

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
END P_DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT;


PROCEDURE P_DMF0044_SAVE_SALES_PLAN_REPORT_C
(
    P_ACTIVE_FLAG           IN  VARCHAR2,
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_CUTOFF_TYPE           IN  VARCHAR2,
    P_CUTOFF_YYYYMMDD       IN  VARCHAR2,
    P_DEPARTMENT_ID         IN  VARCHAR2,
    P_DEPARTMENT_NAME       IN  VARCHAR2,
    P_DEPT_ID               IN  VARCHAR2,
    P_DEPT_NAME             IN  VARCHAR2,
    P_END_CUST_REPORT       IN  VARCHAR2,
    P_CUST_REPORT           IN  VARCHAR2,
    P_PRODUCT_GROUP         IN  VARCHAR2,
    P_ITEM_ID               IN  VARCHAR2,
    P_MEASURE               IN  VARCHAR2,
    P_YYYYMMDD              IN  VARCHAR2,
    P_CURRENCY              IN  VARCHAR2,
    P_COMPANY_ID            IN  VARCHAR2,
    P_QTY                   IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_CELL_MODEL_INFO       IN  VARCHAR2,   --[C20211112-000213]
    P_CELL_MODEL            IN  VARCHAR2,   --[C20211112-000213]
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_SAVE_SALES_PLAN_REPORT_C
 * Description  : 'DM_PLN_SALES_PLAN_REPORT_C' TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190529  KHSONG  Initial Release [PJ20189106] 전지.GSCM 고도화 이행, DM 시스템
 * 20190719  JSYOUN  사업계획리포트테이블 변경(DM_PLN_BP_FCST_C -> DM_PLN_BP_FCST_REPORT_C)
 * 20190822  JSYOUN  DM_PLN_SALES_PLAN_REPORT_C PK에서 DIVISION_ID 제외 CURRENCY 추가, DM_PLN_BP_FCST_REPORT_C PK에 CURRENCY 추가
 * 20191030  KYH	 Attribute1 에 ProductDetails 를 '기타'로 세팅
 * 20200123  hwi1993 company_id 추가
 * 20200206  hwi1993 cutoff_yyyymmdd 보완
 * 20200319  hwi1993 DeptName, DepartmentName 의 룩업화에 따라 JOIN 조건에서 사용하지 않도록 변경
 * 20200522 hwi1993	Save 이후에 Transfer 처리
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2022/01/24	rosia27		[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2023.09.07	jssbae		[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청
 */
IS
    /*
    ''고정
    PROJECT_CODE
    SCM_SITE_ID
    DOM_EXP
    FCST_TYPE
    INCOTERMS
    PLANT_SITE_ID
    */

    -- 스플릿관련 변수
    v_cutoff_yyyymmdd       VARCHAR2(8 CHAR);
    v_version_no            VARCHAR2(100 CHAR);
    v_division_id           VARCHAR2(50 CHAR);
    v_yyyymmdd              VARCHAR2(8 CHAR);
    v_cutoff_type           VARCHAR2(100 CHAR);

    v_exists                PLS_INTEGER;

    -- LOG 용 변수 설정
    V_LOG_TYPE              VARCHAR2(100 CHAR);
    N_LOG_COUNT             PLS_INTEGER := 0;
    V_LOG_MESSAGE           VARCHAR2(4000 CHAR);
    V_DESCRIPTION           VARCHAR2(4000 CHAR);
    D_EVENT_DATE            DATE := SYSDATE;
    n_delete_count          PLS_INTEGER := 0;
    n_merge_count           PLS_INTEGER := 0;
    n_insert_count          PLS_INTEGER := 0;
    n_input_count           PLS_INTEGER := 0;
    n_logo_count            PLS_INTEGER := 0;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT            VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);
    V_SQL_CODE              VARCHAR2(100 CHAR);
    V_SQL_ERRMSG            VARCHAR2(1000 CHAR);

BEGIN

    -- GTT 초기화 (프로시저 시작 시, 이전에 일반 테이블 DML 없으므로 TRUNCATE 허용)
    DELETE FROM SCM_MGR.GT_0044_RESULTS_MST;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure @@@##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- 트랜잭션 (START)

    --===================================================================================== GT_0044_RESULTS_MST 테이블에 split후 insert start
    --###############################################  GT_0044_RESULTS_MST 테이블에 split후 insert (START)
    INSERT INTO SCM_MGR.GT_0044_RESULTS_MST
    (
        ACTIVE_FLAG,
        DIVISION_ID,
        VERSION_NO,
        CUTOFF_TYPE,
        CUTOFF_YYYYMMDD,
        DEPARTMENT_ID,
        DEPARTMENT_NAME,
        DEPT_ID,
        DEPT_NAME,
        END_CUST_REPORT,
        CUST_REPORT,
        PRODUCT_GROUP,
        PROJECT_CODE,
        SCM_SITE_ID,
        DOM_EXP,
        FCST_TYPE,
        INCOTERMS,
        CELL_MODEL_INFO,
        CELL_MODEL,
        ITEM_ID,
        MEASURE,
        YYYYMMDD,
        CURRENCY,
        COMPANY_ID,
        QTY,
        CREATED_BY
    )
    SELECT
        TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,       '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_DIVISION_ID,       '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_VERSION_NO,        '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_CUTOFF_TYPE,       '[^^]+', 1, LVL)),
        NULL,  -- CUTOFF_YYYYMMDD: 후속 UPDATE에서 설정
        TRIM(REGEXP_SUBSTR(P_DEPARTMENT_ID,     '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_DEPARTMENT_NAME,   '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_DEPT_ID,           '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_DEPT_NAME,         '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_END_CUST_REPORT,   '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_CUST_REPORT,       '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_PRODUCT_GROUP,     '[^^]+', 1, LVL)),
        '-',    --project_code   (NOT NULL, PK)
        '-',    --scm_site_id    (NOT NULL, PK)
        '-',    --dom_exp
        '-',    --fcst_type      (NOT NULL, PK)
        '-',    --incoterms      (NOT NULL, PK)
        TRIM(REGEXP_SUBSTR(P_CELL_MODEL_INFO,   '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_CELL_MODEL,        '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_ITEM_ID,           '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_MEASURE,           '[^^]+', 1, LVL)),
        -- yyyymm 값을 월별 첫 영업일(yyyymmdd)로 변환
        (SELECT MIN(C.BASIS_START_DATE)
         FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
         WHERE  SUBSTR(C.BASIS_YYYYMMDD, 1, 6) = SUBSTR(TRIM(REGEXP_SUBSTR(P_YYYYMMDD, '[^^]+', 1, LVL)), 1, 6)
         AND    C.DAYOFWEEK IN ('MON','TUE','WED','THU','FRI')
        ),
        TRIM(REGEXP_SUBSTR(P_CURRENCY,          '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_COMPANY_ID,        '[^^]+', 1, LVL)),
        NVL(NULLIF(TRIM(REGEXP_SUBSTR(P_QTY,    '[^^]+', 1, LVL)), ''), '0'),
        TRIM(REGEXP_SUBSTR(P_CREATED_BY,        '[^^]+', 1, LVL))
    FROM (
        SELECT LEVEL AS LVL
        FROM   DUAL
        CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^^]+', 1, LEVEL) IS NOT NULL
    );

    --###############################################  GT_0044_RESULTS_MST 테이블에 split후 insert (END)

    -- CUTOFF_YYYYMMDD 설정: DM_MDF_VERSION → DM_MST_VERSION JOIN
    UPDATE SCM_MGR.GT_0044_RESULTS_MST R
    SET    R.CUTOFF_YYYYMMDD = (
        SELECT B.YYYYMMDD
        FROM   SCM_MGR.DM_MDF_VERSION A
        JOIN   SCM_MGR.DM_MST_VERSION B
            ON A.DIVISION_ID    = B.DIVISION_ID
            AND A.ORI_VERSION_NO = B.VERSION_NO
        WHERE  A.VERSION_NO  = R.VERSION_NO
        AND    A.DIVISION_ID = R.DIVISION_ID
        AND    ROWNUM = 1
    );

    -- GTT를 다른 테이블과 JOIN 하므로 통계 수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_0044_RESULTS_MST', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_0044_RESULTS_MST',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1'
    );

    --===================================================================================== GT_0044_RESULTS_MST 테이블에 split후 insert end

    --
    -- INPUT COUNT 확인
    SELECT COUNT(ACTIVE_FLAG)
    INTO   n_input_count
    FROM   SCM_MGR.GT_0044_RESULTS_MST;

    -- 마지막 행의 v_version_no, v_division_id, v_yyyymmdd, v_cutoff_type 가져옴
    SELECT VERSION_NO, DIVISION_ID, YYYYMMDD, CUTOFF_TYPE
    INTO   v_version_no, v_division_id, v_yyyymmdd, v_cutoff_type
    FROM   (
        SELECT VERSION_NO, DIVISION_ID, YYYYMMDD, CUTOFF_TYPE
        FROM   SCM_MGR.GT_0044_RESULTS_MST
        ORDER BY ROWID DESC
    )
    WHERE  ROWNUM = 1;

    IF v_cutoff_type = 'REPORT_SP_W' THEN
        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                                  DM_PLN_SALES_PLAN_REPORT_C 테이블 DELETE (START)
        --------------------------------------------------------------------------------------------◇◇◇◇

        -- DELETE COUNT 확인
        SELECT COUNT(DIVISION_ID)
        INTO   n_delete_count
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_0044_RESULTS_MST M
            WHERE  M.ACTIVE_FLAG = 'D'
        );

        DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        WHERE  A.DATA_TYPE = '2'
        AND    EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_0044_RESULTS_MST B
            WHERE  B.ACTIVE_FLAG                = 'D'
            AND    A.VERSION_NO                 = B.VERSION_NO
            AND    A.DIVISION_ID                = B.DIVISION_ID
            AND    A.DEPARTMENT_ID              = B.DEPARTMENT_ID
            --AND A.DEPARTMENT_NAME			= B.DEPARTMENT_NAME
            AND    A.DEPT_ID                    = B.DEPT_ID
            --AND A.DEPT_NAME					= B.DEPT_NAME
            AND    A.END_CUST_REPORT            = B.END_CUST_REPORT
            AND    A.CUST_REPORT                = B.CUST_REPORT
            AND    A.PRODUCT_GROUP              = B.PRODUCT_GROUP
            AND    NVL(NULLIF(TRIM(A.PROJECT_CODE), ''), '-') = NVL(NULLIF(TRIM(B.PROJECT_CODE), ''), '-')
            AND    NVL(NULLIF(TRIM(A.SCM_SITE_ID), ''), '-')  = NVL(NULLIF(TRIM(B.SCM_SITE_ID), ''), '-')
            AND    A.ITEM_ID                    = B.ITEM_ID
            AND    A.MEASURE                    = B.MEASURE
            AND    A.YYYYMMDD                   = B.YYYYMMDD
            AND    A.CURRENCY                   = B.CURRENCY
            AND    A.COMPANY_ID                 = B.COMPANY_ID
            AND    NVL(NULLIF(TRIM(A.FORECAST_INFO_CELL_MODEL), ''), '-') = NVL(NULLIF(TRIM(B.CELL_MODEL_INFO), ''), '-')
            AND    NVL(NULLIF(TRIM(A.ATTRIBUTE3), ''), '-') = NVL(NULLIF(TRIM(B.CELL_MODEL), ''), '-')
        );

        --select @@Rowcount
        n_delete_count := SQL%ROWCOUNT;

        --------------------------------------------------------------------------------------------◇◇◇◇
        --                          DM_PLN_SALES_PLAN_REPORT_C 테이블 DELETE (END)
        --------------------------------------------------------------------------------------------◇◇◇◇

        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                          DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (START)
        --------------------------------------------------------------------------------------------◇◇◇◇
        -- INSERT COUNT 확인
        SELECT COUNT(M.DIVISION_ID)
        INTO   n_insert_count
        FROM   SCM_MGR.GT_0044_RESULTS_MST M
        WHERE  M.ACTIVE_FLAG <> 'D';

        MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        USING (
            SELECT *
            FROM   SCM_MGR.GT_0044_RESULTS_MST M
            WHERE  M.ACTIVE_FLAG <> 'D'
        ) B
        ON (
                A.DIVISION_ID                          = B.DIVISION_ID
            AND A.VERSION_NO                           = B.VERSION_NO
            AND A.DEPARTMENT_ID                        = B.DEPARTMENT_ID
            --AND	    A.DEPARTMENT_NAME	 = B.DEPARTMENT_NAME
            AND A.DEPT_ID                              = B.DEPT_ID
            --AND	    A.DEPT_NAME			 = B.DEPT_NAME
            AND A.END_CUST_REPORT                      = B.END_CUST_REPORT
            AND A.CUST_REPORT                          = B.CUST_REPORT
            AND A.PRODUCT_GROUP                        = B.PRODUCT_GROUP
            AND NVL(NULLIF(TRIM(A.PROJECT_CODE), ''), '-')   = NVL(NULLIF(TRIM(B.PROJECT_CODE), ''), '-')
            AND NVL(NULLIF(TRIM(A.SCM_SITE_ID), ''), '-')    = NVL(NULLIF(TRIM(B.SCM_SITE_ID), ''), '-')
            AND A.ITEM_ID                              = B.ITEM_ID
            AND NVL(NULLIF(TRIM(A.FCST_TYPE), ''), '-')      = NVL(NULLIF(TRIM(B.FCST_TYPE), ''), '-')
            AND NVL(NULLIF(TRIM(A.INCOTERMS), ''), '-')      = NVL(NULLIF(TRIM(B.INCOTERMS), ''), '-')
            AND A.MEASURE                              = B.MEASURE
            AND NVL(NULLIF(TRIM(A.PLANT_SITE_ID), ''), '-')  = '-'
            AND A.YYYYMMDD                             = B.YYYYMMDD
            AND A.CURRENCY                             = B.CURRENCY       -- 20190822
            AND A.COMPANY_ID                           = B.COMPANY_ID     -- 20200123
            AND NVL(NULLIF(TRIM(A.CELL_PROD_SITE), ''), '-') = '-'
            AND A.DATA_TYPE                            = '2'
        )
        WHEN MATCHED THEN
            UPDATE SET
                A.QTY              = B.QTY,
                A.LAST_UPDATED_BY  = B.CREATED_BY,
                A.LAST_UPDATE_DATE = SYSDATE

        WHEN NOT MATCHED THEN
            INSERT (
                DATA_TYPE,
                DIVISION_ID,
                VERSION_NO,
                CUTOFF_TYPE,
                CUTOFF_YYYYMMDD,
                DEPARTMENT_ID,
                DEPARTMENT_NAME,
                DEPT_ID,
                DEPT_NAME,
                END_CUST_REPORT,
                CUST_REPORT,
                PRODUCT_GROUP,
                PROJECT_CODE,
                SCM_SITE_ID,
                DOM_EXP,
                FCST_TYPE,
                INCOTERMS,
                PLANT_SITE_ID,
                ITEM_ID,
                MEASURE,
                YYYYMMDD,
                CURRENCY,
                COMPANY_ID,
                QTY,
                CREATED_BY,
                CREATION_DATE,
                LAST_UPDATED_BY,
                LAST_UPDATE_DATE,
                ATTRIBUTE1,
                ATTRIBUTE2,
                ATTRIBUTE3,
                ATTRIBUTE4,
                ATTRIBUTE5,
                FORECAST_INFO_CELL_MODEL,
                CELL_PROD_SITE
            )
            VALUES (
                '2',
                NVL(B.DIVISION_ID, '-'),
                B.VERSION_NO,
                B.CUTOFF_TYPE,
                B.CUTOFF_YYYYMMDD,
                B.DEPARTMENT_ID,
                B.DEPARTMENT_NAME,
                B.DEPT_ID,
                B.DEPT_NAME,
                B.END_CUST_REPORT,
                B.CUST_REPORT,
                B.PRODUCT_GROUP,
                '-',   --project_code   (NOT NULL, PK)
                '-',   --scm_site_id    (NOT NULL, PK)
                '-',   --dom_exp
                '-',   --fcst_type      (NOT NULL, PK)
                '-',   --incoterms      (NOT NULL, PK)
                '-',   --plant_site_id  (NOT NULL, PK)
                NVL(B.ITEM_ID, '-'),
                NVL(B.MEASURE, '-'),
                NVL(B.YYYYMMDD, '-'),
                NVL(B.CURRENCY, '-'),
                B.COMPANY_ID,
                B.QTY,
                B.CREATED_BY,
                SYSDATE,
                B.CREATED_BY,
                SYSDATE,
                '기타',
                '-',
                B.CELL_MODEL,
                NULL,
                NULL,
                B.CELL_MODEL_INFO,
                '-'    --cell_prod_site (NOT NULL, PK)
            );

            n_merge_count := SQL%ROWCOUNT;
    END IF;
    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                   DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (END)
    --------------------------------------------------------------------------------------------◇◇◇◇

    --ELSE

    --[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 20230907
    MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    USING (
        SELECT LOOKA.MODEL,
               LOOKA.BIZ_TYPE,
               LOOKA.CELL_PACK_COUNT,
               LOOKA.DIVISION_ID
        FROM (
            SELECT SEGMENT2  AS MODEL,
                   SEGMENT3  AS BIZ_TYPE,
                   SEGMENT4  AS CELL_PACK_COUNT,
                   SEGMENT1  AS DIVISION_ID,
                   RANK() OVER (
                       PARTITION BY SEGMENT2
                       ORDER BY DISPLAY_SEQ DESC
                   ) AS MODEL_RANK
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
        ) LOOKA
        WHERE  LOOKA.MODEL_RANK = 1
    ) LOOKA
    ON (
            LOOKA.MODEL        = A.ITEM_ID
        AND LOOKA.DIVISION_ID  = A.DIVISION_ID
        AND A.DIVISION_ID      = '40'
        AND A.VERSION_NO       = v_version_no
        AND A.YYYYMMDD         = v_yyyymmdd
    )
    WHEN MATCHED THEN
        UPDATE SET
            A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT,
            A.FORECAST_INFO_BIZ_TYPE        = LOOKA.BIZ_TYPE;

    -- n_merge_count := SQL%ROWCOUNT;

    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                                  DM_PLN_BP_FCST_REPORT_C 테이블 DELETE (START)
    --------------------------------------------------------------------------------------------◇◇◇◇
    --BEGIN

        ---- DELETE COUNT 확인
        --SET @n_delete_count =  (SELECT COUNT(division_id)  FROM SCM_MGR.DM_PLN_BP_FCST_REPORT_C A
        --						WHERE (
        --								SELECT count(1)
        --									FROM GT_0044_RESULTS_MST M
        --									where M.active_flag		= 'D'
        --								) > 0)

        ----  select * from GT_0044_RESULTS_MST
        --DELETE
        --FROM SCM_MGR.DM_PLN_BP_FCST_REPORT_C
        --WHERE (
        --		SELECT count(1)
        --			FROM GT_0044_RESULTS_MST M
        --			where M.active_flag		= 'D'
        --				and DATA_TYPE = '2'
        --				and DM_PLN_BP_FCST_REPORT_C.division_id		= M.division_id
        --				and DM_PLN_BP_FCST_REPORT_C.version_no		= M.version_no
        --				and DM_PLN_BP_FCST_REPORT_C.department_id	= M.department_id
        --				--and DM_PLN_BP_FCST_REPORT_C.department_name	= M.department_name
        --				and DM_PLN_BP_FCST_REPORT_C.dept_id			= M.dept_id
        --				--and DM_PLN_BP_FCST_REPORT_C.dept_name		= M.dept_name
        --				and DM_PLN_BP_FCST_REPORT_C.end_cust_report	= M.end_cust_report
        --				and DM_PLN_BP_FCST_REPORT_C.cust_report		= M.cust_report
        --				and DM_PLN_BP_FCST_REPORT_C.product_group	= M.product_group

        --				and NVL(DM_PLN_BP_FCST_REPORT_C.project_code	,'')	= M.project_code
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.scm_site_id	,'')	= M.scm_site_id
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.dom_exp		,'')	= M.dom_exp
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.fcst_type	,'')	= M.fcst_type
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.incoterms	,'')	= M.incoterms
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.

        --				and DM_PLN_BP_FCST_REPORT_C.item_id			= M.item_id
        --				and DM_PLN_BP_FCST_REPORT_C.currency	    = M.currency			-- 20190822
        --				and DM_PLN_BP_FCST_REPORT_C.company_id	    = M.company_id			-- 20200123
        --				and DM_PLN_BP_FCST_REPORT_C.measure			= M.measure
        --				and DM_PLN_BP_FCST_REPORT_C.yyyymm			= SUBSTR(M.yyyymmdd,1,6)
        --		) > 0;
    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                                  DM_PLN_BP_FCST_C 테이블 DELETE (END)
    --------------------------------------------------------------------------------------------◇◇◇◇

    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                          DM_PLN_BP_FCST_C 테이블 UPDATE, INSERT (START)
    --------------------------------------------------------------------------------------------◇◇◇◇
        -- INSERT COUNT 확인
        --SET n_insert_count = ( SELECT count(M.division_id)
        --							FROM GT_0044_RESULTS_MST M
        --								where M.active_flag      <> 'D' )

        --			MERGE INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C A
        --			USING (
        --					SELECT *
        --						FROM GT_0044_RESULTS_MST M
        --							where M.active_flag      <> 'D'
        --				  ) B
        --			ON(
        --						A.division_id		 = B.division_id
        --				AND	    A.version_no		 = B.version_no
        --				AND	    A.department_id		 = B.department_id
        --				--AND	    A.department_name	 = B.department_name
        --				AND	    A.dept_id			 = B.dept_id
        --				--AND	    A.dept_name			 = B.dept_name
        --				AND	    A.end_cust_report	 = B.end_cust_report
        --				AND	    A.cust_report		 = B.cust_report
        --				AND	    A.product_group		 = B.product_group

        --				AND	    NVL(A.project_code	,'')	 = B.project_code
        --				AND	    NVL(A.scm_site_id	,'')	 = B.scm_site_id
        --				AND	    NVL(A.dom_exp		,'')	 = B.dom_exp
        --				AND	    NVL(A.fcst_type		,'')	 = B.fcst_type
        --				AND	    NVL(A.incoterms		,'')	 = B.incoterms

        --				AND	    A.item_id			 = B.item_id
        --				AND	    A.currency			 = B.currency				-- 20190822
        --				AND	    A.company_id		 = B.company_id				-- 20200123
        --				AND	    A.measure			 = B.measure
        --				AND	    A.yyyymm			 = SUBSTR(B.yyyymmdd,1,6)
        --				AND		a.DATA_TYPE = '2'
        --			  )
        --			WHEN MATCHED THEN
        --				 UPDATE SET
        --							 A.QTY				= B.QTY
        --							,A.last_updated_by	= B.created_by
        --							,A.last_update_date	= SYSDATE
        --
        --			WHEN NOT MATCHED THEN

        --				 INSERT (
        --						   DATA_TYPE
        --						  ,division_id
        --						  ,version_no
        --						  ,cutoff_type
        --						  ,cutoff_yyyymmdd
        --						  ,department_id
        --						  ,department_name
        --						  ,dept_id
        --						  ,dept_name
        --						  ,end_cust_report
        --						  ,cust_report
        --						  ,product_group
        --						  ,project_code
        --						  ,scm_site_id
        --						  ,dom_exp
        --						  ,fcst_type
        --						  ,incoterms
        --						  ,plant_site_id

        --						  ,item_id
        --						  ,measure
        --						  ,yyyymm
        --						  ,currency
        --						  ,company_id
        --						  ,qty
        --						  ,created_by
        --						  ,CREATION_DATE
        --						  ,LAST_UPDATED_BY
        --						  ,LAST_UPDATE_DATE
        --						  ,ATTRIBUTE1
        --						  ,ATTRIBUTE2
        --						  ,ATTRIBUTE3
        --						  ,ATTRIBUTE4
        --						  ,ATTRIBUTE5
        --						)
        --				 VALUES (   '2'
        --						   ,B.division_id
        --						   ,B.version_no
        --						   ,B.cutoff_type
        --						   ,B.cutoff_yyyymmdd
        --						   ,B.department_id
        --						   ,B.department_name
        --						   ,B.dept_id
        --						   ,B.dept_name
        --						   ,B.end_cust_report
        --						   ,B.cust_report
        --						   ,B.product_group
        --							,''  --project_code
        --							,''	 --scm_site_id
        --							,''	 --dom_exp
        --							,''	 --fcst_type
        --							,''	 --incoterms
        --							,''	 --plant_site_id
        --						   ,B.item_id
        --						   ,B.measure
        --						   ,SUBSTR(B.yyyymmdd,1,6)
        --						   ,B.currency
        --						   ,B.company_id
        --						   ,B.qty
        --						   ,B.CREATED_BY
        --						   ,SYSDATE
        --						   ,B.CREATED_BY
        --						   ,SYSDATE
        --						   ,'기타','',NULL,NULL,NULL
        --						);

    --END
    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                          DM_PLN_BP_FCST_REPORT_C 테이블 UPDATE, INSERT (END)
    --------------------------------------------------------------------------------------------◇◇◇◇


    -- UPDATE 후에 전송처리를 다시 한다.
    BEGIN
        SELECT 1
        INTO   v_exists
        FROM   DUAL
        WHERE  EXISTS (
            SELECT DIVISION_ID
            FROM   SCM_MGR.DM_MDF_VERSION
            WHERE  DIVISION_ID = v_division_id
            AND    VERSION_NO  = v_version_no
            AND    SEND_YN     = 'Y'
        );
        /* TODO 26.03.23
        EXECUTE IMMEDIATE
            'BEGIN SCM_MGR.DMF0044_MOBILE_REPORT_CREATE(:1, :2, :3, :4, :5); END;'
            USING v_division_id, v_version_no, v_cutoff_type, 'T', P_CREATED_BY;
        */

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- SEND_YN = 'Y' 데이터 없으면 전송 처리 스킵
    END;

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    N_LOG_COUNT := n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure @@@##########';
    V_DESCRIPTION := 'input_count: ' || TO_CHAR(n_input_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

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
            'P_CUTOFF_TYPE'     VALUE P_CUTOFF_TYPE,
            'P_CUTOFF_YYYYMMDD' VALUE P_CUTOFF_YYYYMMDD,
            'P_DEPARTMENT_ID'   VALUE P_DEPARTMENT_ID,
            'P_DEPARTMENT_NAME' VALUE P_DEPARTMENT_NAME,
            'P_DEPT_ID'         VALUE P_DEPT_ID,
            'P_DEPT_NAME'       VALUE P_DEPT_NAME,
            'P_END_CUST_REPORT' VALUE P_END_CUST_REPORT,
            'P_CUST_REPORT'     VALUE P_CUST_REPORT,
            'P_PRODUCT_GROUP'   VALUE P_PRODUCT_GROUP,
            'P_ITEM_ID'         VALUE P_ITEM_ID,
            'P_MEASURE'         VALUE P_MEASURE,
            'P_YYYYMMDD'        VALUE P_YYYYMMDD,
            'P_CURRENCY'        VALUE P_CURRENCY,
            'P_COMPANY_ID'      VALUE P_COMPANY_ID,
            'P_QTY'             VALUE P_QTY,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_CELL_MODEL_INFO' VALUE P_CELL_MODEL_INFO,
            'P_CELL_MODEL'      VALUE P_CELL_MODEL
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
END P_DMF0044_SAVE_SALES_PLAN_REPORT_C;


PROCEDURE P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF
(
    P_ACTIVE_FLAG           IN  VARCHAR2,
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_CUTOFF_TYPE           IN  VARCHAR2,
    P_CUTOFF_YYYYMMDD       IN  VARCHAR2,
    P_DEPARTMENT_ID         IN  VARCHAR2,
    P_DEPARTMENT_NAME       IN  VARCHAR2,
    P_DEPT_ID               IN  VARCHAR2,
    P_DEPT_NAME             IN  VARCHAR2,
    P_END_CUST_REPORT       IN  VARCHAR2,
    P_CUST_REPORT           IN  VARCHAR2,
    P_PRODUCT_GROUP         IN  VARCHAR2,
    P_ITEM_ID               IN  VARCHAR2,
    P_MEASURE               IN  VARCHAR2,
    P_YYYYMMDD              IN  VARCHAR2,
    P_CURRENCY              IN  VARCHAR2,
    P_QTY                   IN  VARCHAR2,
    P_SCM_SITE_ID           IN  VARCHAR2,
    P_PROJECT_CODE          IN  VARCHAR2,
    P_COMPANY_ID            IN  VARCHAR2,
    P_FCST_TYPE             IN  VARCHAR2,
    P_INCOTERMS             IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*============================================================================================================================
 * Program ID   : DMF0044_SAVE_SALES_PLAN_REPORT_C_CF
 * Description  : 'DM_PLN_SALES_PLAN_REPORT_C' TABLE INSERT/UPDATE/DELETE
 * Program History
 *============================================================================================================================
 *   Date       In Charge      Description
 *============================================================================================================================
 * 2020/01/17	HWI1993			SCM_SITE_ID, COMPANY_ID, PROJECT_CODE 추가하면서 이름 변경함 - DMF0044_SAVE_SALES_PLAN_REPORT_C_CF ( Cutoff Data 전용임 )
 * 2020/03/26	hwi1993			department_name, dept_name 을 join 조건에서 제거함 ( lookup 적용으로 인해 같은 코드인데 화면과 db data 가 다를 수 있음
 * 2020/05/22	hwi1993			Save 이후에 Transfer 처리
 * 2020/06/18	hwi1993			81번 로직 분리
 * 2020/09/09   P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020/09/18	HWI1993			[C20200909-000188] YYYYMMDD 를 영업일로 변환하는 로직 제거 LEFT(YYYYMMDD, 6) + '01' 로 변경
 * 2020/10/05	HWI1993			[C20201005-000291] Sales Report 대량 변경시 Time out 문제, QTY DATA TYPE 도 NUMERIC(30,10) 으로 변경
 * 2021/07/23	HWI1993			상반기과제 - 소형 마스터 정비
 * 2022/04/13   HWI1993			GM JV 작업
 * 2023/09/07	JSSBAE			[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청
 * 2024/05/09	JSSBAE			[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2025/05/09   JSSBAE			[E20250418-001567]_40사업부 Sales Report, ETC Report 개선
 * 2026.03.24   jcnam           [PJ20264226] NextSCM Pilot 설계 및 개발
 *============================================================================================================================*/
IS
    -----------------------------------------------------------------------------------------------
    -- 스플릿관련 변수
    -----------------------------------------------------------------------------------------------
    V_ACTIVE_FLAG           VARCHAR2(1 CHAR);
    V_DIVISION_ID           VARCHAR2(30 CHAR);
    V_VERSION_NO            VARCHAR2(30 CHAR);
    V_CUTOFF_TYPE           VARCHAR2(20 CHAR);
    V_CUTOFF_YYYYMMDD       VARCHAR2(8 CHAR);
    V_DEPARTMENT_ID         VARCHAR2(10 CHAR);
    V_DEPARTMENT_NAME       VARCHAR2(50 CHAR);
    V_DEPT_ID               VARCHAR2(10 CHAR);
    V_DEPT_NAME             VARCHAR2(50 CHAR);
    V_END_CUST_REPORT       VARCHAR2(30 CHAR);

    V_CUST_REPORT           VARCHAR2(30 CHAR);
    V_PRODUCT_GROUP         VARCHAR2(30 CHAR);
    V_ITEM_ID               VARCHAR2(50 CHAR);
    V_MEASURE               VARCHAR2(20 CHAR);
    V_YYYYMMDD              VARCHAR2(8 CHAR);
    V_CURRENCY              VARCHAR2(5 CHAR);
    V_QTY                   VARCHAR2(40 CHAR);
    V_SCM_SITE_ID           VARCHAR2(30 CHAR);
    V_PROJECT_CODE          VARCHAR2(30 CHAR);
    V_COMPANY_ID            VARCHAR2(30 CHAR);

    V_FCST_TYPE             VARCHAR2(10 CHAR);
    V_INCOTERMS             VARCHAR2(10 CHAR);
    V_CREATED_BY            VARCHAR2(150 CHAR);
    V_ORI_VERSION_NO        VARCHAR2(50 CHAR);
    V_DELIMITER             VARCHAR2(1 CHAR) := '^';

    -----------------------------------------------------------------------------------------------
    -- LOG 용 변수 설정
    -----------------------------------------------------------------------------------------------
    V_PROGRAM_NAME          VARCHAR2(200 CHAR);
    V_LOG_TYPE              VARCHAR2(100 CHAR);
    N_LOG_COUNT             PLS_INTEGER := 0;
    V_LOG_MESSAGE           VARCHAR2(4000 CHAR);
    V_DESCRIPTION           VARCHAR2(4000 CHAR);
    D_EVENT_DATE            DATE := SYSDATE;
    N_DELETE_COUNT          PLS_INTEGER := 0;
    N_INSERT_COUNT          PLS_INTEGER := 0;
    N_INPUT_COUNT           PLS_INTEGER := 0;
    N_LOGO_COUNT            PLS_INTEGER := 0;
    -- [PATCH] 히스토리 테이블 INSERT 카운트 (신규 추가)
    N_HISTORY_COUNT         PLS_INTEGER := 0;

    -----------------------------------------------------------------------------------------------
    --계산용 변수
    -----------------------------------------------------------------------------------------------
    V_I                     PLS_INTEGER;
    V_CNT                   PLS_INTEGER;
    V_ADJQTY                NUMBER(30,10);
    V_REST                  NUMBER(30,10);
    V_ORIQTY                NUMBER(30,10);
    V_QTYCNT                PLS_INTEGER;
    V_MINDATE               VARCHAR2(8 CHAR);
    V_PLAN_YN               VARCHAR2(1 CHAR);
    V_LOC_SALESAMT_LOC      NUMBER(30,10);
    V_LOC_RTF               NUMBER(30,10);
    V_LOC_PRICE             NUMBER(30,10);

    V_EXISTS                PLS_INTEGER;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT            VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);
    V_SQL_CODE              VARCHAR2(100 CHAR);
    V_SQL_ERRMSG            VARCHAR2(1000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -----------------------------------------------------------------------------------------------
    -- GTT 초기화 (이후에 일반 테이블 DML이 있으므로 DELETE FROM 사용)
    -----------------------------------------------------------------------------------------------
    DELETE FROM SCM_MGR.GT_0044_RESULTS_MST_C;

    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_0044_RESULTS_MST_C', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

    --=============================================================================================
    -- 시작 LOG  (START)
    --=============================================================================================
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure @@@##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    --=============================================================================================
    --#results_MST 테이블에 split후 insert (START)
    --=============================================================================================
    INSERT INTO SCM_MGR.GT_0044_RESULTS_MST_C
    ( ACTIVE_FLAG, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD,
      DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT,
      CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, DOM_EXP,
      FCST_TYPE, INCOTERMS, ITEM_ID, MEASURE, YYYYMMDD,
      CURRENCY, QTY, COMPANY_ID, CREATED_BY )
    SELECT TRIM(A_ACTIVE_FLAG), TRIM(A_DIVISION_ID), TRIM(A_VERSION_NO), TRIM(A_CUTOFF_TYPE), TRIM(A_CUTOFF_YYYYMMDD),
           TRIM(A_DEPARTMENT_ID), TRIM(A_DEPARTMENT_NAME), TRIM(A_DEPT_ID), TRIM(A_DEPT_NAME), TRIM(A_END_CUST_REPORT),
           TRIM(A_CUST_REPORT), TRIM(A_PRODUCT_GROUP), TRIM(A_PROJECT_CODE), TRIM(A_SCM_SITE_ID), '-',
           TRIM(A_FCST_TYPE), TRIM(A_INCOTERMS), TRIM(A_ITEM_ID), TRIM(A_MEASURE),
           SUBSTR(TRIM(A_YYYYMMDD), 1, 6) || '01',
           TRIM(A_CURRENCY),
           CASE WHEN TRIM(A_QTY) IS NULL OR TRIM(A_QTY) = '' THEN '0' ELSE TRIM(A_QTY) END,
           TRIM(A_COMPANY_ID), TRIM(A_CREATED_BY)
    FROM (
        SELECT REGEXP_SUBSTR(P_ACTIVE_FLAG,      '[^^]+', 1, LEVEL) AS A_ACTIVE_FLAG,
               REGEXP_SUBSTR(P_DIVISION_ID,      '[^^]+', 1, LEVEL) AS A_DIVISION_ID,
               REGEXP_SUBSTR(P_VERSION_NO,       '[^^]+', 1, LEVEL) AS A_VERSION_NO,
               REGEXP_SUBSTR(P_CUTOFF_TYPE,      '[^^]+', 1, LEVEL) AS A_CUTOFF_TYPE,
               REGEXP_SUBSTR(P_CUTOFF_YYYYMMDD,  '[^^]+', 1, LEVEL) AS A_CUTOFF_YYYYMMDD,
               REGEXP_SUBSTR(P_DEPARTMENT_ID,    '[^^]+', 1, LEVEL) AS A_DEPARTMENT_ID,
               REGEXP_SUBSTR(P_DEPARTMENT_NAME,  '[^^]+', 1, LEVEL) AS A_DEPARTMENT_NAME,
               REGEXP_SUBSTR(P_DEPT_ID,          '[^^]+', 1, LEVEL) AS A_DEPT_ID,
               REGEXP_SUBSTR(P_DEPT_NAME,        '[^^]+', 1, LEVEL) AS A_DEPT_NAME,
               REGEXP_SUBSTR(P_END_CUST_REPORT,  '[^^]+', 1, LEVEL) AS A_END_CUST_REPORT,
               REGEXP_SUBSTR(P_CUST_REPORT,      '[^^]+', 1, LEVEL) AS A_CUST_REPORT,
               REGEXP_SUBSTR(P_PRODUCT_GROUP,    '[^^]+', 1, LEVEL) AS A_PRODUCT_GROUP,
               REGEXP_SUBSTR(P_ITEM_ID,          '[^^]+', 1, LEVEL) AS A_ITEM_ID,
               REGEXP_SUBSTR(P_MEASURE,          '[^^]+', 1, LEVEL) AS A_MEASURE,
               REGEXP_SUBSTR(P_YYYYMMDD,         '[^^]+', 1, LEVEL) AS A_YYYYMMDD,
               REGEXP_SUBSTR(P_CURRENCY,         '[^^]+', 1, LEVEL) AS A_CURRENCY,
               REGEXP_SUBSTR(P_QTY,              '[^^]+', 1, LEVEL) AS A_QTY,
               REGEXP_SUBSTR(P_SCM_SITE_ID,      '[^^]+', 1, LEVEL) AS A_SCM_SITE_ID,
               REGEXP_SUBSTR(P_PROJECT_CODE,     '[^^]+', 1, LEVEL) AS A_PROJECT_CODE,
               REGEXP_SUBSTR(P_COMPANY_ID,       '[^^]+', 1, LEVEL) AS A_COMPANY_ID,
               REGEXP_SUBSTR(P_FCST_TYPE,        '[^^]+', 1, LEVEL) AS A_FCST_TYPE,
               REGEXP_SUBSTR(P_INCOTERMS,        '[^^]+', 1, LEVEL) AS A_INCOTERMS,
               REGEXP_SUBSTR(P_CREATED_BY,       '[^^]+', 1, LEVEL) AS A_CREATED_BY
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^^]+', 1, LEVEL) IS NOT NULL
    );
    --=============================================================================================
    --#results_MST 테이블에 split후 insert (END)
    --=============================================================================================

    -- 공통 변수 보관 (첫번째 토큰)
    V_DIVISION_ID      := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,     '[^^]+', 1, 1));
    V_VERSION_NO       := TRIM(REGEXP_SUBSTR(P_VERSION_NO,      '[^^]+', 1, 1));
    V_CUTOFF_TYPE      := TRIM(REGEXP_SUBSTR(P_CUTOFF_TYPE,     '[^^]+', 1, 1));
    V_CUTOFF_YYYYMMDD  := TRIM(REGEXP_SUBSTR(P_CUTOFF_YYYYMMDD, '[^^]+', 1, 1));
    V_CREATED_BY       := TRIM(REGEXP_SUBSTR(P_CREATED_BY,      '[^^]+', 1, 1));

    -----------------------------------------------------------------------------------------------
    --ORI_VERSION_NO을 조회하여 변수에 보관한다.
    -----------------------------------------------------------------------------------------------
    BEGIN
        SELECT ORI_VERSION_NO INTO V_ORI_VERSION_NO
        FROM   SCM_MGR.DM_MDF_VERSION
        WHERE  VERSION_TYPE = V_CUTOFF_TYPE
        AND    VERSION_NO   = V_VERSION_NO
        AND    ROWNUM       = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL;
    END;

    -----------------------------------------------------------------------------------------------
    -- 처리할 데이터에 순번을 넣어준다. ( 메저들을 묶어서 한 세트로 )
    -----------------------------------------------------------------------------------------------
    FOR REC IN (
        SELECT ROWID AS RID,
               DENSE_RANK() OVER ( ORDER BY DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
                                             DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID,
                                             ITEM_ID, SUBSTR(YYYYMMDD, 1, 6), CURRENCY ) AS NEW_SEQ_RANK
        FROM SCM_MGR.GT_0044_RESULTS_MST_C
    ) LOOP
        UPDATE SCM_MGR.GT_0044_RESULTS_MST_C SET SEQ_RANK = REC.NEW_SEQ_RANK WHERE ROWID = REC.RID;
    END LOOP;

    FOR REC IN (
        SELECT ROWID AS RID,
               ROW_NUMBER() OVER ( PARTITION BY SEQ_RANK
                                   ORDER BY DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
                                            DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID,
                                            ITEM_ID, SUBSTR(YYYYMMDD, 1, 6), CURRENCY ) AS NEW_SEQ_ROWNUM
        FROM SCM_MGR.GT_0044_RESULTS_MST_C
    ) LOOP
        UPDATE SCM_MGR.GT_0044_RESULTS_MST_C SET SEQ_ROWNUM = REC.NEW_SEQ_ROWNUM WHERE ROWID = REC.RID;
    END LOOP;

    -----------------------------------------------------------------------------------------------
    -- 계획구간 여부 UPDATE
    -----------------------------------------------------------------------------------------------
    UPDATE SCM_MGR.GT_0044_RESULTS_MST_C
    SET PLAN_YN = CASE WHEN SUBSTR(YYYYMMDD, 1, 6) >= TO_CHAR(SYSDATE, 'YYYYMM') THEN 'Y' ELSE 'N' END;

    SELECT COUNT(ACTIVE_FLAG) INTO N_INPUT_COUNT FROM SCM_MGR.GT_0044_RESULTS_MST_C;

    -- GTT INSERT 후 통계 수집 (JOIN 사용)
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname => 'SCM_MGR', tabname => 'GT_0044_RESULTS_MST_C',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    --=============================================================================================
    --DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (START)
    --=============================================================================================
    IF V_CUTOFF_TYPE = 'REPORT_SP_W' THEN
        -----------------------------------------------------------------------------------------------
        -- 초기화
        -----------------------------------------------------------------------------------------------
        V_I := 1; V_CNT := 0; V_ADJQTY := 0; V_REST := 0; V_ORIQTY := 0; V_QTYCNT := 0; V_MINDATE := NULL; V_PLAN_YN := 'N';

        SELECT NVL(MAX(SEQ_RANK), 0) INTO V_CNT FROM SCM_MGR.GT_0044_RESULTS_MST_C;

        IF V_DIVISION_ID = '40' THEN
            WHILE V_I <= V_CNT LOOP
                BEGIN
                    SELECT PLAN_YN INTO V_PLAN_YN
                    FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND ROWNUM = 1;
                EXCEPTION WHEN NO_DATA_FOUND THEN V_PLAN_YN := 'N';
                END;

                -----------------------------------------------------------------------------------------------
                -- Pricce 가 변경된 경우 ( 계획구간 ) -- 일단 Price 만 업데이트
                -----------------------------------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'LOC');

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    -----------------------------------------------------------------------------------------------
                    -- LOC 가 있으면 업데이트, 없으면 인서트
                    -----------------------------------------------------------------------------------------------
                    V_EXISTS := 0;

                    BEGIN

                        SELECT 1 INTO V_EXISTS FROM DUAL

                        WHERE EXISTS (

                            SELECT 1

                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA

                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB

                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID

                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP

                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID

                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'

                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE

                             AND BB.SEQ_RANK = V_I

                            WHERE AA.MEASURE = 'LOC' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO

                        );

                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                    END;

                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = NVL((SELECT TO_NUMBER(B.QTY) FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                   WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID
                                   AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                   AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                                   AND B.PRODUCT_GROUP = A.PRODUCT_GROUP AND B.PROJECT_CODE = A.PROJECT_CODE
                                   AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                   AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%'
                                   AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                   AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I AND ROWNUM = 1), A.QTY),
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID
                            AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                            AND B.PRODUCT_GROUP = A.PRODUCT_GROUP AND B.PROJECT_CODE = A.PROJECT_CODE
                            AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%'
                            AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                    ELSE
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
                             , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-'), NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'LOC', '-', NVL(B.YYYYMMDD, '-')
                             , NVL(A.CURRENCY, '-'), NVL(TO_NUMBER(B.QTY), 0), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , NVL(A.COMPANY_ID, '-'), NVL(A.PROJECT_CODE, '-'), A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.SEQ_RANK = V_I AND B.MEASURE = 'LOC'
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                -----------------------------------------------------------------------------------------------
                -- 수량등이 변경된 건이 있을 경우 기존 데이터의 비율대로 배부하고 남은건을 첫번째 날짜에 몰아준다.
                -----------------------------------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE IN ('RTF', 'RTF_SYS_RP'));

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    SELECT TO_NUMBER(QTY) INTO V_ADJQTY FROM SCM_MGR.GT_0044_RESULTS_MST_C
                    WHERE SEQ_RANK = V_I AND MEASURE IN ('RTF', 'RTF_SYS_RP') AND ROWNUM = 1;

                    -----------------------------------------------------------------------------------------------
                    -- 수정전 DM_PLN_SALES_PLAN_REPORT_C 테이블의 수량 합계, 건수 계산
                    -----------------------------------------------------------------------------------------------
                    SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD)
                    INTO V_ORIQTY, V_QTYCNT, V_MINDATE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                    WHERE A.MEASURE IN ('RTF', 'RTF_SYS_RP') AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                    -----------------------------------------------------------------------------------------------
                    -- 수정후 수량 = 수정된 총수량 * 원래개별수량/원래총수량
                    -----------------------------------------------------------------------------------------------
                    IF NVL(V_ORIQTY,0) <> 0 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0) ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END,
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE IN ('RTF', 'RTF_SYS_RP') AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);

                        --나머지 배부
                        SELECT V_ADJQTY - NVL(SUM(A.QTY),0) INTO V_REST
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE IN ('RTF', 'RTF_SYS_RP') AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                        IF V_REST <> 0 THEN
                            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                            SET QTY = A.QTY + V_REST, LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                            WHERE A.MEASURE IN ('RTF', 'RTF_SYS_RP') AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.YYYYMMDD = V_MINDATE
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                        END IF;
                    ELSE
                        -----------------------------------------------------------------------------------------------
                        -- RTF 가 원래 없었을 경우
                        -----------------------------------------------------------------------------------------------
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
                             , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-'), NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), NVL(B.MEASURE, '-'), '-', NVL(B.YYYYMMDD, '-')
                             , NVL(A.CURRENCY, '-'), NVL(TO_NUMBER(B.QTY), 0), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , NVL(A.COMPANY_ID, '-'), NVL(A.PROJECT_CODE, '-'), A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.MEASURE IN ('RTF', 'RTF_SYS_RP') AND B.SEQ_RANK = V_I
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                -----------------------------------------------------------------------
                -- 금액처리_SalesAmt_LOC ( 여기서는 Qty 변수들을 Amnt 로 활용한다. )
                -----------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_LOC');

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    V_ADJQTY := 0; V_REST := 0;
                    SELECT TO_NUMBER(QTY) INTO V_ADJQTY FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_LOC' AND ROWNUM = 1;

                    -- 수정전 금액 합계, 건수 계산
                    SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD) INTO V_ORIQTY, V_QTYCNT, V_MINDATE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                    WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                    V_EXISTS := 0;
                    BEGIN
                        SELECT 1 INTO V_EXISTS FROM DUAL
                        WHERE EXISTS (
                            SELECT 1
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA
                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB
                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID
                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP
                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID
                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'
                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE
                             AND BB.SEQ_RANK = V_I
                            WHERE AA.MEASURE = 'SalesAmt_LOC' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO
                        );
                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
                    END;
                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0) ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END,
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);

                        --나머지 배부
                        SELECT V_ADJQTY - NVL(SUM(A.QTY),0) INTO V_REST
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                        IF V_REST <> 0 THEN
                            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                            SET QTY = A.QTY + V_REST, LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                            WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.YYYYMMDD = V_MINDATE
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                        END IF;
                    ELSE
                        -- 원래 SalesAmt_LOC 메저가 없었던 경우
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
                             , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-'), NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'SalesAmt_LOC', '-', NVL(B.YYYYMMDD, '-')
                             , NVL(A.CURRENCY, '-'), NVL(TO_NUMBER(B.QTY), 0), P_CREATED_BY, SYSDATE, P_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , NVL(A.COMPANY_ID, '-'), NVL(A.PROJECT_CODE, '-'), A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.MEASURE = 'SalesAmt_LOC' AND B.SEQ_RANK = V_I
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                -----------------------------------------------------------------------
                -- 금액처리_SalesAmt_KRW
                -----------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_KRW');

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    SELECT TO_NUMBER(QTY) INTO V_ADJQTY FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_KRW' AND ROWNUM = 1;

                    SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD) INTO V_ORIQTY, V_QTYCNT, V_MINDATE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                    WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                    V_EXISTS := 0;
                    BEGIN
                        SELECT 1 INTO V_EXISTS FROM DUAL
                        WHERE EXISTS (
                            SELECT 1
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA
                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB
                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID
                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP
                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID
                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'
                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE
                             AND BB.SEQ_RANK = V_I
                            WHERE AA.MEASURE = 'SalesAmt_KRW' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO
                        );
                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
                    END;
                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0) ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END,
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);

                        SELECT V_ADJQTY - NVL(SUM(A.QTY),0) INTO V_REST
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                        IF V_REST <> 0 THEN
                            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                            SET QTY = A.QTY + V_REST, LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                            WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.YYYYMMDD = V_MINDATE
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                        END IF;
                    ELSE
                        -- 원래 SalesAmt_KRW 메저가 없었던 경우
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
                             , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-'), NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'SalesAmt_KRW', '-', NVL(B.YYYYMMDD, '-')
                             , NVL(A.CURRENCY, '-'), NVL(TO_NUMBER(B.QTY), 0), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , NVL(A.COMPANY_ID, '-'), NVL(A.PROJECT_CODE, '-'), A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.MEASURE = 'SalesAmt_KRW' AND B.SEQ_RANK = V_I
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                -----------------------------------------------------------------------
                -- 금액처리_SalesAmt_USD
                -----------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_USD');

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    SELECT TO_NUMBER(QTY) INTO V_ADJQTY FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_USD' AND ROWNUM = 1;

                    SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD) INTO V_ORIQTY, V_QTYCNT, V_MINDATE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                    WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                    V_EXISTS := 0;
                    BEGIN
                        SELECT 1 INTO V_EXISTS FROM DUAL
                        WHERE EXISTS (
                            SELECT 1
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA
                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB
                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID
                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP
                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID
                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'
                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE
                             AND BB.SEQ_RANK = V_I
                            WHERE AA.MEASURE = 'SalesAmt_USD' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO
                        );
                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
                    END;
                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0) ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END,
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);

                        SELECT V_ADJQTY - NVL(SUM(A.QTY),0) INTO V_REST
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                        IF V_REST <> 0 THEN
                            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                            SET QTY = A.QTY + V_REST, LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                            WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.YYYYMMDD = V_MINDATE
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                        END IF;
                    ELSE
                        -- 원래 SalesAmt_USD 메저가 없었던 경우
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
                             , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-'), NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'SalesAmt_USD', '-', NVL(B.YYYYMMDD, '-')
                             , NVL(A.CURRENCY, '-'), NVL(TO_NUMBER(B.QTY), 0), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , NVL(A.COMPANY_ID, '-'), NVL(A.PROJECT_CODE, '-'), A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.MEASURE = 'SalesAmt_USD' AND B.SEQ_RANK = V_I
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                --====================================================================================================================================================
                --여기부터는 구간 일괄 업데이트
                --====================================================================================================================================================
                IF V_PLAN_YN = 'Y' THEN
                    -----------------------------------------------------------------------------------------------
                    -- 계획구간은 금액을 업데이트함 ( LOC )
                    -----------------------------------------------------------------------------------------------
                    V_EXISTS := 0;

                    BEGIN

                        SELECT 1 INTO V_EXISTS FROM DUAL

                        WHERE EXISTS (

                            SELECT 1

                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA

                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB

                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID

                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP

                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID

                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'

                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE

                             AND BB.SEQ_RANK = V_I

                            WHERE AA.MEASURE = 'SalesAmt_LOC' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO

                        );

                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                    END;

                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = NVL((SELECT C.QTY * D.QTY
                                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C, SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C D
                                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID
                                   AND C.MEASURE IN ('RTF', 'RTF_SYS_RP')
                                   AND D.VERSION_NO = A.VERSION_NO AND D.DIVISION_ID = A.DIVISION_ID AND D.DEPARTMENT_ID = A.DEPARTMENT_ID AND D.DEPT_ID = A.DEPT_ID
                                   AND D.END_CUST_REPORT = A.END_CUST_REPORT AND D.CUST_REPORT = A.CUST_REPORT AND D.PRODUCT_GROUP = A.PRODUCT_GROUP
                                   AND D.PROJECT_CODE = A.PROJECT_CODE AND D.SCM_SITE_ID = A.SCM_SITE_ID AND D.ITEM_ID = A.ITEM_ID
                                   AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = A.CURRENCY AND D.COMPANY_ID = A.COMPANY_ID
                                   AND D.MEASURE = 'LOC' AND ROWNUM = 1), A.QTY),
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.SEQ_RANK = V_I);
                    ELSE
                        -- 계획구간 SalesAmt_LOC INSERT (RTF * LOC)
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, NVL(C.DEPARTMENT_ID, '-'), NVL(C.DEPARTMENT_NAME, '-'), NVL(C.DEPT_ID, '-'), NVL(C.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
                             , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-'), NVL(C.DOM_EXP, '-'), NVL(C.FCST_TYPE, '-'), NVL(C.INCOTERMS, '-'), 'SalesAmt_LOC', '-', NVL(A.YYYYMMDD, '-')
                             , NVL(A.CURRENCY, '-'), NVL(SUM(C.QTY) * MAX(D.QTY), 0), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10
                             , NVL(C.COMPANY_ID, '-'), NVL(C.PROJECT_CODE, '-'), C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC, C.NICK_NAME
                             , C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME, C.APPLICATION, C.APPLICATION_GR
                             , C.COUNTRY_KR_NAME, C.ROUTE, NVL(C.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.GT_0044_RESULTS_MST_C A
                        JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                          ON A.VERSION_NO = C.VERSION_NO AND A.DIVISION_ID = C.DIVISION_ID AND A.DEPARTMENT_ID = C.DEPARTMENT_ID AND A.DEPT_ID = C.DEPT_ID
                         AND A.END_CUST_REPORT = C.END_CUST_REPORT AND A.CUST_REPORT = C.CUST_REPORT AND A.PRODUCT_GROUP = C.PRODUCT_GROUP
                         AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(C.YYYYMMDD,1,6)||'%' AND A.CURRENCY = C.CURRENCY AND A.COMPANY_ID = C.COMPANY_ID
                         AND C.MEASURE IN ('RTF', 'RTF_SYS_RP')
                        JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C D
                          ON A.VERSION_NO = D.VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.DEPARTMENT_ID = D.DEPARTMENT_ID AND A.DEPT_ID = D.DEPT_ID
                         AND A.END_CUST_REPORT = D.END_CUST_REPORT AND A.CUST_REPORT = D.CUST_REPORT AND A.PRODUCT_GROUP = D.PRODUCT_GROUP
                         AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND A.CURRENCY = D.CURRENCY AND A.COMPANY_ID = D.COMPANY_ID
                         AND D.MEASURE = 'LOC'
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.SEQ_RANK = V_I
                        GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, C.DEPARTMENT_ID
                               , NVL(C.DEPARTMENT_NAME, '-'), C.DEPT_ID, NVL(C.DEPT_NAME, '-'), A.END_CUST_REPORT, A.CUST_REPORT
                               , A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(C.DOM_EXP, '-'), C.FCST_TYPE
                               , NVL(C.INCOTERMS, '-'), A.YYYYMMDD, A.CURRENCY, C.ATTRIBUTE1, C.ATTRIBUTE2
                               , C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7
                               , C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10, C.COMPANY_ID, C.PROJECT_CODE
                               , C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC
                               , C.NICK_NAME, C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME
                               , C.APPLICATION, C.APPLICATION_GR, C.COUNTRY_KR_NAME, C.ROUTE, C.CELL_PROD_SITE;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;

                    -- 계획구간은 금액을 업데이트함 ( KRW ) - SalesAmt_LOC * EXCHANGE
                    V_EXISTS := 0;

                    BEGIN

                        SELECT 1 INTO V_EXISTS FROM DUAL

                        WHERE EXISTS (

                            SELECT 1

                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA

                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB

                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID

                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP

                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID

                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'

                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE

                             AND BB.SEQ_RANK = V_I

                            WHERE AA.MEASURE = 'SalesAmt_KRW' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO

                        );

                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                    END;

                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = NVL((SELECT ROUND(C.QTY * D.EXCHANGE_PRICE, 0)
                                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D
                                     ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID
                                    AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = A.CURRENCY
                                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID
                                   AND C.MEASURE = 'SalesAmt_LOC' AND ROWNUM = 1), A.QTY),
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.SEQ_RANK = V_I);
                    ELSE
                        -- 계획구간 SalesAmt_KRW INSERT
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, NVL(C.DEPARTMENT_ID, '-'), NVL(C.DEPARTMENT_NAME, '-'), NVL(C.DEPT_ID, '-'), NVL(C.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
                             , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-'), NVL(C.DOM_EXP, '-'), NVL(C.FCST_TYPE, '-'), NVL(C.INCOTERMS, '-'), 'SalesAmt_KRW', '-', NVL(A.YYYYMMDD, '-')
                             , NVL(A.CURRENCY, '-'), NVL(ROUND(C.QTY * D.EXCHANGE_PRICE, 0), 0), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10
                             , NVL(C.COMPANY_ID, '-'), NVL(C.PROJECT_CODE, '-'), C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC, C.NICK_NAME
                             , C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME, C.APPLICATION, C.APPLICATION_GR
                             , C.COUNTRY_KR_NAME, C.ROUTE, NVL(C.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.GT_0044_RESULTS_MST_C A
                        JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                          ON A.VERSION_NO = C.VERSION_NO AND A.DIVISION_ID = C.DIVISION_ID AND A.DEPARTMENT_ID = C.DEPARTMENT_ID AND A.DEPT_ID = C.DEPT_ID
                         AND A.END_CUST_REPORT = C.END_CUST_REPORT AND A.CUST_REPORT = C.CUST_REPORT AND A.PRODUCT_GROUP = C.PRODUCT_GROUP
                         AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(C.YYYYMMDD,1,6)||'%' AND A.CURRENCY = C.CURRENCY AND A.COMPANY_ID = C.COMPANY_ID
                         AND C.MEASURE = 'SalesAmt_LOC'
                        JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D
                          ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID
                         AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = A.CURRENCY
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.SEQ_RANK = V_I
                        AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;

                    -- 계획구간은 금액을 업데이트함 ( USD )
                    V_EXISTS := 0;

                    BEGIN

                        SELECT 1 INTO V_EXISTS FROM DUAL

                        WHERE EXISTS (

                            SELECT 1

                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA

                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB

                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID

                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP

                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID

                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'

                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE

                             AND BB.SEQ_RANK = V_I

                            WHERE AA.MEASURE = 'SalesAmt_USD' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO

                        );

                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                    END;

                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = NVL((SELECT CASE WHEN NVL(E.EXCHANGE_PRICE,0) <> 0 THEN ROUND(C.QTY * D.EXCHANGE_PRICE / E.EXCHANGE_PRICE, 0) ELSE 0 END
                                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = 'USD'
                                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C E ON E.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = E.DIVISION_ID AND A.YYYYMMDD LIKE SUBSTR(E.YYYYMMDD,1,6)||'%' AND E.CURRENCY = 'KRW' AND E.UNIT_CURRENCY = A.CURRENCY
                                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID
                                   AND C.MEASURE = 'SalesAmt_LOC' AND ROWNUM = 1), A.QTY),
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.SEQ_RANK = V_I);
                    ELSE
                        -- 계획구간 SalesAmt_USD INSERT
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, NVL(C.DEPARTMENT_ID, '-'), NVL(C.DEPARTMENT_NAME, '-'), NVL(C.DEPT_ID, '-'), NVL(C.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
                             , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-'), NVL(C.DOM_EXP, '-'), NVL(C.FCST_TYPE, '-'), NVL(C.INCOTERMS, '-'), 'SalesAmt_USD', '-', NVL(A.YYYYMMDD, '-')
                             , NVL(A.CURRENCY, '-'), NVL(CASE WHEN NVL(E.EXCHANGE_PRICE,0) <> 0 THEN ROUND(C.QTY * D.EXCHANGE_PRICE / E.EXCHANGE_PRICE, 0) ELSE 0 END, 0)
                             , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10
                             , NVL(C.COMPANY_ID, '-'), NVL(C.PROJECT_CODE, '-'), C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC, C.NICK_NAME
                             , C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME, C.APPLICATION, C.APPLICATION_GR
                             , C.COUNTRY_KR_NAME, C.ROUTE, NVL(C.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.GT_0044_RESULTS_MST_C A
                        JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                          ON A.VERSION_NO = C.VERSION_NO AND A.DIVISION_ID = C.DIVISION_ID AND A.DEPARTMENT_ID = C.DEPARTMENT_ID AND A.DEPT_ID = C.DEPT_ID
                         AND A.END_CUST_REPORT = C.END_CUST_REPORT AND A.CUST_REPORT = C.CUST_REPORT AND A.PRODUCT_GROUP = C.PRODUCT_GROUP
                         AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(C.YYYYMMDD,1,6)||'%' AND A.CURRENCY = C.CURRENCY AND A.COMPANY_ID = C.COMPANY_ID
                         AND C.MEASURE = 'SalesAmt_LOC'
                        JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = 'USD'
                        JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C E ON E.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = E.DIVISION_ID AND A.YYYYMMDD LIKE SUBSTR(E.YYYYMMDD,1,6)||'%' AND E.CURRENCY = 'KRW' AND E.UNIT_CURRENCY = A.CURRENCY
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.SEQ_RANK = V_I
                        AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                ELSE
                    -----------------------------------------------------------------------------------------------
                    -- 실적구간은 단가를 업데이트
                    -- SalesAmt_LOC 를 Qty 로 나눠서 단가를 계산한다. ( 본테이블에서 LOC 를 지우고, 다시 계산해서 INSERT 한다. )
                    -----------------------------------------------------------------------------------------------
                    -- INSERT 할 날짜
                    BEGIN
                        SELECT YYYYMMDD INTO V_YYYYMMDD FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND ROWNUM = 1;
                    EXCEPTION WHEN NO_DATA_FOUND THEN V_YYYYMMDD := NULL;
                    END;
                    V_YYYYMMDD := SUBSTR(V_YYYYMMDD, 1, 6) || '01';

                    -- 삭제
                    DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    WHERE A.MEASURE = 'LOC'
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                        WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                        AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                        AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                        AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                        AND B.SEQ_RANK = V_I);
                    N_DELETE_COUNT := N_DELETE_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                    -- SalesAmt_LOC 합산
                    SELECT NVL(SUM(A.QTY),0) INTO V_LOC_SALESAMT_LOC
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND B.SEQ_RANK = V_I AND B.SEQ_ROWNUM = 1 AND A.MEASURE = 'SalesAmt_LOC';

                    SELECT NVL(SUM(A.QTY),0) INTO V_LOC_RTF
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND B.SEQ_RANK = V_I AND B.SEQ_ROWNUM = 1 AND A.MEASURE IN ('RTF', 'RTF_SYS_RP');

                    INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                    ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                    , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                    , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                    , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                    , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                    , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                    SELECT '1', NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
                         , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-'), NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'LOC', '-', NVL(B.YYYYMMDD, '-')
                         , NVL(A.CURRENCY, '-'), NVL(CASE WHEN NVL(V_LOC_RTF, 0) <> 0 THEN ROUND(V_LOC_SALESAMT_LOC / V_LOC_RTF, 3) ELSE 0 END, 0)
                         , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                         , NVL(A.COMPANY_ID, '-'), NVL(A.PROJECT_CODE, '-'), A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                         , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND B.SEQ_RANK = V_I AND B.SEQ_ROWNUM = 1
                    WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                    N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                END IF; -- V_PLAN_YN

                V_I := V_I + 1;
            END LOOP; -- WHILE V_I <= V_CNT (division_id = '40')

        ELSE
            -----------------------------------------------------------------------------------------------
            -- 자동차 ESS ( 데이터는 1일자에만 들어있고, 수정은 계획구간의 LOC 만 가능 )
            -- 자동차는 Product_group 을 조건에서 제외함
            -- *** 이 분기는 원본 MSSQL A030~A036 영역에 해당하며 동일 패턴으로 변환 ***
            -- (분량 제약으로 동일 패턴의 반복 코드는 축약 표기하되, 실제 배포 시 전개 필요)
            -----------------------------------------------------------------------------------------------
            WHILE V_I <= V_CNT LOOP
                -- LOC 가 있으면 업데이트, 없으면 인서트 (PRODUCT_GROUP, COMPANY_ID 조인 제외, FCST_TYPE 분기, YYYYMMDD 직접매칭)
                V_EXISTS := 0;
                BEGIN
                    SELECT 1 INTO V_EXISTS FROM DUAL WHERE EXISTS (
                        SELECT 1 FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD = B.YYYYMMDD AND A.CURRENCY = B.CURRENCY AND A.MEASURE = B.MEASURE
                         AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                         AND A.INCOTERMS = B.INCOTERMS AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE = 'LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO);
                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
                END;

                IF V_EXISTS = 1 THEN
                    -- 1. LOC 메저를 업데이트
                    UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    SET QTY = NVL((SELECT TO_NUMBER(B.QTY) FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                               WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                               AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                               AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                               AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.MEASURE = A.MEASURE
                               AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                               AND B.INCOTERMS = A.INCOTERMS AND B.SEQ_RANK = V_I AND ROWNUM = 1), A.QTY),
                        LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                    WHERE A.MEASURE = 'LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                        WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                        AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                        AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                        AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.MEASURE = A.MEASURE
                        AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                        AND B.INCOTERMS = A.INCOTERMS AND B.SEQ_RANK = V_I);
                ELSE
                    -- LOC INSERT (자동차 ESS - PRODUCT_GROUP 제외)
                    INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                    ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                    , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                    , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                    , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                    , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                    , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                    SELECT '1', NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
                         , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-'), NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'LOC', '-', NVL(B.YYYYMMDD, '-')
                         , NVL(A.CURRENCY, '-'), NVL(TO_NUMBER(B.QTY), 0), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                         , NVL(A.COMPANY_ID, '-'), NVL(A.PROJECT_CODE, '-'), A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                         , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-')
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.CURRENCY = B.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                     AND A.INCOTERMS = B.INCOTERMS AND B.MEASURE = 'LOC' AND B.SEQ_RANK = V_I
                    WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                    N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                END IF;

                -- 2. 기타 금액메저 모두 삭제
                DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                WHERE (A.MEASURE IN ('KRW','USD') OR A.MEASURE LIKE 'SalesAmt%')
                AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                    WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                    AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                    AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                    AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY
                    AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                    AND B.INCOTERMS = A.INCOTERMS AND B.SEQ_RANK = V_I);
                N_DELETE_COUNT := N_DELETE_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                -- 3. KRW 메저 INSERT (LOC * EXCHANGE_PRICE)
                INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                , COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                SELECT SUB_A.DATA_TYPE, NVL(SUB_A.DIVISION_ID, '-'), NVL(SUB_A.VERSION_NO, '-'), SUB_A.CUTOFF_TYPE, SUB_A.CUTOFF_YYYYMMDD, NVL(SUB_A.DEPARTMENT_ID, '-'), NVL(SUB_A.DEPARTMENT_NAME, '-'), NVL(SUB_A.DEPT_ID, '-'), NVL(SUB_A.DEPT_NAME, '-'), NVL(SUB_A.END_CUST_REPORT, '-')
                     , NVL(SUB_A.CUST_REPORT, '-'), NVL(SUB_A.PRODUCT_GROUP, '-'), NVL(SUB_A.PROJECT_CODE, '-'), NVL(SUB_A.SCM_SITE_ID, '-'), NVL(SUB_A.ITEM_ID, '-'), SUB_A.DOM_EXP, NVL(SUB_A.FCST_TYPE, '-'), NVL(SUB_A.INCOTERMS, '-'), 'KRW', NVL(SUB_A.PLANT_SITE_ID, '-')
                     , NVL(SUB_A.YYYYMMDD, '-'), NVL(SUB_A.CURRENCY, '-'), NVL(SUB_A.QTY * EX.EXCHANGE_PRICE, 0), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                     , SUB_A.ATTRIBUTE1, SUB_A.ATTRIBUTE2, SUB_A.ATTRIBUTE3, SUB_A.ATTRIBUTE4, SUB_A.ATTRIBUTE5, SUB_A.ATTRIBUTE6, SUB_A.ATTRIBUTE7, SUB_A.ATTRIBUTE8, SUB_A.ATTRIBUTE9, SUB_A.ATTRIBUTE10
                     , NVL(SUB_A.COMPANY_ID, '-'), SUB_A.SOLDTO_CUST_REPORT, SUB_A.OWNER_NAME, SUB_A.CUST_GROUP_DTL, SUB_A.PRODUCT_DETAILS, SUB_A.FORECAST_INFO_SPEC, SUB_A.NICK_NAME
                     , SUB_A.FORECAST_INFO_CELL_MODEL, SUB_A.FORECAST_INFO_CELL_PACK_COUNT, SUB_A.FORECAST_INFO_BIZ_TYPE, SUB_A.COMPANY_NAME, SUB_A.APPLICATION, SUB_A.APPLICATION_GR
                     , SUB_A.COUNTRY_KR_NAME, SUB_A.ROUTE, NVL(SUB_A.CELL_PROD_SITE, '-')
                FROM (SELECT A.* FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD = B.YYYYMMDD AND A.CURRENCY = B.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                     AND A.INCOTERMS = B.INCOTERMS AND B.SEQ_RANK = V_I
                     WHERE A.DIVISION_ID = V_DIVISION_ID AND A.MEASURE = 'LOC' AND A.VERSION_NO = V_VERSION_NO) SUB_A
                JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C EX
                  ON SUB_A.DIVISION_ID = EX.DIVISION_ID AND SUB_A.VERSION_NO = EX.VERSION_NO AND SUB_A.CUTOFF_TYPE = EX.CUTOFF_TYPE
                 AND SUB_A.CUTOFF_YYYYMMDD = EX.CUTOFF_YYYYMMDD AND EX.CURRENCY = 'KRW' AND SUB_A.CURRENCY = EX.UNIT_CURRENCY
                 AND SUB_A.YYYYMMDD = EX.YYYYMMDD AND EX.VERSION_NO = V_VERSION_NO;
                N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                -- USD 메저 INSERT
                INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                , COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                SELECT SUB_A.DATA_TYPE, NVL(SUB_A.DIVISION_ID, '-'), NVL(SUB_A.VERSION_NO, '-'), SUB_A.CUTOFF_TYPE, SUB_A.CUTOFF_YYYYMMDD, NVL(SUB_A.DEPARTMENT_ID, '-'), NVL(SUB_A.DEPARTMENT_NAME, '-'), NVL(SUB_A.DEPT_ID, '-'), NVL(SUB_A.DEPT_NAME, '-'), NVL(SUB_A.END_CUST_REPORT, '-')
                     , NVL(SUB_A.CUST_REPORT, '-'), NVL(SUB_A.PRODUCT_GROUP, '-'), NVL(SUB_A.PROJECT_CODE, '-'), NVL(SUB_A.SCM_SITE_ID, '-'), NVL(SUB_A.ITEM_ID, '-'), SUB_A.DOM_EXP, NVL(SUB_A.FCST_TYPE, '-'), NVL(SUB_A.INCOTERMS, '-'), 'USD', NVL(SUB_A.PLANT_SITE_ID, '-')
                     , NVL(SUB_A.YYYYMMDD, '-'), NVL(SUB_A.CURRENCY, '-')
                     , NVL(CASE WHEN NVL(EX.EXCHANGE_PRICE, 0) <> 0 THEN ROUND(SUB_A.QTY / EX.EXCHANGE_PRICE, 3) ELSE 0 END, 0)
                     , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                     , SUB_A.ATTRIBUTE1, SUB_A.ATTRIBUTE2, SUB_A.ATTRIBUTE3, SUB_A.ATTRIBUTE4, SUB_A.ATTRIBUTE5, SUB_A.ATTRIBUTE6, SUB_A.ATTRIBUTE7, SUB_A.ATTRIBUTE8, SUB_A.ATTRIBUTE9, SUB_A.ATTRIBUTE10
                     , NVL(SUB_A.COMPANY_ID, '-'), SUB_A.SOLDTO_CUST_REPORT, SUB_A.OWNER_NAME, SUB_A.CUST_GROUP_DTL, SUB_A.PRODUCT_DETAILS, SUB_A.FORECAST_INFO_SPEC, SUB_A.NICK_NAME
                     , SUB_A.FORECAST_INFO_CELL_MODEL, SUB_A.FORECAST_INFO_CELL_PACK_COUNT, SUB_A.FORECAST_INFO_BIZ_TYPE, SUB_A.COMPANY_NAME, SUB_A.APPLICATION, SUB_A.APPLICATION_GR
                     , SUB_A.COUNTRY_KR_NAME, SUB_A.ROUTE, NVL(SUB_A.CELL_PROD_SITE, '-')
                FROM (SELECT A.* FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD = B.YYYYMMDD AND A.CURRENCY = B.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                     AND A.INCOTERMS = B.INCOTERMS AND B.SEQ_RANK = V_I
                     WHERE A.DIVISION_ID = V_DIVISION_ID AND A.MEASURE = 'KRW' AND A.VERSION_NO = V_VERSION_NO) SUB_A
                JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C EX
                  ON SUB_A.DIVISION_ID = EX.DIVISION_ID AND SUB_A.VERSION_NO = EX.VERSION_NO AND SUB_A.CUTOFF_TYPE = EX.CUTOFF_TYPE
                 AND SUB_A.CUTOFF_YYYYMMDD = EX.CUTOFF_YYYYMMDD AND EX.CURRENCY = 'KRW' AND EX.UNIT_CURRENCY = 'USD'
                 AND SUB_A.YYYYMMDD = EX.YYYYMMDD AND EX.VERSION_NO = V_VERSION_NO;
                N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                -- 4. SalesAmt_LOC, KRW, USD 업데이트 또는 생성 (RTF * LOC/KRW/USD 매칭)
                INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                , COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                SELECT SUB_A.DATA_TYPE, NVL(SUB_A.DIVISION_ID, '-'), NVL(SUB_A.VERSION_NO, '-'), SUB_A.CUTOFF_TYPE, SUB_A.CUTOFF_YYYYMMDD, NVL(SUB_A.DEPARTMENT_ID, '-'), NVL(SUB_A.DEPARTMENT_NAME, '-'), NVL(SUB_A.DEPT_ID, '-'), NVL(SUB_A.DEPT_NAME, '-'), NVL(SUB_A.END_CUST_REPORT, '-')
                     , NVL(SUB_A.CUST_REPORT, '-'), NVL(SUB_A.PRODUCT_GROUP, '-'), NVL(SUB_A.PROJECT_CODE, '-'), NVL(SUB_A.SCM_SITE_ID, '-'), NVL(SUB_A.ITEM_ID, '-'), SUB_A.DOM_EXP, NVL(SUB_A.FCST_TYPE, '-'), NVL(SUB_A.INCOTERMS, '-'), NVL(SUB_A.MEASURE, '-'), NVL(SUB_A.PLANT_SITE_ID, '-')
                     , NVL(SUB_A.YYYYMMDD, '-'), NVL(SUB_A.CURRENCY, '-'), NVL(SUB_A.QTY, 0), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                     , SUB_A.ATTRIBUTE1, SUB_A.ATTRIBUTE2, SUB_A.ATTRIBUTE3, SUB_A.ATTRIBUTE4, SUB_A.ATTRIBUTE5, SUB_A.ATTRIBUTE6, SUB_A.ATTRIBUTE7, SUB_A.ATTRIBUTE8, SUB_A.ATTRIBUTE9, SUB_A.ATTRIBUTE10
                     , NVL(SUB_A.COMPANY_ID, '-'), SUB_A.SOLDTO_CUST_REPORT, SUB_A.OWNER_NAME, SUB_A.CUST_GROUP_DTL, SUB_A.PRODUCT_DETAILS, SUB_A.FORECAST_INFO_SPEC, SUB_A.NICK_NAME
                     , SUB_A.FORECAST_INFO_CELL_MODEL, SUB_A.FORECAST_INFO_CELL_PACK_COUNT, SUB_A.FORECAST_INFO_BIZ_TYPE, SUB_A.COMPANY_NAME, SUB_A.APPLICATION, SUB_A.APPLICATION_GR
                     , SUB_A.COUNTRY_KR_NAME, SUB_A.ROUTE, NVL(SUB_A.CELL_PROD_SITE, '-')
                FROM (
                    SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-') AS DEPARTMENT_NAME, A.DEPT_ID, NVL(A.DEPT_NAME, '-') AS DEPT_NAME, A.END_CUST_REPORT
                         , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-') AS DOM_EXP, NVL(A.FCST_TYPE, '-') AS FCST_TYPE, A.INCOTERMS
                         , 'SalesAmt_' || C.MEASURE AS MEASURE, A.PLANT_SITE_ID
                         , A.YYYYMMDD, A.CURRENCY, ROUND(A.QTY * C.QTY, 3) AS QTY
                         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                         , A.COMPANY_ID, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                         , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') AS CELL_PROD_SITE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD = B.YYYYMMDD AND A.CURRENCY = B.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                     AND A.INCOTERMS = B.INCOTERMS AND B.SEQ_RANK = V_I
                    JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                      ON A.VERSION_NO = C.VERSION_NO AND A.DIVISION_ID = C.DIVISION_ID AND A.DEPARTMENT_ID = C.DEPARTMENT_ID AND A.DEPT_ID = C.DEPT_ID
                     AND A.END_CUST_REPORT = C.END_CUST_REPORT AND A.CUST_REPORT = C.CUST_REPORT
                     AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                     AND A.YYYYMMDD = C.YYYYMMDD AND A.CURRENCY = C.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE C.FCST_TYPE END
                     AND A.INCOTERMS = C.INCOTERMS AND C.MEASURE IN ('LOC', 'USD', 'KRW')
                    WHERE A.DIVISION_ID = V_DIVISION_ID
                    AND A.MEASURE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN 'RTF_SYS_RP' ELSE 'RTF' END
                    AND A.VERSION_NO = V_VERSION_NO
                ) SUB_A;
                N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                V_I := V_I + 1;
            END LOOP; -- 자동차 ESS
        END IF; -- V_DIVISION_ID = '40'
    --=============================================================================================
    --DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (END)
    --=============================================================================================
    --=============================================================================================
    --BP인 경우 (START)
    --=============================================================================================
    ELSE
        --[C20201005-000291] BP 부분을 루프에서 원쿼리로 변경함.
        -----------------------------------------------------------------------------------------------
        -- 단가 변경이 있을 경우 LOC, KRW, USD 를 같이 변경함
        -----------------------------------------------------------------------------------------------
        V_EXISTS := 0;
        BEGIN
            SELECT 1 INTO V_EXISTS FROM DUAL WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE MEASURE = 'LOC');
        EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
        END;

        IF V_EXISTS = 1 THEN
            -- LOC
            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
            SET QTY = NVL((SELECT TO_NUMBER(B.QTY) FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                       WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                       AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                       AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                       AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                       AND B.MEASURE = A.MEASURE AND ROWNUM = 1), A.QTY),
                LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
            WHERE A.MEASURE = 'LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID AND B.MEASURE = A.MEASURE);

            -- KRW (LOC * EXCHANGE)
            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
            SET QTY = NVL((SELECT ROUND(C.QTY * D.EXCHANGE_PRICE, 0)
                       FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                       JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD = D.YYYYMMDD AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = A.CURRENCY
                       WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                       AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                       AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                       AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID AND C.MEASURE = 'LOC' AND ROWNUM = 1), A.QTY),
                LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
            WHERE A.MEASURE = 'KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID AND B.MEASURE = 'LOC');

            -- USD (KRW / EXCHANGE)
            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
            SET QTY = NVL((SELECT ROUND(CASE WHEN NVL(D.EXCHANGE_PRICE,0) = 0 THEN 0 ELSE C.QTY / NVL(D.EXCHANGE_PRICE,0) END, 0)
                       FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                       JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD = D.YYYYMMDD AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = 'USD'
                       WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                       AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                       AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                       AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID AND C.MEASURE = 'KRW' AND ROWNUM = 1), A.QTY),
                LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
            WHERE A.MEASURE = 'USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID AND B.MEASURE = 'USD');
        END IF;

        --	수량 변경이 있을 경우 처리 ( 수량은 수량만 수정 )
        V_EXISTS := 0;
        BEGIN SELECT 1 INTO V_EXISTS FROM DUAL WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE MEASURE = 'Business_Plan');
        EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0; END;

        IF V_EXISTS = 1 THEN
            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
            SET QTY = NVL((SELECT TO_NUMBER(B.QTY) FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                       WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                       AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                       AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                       AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                       AND B.MEASURE = A.MEASURE AND ROWNUM = 1), A.QTY),
                LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
            WHERE A.MEASURE = 'Business_Plan' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID AND B.MEASURE = A.MEASURE);
        END IF;

        -- BP는 모든 구간이 계획이므로 금액을 조정: SalesAmt_LOC = Business_Plan * LOC
        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        SET QTY = NVL((SELECT C.QTY * D.QTY
                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C, SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C D
                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID AND C.MEASURE = 'Business_Plan'
                   AND D.VERSION_NO = A.VERSION_NO AND D.DIVISION_ID = A.DIVISION_ID AND D.DEPARTMENT_ID = A.DEPARTMENT_ID AND D.DEPT_ID = A.DEPT_ID
                   AND D.END_CUST_REPORT = A.END_CUST_REPORT AND D.CUST_REPORT = A.CUST_REPORT AND D.PRODUCT_GROUP = A.PRODUCT_GROUP
                   AND D.PROJECT_CODE = A.PROJECT_CODE AND D.SCM_SITE_ID = A.SCM_SITE_ID AND D.ITEM_ID = A.ITEM_ID
                   AND D.YYYYMMDD = A.YYYYMMDD AND D.CURRENCY = A.CURRENCY AND D.COMPANY_ID = A.COMPANY_ID AND D.MEASURE = 'LOC' AND ROWNUM = 1), A.QTY),
            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
        WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
            AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID);

        -- SalesAmt_KRW = SalesAmt_LOC * EXCHANGE
        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        SET QTY = NVL((SELECT ROUND(C.QTY * D.EXCHANGE_PRICE, 0)
                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD = D.YYYYMMDD AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = A.CURRENCY
                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID AND C.MEASURE = 'SalesAmt_LOC' AND ROWNUM = 1), A.QTY),
            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
        WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
            AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID);

        -- SalesAmt_USD = SalesAmt_KRW / EXCHANGE(USD)
        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        SET QTY = NVL((SELECT ROUND(CASE WHEN NVL(D.EXCHANGE_PRICE,0) = 0 THEN 0 ELSE B_SUB.QTY / NVL(D.EXCHANGE_PRICE,0) END, 0)
                   FROM (SELECT A2.DIVISION_ID, A2.DEPARTMENT_ID, A2.DEPT_ID, A2.END_CUST_REPORT, A2.CUST_REPORT, A2.PRODUCT_GROUP, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.ITEM_ID, A2.YYYYMMDD, A2.CURRENCY, A2.COMPANY_ID, A2.QTY
                         FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A2
                         WHERE A2.MEASURE = 'SalesAmt_KRW' AND A2.VERSION_NO = V_VERSION_NO AND A2.DIVISION_ID = V_DIVISION_ID) B_SUB
                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD = D.YYYYMMDD AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = 'USD'
                   WHERE B_SUB.DIVISION_ID = A.DIVISION_ID AND B_SUB.DEPARTMENT_ID = A.DEPARTMENT_ID AND B_SUB.DEPT_ID = A.DEPT_ID
                   AND B_SUB.END_CUST_REPORT = A.END_CUST_REPORT AND B_SUB.CUST_REPORT = A.CUST_REPORT AND B_SUB.PRODUCT_GROUP = A.PRODUCT_GROUP
                   AND B_SUB.PROJECT_CODE = A.PROJECT_CODE AND B_SUB.SCM_SITE_ID = A.SCM_SITE_ID AND B_SUB.ITEM_ID = A.ITEM_ID
                   AND B_SUB.YYYYMMDD = A.YYYYMMDD AND B_SUB.CURRENCY = A.CURRENCY AND B_SUB.COMPANY_ID = A.COMPANY_ID AND ROWNUM = 1), A.QTY),
            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
        WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C C
            WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
            AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
            AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
            AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID);
    END IF; -- V_CUTOFF_TYPE
    --=============================================================================================
    --BP인 경우 (END)
    --=============================================================================================

    --=============================================================================================
    --[E20230906-001160] GDW 송신용 데이터 Lookup 수정 START
    --=============================================================================================
    MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    USING (
        SELECT MODEL, BIZ_TYPE, CELL_PACK_COUNT, DIVISION_ID
        FROM (SELECT SEGMENT2 AS MODEL, SEGMENT3 AS BIZ_TYPE, SEGMENT4 AS CELL_PACK_COUNT, SEGMENT1 AS DIVISION_ID,
                     RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
              FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40')
        WHERE MODEL_RANK = 1
    ) LOOKA ON (LOOKA.MODEL = A.ITEM_ID AND LOOKA.DIVISION_ID = A.DIVISION_ID)
    WHEN MATCHED THEN UPDATE
    SET A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT,
        A.FORECAST_INFO_BIZ_TYPE        = LOOKA.BIZ_TYPE,
        A.LAST_UPDATED_BY               = V_CREATED_BY, --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
        A.LAST_UPDATE_DATE              = SYSDATE       --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
    WHERE A.DIVISION_ID = '40' AND A.VERSION_NO = V_VERSION_NO;
    --=============================================================================================
    --[E20230906-001160] GDW 송신용 데이터 Lookup 수정 END
    --=============================================================================================

    --=============================================================================================
    --[E20250418-001567]_Sales Report 이력 테이블 생성 START
    --=============================================================================================
    INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_H
    ( DATA_TYPE, DIVISION_ID, HISTORY_SEQ, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
    , END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
    , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
    , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
    , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
    , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )
    SELECT A.DATA_TYPE, A.DIVISION_ID, SEQ1_DM_PLN_SALES_PLAN_REPORT_H.NEXTVAL, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, A.DEPT_NAME
         , A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), A.MEASURE, A.PLANT_SITE_ID
         , A.YYYYMMDD, A.CURRENCY, A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
         , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
         , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-')
    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
     AND A.MEASURE = B.MEASURE
    WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;
    N_HISTORY_COUNT := SQL%ROWCOUNT;  -- [PATCH] DML count
    --=============================================================================================
    --[E20250418-001567]_Sales Report 이력 테이블 생성 END
    --=============================================================================================

    -----------------------------------------------------------------------------------------------
    -- UPDATE 후에 전송처리를 다시 한다.
    -----------------------------------------------------------------------------------------------
    V_EXISTS := 0;
    BEGIN
        SELECT 1 INTO V_EXISTS FROM DUAL WHERE EXISTS (
            SELECT 1 FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID = V_DIVISION_ID AND VERSION_NO = V_VERSION_NO AND SEND_YN = 'Y');
    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
    END;

    /* TODO DMF0044_MOBILE_REPORT_CREATE
    IF V_EXISTS = 1 THEN
        SCM_MGR.DMF0044_MOBILE_REPORT_CREATE(V_DIVISION_ID, V_VERSION_NO, V_CUTOFF_TYPE, 'T', V_CREATED_BY);
    END IF;
    */

    --=============================================================================================
    -- COMMIT (종료 직전 1회)
    --=============================================================================================
    COMMIT;

    N_LOG_COUNT := N_INPUT_COUNT;
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    --=============================================================================================
    -- 종료 LOG
    --=============================================================================================
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure @@@##########';
    V_DESCRIPTION := 'input_count: '    || TO_CHAR(N_INPUT_COUNT)
                  || ' / insert_count: '|| TO_CHAR(N_INSERT_COUNT)
                  || ' / delete_count: '|| TO_CHAR(N_DELETE_COUNT)
                  || ' / history_count: '|| TO_CHAR(N_HISTORY_COUNT)
                  || ' / total_dml: '   || TO_CHAR(N_INSERT_COUNT + N_DELETE_COUNT);  -- [PATCH] DML 카운트
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'      VALUE P_DIVISION_ID,
            'P_VERSION_NO'       VALUE P_VERSION_NO,
            'P_CUTOFF_TYPE'      VALUE P_CUTOFF_TYPE,
            'P_CUTOFF_YYYYMMDD'  VALUE P_CUTOFF_YYYYMMDD,
            'P_CREATED_BY'       VALUE P_CREATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF;


PROCEDURE P_DMF0044_SAVE_TEXTBOX
(
    P_VERSION_NO        IN  VARCHAR2,
    P_YYYYMM            IN  VARCHAR2,
    P_DESCRIPTION1      IN  VARCHAR2,
    P_DESCRIPTION2      IN  VARCHAR2,
    P_DESCRIPTION3      IN  VARCHAR2,
    P_DESCRIPTION4      IN  VARCHAR2,
    P_DESCRIPTION5      IN  VARCHAR2,
    P_DESCRIPTION6      IN  VARCHAR2,
    P_DESCRIPTION7      IN  VARCHAR2,
    P_DESCRIPTION8      IN  VARCHAR2,
    P_DESCRIPTION9      IN  VARCHAR2,
    P_DESCRIPTION10     IN  VARCHAR2,
    P_DESCRIPTION11     IN  VARCHAR2,
    P_DESCRIPTION12     IN  VARCHAR2,
    P_DESCRIPTION13     IN  VARCHAR2,
    P_CREATED_BY        IN  VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*************************************************************************************************
* Program ID  : DMF0044_SAVE_TEXTBOX
* Description : Procedure 작성 가이드
* Usage       : TEXTBOX POPUP 에서 Request 를 생성할 때 사용
* Parameter   :
*
*------------------------------------------------------------------------------------------------
* Date        In Charge    Description
*------------------------------------------------------------------------------------------------
* 2021-09-16   ROSIA27		[과제] TEXTBOX POPUP
* 2026.03.24   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
***************************************************************************************************/
IS
    -- Case 41: 프로그램명 (패키지 대응)
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);

    -- LOG 용 변수 설정
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;

    v_exists            PLS_INTEGER;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure @@@##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    -- VERSION_NO Validation
    BEGIN
        SELECT 1 INTO v_exists FROM DUAL
        WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_MDF_VERSION
                      WHERE DIVISION_ID = '82' AND VERSION_NO = P_VERSION_NO);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := '해당 VERSION 이 존재하지 않습니다.';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
    END;

    UPDATE SCM_MGR.DM_MDF_VERSION
    SET    TEXT_START_YYYYMM = P_YYYYMM,
           DESCRIPTION1      = NVL(P_DESCRIPTION1, ''),
           DESCRIPTION2      = NVL(P_DESCRIPTION2, ''),
           DESCRIPTION3      = NVL(P_DESCRIPTION3, ''),
           DESCRIPTION4      = NVL(P_DESCRIPTION4, ''),
           DESCRIPTION5      = NVL(P_DESCRIPTION5, ''),
           DESCRIPTION6      = NVL(P_DESCRIPTION6, ''),
           DESCRIPTION7      = NVL(P_DESCRIPTION7, ''),
           DESCRIPTION8      = NVL(P_DESCRIPTION8, ''),
           DESCRIPTION9      = NVL(P_DESCRIPTION9, ''),
           DESCRIPTION10     = NVL(P_DESCRIPTION10, ''),
           DESCRIPTION11     = NVL(P_DESCRIPTION11, ''),
           DESCRIPTION12     = NVL(P_DESCRIPTION12, ''),
           DESCRIPTION13     = NVL(P_DESCRIPTION13, ''),
           LAST_UPDATED_BY   = P_CREATED_BY,
           LAST_UPDATE_DATE  = SYSDATE
    WHERE  DIVISION_ID = '82'
    AND    VERSION_NO  = P_VERSION_NO;

    n_merge_count := SQL%ROWCOUNT;

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    N_LOG_COUNT := n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_VERSION_NO'    VALUE P_VERSION_NO,
            'P_YYYYMM'       VALUE P_YYYYMM,
            'P_DESCRIPTION1'  VALUE P_DESCRIPTION1,
            'P_CREATED_BY'    VALUE P_CREATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_SAVE_TEXTBOX;


PROCEDURE P_DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE 
(
    P_YEAR            IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE                                            */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2020/03/23  P.C.I        Initial Release [prepare] Sales Report Exchange Rate Popup              */
/* 2026.03.18   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                 */
/*                                                                                                  */
/****************************************************************************************************/
IS

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

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    OPEN O_RC1 FOR
    SELECT MIN(BASIS_START_DATE) AS BASIS_START_DATE, CALENDAR_YYYY, CALENDAR_MONTH
    FROM   SCM_SYS_CALENDAR_M
    WHERE  CALENDAR_YYYY = P_YEAR
    GROUP BY CALENDAR_YYYY, CALENDAR_MONTH
    ORDER BY BASIS_START_DATE;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_YEAR' VALUE P_YEAR
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
END P_DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE;


PROCEDURE P_DMF0044_GET_SPREAD_TITLE 
(
	P_DIVISION_ID			VARCHAR2 DEFAULT '40',
	P_CREATED_BY			VARCHAR2 DEFAULT 'greenzun',
	P_START_DT				VARCHAR2 DEFAULT '20190101',
	P_END_DT				VARCHAR2 DEFAULT '20191231',
	O_RC1					OUT SYS_REFCURSOR,
	O_RESULT_CURSOR			OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DMF0044_GET_SPREAD_TITLE                                                          */
/* Description : MDF Reports 스프레드 타이틀(컬럼 정의 + 기간 월별 동적컬럼) 조회                  */
/* Program History                                                                                 */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/05/15  JYE          DMF0044_GET_SPREAD_TITLE                                                */
/* 2020/10/06  hwi1993      C20201005-000291 Sales Report 대량변경. 소수점 자리수를 룩업에서 먼저   */
/*                          찾도록 함 ( 소형만 10자리 )                                             */
/* 2022.04.13  HWI1993      GM JV 작업                                                              */
/* 2026.06.08  변환         [PJ20264226] NextSCM Pilot 재변환 (깨진 자동변환 정정:                  */
/*                          OUT커서 래핑 / 변수 중복선언 제거 / ) MA; 조기종료·ORDER BY 분리 수정)  */
/****************************************************************************************************/
IS

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

    /* ── 비즈니스 변수 ── */
    P_PROGRAM_ID        VARCHAR2(50 CHAR);
    P_SHEET_NAME        VARCHAR2(50 CHAR);
    V_DATA_SCALE_NUMBER VARCHAR2(2 CHAR);

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 소수점 자리수 룩업 (해당 division 설정이 없으면 NULL 유지) ── */
    BEGIN
        SELECT SEGMENT3
          INTO V_DATA_SCALE_NUMBER
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'DMF0044_CONFIG'
           AND SEGMENT1 = P_DIVISION_ID
           AND SEGMENT2 = 'DIGIT_NUMBER';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_DATA_SCALE_NUMBER := NULL;
    END;

    P_PROGRAM_ID := 'DMF0044';
    P_SHEET_NAME := 'MDF Reports';

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    OPEN O_RC1 FOR
    SELECT C.PROGRAM_ID
        , C.SHEET_NAME
        , C.COLUMN_NAME
        , C.COLUMN_LABEL_NAME
        --, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
        , CASE WHEN P_DIVISION_ID = '40' THEN C.SORT_ORDER_NO
               WHEN P_DIVISION_ID like '81%' THEN TO_NUMBER(C.ATTRIBUTE2)
               WHEN P_DIVISION_ID = '82' THEN TO_NUMBER(C.ATTRIBUTE3)
               END AS SORT_ORDER_NO   -- CASE/UNION 타입통일(NUMBER): 원본 MSSQL precedence(int) 동등
        , C.DATA_SORT_METHOD_CODE
        , C.SMALL_CLASS_LABEL_NAME
        , C.LARGE_CLASS_LABEL_NAME
        , '' AS DAY_CODE
        , C.FIXED_FLAG
        , CASE WHEN
                CASE WHEN P_DIVISION_ID = '40' THEN C.VISIBLE_FLAG
                     WHEN P_DIVISION_ID like '81%' THEN C.ATTRIBUTE4
                     WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE5
                     END = 'Y'
                     THEN C.COLUMN_WIDTH
            ELSE 0
            END AS COLUMN_WIDTH
        , C.CELL_CONTROL_OBJECT_TYPE_CODE
        , C.CELL_COMBO_DATA_TYPE
        , C.DATA_SCALE_NUMBER
        , C.DATA_MAX_LENGTH
        , C.HORIZONTAL_ALIGN_CODE
        , C.UPPERCASE_APPLY_FLAG
        , CASE  WHEN P_DIVISION_ID = '40' THEN C.VISIBLE_FLAG
                WHEN P_DIVISION_ID like '81%' THEN C.ATTRIBUTE4
                WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE5
                END AS VISIBLE_FLAG
        , C.DEFAULT_FLAG
        , C.USER_SELECTABLE_FLAG
        , C.VALID_YN
        , C.DIVISION_ID
        , P_DIVISION_ID as ATTRIBUTE1		-- COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
        , CASE WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 ELSE C.ATTRIBUTE1 END AS ATTRIBUTE2
        , C.ATTRIBUTE3
        , C.ATTRIBUTE4
        , C.ATTRIBUTE5
    FROM   SCM_MST_SHEET_COLUMNS C
    WHERE  1 = 1
        AND    C.PROGRAM_ID  = P_PROGRAM_ID
        AND    C.SHEET_NAME  = P_SHEET_NAME
        AND    C.VALID_YN     = 'Y'
        --AND	   C.DIVISION_ID LIKE '%' + P_DIVISION_ID + '%'
        AND	    P_DIVISION_ID IN (SELECT token FROM TABLE(FN_STRING_SPLIT(C.DIVISION_ID ,',')) )
    UNION ALL

    SELECT
        P_PROGRAM_ID   AS PROGRAM_ID
        , P_SHEET_NAME AS SHEET_NAME
        , MA.COLUMN_NAME
        , MA.COLUMN_LABEL_NAME
        , TO_NUMBER(MA.SORT_ORDER_NO)         AS SORT_ORDER_NO   -- UNION 타입통일(NUMBER): 원본 MSSQL 결과타입 보존
        , ''         AS DATA_SORT_METHOD_CODE
        , MA.SMALL_CLASS_LABEL_NAME
        , MA.LARGE_CLASS_LABEL_NAME
        , MA.DAY_CODE
        , ''         AS FIXED_FLAG
        , CASE WHEN V_DATA_SCALE_NUMBER IS NULL THEN 120 ELSE 200 END         AS COLUMN_WIDTH
        , MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
        , ''         AS CELL_COMBO_DATA_TYPE
        --, '2'         AS DATA_SCALE_NUMBER
        , TO_NUMBER(NVL(V_DATA_SCALE_NUMBER, '3'))         AS DATA_SCALE_NUMBER -- 20181029  (UNION 타입통일 NUMBER)
        , 2         AS DATA_MAX_LENGTH
        , 'R'        AS HORIZONTAL_ALIGN_CODE
        , ''        AS UPPERCASE_APPLY_FLAG
        , 'Y'        AS VISIBLE_FLAG
        , ''         AS DEFAULT_FLAG
        , ''     AS USER_SELECTABLE_FLAG
        , ''         AS VALID_YN
        , ''			AS DIVISION_ID
        , '' AS ATTRIBUTE1
        , '' AS ATTRIBUTE2
        , '' AS ATTRIBUTE3
        , '' AS ATTRIBUTE4
        , '' AS ATTRIBUTE5
    FROM  (
        SELECT
            DISTINCT
            'M_'  ||  BASIS_YYYYMM								AS COLUMN_NAME
            , MONTH_NAME										AS COLUMN_LABEL_NAME
            , MONTH_NAME										AS SMALL_CLASS_LABEL_NAME
            , MONTH_NAME										AS LARGE_CLASS_LABEL_NAME
            , ''														AS DAY_CODE
            , BASIS_YYYYMM									AS SORT_ORDER_NO
            , 'FPNumber'											AS CELL_CONTROL_OBJECT_TYPE_CODE
        FROM SCM_SYS_CALENDAR_M
        WHERE  BASIS_YYYYMMDD >= P_START_DT
            AND BASIS_YYYYMMDD <= P_END_DT

    ) MA
    ORDER BY SORT_ORDER_NO;

    /*  ── (참고) 구버전 백업 쿼리 — 원본 주석 보존 ──

	p_program_id := 'DMF0044';
	p_sheet_name := 'MDF Reports';

	SELECT C.PROGRAM_ID
		, C.SHEET_NAME
		, C.COLUMN_NAME
		, C.COLUMN_LABEL_NAME
		, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
		, C.DATA_SORT_METHOD_CODE
		, C.SMALL_CLASS_LABEL_NAME
		, C.LARGE_CLASS_LABEL_NAME
		, '' AS DAY_CODE
		, C.FIXED_FLAG
		, C.COLUMN_WIDTH
		, C.CELL_CONTROL_OBJECT_TYPE_CODE
		, C.CELL_COMBO_DATA_TYPE
		, C.DATA_SCALE_NUMBER
		, C.DATA_MAX_LENGTH
		, C.HORIZONTAL_ALIGN_CODE
		, C.UPPERCASE_APPLY_FLAG
		, C.VISIBLE_FLAG
		, C.DEFAULT_FLAG
		, C.USER_SELECTABLE_FLAG
		, C.VALID_YN
		, C.DIVISION_ID
		, C.ATTRIBUTE1
	FROM   SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
		AND    C.PROGRAM_ID  = p_program_id
		AND    C.SHEET_NAME  = p_sheet_name
		--AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )
		--AND    C.COLUMN_NAME IN ('LAST_UPDATE_DATE', 'LAST_UPDATED_BY')
	UNION ALL

	SELECT
		p_program_id   AS PROGRAM_ID
		, p_sheet_name AS SHEET_NAME
		, MA.COLUMN_NAME
		, MA.COLUMN_LABEL_NAME
		, MA.SORT_ORDER_NO
		, ''         AS DATA_SORT_METHOD_CODE
		, MA.SMALL_CLASS_LABEL_NAME
		, MA.LARGE_CLASS_LABEL_NAME
		, MA.DAY_CODE
		, ''         AS FIXED_FLAG
		, 120         AS COLUMN_WIDTH
		, MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		, ''         AS CELL_COMBO_DATA_TYPE
		--, '2'         AS DATA_SCALE_NUMBER
		, '3'         AS DATA_SCALE_NUMBER -- 20181029
		, '2'         AS DATA_MAX_LENGTH
		, 'R'        AS HORIZONTAL_ALIGN_CODE
		, ''        AS UPPERCASE_APPLY_FLAG
		, 'Y'        AS VISIBLE_FLAG
		, ''         AS DEFAULT_FLAG
		, ''         AS USER_SELECTABLE_FLAG
		, ''         AS VALID_YN
		, ''			AS DIVISION_ID
		, '' AS ATTRIBUTE1
	FROM  (
		SELECT
			DISTINCT
			'M_' || BASIS_YYYYMM								AS COLUMN_NAME
			, MONTH_NAME										AS COLUMN_LABEL_NAME
			, MONTH_NAME										AS SMALL_CLASS_LABEL_NAME
			, MONTH_NAME										AS LARGE_CLASS_LABEL_NAME
			, ''														AS DAY_CODE
			, BASIS_YYYYMM									AS SORT_ORDER_NO
			, 'FPNumber'											AS CELL_CONTROL_OBJECT_TYPE_CODE
		FROM SCM_SYS_CALENDAR_M
		WHERE  BASIS_YYYYMMDD >= p_start_dt
			AND BASIS_YYYYMMDD <= p_end_dt

	) MA
	ORDER BY SORT_ORDER_NO
    */

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_CREATED_BY'  VALUE P_CREATED_BY,
            'P_START_DT'    VALUE P_START_DT,
            'P_END_DT'      VALUE P_END_DT
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
END P_DMF0044_GET_SPREAD_TITLE;


PROCEDURE P_DMF0044_MOBILE_REPORT_CREATE 
(
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_VERSION_TYPE      IN  VARCHAR2,
    P_ACTION_TYPE       IN  VARCHAR2,   -- T:Transfer, C:Cancel
    P_CREATED_BY        IN  VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_MOBILE_REPORT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *========================================================================================================================
 * 2019.05.22	JSYOUN			Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 2019.11.18	hwi1993			파라미터 추가  및 데이터타입 변경, Cancel 기능 추가
 * 2020.05.19	HWI1993			@YYYY 를 버전번호를 잘라서 사용하던 것을 MDF_VERSION 에서 가져오도록 함
 * 2020.05.22	HWI1993			전송시 etc 를 묶는 로직 추가
 * 2020.06.05	HWI1993			BP 로직 제거 ( SP 와 변합 )
 * 2020.09.09   P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020.09.21	HWI1993			[C20200909-000188] [ESS영업관리팀] GDW 용도별 매출 수정 (프로젝트 코드 S 주택용/상업용 분리)
 * 2021.08.16	hwi1993			[C20210811-000341] ETC Report - GDW 전송시 누락 컬럼 점검 요청의 건
 * 2024.05.09	JSSBAE			[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2025.04.04   JSSBAE			[E20250401-000548] SMS 선감지 대상 정리
 * 2025.05.09   JSSBAE			[E20250418-001567]_40사업부 Sales Report, ETC Report 개선
 * 2026.02.09   JSSBAE			[E20260107-001542]_DM_COMPANY 룩업코드 로직 개선
 * 2026/06/05	NextSCM Migration	[PJ202650304] 기존 배포본(미완성 자동변환, INVALID) 재변환. BEGIN TRY/GOTO ERR_RTN 검증→구조화 조기 RETURN, 하위 3 PROC EXEC는 로컬 커서 인자, GETDATE→SYSDATE, ATTRIBUTE2<>''→IS NOT NULL, 로깅(PR_DM_SYS_LOG_BATCH)/EXCEPTION/O_RESULT_CURSOR 표준
 */
IS
    V_PROGRAM_NAME      VARCHAR2(200 CHAR) := 'DMF0044_MOBILE_REPORT_CREATE';
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;

    v_yyyy              VARCHAR2(4 CHAR);
    v_chk               PLS_INTEGER := 0;
    v_dup_msg           VARCHAR2(1000 CHAR);

    l_rc                SYS_REFCURSOR;

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

    PROCEDURE LOG_END IS
    BEGIN
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
        D_EVENT_DATE  := SYSDATE;
        SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY);
    END LOG_END;

BEGIN
    SELECT MAX(SUBSTR(YYYYMMDD, 1, 4)) INTO v_yyyy
    FROM  DM_MDF_VERSION
    WHERE VERSION_NO = P_VERSION_NO;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY);
    V_LOG_MESSAGE := NULL;
    -- 시작 LOG  (END)

    -----------------------------------------------------------------------------------------------------------------------
    -- Validation (BEGIN)  -- 원본 GOTO ERR_RTN → 구조화 조기 RETURN(로그+메시지 커서)
    -----------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_chk FROM SCM_MST_DIVISION WHERE DIVISION_ID = P_DIVISION_ID AND ROWNUM = 1;
    IF v_chk = 0 THEN
        V_LOG_TYPE := 'DIVISION_INVALID'; V_LOG_MESSAGE := 'Division 값이 존재하지 않습니다.'; V_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
        SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY);
        LOG_END;
        OPEN O_RESULT_CURSOR FOR SELECT 'Division 값이 존재하지 않습니다.' AS MSG FROM DUAL;
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_chk FROM DM_MDF_VERSION WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO AND ROWNUM = 1;
    IF v_chk = 0 THEN
        V_LOG_TYPE := 'VERSION_NO_INVALID'; V_LOG_MESSAGE := 'VERSION 값이 존재하지 않습니다.'; V_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
        SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY);
        LOG_END;
        OPEN O_RESULT_CURSOR FOR SELECT 'VERSION 값이 존재하지 않습니다.' AS MSG FROM DUAL;
        RETURN;
    END IF;

    IF P_ACTION_TYPE = 'C' THEN
        SELECT COUNT(*) INTO v_chk FROM DM_MDF_VERSION WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO AND SEND_YN = 'Y' AND ROWNUM = 1;
        IF v_chk = 0 THEN
            V_LOG_TYPE := 'ACTION_TYPE_INVALID_C'; V_LOG_MESSAGE := 'Transfer Cancel은 SendYN 이 Y일 경우만 가능합니다.'; V_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
            SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY);
            LOG_END;
            OPEN O_RESULT_CURSOR FOR SELECT 'Transfer Cancel은 SendYN 이 Y일 경우만 가능합니다.' AS MSG FROM DUAL;
            RETURN;
        END IF;
    END IF;

    IF P_ACTION_TYPE = 'T' THEN
        SELECT COUNT(*) INTO v_chk FROM DM_MDF_VERSION WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO AND SEND_YN IN ('Y','N') AND ROWNUM = 1;
        IF v_chk = 0 THEN
            V_LOG_TYPE := 'ACTION_TYPE_INVALID_T'; V_LOG_MESSAGE := 'Transfer 는 SendYN 이 N일 경우만 가능합니다.'; V_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
            SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY);
            LOG_END;
            OPEN O_RESULT_CURSOR FOR SELECT 'Transfer 는 SendYN 이 N일 경우만 가능합니다.' AS MSG FROM DUAL;
            RETURN;
        END IF;
    END IF;

    SELECT COUNT(1) INTO v_chk FROM DM_PLN_SALES_ETC_REPORT_C
     WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO AND DEPT_NAME IS NULL;
    IF v_chk > 0 THEN
        V_LOG_TYPE := 'DEPT_NAME INVALID'; V_LOG_MESSAGE := 'DEPT_NAME 정보가 존재하지 않아 저장할 수 없습니다.'; V_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
        SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY);
        LOG_END;
        OPEN O_RESULT_CURSOR FOR SELECT 'DEPT_NAME 정보가 존재하지 않아 저장할 수 없습니다.' AS MSG FROM DUAL;
        RETURN;
    END IF;

    SELECT COUNT(1) INTO v_chk FROM DM_PLN_SALES_ETC_REPORT_C
     WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO AND DEPARTMENT_NAME IS NULL;
    IF v_chk > 0 THEN
        V_LOG_TYPE := 'DEPARTMENT_NAME INVALID'; V_LOG_MESSAGE := 'DEPARTMENT_NAME 정보가 존재하지 않아 저장할 수 없습니다.'; V_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
        SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY);
        LOG_END;
        OPEN O_RESULT_CURSOR FOR SELECT 'DEPARTMENT_NAME 정보가 존재하지 않아 저장할 수 없습니다.' AS MSG FROM DUAL;
        RETURN;
    END IF;

    -- [E20250418-001567] 중복 검증 (Report 병합 시 중복 방지)
    SELECT COUNT(*) INTO v_chk FROM (
        SELECT A.VERSION_NO, A.DIVISION_ID, A.DEPARTMENT_ID, A.DEPT_ID, A.ITEM_ID
             , A.MEASURE, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.END_CUST_REPORT
             , A.CUST_REPORT, A.PRODUCT_GROUP, SCM_MGR.FN_GET_COUNTRY_KR_NAME(A.COUNTRY_CODE) AS COUNTRY_KR_NAME
          FROM DM_PLN_SALES_ETC_REPORT_C A
         WHERE A.DIVISION_ID = P_DIVISION_ID AND A.VERSION_NO = P_VERSION_NO
         GROUP BY A.VERSION_NO, A.DIVISION_ID, A.DEPARTMENT_ID, A.DEPT_ID, A.ITEM_ID
                , A.MEASURE, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.END_CUST_REPORT
                , A.CUST_REPORT, A.PRODUCT_GROUP, SCM_MGR.FN_GET_COUNTRY_KR_NAME(A.COUNTRY_CODE)
        HAVING COUNT(*) > 1
    );
    IF v_chk > 0 THEN
        v_dup_msg := 'ETC Report데이터를 Sales Report 데이터와 병합하는 과정에서 중복 데이터가 발생했습니다.' || CHR(10)
                  || 'ETC Report데이터에서 해당 데이터의 정보를 수정하시기 바랍니다.';
        V_LOG_TYPE := 'DUPLICATION VALIDATION'; V_LOG_MESSAGE := v_dup_msg; V_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
        SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY);
        LOG_END;
        OPEN O_RESULT_CURSOR FOR SELECT v_dup_msg AS MSG FROM DUAL;
        RETURN;
    END IF;
    -----------------------------------------------------------------------------------------------------------------------
    -- Validation (END)
    -----------------------------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------------------------
    -- 전송준비 및 매출/사업계획 리포트 데이터 생성 (BEGIN)
    -----------------------------------------------------------------------------------------------------------------------
    -- 발송플래그 업데이트
    UPDATE DM_MDF_VERSION
       SET SEND_YN = CASE WHEN P_ACTION_TYPE = 'T' THEN 'Y' ELSE 'C' END
         , LAST_UPDATED_BY = P_CREATED_BY
         , LAST_UPDATE_DATE = SYSDATE
     WHERE DIVISION_ID = P_DIVISION_ID
       AND VERSION_NO  = P_VERSION_NO;

    IF ( P_DIVISION_ID = '40' ) THEN -- 소형일 때만 적용

        -- 같은 버전이 생성되어 있다면, 삭제 먼저 진행
        DELETE FROM DM_PLN_SALES_PLAN_REPORT_C
        WHERE DIVISION_ID = P_DIVISION_ID
        AND   VERSION_NO = P_VERSION_NO
        AND   DATA_TYPE = '2';

        n_delete_count := SQL%ROWCOUNT;

        -- 데이터 생성 (ETC → SALES_PLAN_REPORT_C, DATA_TYPE='2')
        INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
        , DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
        , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
        , LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
        , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS
        , FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
        , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE
        , COMPANY_NAME, APPLICATION, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
        , CELL_PROD_SITE )
        SELECT '2' AS DATA_TYPE, NVL(DIVISION_ID, '-'), NVL(VERSION_NO, '-'), 'REPORT_SP_W_E' AS CUTOFF_TYPE, CUTOFF_YYYYMMDD, NVL(DEPARTMENT_ID, '-'), NVL(DEPARTMENT_NAME, '-'), NVL(DEPT_ID, '-')
        , NVL(DEPT_NAME, '-'), NVL(END_CUST_REPORT, '-'), NVL(CUST_REPORT, '-'), NVL(PRODUCT_GROUP, '-'), NVL(PROJECT_CODE, '-'), NVL(SCM_SITE_ID, '-'), NVL(ITEM_ID, '-'), DOM_EXP, NVL(FCST_TYPE, '-')
        , NVL(INCOTERMS, '-'), NVL(MEASURE, '-'), NVL(PLANT_SITE_ID, '-'), NVL(YYYYMMDD, '-'), NVL(CURRENCY, '-'), NVL(QTY, 0), CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
        , LAST_UPDATE_DATE, PRODUCT_DETAILS AS ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
        , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, NVL(COMPANY_ID, '-'), SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS
        , FORECAST_INFO_SPEC, NICK_NAME, CASE WHEN ATTRIBUTE2 IS NOT NULL THEN ATTRIBUTE2 ELSE CELL_MODEL_INFO END AS FORECAST_INFO_CELL_MODEL
        , FORECAST_INFO_CELL_PACK_COUNT, BIZ_TYPE AS FORECAST_INFO_BIZ_TYPE
        , COMPANY_NAME, APPLICATION, APPLICATION_GR, SCM_MGR.FN_GET_COUNTRY_KR_NAME(COUNTRY_CODE) AS COUNTRY_KR_NAME, ROUTE
        , '-' AS CELL_PROD_SITE
        FROM DM_PLN_SALES_ETC_REPORT_C
        WHERE DIVISION_ID = P_DIVISION_ID
        AND   VERSION_NO  = P_VERSION_NO;

        n_merge_count := SQL%ROWCOUNT;

        PKG_DMF0044.P_DMF0044_SALES_REPORT_PRODUCT_CREATE(P_DIVISION_ID, P_VERSION_NO, P_ACTION_TYPE, v_yyyy, l_rc);
        PKG_DMF0044.P_DMF0044_SALES_REPORT_DEPT_CREATE(P_DIVISION_ID, P_VERSION_NO, P_ACTION_TYPE, v_yyyy, l_rc);
        PKG_DMF0044.P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE(P_DIVISION_ID, P_VERSION_NO, P_ACTION_TYPE, v_yyyy, l_rc);

    END IF;
    -----------------------------------------------------------------------------------------------------------------------
    -- 전송준비 및 매출/사업계획 리포트 데이터 생성 (END)
    -----------------------------------------------------------------------------------------------------------------------

    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    OPEN O_RESULT_CURSOR FOR SELECT 'success' AS MSG FROM DUAL;

    -- 종료 LOG
    LOG_END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_VERSION_NO'   VALUE P_VERSION_NO,
            'P_VERSION_TYPE' VALUE P_VERSION_TYPE,
            'P_ACTION_TYPE'  VALUE P_ACTION_TYPE,
            'P_CREATED_BY'   VALUE P_CREATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY,
                V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_MOBILE_REPORT_CREATE;


PROCEDURE P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY 
(
    p_division_id          IN  VARCHAR2,
    p_version_no           IN  VARCHAR2,
    p_version_description  IN  VARCHAR2,
    p_created_by           IN  VARCHAR2,
    p_result_date          IN  VARCHAR2,    -- 실적기준일
    p_action_type          IN  VARCHAR2,    -- D:삭제, CR:생성, CP:복사
    p_mv_plan_yyyymm       IN  VARCHAR2,    -- 이동계획 월
    p_update_yn            IN  VARCHAR2,    -- Y일 경우 마스터들을 최신 데이터로 업데이트
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DMF0044_SAVE_SALES_PLAN_VERSION_COPY                                               */
/* Description : MDF REPORT (DM_PLN_SALES_PLAN_C -> DM_PLN_SALES_PLAN_REPORT_C) VERSION COPY        */
/* History     : 2019/05/22 KHSONG Initial [PJ20189106] ~ 2020/12/08 P.C.I (원본 이력 보존)         */
/*               2026.06.08 변환 [PJ20264226] NextSCM Pilot 재변환(깨진 자동변환 정정:               */
/*               선언부 구조역전/NCHAR/인라인DECLARE/GOTO->예외/ISNUMERIC/ISDATE/NOLOCK/SELECT대입)   */
/****************************************************************************************************/
IS
    v_program_name VARCHAR2(150 CHAR) := 'DMF0044_SAVE_SALES_PLAN_VERSION_COPY';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_merge_count INTEGER := 0;
    v_version_type VARCHAR2(50 CHAR);
    v_Ori_Version VARCHAR2(30 CHAR);
    v_cp_VERSION_NO VARCHAR2(30 CHAR);
    v_cp_CUTOFF_TYPE VARCHAR2(20 CHAR);
    v_cp_CUTOFF_YYYYMMDD VARCHAR2(8 CHAR);
    V_RESULT_YEAR_CNT VARCHAR2(1 CHAR);
    V_MAX_ETC_RESULT_VERSION_NO VARCHAR2(30 CHAR);
    V_ETC_RESULT_MONTH VARCHAR2(6 CHAR);
    V_MAX_DATA_SEQ INTEGER;
    c_ER_version VARCHAR2(100 CHAR);
    v_plan_start_yyyymmdd VARCHAR2(08 CHAR);
    c_cutoff_yyyymmdd VARCHAR2(08 CHAR);
    v_ETC_DEPARTMENT_ID VARCHAR2(30 CHAR);
    v_ETC_DEPARTMENT_NAME VARCHAR2(100 CHAR);
    v_rp_version VARCHAR2(2 CHAR);
    V_RPT_SEQ INTEGER;
    v_version_x VARCHAR2(50 CHAR);
    V_VERSION_NO_VMI VARCHAR2(50 CHAR);
    V_MON_CNT INTEGER;
    v_cnt_1  INTEGER := 0;

    -- [재변환] 흩어진 인라인 선언 통합 (BEGIN 뒤 선언 구조역전 해소, NCHAR->VARCHAR2)
    d_Result_Date         VARCHAR2(8 CHAR);  -- 실적구간 판단 기준일자
    v_err_mv_version_no   VARCHAR2(30 CHAR); -- 기 존재하는 이동계획버전
    v_cp_MIN_YYYYMMDD     VARCHAR2(8 CHAR);  -- 해당 버전 시작일자(실적 복사 시작점)
    V_VERSION_DATE        VARCHAR2(8 CHAR);
    V_NEW_VERSION_NO      VARCHAR2(50 CHAR);
    V_ORI_CUTOFF_VERSION  VARCHAR2(50 CHAR);
    V_SP_BP               VARCHAR2(2 CHAR);
    V_ETC_CUTOFF_TYPE     VARCHAR2(20 CHAR);
    V_ETC_CUTOFF_YYYYMMDD VARCHAR2(8 CHAR);

    -- [재변환] 검증실패 처리용 (GOTO ERR_RTN 대체)
    e_validation   EXCEPTION;
    v_result_msg   VARCHAR2(4000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 이관 대응)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        v_program_name := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    v_log_message := NULL;

    -- 실적 시작년수 룩업 (없으면 NULL 유지)
    BEGIN
        SELECT ATTRIBUTE1 INTO V_RESULT_YEAR_CNT
        FROM SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE LOOKUP_TYPE = 'SALES_REPORT_SETTING'
            AND segment1 = 'Result_Start_Year_Cnt'
            AND segment2 = p_division_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_RESULT_YEAR_CNT := NULL;
    END;

    IF REGEXP_LIKE(V_RESULT_YEAR_CNT, '^[+-]?[0-9]+(\.[0-9]+)?$') THEN
        v_cp_MIN_YYYYMMDD := TO_CHAR(ADD_MONTHS(SYSDATE, (-1 * V_RESULT_YEAR_CNT)*12), 'YYYYMMDD') || '0101';
    END IF;


	-- 버전 유형 확인
	SELECT MAX(VERSION_TYPE)
  INTO v_version_type
	FROM DM_MDF_VERSION
	WHERE DIVISION_ID = p_division_id
		AND VERSION_NO = p_version_no;

	IF v_version_type IS NULL THEN
		SELECT MAX(VERSION_TYPE)
		  INTO v_version_type
		FROM DM_MST_VERSION
		WHERE DIVISION_ID = p_division_id
			AND VERSION_NO = p_version_no;
	END IF;

	-- PJ202001380 Future Price Version_No 구분
	/*



	-- 변수값 셋팅
	-- ----------------------------------------------------------------------------------------------------------------------------------------
	-- Weekly Cutoff 환율 Version No 조회 (40,81 : 화요일 /82 : SP Version과 동일)
	IF v_version_type NOT LIKE 'REPORT%' AND p_division_id IN ('40', '81') AND  SUBSTR(p_version_no, 1, 4) = 'SP_W' THEN
			c_cutoff_yyyymmdd := SUBSTR(p_version_no,6,8);
			v_plan_start_yyyymmdd := TO_CHAR(FN_NEXT_DAY(c_cutoff_yyyymmdd, 'MON') + (-7), 'YYYYMMDD');   -- 월요일
			SELECT NVL(MAX(VERSION_NO), p_version_no)
			  INTO c_ER_version
			FROM   DM_MST_VERSION
			WHERE  DIVISION_ID  = p_division_id
			and    yyyymmdd    >= v_plan_start_yyyymmdd
			and    yyyymmdd    <= c_cutoff_yyyymmdd
			and    version_type = 'SP_W'
			and    CREATED_BY   = 'WITHOUT_SP_W';
	ELSE
			c_ER_version := p_version_no;
	END IF;

	-- ----------------------------------------------------------------------------------------------------------------------------------------
	*/

	-- 시작 LOG  (START)
	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_DM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_created_by);
	v_log_message := NULL      ;  /* -- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)

	-- ------------------------------------------------------------------------------------------------------------------------
    -- (BEGIN TRY) 메인 BEGIN/EXCEPTION 블록으로 통합
	-- ------------------------------------------------------------------------------------------------------------------------
		-- Div 에 관계없이 여기에 넣고, 나중에 집계하면서 Div 별 처리한다.
		DELETE FROM GT_DMF0_VERSION_COPY;

		DELETE FROM GT_DMF0_REPORT;

		DELETE FROM GT_DMF0_MEASURE;

	--[E20230906-001160]_DM SINGLE VIEW 수정
	/* TODO:GTT:GT_DMF0044_ITEM_SINGLE_V-->GT_DMF0044_ITEM_SINGLE_V */
	INSERT INTO GT_DMF0044_ITEM_SINGLE_V
	SELECT DISTINCT ITEM_ID,ITEM_CLASS_NAME
			, CASE WHEN REGEXP_LIKE(ENERGE, '^[+-]?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(ENERGE) ELSE 0 END AS ENERGY
			, CASE WHEN REGEXP_LIKE(CELL_QUANTITY, '^[+-]?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(CELL_QUANTITY) ELSE 0 END AS CELL_QUANTITY
			, FORECAST_INFO_BIZ_TYPE	-- 소형 BIZ_TYPE ( 부자재 매출 제거에 사용 )
			, FORECAST_INFO_SPEC, NICK_NAME,FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
	FROM (
			SELECT	T1.DIVISION_ID, T1.ITEM_ID
				  , MAX(T1.ITEM_CLASS_NAME)						AS ITEM_CLASS_NAME			--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
				  , MAX(T1.ENERGE)  							AS ENERGE
				  , MAX(T1.CELL_QUANTITY)						AS CELL_QUANTITY
				  , MAX(T2.FORECAST_INFO_BIZ_TYPE)				AS FORECAST_INFO_BIZ_TYPE
				  , MAX(T2.FORECAST_INFO_SPEC)					AS FORECAST_INFO_SPEC
				  , MAX(T1.NICK_NAME)							AS NICK_NAME				--닉네임이 NULL인 경우가 있으므로 하나로 통일
				  , MAX(T2.FORECAST_INFO_CELL_MODEL)			AS FORECAST_INFO_CELL_MODEL
				  , MAX(T2.FORECAST_INFO_CELL_PACK_COUNT)		AS FORECAST_INFO_CELL_PACK_COUNT
			FROM SCM_MST_ITEM_SN T1
			INNER JOIN ( SELECT DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
							, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
							, MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
							, MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
							, MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
						 FROM  SCM_MST_ITEM_SN T2
					 WHERE	DIVISION_ID =  p_division_id
						 GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
					   ) T2
					ON T1.DIVISION_ID = T2.DIVISION_ID
				   AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
			WHERE 1=1
			AND		T1.DIVISION_ID = p_division_id
			GROUP BY T1.DIVISION_ID, T1.ITEM_ID
			) G;


	-- --------------------------------------------------------------------------------------
	--                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)
	-- --------------------------------------------------------------------------------------
	/* (MSSQL CLUSTERED INDEX 제거 — Oracle GTT는 별도 인덱스 불필요) */
	-- ---------------------------------------------------------------------------------------
	--                      20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)
	-- ---------------------------------------------------------------------------------------
	-- ---------------------------------------------------------------------------------------
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
	-- ---------------------------------------------------------------------------------------
	/* TODO:GTT:GT_DMF0_SCM_MST_SITE_ITEM-->GT_DMF0_SCM_MST_SITE_ITEM */
	INSERT INTO GT_DMF0_SCM_MST_SITE_ITEM
	SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
		, CASE WHEN REGEXP_LIKE(CELL_PER_CAR, '^[+-]?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(CELL_PER_CAR) ELSE 0 END AS CELL_PER_CAR
		, CASE WHEN REGEXP_LIKE(CELL_PER_MODULE, '^[+-]?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(CELL_PER_MODULE) ELSE 0 END AS CELL_PER_MODULE
		--, CURRENCY, LIABILITY_PERIOD
		--, SALES_PLAN_ADJUST_YN, ITEM_HRCY_ID, VALID_YN, BPMS_EXIST, CUST_GROUP, CUST_GROUP_DTL, OWNER, APPLICATION
		--, ROUTE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
		--, ATTRIBUTE9, ATTRIBUTE10, REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5, REPORT_GROUP6
		--, REPORT_GROUP7, REPORT_GROUP8, OS_CORP, CONTRIBUTION_TYPE, EDI_LT, SCP_VMI_LT
		--, FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'EN' )		     AS OWNER_NAME
		--, FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'KO' )		     AS OWNER_NAME_KO
		--,(	SELECT SU.DEPT_ID
		--	FROM SCM_MST_SSO_USER_INFO SU
		--	WHERE SU.USER_ID = (SELECTtoken FROM TABLE(fn_string_split(SMSI.owner, ','))) ) DEPT_ID
	FROM SCM_MST_SITE_ITEM SMSI
	WHERE SMSI.Division_id = p_division_id;

		-- 실적 기준일 지정
		IF p_action_type = 'CR' THEN
			BEGIN
				SELECT TO_CHAR(FN_NEXT_DAY(TO_DATE(YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
				  INTO d_Result_Date
				FROM DM_MST_VERSION
				WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;
			EXCEPTION WHEN NO_DATA_FOUND THEN d_Result_Date := NULL;
			END;
		ELSIF p_action_type = 'CP' THEN
			d_Result_Date := REPLACE(p_result_date, '-', '');   -- 미입력 시 NULL
			-- 말일자이면 해당월(YYYYMM), 아니면 직전월
			IF d_Result_Date IS NOT NULL THEN
				V_ETC_RESULT_MONTH := CASE WHEN d_Result_Date = TO_CHAR(LAST_DAY(TO_DATE(d_Result_Date,'YYYYMMDD')),'YYYYMMDD')
									THEN SUBSTR(d_Result_Date, 1, 6)
									ELSE TO_CHAR(ADD_MONTHS(TO_DATE(d_Result_Date,'YYYYMMDD'), -1), 'YYYYMM')
								END;
			END IF;
		END IF;

		IF NOT VALIDATE_CONVERSION(NVL(V_ETC_RESULT_MONTH,'x')||'01' AS DATE,'YYYYMMDD') = 1 THEN
			V_ETC_RESULT_MONTH := TO_CHAR(SYSDATE, 'YYYYMM');
		END IF;

		-- ------------------------------------------------------------------
		--                       Validation (BEGIN)
		-- ------------------------------------------------------------------
		-- DIVISION 유효성
		SELECT COUNT(*) INTO v_cnt_1 FROM SCM_MST_DIVISION WHERE DIVISION_ID = p_division_id;
		IF v_cnt_1 = 0 THEN v_log_type := 'DIVISION_INVALID'; RAISE e_validation; END IF;

		-- 기능과 버전 불일치 (CP,D)
		IF p_action_type IN ('CP','D') THEN
			SELECT COUNT(*) INTO v_cnt_1 FROM DM_MDF_VERSION WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;
			IF v_cnt_1 = 0 THEN v_log_type := 'VERSION_NO_INVALID'; RAISE e_validation; END IF;
		END IF;

		IF p_action_type = 'CR' THEN
			SELECT COUNT(*) INTO v_cnt_1 FROM DM_MST_VERSION WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;
			IF v_cnt_1 = 0 THEN v_log_type := 'VERSION_NO_INVALID'; RAISE e_validation; END IF;
		END IF;

		-- 삭제인데 SEND_YN='Y'
		IF p_action_type = 'D' THEN
			SELECT COUNT(*) INTO v_cnt_1 FROM DM_MDF_VERSION WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no AND SEND_YN = 'Y';
			IF v_cnt_1 > 0 THEN v_log_type := 'VERSION_NO_INVALID'; RAISE e_validation; END IF;
		END IF;

		-- 이동계획 중복 (D)
		IF VALIDATE_CONVERSION(p_mv_plan_yyyymm||'01' AS DATE,'YYYYMMDD') = 1 AND p_action_type = 'D' THEN
			SELECT COUNT(*) INTO v_cnt_1 FROM DM_MDF_VERSION
			WHERE SEND_YN <> 'D' AND MV_PLAN_YYYYMM = p_mv_plan_yyyymm AND DIVISION_ID = p_division_id;
			IF v_cnt_1 > 0 THEN
				SELECT MAX(VERSION_NO) INTO v_err_mv_version_no FROM DM_MDF_VERSION
				WHERE SEND_YN <> 'D' AND MV_PLAN_YYYYMM = p_mv_plan_yyyymm AND DIVISION_ID = p_division_id;
				IF v_err_mv_version_no IS NOT NULL THEN
					v_log_type := '이동계획 중복';
					v_description := '이미 해당월의 이동계획이 있습니다.[' || RTRIM(v_err_mv_version_no) || ']';
					RAISE e_validation;
				END IF;
			END IF;
		END IF;

		-- 1~3 담당 외에는 기타로 묶기 위애서 기타 부서코드를 찾는다.

		SELECT SEGMENT1, SEGMENT2
		  INTO V_ETC_DEPARTMENT_ID, v_ETC_DEPARTMENT_NAME
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
		WHERE A.LOOKUP_TYPE = 'MDF_DEPARTMENT'
			AND A.SEGMENT3 = 'Y'
			AND A.ATTRIBUTE1 = 'Y';


		-- --------------------------------------------------------------------------------------------------
		--										   Validation (END)
		-- --------------------------------------------------------------------------------------------------
		-- --------------------------------------------------------------------------------------------------
		--						     MDF VERSION MST INSERT (BEGIN)
		-- --------------------------------------------------------------------------------------------------
		V_VERSION_DATE := TO_CHAR(SYSDATE, 'YYYYMMDD'); -- 채번 기준일자

		--[PJ2024-50611] Sales Report 생성 시 Catcu_Up 수량 더해줌 START
		--CATCH_UP 메저를 가진 데이터셋 생성
		/* TODO:GTT:GT_DMF0_PLAN_C_CATCHUP-->GT_DMF0_PLAN_C_CATCHUP */
		INSERT INTO GT_DMF0_PLAN_C_CATCHUP
		SELECT *
		FROM
		(
			SELECT
				A.DIVISION_ID
				,A.VERSION_NO
				, 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE
				,A.CUTOFF_YYYYMMDD
				,A.PROJECT_CODE
				,A.SCM_SITE_ID
				,A.ITEM_ID
				,A.DOM_EXP
				,A.FCST_TYPE
				,A.INCOTERMS
				,A.CURRENCY
				,A.MEASURE AS ORG_MEASURE
				,CASE WHEN A.MEASURE = 'Catch_Up' THEN 'RTF_SYS_RP'
					  WHEN A.MEASURE = 'SalesAmt_KRW_Catch_Up' THEN 'SalesAmt_KRW'
					  WHEN A.MEASURE = 'SalesAmt_LOC_Catch_Up' THEN 'SalesAmt_LOC'
					  WHEN A.MEASURE = 'SalesAmt_USD_Catch_Up' THEN 'SalesAmt_USD'
				 END AS MEASURE -- RTF_ALLOCATION 과 매핑을 위한 MEASURE로 변경
				 ,A.PLANT_SITE_ID
				,A.YYYYMMDD
				,A.QTY
				,B.SALES_COMPANY AS COMPANY_ID
				,B.ATTRIBUTE1 AS SOLDTO_CUST_REPORT
				--,'' AS CELL_PROD_SITE
				,'-' AS CELL_PROD_SITE--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
				--FROM DM_PLN_SALES_PLAN_C A
				FROM DM_PLN_SALES_ETC_PLAN_C A --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
				JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
				WHERE A.VERSION_NO = p_version_no
				AND A.DIVISION_ID = p_division_id
				AND A.YYYYMMDD >= d_Result_Date
				AND A.MEASURE IN (
					SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
					WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
					AND SEGMENT1 = p_division_id
					AND VALID_YN = 'Y'
				)
				UNION ALL
				SELECT
				A.DIVISION_ID
				,A.VERSION_NO
				, 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE
				,A.CUTOFF_YYYYMMDD
				,A.PROJECT_CODE
				,A.SCM_SITE_ID
				,A.ITEM_ID
				,A.DOM_EXP
				,A.FCST_TYPE
				,A.INCOTERMS
				,A.CURRENCY
				,A.MEASURE AS ORG_MEASURE
				,CASE WHEN A.MEASURE = 'Catch_Up' THEN 'MKT_FCST'
				 END AS MEASURE -- RTF_ALLOCATION 과 매핑을 위한 MEASURE로 변경
				 ,A.PLANT_SITE_ID
				,A.YYYYMMDD
				,A.QTY
				,B.SALES_COMPANY AS COMPANY_ID
				,B.ATTRIBUTE1 AS SOLDTO_CUST_REPORT
				--,'' AS CELL_PROD_SITE
				--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
				,'-' AS CELL_PROD_SITE
				--FROM DM_PLN_SALES_PLAN_C A
				FROM DM_PLN_SALES_ETC_PLAN_C A --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
				JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
				WHERE A.VERSION_NO = p_version_no
				AND A.DIVISION_ID = p_division_id
				AND A.YYYYMMDD >= d_Result_Date
				AND A.MEASURE = 'Catch_Up'
				AND A.cutoff_type = 'SP_W'
			) A;
		--[PJ2024-50611] Sales Report 생성 시 Catcu_Up 수량 더해줌 END


		-- 버전처리
		-- 버전처리 (생성)
		IF p_action_type = 'CR' THEN
			SELECT NVL(MAX(VER_CRE_SEQ),0) + 1
			  INTO V_RPT_SEQ
			FROM DM_MDF_VERSION
			WHERE DIVISION_ID = p_division_id
				AND TO_CHAR(CREATION_DATE, 'YYYYMMDD') = V_VERSION_DATE;

			-- [C20201014-000098] SP_M추가 ( LIKE '%SP_W' -> LIKE '%SP%' )
			SELECT CASE WHEN VERSION_TYPE LIKE '%SP%' THEN 'SP' ELSE 'BP' END
			  INTO V_SP_BP
			FROM DM_MST_VERSION
			WHERE DIVISION_ID = p_division_id AND VERSION_NO = P_VERSION_NO;

			-- 최종 버전 셋팅
			V_NEW_VERSION_NO := CASE WHEN VALIDATE_CONVERSION(p_mv_plan_yyyymm||'01' AS DATE,'YYYYMMDD') = 1 THEN 'RP_' ELSE 'R_' END
				|| SUBSTR(V_SP_BP, 1, 1) || '_' || V_VERSION_DATE || '_V'
				|| LPAD(TO_CHAR(V_RPT_SEQ), 3, '0');

			INSERT INTO DM_MDF_VERSION (
				DIVISION_ID,VERSION_NO,VERSION_DESCRIPTION,VERSION_TYPE,SEND_YN,YYYYMMDD,VER_CRE_SEQ,ORI_VERSION_NO, ORI_CUTOFF_VERSION_NO, MV_PLAN_YYYYMM
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)
			SELECT p_division_id, V_NEW_VERSION_NO, p_version_description
				, 'REPORT_'||(CASE WHEN VERSION_TYPE = 'SP_M' THEN 'SP_W' ELSE VERSION_TYPE END)
				,'N', YYYYMMDD, V_RPT_SEQ, VERSION_NO, VERSION_NO, p_mv_plan_yyyymm
				,p_created_by,SYSDATE,p_created_by,SYSDATE,'CR',NULL,NULL,NULL,NULL
			FROM DM_MST_VERSION
			WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;

			--[PJ20200138] 환율 정보 copy
			IF V_SP_BP = 'SP' THEN
				INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C (
					DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
				SELECT DIVISION_ID, V_NEW_VERSION_NO
					, 'REPORT_'||(CASE WHEN CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE CUTOFF_TYPE END)
					, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, p_created_by, SYSDATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM DM_MST_EXCHANGE_RATE_C
				WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;
			ELSE
				INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C (
					DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
				SELECT DIVISION_ID, V_NEW_VERSION_NO
					, 'REPORT_'||CUTOFF_TYPE
					, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, p_created_by, SYSDATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM DM_BP_EXCHANGE_RATE_C
				WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;
			END IF;
		END IF;

		-- 버전처리 (복사)
		IF p_action_type = 'CP' THEN
			SELECT NVL(MAX(VER_CRE_SEQ),0) + 1 INTO V_RPT_SEQ
			FROM DM_MDF_VERSION
			WHERE DIVISION_ID = p_division_id AND TO_CHAR(CREATION_DATE,'YYYYMMDD') = V_VERSION_DATE;

			SELECT CASE WHEN VERSION_TYPE LIKE '%SP%' THEN 'SP' ELSE 'BP' END INTO V_SP_BP
			FROM DM_MDF_VERSION
			WHERE DIVISION_ID = p_division_id AND VERSION_NO = P_VERSION_NO;

			V_NEW_VERSION_NO := CASE WHEN VALIDATE_CONVERSION(p_mv_plan_yyyymm||'01' AS DATE,'YYYYMMDD') = 1 THEN 'RP_' ELSE 'R_' END
				|| SUBSTR(V_SP_BP,1,1) || '_' || V_VERSION_DATE || '_V'
				|| LPAD(TO_CHAR(V_RPT_SEQ),3,'0') || '_C';

			INSERT INTO DM_MDF_VERSION
				(DIVISION_ID,VERSION_NO,VERSION_DESCRIPTION,VERSION_TYPE,SEND_YN,YYYYMMDD,VER_CRE_SEQ,ORI_VERSION_NO,ORI_CUTOFF_VERSION_NO, ETC_RESULT_MONTH, MV_PLAN_YYYYMM
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)
			SELECT p_division_id, V_NEW_VERSION_NO, p_version_description, VERSION_TYPE, 'N', YYYYMMDD
				, V_RPT_SEQ, P_VERSION_NO, ORI_CUTOFF_VERSION_NO, V_ETC_RESULT_MONTH, p_mv_plan_yyyymm
				, p_created_by, SYSDATE, p_created_by, SYSDATE, 'CP', p_result_date, NULL, NULL, NULL
			FROM DM_MDF_VERSION
			WHERE DIVISION_ID = p_division_id AND VERSION_NO = P_VERSION_NO;

			--[PJ20200138] 환율 정보 copy (기존 REPORT 환율을 신버전으로 복사; 원본 SP/ELSE 동일 로직)
			INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
				, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
			SELECT DIVISION_ID, V_NEW_VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, p_created_by, SYSDATE
				, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			FROM DM_PLN_SALES_REPORT_EXCHANGE_C
			WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;
		END IF;

		-- 삭제
		IF p_action_type = 'D' THEN
			UPDATE DM_MDF_VERSION SET SEND_YN = 'D'
			WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;

			DELETE FROM DM_PLN_SALES_PLAN_REPORT_C WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;
			DELETE FROM DM_PLN_BP_FCST_REPORT_C   WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;
			DELETE FROM DM_PLN_SALES_REPORT_EXCHANGE_C WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;
		END IF;


		INSERT INTO GT_DMF0_MEASURE ( PLAN_RESULT, I_MEASURE, O_MEASURE, CALC_YN, QTY_AMT, SRC_TABLE )
		SELECT SEGMENT3, SEGMENT4, SEGMENT5
			, CASE WHEN SEGMENT4 <> SEGMENT5 AND ATTRIBUTE2 IS NOT NULL THEN 'Y' ELSE '' END, ATTRIBUTE2, ATTRIBUTE1
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		WHERE LOOKUP_TYPE = 'DM_SALES_REPORT_' || p_action_type
			AND SEGMENT1 = P_DIVISION_ID
			AND SEGMENT2 = V_SP_BP;

	--SELECT P_DIVISION_ID , P_ACTION_TYPE, V_SP_BP

--SELECT 'X', 0
		-- --------------------------------------------------------------------------------------------------
		--                                                                        요청VERSION COPY (BEGIN)
		-- --------------------------------------------------------------------------------------------------
		IF p_action_type IN ( 'CR', 'CP' ) THEN

			IF p_action_type = 'CR' THEN

				-- [C20210315-000347]
				SELECT VERSION_TYPE,
    YYYYMMDD
  INTO v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD
				FROM DM_MDF_VERSION
				WHERE DIVISION_ID = p_division_id
					AND VERSION_NO = V_NEW_VERSION_NO;

				/* 20190916, SCM_SITE_ID 가 NULL 인 데이터는 제외한다. */
				IF V_SP_BP = 'SP' THEN
					INSERT INTO GT_DMF0_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
							,DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
							,CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT A.DIVISION_ID, A.VERSION_NO
					        , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
							, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, SUM(A.QTY) AS QTY
							, B.SALES_COMPANY AS COMPANY_ID
							, B.ATTRIBUTE1
							--, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE
					FROM DM_PLN_SALES_PLAN_C A
					JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = ''
					WHERE	A.VERSION_NO = p_version_no
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD >= d_Result_Date -- 미래구간
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
						AND A.FCST_TYPE <> 'ETC'--[PJ2024-50611] Sales Report 생성 시 ETC 제외
						--마이그레이션 된 데이터 지우면 조건삭제
						AND A.MEASURE NOT IN
						(
							SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
							WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
							AND VALID_YN = 'Y'
						)
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
						, B.SALES_COMPANY, B.ATTRIBUTE1
						, A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
					--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 START
					UNION ALL
					SELECT A.DIVISION_ID, A.VERSION_NO
					        , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
							, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, SUM(A.QTY) AS QTY
							, B.SALES_COMPANY AS COMPANY_ID
							, B.ATTRIBUTE1
							--, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, '-' AS CELL_PROD_SITE
					FROM DM_PLN_SALES_ETC_PLAN_C A
					JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = ''
					WHERE	A.VERSION_NO = p_version_no
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD >= d_Result_Date -- 미래구간
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
						AND A.FCST_TYPE <> 'ETC'--[PJ2024-50611] Sales Report 생성 시 ETC 제외
						AND A.MEASURE IN
						(
							SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
							WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
							AND VALID_YN = 'Y'
						)
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
						, B.SALES_COMPANY, B.ATTRIBUTE1
					--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 END
					-- ------
					UNION ALL
					-- ------
					SELECT A.DIVISION_ID, A.VERSION_NO
					     , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
						 , A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						 , CASE WHEN( NVL(A.CURRENCY, '-') = '-' ) THEN ''   -- [C20210315-000347]
														ELSE NVL(A.CURRENCY, NULL) END
														AS CURRENCY

						 , M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
						 , A.COMPANY_ID
						 , B.ATTRIBUTE1
						 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						 --, '-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
						 , A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM DM_PLN_SALES_PLAN_RESULT_C A
					JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'RESULT' AND M.CALC_YN = '' AND M.SRC_TABLE = 'DM_PLN_SALES_PLAN_RESULT_C'
					WHERE	A.VERSION_NO = p_version_no
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD < d_Result_Date   -- 과거실적구간으로 추출
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID
						, A.COMPANY_ID, B.ATTRIBUTE1
						, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					-- ------
					UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다.
					-- ------
					SELECT A.DIVISION_ID, A.VERSION_NO
					     , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
						 , A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, 'SalesAmt_USD' AS Measure ,A.PLANT_SITE_ID, A.YYYYMMDD
						 , SUM(CASE	WHEN NVL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
										ELSE A.QTY/NVL(FP.EXCHANGE_PRICE,0)
										END) AS QTY
						 , A.COMPANY_ID, B.ATTRIBUTE1
						 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
						 , A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM DM_PLN_SALES_PLAN_RESULT_C A
					JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					LEFT OUTER JOIN DM_PLN_SALES_REPORT_EXCHANGE_C FP
							 ON A.DIVISION_ID = FP.DIVISION_ID AND SUBSTR(A.YYYYMMDD,1,6) || '01' = FP.YYYYMMDD AND FP.UNIT_CURRENCY = 'USD'  AND FP.VERSION_NO = V_NEW_VERSION_NO
					WHERE	A.VERSION_NO = p_version_no
						AND A.MEASURE IN ('SalesAmt_KRW')
						AND A.CURRENCY <> 'USD'
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD < d_Result_Date   -- 과거실적구간으로 추출
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
						, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					-- ------
					UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다. ( LOC = USD 인 경우 )
					-- ------
					SELECT A.DIVISION_ID, A.VERSION_NO
					     , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
						 , A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, 'SalesAmt_USD' AS Measure ,A.PLANT_SITE_ID, A.YYYYMMDD
						 ,SUM(A.QTY) AS QTY
						, A.COMPANY_ID, B.ATTRIBUTE1
						--, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						--,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
						 , A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM DM_PLN_SALES_PLAN_RESULT_C A
					JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					WHERE	A.VERSION_NO = p_version_no
						AND A.MEASURE IN ('SalesAmt_LOC')
						AND A.CURRENCY = 'USD'
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD < d_Result_Date   -- 과거실적구간으로 추출
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
						, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					--Start [C20201014-000094] 82 사업부 비물동 구분코드 추가
					-- ------
					UNION ALL
					-- ------
					SELECT A.DIVISION_ID, A.VERSION_NO
					        , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
							, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, SUM(A.QTY) AS QTY
							, B.SALES_COMPANY AS COMPANY_ID
							, B.ATTRIBUTE1
							--, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
					FROM DM_PLN_SALES_PLAN_C A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = ''
					WHERE	A.VERSION_NO  = p_version_no
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD   >= d_Result_Date -- 미래구간
						AND D.COMPANY_ID IS NULL
						AND A.DIVISION_ID = '82'
						AND NVL(A.QTY,0) <> 0
						AND A.FCST_TYPE <> 'ETC'--[PJ2024-50611] Sales Report 생성 시 ETC 제외
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, B.SALES_COMPANY
						, B.ATTRIBUTE1
						, A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
					-- ------
					UNION ALL
					-- ------
					SELECT A.DIVISION_ID, A.VERSION_NO
					     , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
						 , A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
						 , A.COMPANY_ID, B.ATTRIBUTE1
						 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
						 , A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM DM_PLN_SALES_PLAN_RESULT_C A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'RESULT' AND M.CALC_YN = '' AND M.SRC_TABLE = 'DM_PLN_SALES_PLAN_RESULT_C'
					WHERE	A.VERSION_NO  = p_version_no
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD    < d_Result_Date   -- 과거실적구간으로 추출
						--AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
						AND A.DIVISION_ID = '82'
						AND NVL(A.QTY,0) <> 0
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID
						, A.COMPANY_ID, B.ATTRIBUTE1
						, A.CELL_PROD_SITE_ID;			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					--End [C20201014-000094] 82 사업부 비물동 구분코드 추가

					-- 소형 처리( 무상건 제외 )
					-- [C20210315-000140]
					IF p_division_id = '40' THEN
						DELETE FROM GT_DMF0_VERSION_COPY A
						WHERE EXISTS (
							SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
							WHERE A.FCST_TYPE = B.SEGMENT1 AND B.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND B.SEGMENT4 = 'FREE'
						);
					END IF;

					-- RTF_SCP 처리
					IF p_division_id like '81%' THEN
						INSERT INTO GT_DMF0_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
								, DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
							    , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT A.DIVISION_ID, A.VERSION_NO, 'REPORT_SP_W' as Cutoff_Type, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
								, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, '' AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
								, SUM(A.QTY) AS QTY
								, E.COMPANY_ID AS COMPANY_ID, B.ATTRIBUTE1
								--, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
								--, '-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
								, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_MKT_FCST_RESULT_C A
						JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
						JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = '' AND M.SRC_TABLE = 'DM_PLN_MKT_FCST_RESULT_C'
						WHERE	A.VERSION_NO = 'MF_'  ||  SUBSTR(p_version_no,4,15)
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD < d_Result_Date   -- 과거실적구간으로 추출
							AND A.YYYYMMDD >= v_cp_MIN_YYYYMMDD
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, E.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID;			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					END IF;
					-- [C20210315-000347]
					IF p_division_id = '40' THEN

						-- SP 버전은 v002 등으로 재생성하더라도 보통 mf_w 는 v001 로 그대로 있으므로 끝자리는 고정한다.
						V_VERSION_NO_VMI := 'MF_W_' || TO_CHAR(FN_NEXT_DAY(SUBSTR(p_version_no,6,8), 'MON') + (-6), 'YYYYMMDD')  -- 당주 월요일 이후인건만 추출
												 || '_V001';

						INSERT INTO GT_DMF0_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
							, DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
							, CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT A.DIVISION_ID, A.VERSION_NO
								, v_cp_CUTOFF_TYPE  , v_cp_CUTOFF_YYYYMMDD --	, 'REPORT_SP_W' as Cutoff_Type , A.CUTOFF_YYYYMMDD
								, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
								, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, '' AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
								, SUM(A.QTY) AS QTY
								,'' AS COMPANY_ID  --, E.COMPANY_ID AS COMPANY_ID
								, B.ATTRIBUTE1
								--, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
								, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE
						--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
						--FROM DM_PLN_MKT_FCST_C A
						FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
						JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
						JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = '' AND M.SRC_TABLE = 'DM_PLN_MKT_FCST_C'
						WHERE	A.VERSION_NO = V_VERSION_NO_VMI
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD >= d_Result_Date   -- 미래구간
							AND MEASURE IN ('VMI_In_Plan', 'VMI_In_Req')
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, E.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID; --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경

						-- MKT FCST 테이블에서 데이터를 가져오면 Currency 및 Company_id 가 없어서 업데이트 해준다.
						-- 여기에서 하고 최종 INSERT INTO 전에 한 번 더 해준다.
						-- (MSSQL UPDATE...FROM...JOIN → Oracle MERGE. ON절 갱신컬럼 ORA-38104 회피 위해 필터는 WHEN MATCHED WHERE 로)
						MERGE INTO GT_DMF0_VERSION_COPY A
						USING ( SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM
									, MAX(CURRENCY) AS CURRENCY
								FROM DM_PLN_SALES_PLAN_C A
								WHERE A.VERSION_NO = p_version_no
									AND A.DIVISION_ID = p_division_id
									AND A.YYYYMMDD >= d_Result_Date -- 미래구간
								GROUP BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, SUBSTR(YYYYMMDD, 1, 6)
							) B ON ( A.PROJECT_CODE = B.PROJECT_CODE
								AND A.SCM_SITE_ID	= B.SCM_SITE_ID
								AND A.ITEM_ID		= B.ITEM_ID
								AND A.DOM_EXP		= B.DOM_EXP
								AND A.FCST_TYPE		= B.FCST_TYPE
								AND A.INCOTERMS		= B.INCOTERMS
								AND SUBSTR(A.YYYYMMDD, 1, 6)	= B.YYYYMM )
						WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
							WHERE A.MEASURE IN ('VMI_In_Plan', 'VMI_In_Req')
								AND A.CURRENCY IS NULL;

						MERGE INTO GT_DMF0_VERSION_COPY A
						USING ( SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
									, MAX(CURRENCY) AS CURRENCY
								FROM DM_PLN_SALES_PLAN_C A
								WHERE A.VERSION_NO = p_version_no
									AND A.DIVISION_ID = p_division_id
									AND A.YYYYMMDD >= d_Result_Date -- 미래구간
								GROUP BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
							) B ON ( A.PROJECT_CODE = B.PROJECT_CODE
								AND A.SCM_SITE_ID	= B.SCM_SITE_ID
								AND A.ITEM_ID		= B.ITEM_ID
								AND A.DOM_EXP		= B.DOM_EXP
								AND A.FCST_TYPE		= B.FCST_TYPE
								AND A.INCOTERMS		= B.INCOTERMS )
						WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
							WHERE A.MEASURE IN ('VMI_In_Plan', 'VMI_In_Req')
								AND A.CURRENCY IS NULL;

						MERGE INTO GT_DMF0_VERSION_COPY A
						USING SCM_MST_SITE_ITEM B
						ON ( A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID )
						WHEN MATCHED THEN UPDATE SET A.COMPANY_ID = B.SALES_COMPANY;
					END IF;
				ELSE
					INSERT INTO GT_DMF0_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
						, DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, ITEM_USE, END_CUSTOMER
							, CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT A.DIVISION_ID, A.VERSION_NO
					    , 'REPORT_' ||  A.CUTOFF_TYPE AS CUTOFF_TYPE
						, A.CUTOFF_YYYYMMDD
						, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, '' AS INCOTERMS, A.CURRENCY, A.MEASURE,A.PLANT_SITE_ID
						, A.YYYYMM  ||	'01', SUM(A.QTY) AS QTY
						, NVL(B.SALES_COMPANY, NULL) AS COMPANY_ID
						, B.ATTRIBUTE1
						, CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID ELSE NULL END AS DEPT_ID
						, NVL(A.ITEM_USE, NULL) AS ITEM_USE, NVL(A.END_CUSTOMER, NULL) AS END_CUSTOMER
						, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_BP_FCST_C A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_MST_SITE C	ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
					JOIN ( SELECT DISTINCT I_MEASURE FROM GT_DMF0_MEASURE ) M ON A.MEASURE = M.I_MEASURE
					WHERE A.VERSION_NO = p_version_no
					--AND MEASURE IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD', 'Business_Plan','CAR_QTY')
					AND A.DIVISION_ID = p_division_id
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
						, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.CURRENCY, A.MEASURE, A.PLANT_SITE_ID
						, A.YYYYMM, B.ATTRIBUTE1
						--[C20201125-000012] COMPANY_ID 변경(Site -> Sales Site Project Model)
						--, NVL(C.COMPANY_ID, NULL)
						, NVL(B.SALES_COMPANY, NULL)
						, CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID ELSE NULL END
						, NVL(A.ITEM_USE, NULL), NVL(A.END_CUSTOMER, NULL), A.CELL_PROD_SITE; --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				END IF;
			ELSIF p_action_type = 'CP' THEN
				SELECT VERSION_TYPE,
    YYYYMMDD
  INTO v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD
				FROM DM_MDF_VERSION
				WHERE VERSION_NO = p_version_no;

				SELECT A.VERSION_NO, MIN(A.YYYYMMDD)
				  INTO v_cp_VERSION_NO, v_cp_MIN_YYYYMMDD
				FROM DM_PLN_SALES_PLAN_REPORT_C A
				WHERE	A.VERSION_NO = p_version_no
					and A.Cutoff_type = v_cp_CUTOFF_TYPE
					and A.Data_type = '1'
				GROUP BY A.VERSION_NO;

				-- 실적 불러오기 처리시, 실적의 시작일자를 CUTOFF 일자를 기준으로 룩업에 세팅된 개월수만큼 전으로 가서 가져온다.

				SELECT TO_NUMBER(SEGMENT3)
				  INTO V_MON_CNT
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
				WHERE LOOKUP_TYPE = 'DMF0044_CONFIG'
					AND SEGMENT1 = P_DIVISION_ID
					AND SEGMENT2 = 'RESULT_START_PERIOD';

				v_cp_MIN_YYYYMMDD := TO_CHAR(ADD_MONTHS(TO_DATE(v_cp_CUTOFF_YYYYMMDD, 'YYYYMMDD'), V_MON_CNT * -1), 'YYYYMMDD');
				-- ----------------------------------------------------------------------------------------------------
				BEGIN
					-- 실적불러오기 선택을 하지 않은 순수한 복사시에만 기존 마스터 그대로 유지가 가능함. 아니면 항상 마스터 최신화 적용됨
					IF ( P_UPDATE_YN <> 'Y' AND d_Result_Date IS NULL) THEN
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
							 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
							 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
							 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
							 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
							 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
							 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
							 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
							 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
							 -- 2021.7.23
							 , SOLDTO_CUST_REPORT
							 , OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
							 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
							 , APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
							 , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT A.DATA_TYPE, NVL(A.DIVISION_ID, '-'), V_NEW_VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
							 , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.PROJECT_CODE, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-')
							 , A.DOM_EXP, NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), NVL(M.O_MEASURE, '-'), NVL(A.PLANT_SITE_ID, '-')
							 , NVL(A.YYYYMMDD, '-'), NVL(A.CURRENCY, '-'), NVL(A.QTY, 0), p_created_by, SYSDATE
							 , p_created_by, SYSDATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
							 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
							 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
							 , A.SOLDTO_CUST_REPORT
							 , A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
							 , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION
							 , A.APPLICATION_GR, A.COUNTRY_KR_NAME, A.ROUTE
							 , NVL(A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 , '-')
						FROM   DM_PLN_SALES_PLAN_REPORT_C A
						JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = ''
						WHERE A.VERSION_NO = p_version_no
							AND A.DATA_TYPE = '1'
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD > d_Result_Date; -- 미래구간
					ELSE
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
							 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
							 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
							 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
							 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
							 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
							 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
							 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
							 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
							 -- 2021.7.23
							 , SOLDTO_CUST_REPORT
							 , OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
							 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
							 , APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
							 , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT A.DATA_TYPE, NVL(A.DIVISION_ID, '-'), V_NEW_VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , NVL(CASE WHEN LK1.SEGMENT1 IS NULL  THEN v_ETC_DEPARTMENT_ID ELSE A.DEPARTMENT_ID END, '-') AS DEPARTMENT_ID
							 , NVL(CASE WHEN LK1.SEGMENT1 IS NULL  THEN v_ETC_DEPARTMENT_NAME ELSE LK1.SEGMENT2 END, '-') AS DEPARTMENT_NAME
							 , NVL(A.DEPT_ID, '-'), NVL(LK2.SEGMENT2, '-') AS DEPT_NAME, NVL(A.END_CUST_REPORT, '-')
							 , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.PROJECT_CODE, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-')
							 , A.DOM_EXP, NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), NVL(M.O_MEASURE, '-'), NVL(A.PLANT_SITE_ID, '-')
							 , NVL(A.YYYYMMDD, '-'), NVL(A.CURRENCY, '-'), NVL(A.QTY, 0), p_created_by, SYSDATE
							 , p_created_by, SYSDATE
							 , CASE WHEN NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL) IS NOT NULL THEN NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL) ELSE NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL) END
							 , A.ATTRIBUTE2, A.ATTRIBUTE3
							 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
							 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
							 , B.ATTRIBUTE1 AS SOLDTO_CUST_REPORT
							 , FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' )		 AS OWNER_NAME
							 , B.CUST_GROUP_DTL
							 , CASE WHEN NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL) IS NOT NULL THEN NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL) ELSE NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL) END AS PRODUCT_DETAILS
							 , C.FORECAST_INFO_SPEC, C.NICK_NAME
							 , NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/ AS FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE
							 , D.SEGMENT2, B.APPLICATION, NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/ AS APPLICATION_GR, F.COUNTRY_KR_NAME, B.ROUTE
							 , NVL(A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 , '-')
						FROM   DM_PLN_SALES_PLAN_REPORT_C A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
						LEFT OUTER JOIN GT_DMF0044_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
						LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
						LEFT OUTER JOIN SCM_MST_COUNTRY F ON E.COUNTRY = F.COUNTRY
						JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = ''
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'
													 ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END AND LK1.VALID_YN = 'Y' AND LK1.SEGMENT3 = 'Y'
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'
													 ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END AND LK2.VALID_YN = 'Y'
						WHERE A.VERSION_NO = p_version_no
							AND A.DATA_TYPE = '1'
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD > d_Result_Date; -- 미래구간

					END IF;
					-- --------
					--UNION ALL -- 여기부터는 실적구간
					-- --------
					BEGIN

						INSERT INTO GT_DMF0_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
								, DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
								, CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT A.DIVISION_ID, v_cp_VERSION_NO, v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(QTY) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_SALES_PLAN_RESULT A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'RESULT' AND M.CALC_YN = ''
						WHERE	A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD <= d_Result_Date   -- 과거실적구간으로 추출
							AND NVL(d_Result_Date, NULL) IS NOT NULL
							AND A.YYYYMMDD >= v_cp_MIN_YYYYMMDD
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						-- ------
						UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다.
						-- ------
						SELECT A.DIVISION_ID, v_cp_VERSION_NO, v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(CASE	WHEN NVL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
										ELSE A.QTY/NVL(FP.EXCHANGE_PRICE,0)
										END) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_SALES_PLAN_RESULT A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						LEFT OUTER JOIN DM_PLN_SALES_REPORT_EXCHANGE_C FP
								 ON A.DIVISION_ID = FP.DIVISION_ID AND SUBSTR(A.YYYYMMDD,1,6) || '01' = FP.YYYYMMDD AND FP.UNIT_CURRENCY = 'USD' AND FP.VERSION_NO = V_NEW_VERSION_NO
						WHERE	A.MEASURE = 'SalesAmt_KRW'
							AND A.CURRENCY <> 'USD'
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD <= d_Result_Date   -- 과거실적구간으로 추출
							AND NVL(d_Result_Date, NULL) IS NOT NULL
							AND A.YYYYMMDD >= v_cp_MIN_YYYYMMDD
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL),  A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						-- ------
						UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다.	( LOC = USD )
						-- ------
						SELECT A.DIVISION_ID, v_cp_VERSION_NO, v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(A.QTY) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_SALES_PLAN_RESULT A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						WHERE	A.MEASURE = 'SalesAmt_LOC'
							AND A.CURRENCY = 'USD'
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD <= d_Result_Date   -- 과거실적구간으로 추출
							AND NVL(d_Result_Date, NULL) IS NOT NULL
							AND A.YYYYMMDD >= v_cp_MIN_YYYYMMDD
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL),  A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						--Start [C20201014-000094] 82 사업부 비물동 구분코드 추가
						-- ------
						UNION ALL
						-- ------
						SELECT A.DIVISION_ID, v_cp_VERSION_NO, v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(QTY) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_SALES_PLAN_RESULT A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'RESULT' AND M.CALC_YN = ''
						WHERE	A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD   <= d_Result_Date   -- 과거실적구간으로 추출
							AND NVL(d_Result_Date, NULL) IS NOT NULL
							AND A.YYYYMMDD	 >= v_cp_MIN_YYYYMMDD
							AND D.COMPANY_ID IS NULL
							AND A.DIVISION_ID = '82'
							AND NVL(A.QTY,0) <> 0
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						-- ------
						UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다.
						-- ------
						SELECT A.DIVISION_ID, v_cp_VERSION_NO, v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(CASE	WHEN NVL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
										ELSE A.QTY/NVL(FP.EXCHANGE_PRICE,0)
										END) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_SALES_PLAN_RESULT A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						LEFT OUTER JOIN DM_PLN_SALES_REPORT_EXCHANGE_C FP
								 ON A.DIVISION_ID = FP.DIVISION_ID AND SUBSTR(A.YYYYMMDD,1,6) || '01' = FP.YYYYMMDD AND FP.UNIT_CURRENCY = 'USD' AND FP.VERSION_NO = V_NEW_VERSION_NO
						WHERE	A.MEASURE = 'SalesAmt_KRW'
							AND A.CURRENCY <> 'USD'
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD	 <= d_Result_Date
							AND NVL(d_Result_Date, NULL) IS NOT NULL
							AND A.YYYYMMDD	 >= v_cp_MIN_YYYYMMDD
							AND D.COMPANY_ID IS NULL
							AND A.DIVISION_ID = '82'
							AND NVL(A.QTY,0) <> 0
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL),  A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						-- ------
						UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다. ( LOC = USD )
						-- ------
						SELECT A.DIVISION_ID, v_cp_VERSION_NO, v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(A.QTY) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_SALES_PLAN_RESULT A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						LEFT OUTER JOIN DM_PLN_SALES_REPORT_EXCHANGE_C FP
								 ON A.DIVISION_ID = FP.DIVISION_ID AND SUBSTR(A.YYYYMMDD,1,6) || '01' = FP.YYYYMMDD AND FP.UNIT_CURRENCY = 'USD' AND FP.VERSION_NO = V_NEW_VERSION_NO
						WHERE	A.MEASURE = 'SalesAmt_LOC'
							AND A.CURRENCY = 'USD'
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD	 <= d_Result_Date
							AND NVL(d_Result_Date, NULL) IS NOT NULL
							AND A.YYYYMMDD	 >= v_cp_MIN_YYYYMMDD
							--AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
							AND A.DIVISION_ID = '82'
							AND NVL(A.QTY,0) <> 0
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL),  A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID;			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						--End [C20201014-000094] 82 사업부 비물동 구분코드 추가

						-- RTF_SCP 처리
						IF p_division_id like '81%' THEN
							INSERT INTO GT_DMF0_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
									  , DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
									  , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							SELECT A.DIVISION_ID, A.VERSION_NO, 'REPORT_SP_W' as Cutoff_Type, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
								 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, '' AS CURRENCY, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
								 , SUM(A.QTY) AS QTY
								 , B.SALES_COMPANY AS COMPANY_ID
								 , B.ATTRIBUTE1
								 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
								 --, '-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
								, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
							FROM DM_PLN_MKT_FCST_RESULT_C A
							JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
							LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
							LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
							JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
							JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = '' AND M.SRC_TABLE = 'DM_PLN_MKT_FCST_RESULT_C'
							WHERE	A.VERSION_NO = 'MF_'  ||  SUBSTR(p_version_no,4,15)
								AND A.DIVISION_ID = p_division_id
								AND A.YYYYMMDD < d_Result_Date   -- 과거실적구간으로 추출
								AND NVL(d_Result_Date, NULL) IS NOT NULL
								AND A.YYYYMMDD >= v_cp_MIN_YYYYMMDD
								AND C.LOOKUP_TYPE IS NULL
								AND D.COMPANY_ID IS NULL
							GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
								, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
								, B.SALES_COMPANY
								, B.ATTRIBUTE1
								, A.CELL_PROD_SITE_ID;			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						END IF;
					END;

				END;

			END IF;

			-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- DIV 별로 키값에 맞춰서 묶어준다. ( YYYYMMDD 때문에 단순 MAX 처리로는 안되고, 키값전체를 이용해서 정리해줘야 한다. )
			-- Scm_site_id 와 Project Code 를 뭉친다.
			-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF P_DIVISION_ID = '40' THEN

				-- [PJ2024-50611] 소형 매출 프로세스 개선
				IF (p_action_type IN ('CR') AND V_SP_BP = 'SP') THEN
				/*
					-- TODO:GTT:GT_DMF0_VERSION_COPY_RTF_ALLOC (구 RTF 로직 — 주석 보존)
					INSERT INTO GT_DMF0_VERSION_COPY_RTF_ALLOC
					SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
						 , COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, ITEM_USE, END_CUSTOMER, CELL_PROD_SITE
					FROM GT_DMF0_VERSION_COPY
					WHERE DIVISION_ID = P_DIVISION_ID
					AND   MEASURE IN ('RTF_SYS_RP','VMI_In_Plan','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

					-- TODO:GTT:GT_DMF0_VERSION_COPY_RTF_ALLOC (구 RTF 로직 — 주석 보존)
					INSERT INTO GT_DMF0_VERSION_COPY_RTF_ALLOC
					SELECT	 DISTINCT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
							,DOM_EXP, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, COMPANY_ID, SOLDTO_CUST_REPORT
							,DEPT_ID,ITEM_USE, END_CUSTOMER, CELL_PROD_SITE
					FROM GT_DMF0_VERSION_COPY_RTF_ALLOC;

					DELETE GT_DMF0_VERSION_COPY
					WHERE DIVISION_ID	= P_DIVISION_ID
					AND   YYYYMMDD		> d_Result_Date
					AND   MEASURE IN ('RTF_SYS_RP','VMI_In_Plan','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

					INSERT INTO GT_DMF0_VERSION_COPY
					(
						   DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
						 , COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, ITEM_USE, END_CUSTOMER, CELL_PROD_SITE
					)
					SELECT A.DIVISION_ID, A.VERSION_NO,A.CUTOFF_TYPE,A.CUTOFF_YYYYMMDD,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID
							,A.DOM_EXP,A.FCST_TYPE,A.INCOTERMS,A.CURRENCY,A.MEASURE
							,B.PLANT_SITE_ID
							,B.YYYYMMDD
							,B.QTY, A.COMPANY_ID, A.SOLDTO_CUST_REPORT
							,A.DEPT_ID,A.ITEM_USE, A.END_CUSTOMER
							--, B.FROM_SITE_ID AS CELL_PROD_SITE
							,B.CELL_PROD_SITE_ID AS CELL_PROD_SITE
					FROM GT_DMF0_VERSION_COPY_RTF_ALLOC A
					--INNER JOIN DM_PLN_RTF_ALLOCATION_C B
					--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
					 INNER JOIN DM_PLN_SALES_PLAN_C B
					ON	A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE  = B.PROJECT_CODE
					AND A.SCM_SITE_ID   = B.SCM_SITE_ID
					AND A.ITEM_ID	    = B.ITEM_ID
					AND A.DOM_EXP	    = B.DOM_EXP
					AND A.FCST_TYPE     = B.FCST_TYPE
					AND A.INCOTERMS     = B.INCOTERMS
					AND A.MEASURE		= B.MEASURE
					AND A.YYYYMMDD		= B.YYYYMMDD
					WHERE A.DIVISION_ID = P_DIVISION_ID
					AND   A.YYYYMMDD	> d_Result_Date
					AND   B.MEASURE IN ('RTF_SYS_RP','VMI_In_Plan','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
					AND   B.VERSION_NO = p_version_no
					AND   B.CUTOFF_TYPE	= v_version_type;
					*/
					--[PJ2024-50611] Sales Report 생성 시 Catcu_Up 수량 더해줌 START
					MERGE INTO GT_DMF0_VERSION_COPY A
							USING GT_DMF0_PLAN_C_CATCHUP B
							ON   (	A.DIVISION_ID = B.DIVISION_ID
								AND A.VERSION_NO = B.VERSION_NO
								AND A.CUTOFF_TYPE= B.CUTOFF_TYPE
								AND A.CUTOFF_YYYYMMDD= B.CUTOFF_YYYYMMDD
								AND A.PROJECT_CODE = B.PROJECT_CODE
								AND A.SCM_SITE_ID = B.SCM_SITE_ID
								AND A.ITEM_ID = B.ITEM_ID
								AND A.DOM_EXP = B.DOM_EXP
								AND A.FCST_TYPE= B.FCST_TYPE
								AND A.INCOTERMS = B.INCOTERMS
								AND A.CURRENCY = B.CURRENCY
								AND A.MEASURE = B.MEASURE
								AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
								AND A.YYYYMMDD = B.YYYYMMDD
								AND A.COMPANY_ID = B.COMPANY_ID
								AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
								AND A.CELL_PROD_SITE = B.CELL_PROD_SITE
								)
							WHEN MATCHED THEN
								UPDATE SET
									A.QTY = A.QTY + B.QTY
							WHEN NOT MATCHED THEN
								INSERT
								(
								   DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
								 , DOM_EXP, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
								 , COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, ITEM_USE, END_CUSTOMER, CELL_PROD_SITE
									)
								VALUES
								(
									B.DIVISION_ID
									,B.VERSION_NO
									,B.CUTOFF_TYPE
									,B.CUTOFF_YYYYMMDD
									,B.PROJECT_CODE
									,B.SCM_SITE_ID
									,B.ITEM_ID
									,B.DOM_EXP
									,B.FCST_TYPE
									,B.INCOTERMS
									,B.CURRENCY
									,B.MEASURE
									,B.PLANT_SITE_ID
									,B.YYYYMMDD
									,B.QTY
									,B.COMPANY_ID
									,B.SOLDTO_CUST_REPORT
									,'','',''
									,B.CELL_PROD_SITE
								);
						--[PJ2024-50611] Sales Report 생성 시 Catcu_Up 수량 더해줌 END
				END IF;

				-- 월별로 하나의 날짜로 변환시킴
				UPDATE GT_DMF0_VERSION_COPY
				SET YYYYMMDD = SUBSTR(YYYYMMDD, 1, 6)  ||  '01';


				-- VMI 의 경우 통화가 빠진 데이터가 있어서 여기서 업데이트 해준다.
				MERGE INTO GT_DMF0_VERSION_COPY A
				USING ( SELECT PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY, COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, END_CUSTOMER
						FROM GT_DMF0_VERSION_COPY
						WHERE CURRENCY IS NOT NULL
						GROUP BY PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY, COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, END_CUSTOMER
					) B ON ( A.PROJECT_CODE = B.PROJECT_CODE
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.ITEM_ID = B.ITEM_ID
						AND A.DOM_EXP = B.DOM_EXP
						AND A.FCST_TYPE = B.FCST_TYPE
						AND A.INCOTERMS = B.INCOTERMS
						AND A.COMPANY_ID = B.COMPANY_ID
						AND NVL(A.SOLDTO_CUST_REPORT, '-') = NVL(B.SOLDTO_CUST_REPORT, '-')
						AND A.DEPT_ID = B.DEPT_ID
						AND NVL(A.END_CUSTOMER, '-') = NVL(B.END_CUSTOMER, '-') )
				WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
					WHERE A.CURRENCY IS NULL;

				MERGE INTO GT_DMF0_VERSION_COPY A
				USING ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, MAX(CURRENCY) AS CURRENCY, DOM_EXP, FCST_TYPE, INCOTERMS
						FROM DM_PLN_CFM_SELLING_PRICE A
						WHERE YYYYMMDD > d_Result_Date AND A.DIVISION_ID = P_DIVISION_ID
						GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					) B ON ( A.DIVISION_ID = B.DIVISION_ID
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.ITEM_ID = B.ITEM_ID
						AND A.DOM_EXP = B.DOM_EXP
						AND A.FCST_TYPE = B.FCST_TYPE
						AND A.INCOTERMS = B.INCOTERMS )
				WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
					WHERE A.CURRENCY IS NULL;

				INSERT INTO GT_DMF0_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
						  , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
						  , CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
						  , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
						  , PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, COMPANY_ID, ATTRIBUTE1, SOLDTO_CUST_REPORT
						  , APPLICATION, CUST_GROUP_DTL, COUNTRY
						  , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
						, D.UPPER_DEPT_ID AS DEPARTMENT_ID, E.SEGMENT2 AS DEPARTMENT_NAME
						, D.DEPT_ID AS DEPT_ID, F.SEGMENT2 AS DEPT_NAME
						, NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL)	AS CUST_REPORT    -- (DMS)판매처
						, NVL(B.attribute2, NULL)	AS END_CUST_REPORT  -- (DMS)고객군
						, NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL)	AS PRODUCT_GROUP
						, B.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
						, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY
						--[C20210304-000196] 소형 부자재 및 전극 매출 수량 표기(biz_type is null 제외)
						/*, CASE WHEN V.FORECAST_INFO_BIZ_TYPE IS NULL AND ( A.MEASURE LIKE '%RTF%' OR A.MEASURE LIKE '%MKT_FCST%' ) THEN 0
								ELSE A.QTY END AS QTY*/
						, A.QTY AS QTY
						, NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
						, CASE WHEN NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL) IS NOT NULL THEN NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL) ELSE NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL) END	AS ATTRIBUTE1
						, NVL(A.SOLDTO_CUST_REPORT, NULL)
						, B.APPLICATION, B.CUST_GROUP_DTL
						, G.COUNTRY
						, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM GT_DMF0_VERSION_COPY A
				JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
				JOIN SCM_MST_SSO_USER_INFO C ON SUBSTR(B.OWNER, 1, CASE WHEN INSTR(B.OWNER, ',') > 0 THEN INSTR(B.OWNER, ',')-1 ELSE LENGTH(B.OWNER) END) = C.USER_ID
				JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND E.VALID_YN = 'Y'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' AND F.VALID_YN = 'Y'
				JOIN SCM_MST_SITE G ON B.DIVISION_ID = G.DIVISION_ID AND B.SCM_SITE_ID = G.SCM_SITE_ID
				LEFT OUTER JOIN GT_DMF0044_ITEM_SINGLE_V V ON A.ITEM_ID = V.ITEM_ID;

				-- 1~3 담당 외에는 기타로 묶는다.
				UPDATE GT_DMF0_REPORT A
				SET A.DEPARTMENT_ID = v_ETC_DEPARTMENT_ID
				WHERE NOT EXISTS ( SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
					WHERE A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND B.SEGMENT3 = 'Y' AND B.VALID_YN = 'Y' );

--SELECT * FROM GT_DMF0_REPORT WHERE MEASURE = 'MKT_FCST'
				-- 인서트
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C (
					  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
					, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
					, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
					, PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY, COMPANY_ID
					, CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1
					-- 2021.7.23
					, SOLDTO_CUST_REPORT
					, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
					, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
					, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
					, ATTRIBUTE3	-- CELL MODEL
					, CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, NVL(P_DIVISION_ID, '-') AS DIVISION_ID, V_NEW_VERSION_NO AS VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-')
					 , NVL(A.CUST_REPORT, '-'), NVL(A.END_CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.PROJECT_CODE, '-'), NVL(A.SCM_SITE_ID, '-')
					 , NVL(A.ITEM_ID, '-'), A.DOM_EXP, NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), NVL(A.MEASURE, '-')
					 , NVL(A.PLANT_SITE_ID, '-'), NVL(A.YYYYMMDD, '-'), NVL(A.CURRENCY, '-'), NVL(A.QTY, 0), NVL(A.COMPANY_ID, '-')
					 , p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE, A.ATTRIBUTE1
					 , B.ATTRIBUTE1 AS SOLDTO_CUST_REPORT
					 , FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' ) AS OWNER_NAME
					 , A.CUST_GROUP_DTL
					 , CASE WHEN NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL) IS NOT NULL THEN NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL) ELSE NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL) END AS PRODUCT_DETAILS
					 , C.FORECAST_INFO_SPEC, C.NICK_NAME
					 , NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/ AS FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE
					 , D.SEGMENT2, A.APPLICATION, NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/ AS APPLICATION_GR, F.COUNTRY_KR_NAME, B.ROUTE
					 , B.ATTRIBUTE5 AS CELL_MODEL
					 , NVL(A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 , '-')
				FROM (
					SELECT '1' AS DATA_TYPE, P_DIVISION_ID AS DIVISION_ID, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
							, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.CUST_REPORT
							, A.END_CUST_REPORT, A.PRODUCT_GROUP
							, FN_SCM_SPLIT(A.MIX_VAL, 1, '^') AS PROJECT_CODE
							, FN_SCM_SPLIT(A.MIX_VAL, 2, '^') AS SCM_SITE_ID
							, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
							, A.PLANT_SITE_ID, B.YYYYMMDD, A.CURRENCY, SUM(B.QTY) as QTY, A.COMPANY_ID
							, B.ATTRIBUTE1
							, A.APPLICATION, A.CUST_GROUP_DTL
							, A.COUNTRY
							, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM (
						-- 병합처리를 위해 키 중 병합되지 않은 키만 분리 ( 하지만 SCM_SITE_ID-PROJECT_CODE-ITEM_ID 간의 관계는 유지되어야 함
						--- 그냥 MAX로 조합할 경우 SCM_MST_SITE_ITEM 에 JOIN 이 안됨 )
						SELECT A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
							, A.CUST_REPORT, A.END_CUST_REPORT, A.PRODUCT_GROUP, A.ITEM_ID, A.CURRENCY, A.COMPANY_ID, A.SOLDTO_CUST_REPORT
							, MAX((NVL(A.PROJECT_CODE, NULL) || '^' || NVL(A.SCM_SITE_ID, NULL))) AS MIX_VAL
							, MAX(A.DOM_EXP) AS DOM_EXP
							, MAX(A.FCST_TYPE) AS FCST_TYPE, MAX(A.INCOTERMS) AS INCOTERMS, MAX(A.PLANT_SITE_ID) AS PLANT_SITE_ID
							, A.APPLICATION, A.CUST_GROUP_DTL, A.COUNTRY
						FROM GT_DMF0_REPORT A
						LEFT OUTER JOIN SCM_MST_SITE B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
						LEFT OUTER JOIN SCM_MST_COUNTRY C ON B.COUNTRY = C.COUNTRY
						GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
							, A.CUST_REPORT, A.END_CUST_REPORT, A.PRODUCT_GROUP, A.ITEM_ID, A.CURRENCY, A.COMPANY_ID, A.SOLDTO_CUST_REPORT
							, A.APPLICATION, A.CUST_GROUP_DTL, A.COUNTRY
						) A
					JOIN GT_DMF0_REPORT B ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
							AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
							AND A.DEPT_ID = B.DEPT_ID
							AND A.DEPT_NAME = B.DEPT_NAME
							AND A.CUST_REPORT = B.CUST_REPORT
							AND A.END_CUST_REPORT = B.END_CUST_REPORT
							AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
							AND A.ITEM_ID = B.ITEM_ID
							AND A.CURRENCY = B.CURRENCY
							AND A.COMPANY_ID = B.COMPANY_ID
							AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
							AND A.APPLICATION = B.APPLICATION
							AND A.CUST_GROUP_DTL = B.CUST_GROUP_DTL
							AND A.COUNTRY = B.COUNTRY
					GROUP BY B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
							, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
							, A.CUST_REPORT, A.END_CUST_REPORT, A.PRODUCT_GROUP
							, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
							, A.PLANT_SITE_ID, B.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, B.ATTRIBUTE1
							, A.APPLICATION, A.CUST_GROUP_DTL
							, A.MIX_VAL, A.COUNTRY, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					) A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN GT_DMF0044_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
					LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					LEFT OUTER JOIN SCM_MST_COUNTRY F ON A.COUNTRY = F.COUNTRY;

			ELSIF P_DIVISION_ID like '81%' THEN
				IF V_SP_BP = 'SP' THEN
					-- 자동차는 팀 없는 건은 전송하지 않음.
					INSERT INTO GT_DMF0_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
							  , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
							  , PROJECT_CODE, FCST_TYPE, PLANT_SITE_ID, ITEM_ID, SCM_SITE_ID
							  , INCOTERMS, CURRENCY
							  , MEASURE, YYYYMMDD, QTY
							  , DOM_EXP, COMPANY_ID
							  , CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
							  , CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
						 , D.UPPER_DEPT_ID AS DEPARTMENT_ID, NVL(E.SEGMENT2, NULL) AS DEPARTMENT_NAME
						 , D.DEPT_ID AS DEPT_ID, NVL(F.SEGMENT2, NULL) AS DEPT_NAME
						 , NVL(B.PROJECT_CODE, NULL), NVL(A.FCST_TYPE, NULL), NVL(A.PLANT_SITE_ID, NULL), NVL(A.ITEM_ID, NULL), NVL(A.SCM_SITE_ID, NULL)
						 , NVL(A.INCOTERMS, NULL), NVL(A.CURRENCY, NULL)
						 , A.MEASURE, A.YYYYMMDD, A.QTY
						 , NVL(A.DOM_EXP, NULL), NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
						 , ''	AS CUST_REPORT    -- (DMS)판매처
						 , ''	AS END_CUST_REPORT  --
						 , ''	AS PRODUCT_GROUP
						 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM GT_DMF0_VERSION_COPY A
					JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
					JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
					JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = 'MDF_DEPARTMENT'  ||  p_division_id
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'  ||  p_division_id
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G ON A.FCST_TYPE = G.SEGMENT1 AND G.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND G.SEGMENT4 <> 'FREE';
				ELSE
					INSERT INTO GT_DMF0_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
							, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
							, PROJECT_CODE, FCST_TYPE, PLANT_SITE_ID, ITEM_ID, SCM_SITE_ID
							, INCOTERMS, CURRENCY
							, MEASURE, YYYYMMDD, QTY
							, DOM_EXP, COMPANY_ID
							, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
							, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							, D.UPPER_DEPT_ID AS DEPARTMENT_ID, NVL(E.SEGMENT2, NULL) AS DEPARTMENT_NAME
							, D.DEPT_ID AS DEPT_ID, NVL(F.SEGMENT2, NULL) AS DEPT_NAME
							, NVL(A.PROJECT_CODE, NULL), NVL(A.FCST_TYPE, NULL), NVL(A.PLANT_SITE_ID, NULL), NVL(A.ITEM_ID, NULL), NVL(A.SCM_SITE_ID, NULL)
							, NVL(A.INCOTERMS, NULL), NVL(A.CURRENCY, NULL)
							, A.MEASURE, A.YYYYMMDD, A.QTY
							, NVL(A.DOM_EXP, NULL), NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
							, ''	AS CUST_REPORT    -- (DMS)판매처
							, A.END_CUSTOMER	AS END_CUST_REPORT  --
							, ''	AS PRODUCT_GROUP
						    , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM GT_DMF0_VERSION_COPY A
					JOIN SCM_MST_SSO_DEPT_INFO D ON A.DEPT_ID = D.DEPT_ID
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = 'MDF_DEPARTMENT'  ||  p_division_id
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'  ||  p_division_id
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G ON A.FCST_TYPE = G.SEGMENT1 AND G.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND G.SEGMENT4 <> 'FREE';
				END IF;
--select * from GT_DMF0_MEASURE
--select measure, count(*) from GT_DMF0_VERSION_COPY group by measure
--select measure, count(*) from GT_DMF0_REPORT group by measure

				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C (
					  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
					, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
					, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
					, PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY, COMPANY_ID
					, CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT '1' AS DATA_TYPE, NVL(P_DIVISION_ID, '-'), V_NEW_VERSION_NO, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
						, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-')
						, NVL(B.CUST_REPORT, '-'), NVL(B.END_CUST_REPORT, '-'), NVL(B.PRODUCT_GROUP, '-'), NVL(A.PROJECT_CODE, '-'), NVL(A.SCM_SITE_ID, '-')
						, NVL(A.ITEM_ID, '-'), A.DOM_EXP, NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), NVL(B.MEASURE, '-')
						, NVL(A.PLANT_SITE_ID, '-'), NVL(SUBSTR(B.YYYYMMDD, 1, 6)  ||  '01', '-') AS YYYYMMDD, NVL(A.CURRENCY, '-'), NVL(SUM(B.QTY), 0) as QTY, NVL(A.COMPANY_ID, '-')
						,'mdf_batch',SYSDATE,'mdf_batch',SYSDATE
						, NVL(B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 , '-')
				FROM (
					-- 병합처리를 위해 키 중 병합되지 않은 키만 분리
					SELECT A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, A.PROJECT_CODE, A.FCST_TYPE, A.PLANT_SITE_ID, A.ITEM_ID, A.SCM_SITE_ID
						, A.INCOTERMS, A.CURRENCY
						, MAX(A.DOM_EXP) AS DOM_EXP, MAX(A.COMPANY_ID) AS COMPANY_ID
					FROM GT_DMF0_REPORT A
					GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, A.PROJECT_CODE, A.FCST_TYPE, A.PLANT_SITE_ID, A.ITEM_ID, A.SCM_SITE_ID
						, A.INCOTERMS, A.CURRENCY
					) A
				JOIN GT_DMF0_REPORT B ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
						AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
						AND A.DEPT_ID = B.DEPT_ID
						AND A.DEPT_NAME = B.DEPT_NAME
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.FCST_TYPE = B.FCST_TYPE
						AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
						AND A.ITEM_ID = B.ITEM_ID
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.INCOTERMS = B.INCOTERMS
						AND A.CURRENCY = B.CURRENCY
				GROUP BY B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
						, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, B.CUST_REPORT, B.END_CUST_REPORT, B.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
						, A.PLANT_SITE_ID, SUBSTR(B.YYYYMMDD, 1, 6), A.CURRENCY, A.COMPANY_ID, B.CELL_PROD_SITE; --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청

			ELSIF P_DIVISION_ID = '82' THEN

				IF V_SP_BP = 'SP' THEN
					INSERT INTO GT_DMF0_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
							, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
							, PROJECT_CODE, FCST_TYPE, PLANT_SITE_ID, ITEM_ID, SCM_SITE_ID
							, INCOTERMS, CURRENCY
							, MEASURE, YYYYMMDD, QTY
							, DOM_EXP, COMPANY_ID
							, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
							, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							, D.UPPER_DEPT_ID AS DEPARTMENT_ID, NVL(E.SEGMENT2, NULL) AS DEPARTMENT_NAME
							, D.DEPT_ID AS DEPT_ID, NVL(F.SEGMENT2, NULL) AS DEPT_NAME
							, NVL(B.PROJECT_CODE, NULL), NVL(A.FCST_TYPE, NULL), NVL(A.PLANT_SITE_ID, NULL), NVL(A.ITEM_ID, NULL), NVL(A.SCM_SITE_ID, NULL)
							, NVL(A.INCOTERMS, NULL), NVL(A.CURRENCY, NULL)
							, A.MEASURE, A.YYYYMMDD, A.QTY
							, NVL(A.DOM_EXP, NULL), NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
							, ''	AS CUST_REPORT    -- (DMS)판매처
							, ''	AS END_CUST_REPORT  --
							, ''	AS PRODUCT_GROUP
							, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM GT_DMF0_VERSION_COPY A
					JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
					JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
					JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = 'MDF_DEPARTMENT_82'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2_82'
				    -- ------
					UNION ALL --[C20201014-000094] 82 사업부 비물동 구분코드 추가
					-- ------
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					        --[C20201014-000094] 82 사업부 비물동 구분코드 추가 (NVL(D.UPPER_DEPT_ID, NULL),  NVL(D.DEPT_ID, NULL))
							, NVL(D.UPPER_DEPT_ID, NULL) AS DEPARTMENT_ID, NVL(E.SEGMENT2, NULL) AS DEPARTMENT_NAME
							, NVL(D.DEPT_ID, NULL) AS DEPT_ID, NVL(F.SEGMENT2, NULL) AS DEPT_NAME
							, NVL(B.PROJECT_CODE, NULL), NVL(A.FCST_TYPE, NULL), NVL(A.PLANT_SITE_ID, NULL), NVL(A.ITEM_ID, NULL), NVL(A.SCM_SITE_ID, NULL)
							, NVL(A.INCOTERMS, NULL), NVL(A.CURRENCY, NULL)
							, A.MEASURE, A.YYYYMMDD, A.QTY
							, NVL(A.DOM_EXP, NULL), NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
							, ''	AS CUST_REPORT    -- (DMS)판매처
							, ''	AS END_CUST_REPORT  --
							, ''	AS PRODUCT_GROUP
							, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM GT_DMF0_VERSION_COPY A
					--[C20201014-000094] 82 사업부 비물동 구분코드 추가 (JOIN -> LEFT OUTER JOIN)
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
					LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = 'MDF_DEPARTMENT_82'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2_82'
					--[C20201014-000094] 82 사업부 비물동 구분코드 추가
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G  ON A.ITEM_ID = G.SEGMENT1 AND A.DIVISION_ID = G.SEGMENT3 AND G.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
					WHERE A.DIVISION_ID = '82';
				ELSE
					INSERT INTO GT_DMF0_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
							, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
							, PROJECT_CODE, FCST_TYPE, PLANT_SITE_ID, ITEM_ID, SCM_SITE_ID
							, INCOTERMS, CURRENCY
							, MEASURE, YYYYMMDD, QTY
							, DOM_EXP, COMPANY_ID
							, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
							, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							, D.UPPER_DEPT_ID AS DEPARTMENT_ID, NVL(E.SEGMENT2, NULL) AS DEPARTMENT_NAME
							, D.DEPT_ID AS DEPT_ID, NVL(F.SEGMENT2, NULL) AS DEPT_NAME
							, A.ITEM_USE AS PROJECT_CODE, '' AS FCST_TYPE, '' AS PLANT_SITE_ID, '' AS ITEM_ID, '' AS SCM_SITE_ID
							, '' AS INCOTERMS, NVL(A.CURRENCY, NULL)
							, A.MEASURE, A.YYYYMMDD, A.QTY
							, NVL(A.DOM_EXP, NULL), NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
							, ''	AS CUST_REPORT    -- (DMS)판매처
							, ''	AS END_CUST_REPORT  --
							, ''	AS PRODUCT_GROUP
							, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM GT_DMF0_VERSION_COPY A
					LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON A.DEPT_ID = D.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = 'MDF_DEPARTMENT_82'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2_82';

				END IF;

				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C (
					  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
					, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
					, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
					, PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY, COMPANY_ID
					, CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT '1' AS DATA_TYPE, NVL(P_DIVISION_ID, '-'), V_NEW_VERSION_NO, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
						, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-')
						, NVL(B.CUST_REPORT, '-'), NVL(B.END_CUST_REPORT, '-'), NVL(B.PRODUCT_GROUP, '-'), NVL(A.PROJECT_CODE, '-'), NVL(A.SCM_SITE_ID, '-')
						, NVL(A.ITEM_ID, '-'), A.DOM_EXP, NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), NVL(B.MEASURE, '-')
						, NVL(A.PLANT_SITE_ID, '-'), NVL(SUBSTR(B.YYYYMMDD, 1, 6)  ||  '01', '-'), NVL(A.CURRENCY, '-'), NVL(SUM(B.QTY), 0) as QTY, NVL(A.COMPANY_ID, '-')
						,p_created_by, SYSDATE, p_created_by, SYSDATE
						, NVL(B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 , '-')
				FROM (
					-- 병합처리를 위해 키 중 병합되지 않은 키만 분리
					SELECT A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, A.PROJECT_CODE, A.INCOTERMS, A.CURRENCY, A.SCM_SITE_ID, A.ITEM_ID
						, MAX(A.FCST_TYPE) AS FCST_TYPE, MAX(A.PLANT_SITE_ID) AS PLANT_SITE_ID
						, MAX(A.DOM_EXP) AS DOM_EXP, MAX(A.COMPANY_ID) AS COMPANY_ID
					FROM GT_DMF0_REPORT A
					GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, A.PROJECT_CODE, A.ITEM_ID, A.SCM_SITE_ID
						, A.INCOTERMS, A.CURRENCY
					) A
				JOIN GT_DMF0_REPORT B ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
						AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
						AND A.DEPT_ID = B.DEPT_ID
						AND A.DEPT_NAME = B.DEPT_NAME
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.ITEM_ID = B.ITEM_ID
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.INCOTERMS = B.INCOTERMS
						AND A.CURRENCY = B.CURRENCY
				GROUP BY B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
						, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, B.CUST_REPORT, B.END_CUST_REPORT, B.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
						, A.PLANT_SITE_ID, SUBSTR(B.YYYYMMDD, 1, 6), A.CURRENCY, A.COMPANY_ID, B.CELL_PROD_SITE; --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청


--SELECT SQL%ROWCOUNT AS ROW_CNT
--SELECT * FROM GT_DMF0_VERSION_COPY
--SELECT * FROM GT_DMF0_REPORT

			END IF;

			-- --------------------------------------------------------------------------------------------------
			--		PRICE 메저 생성
			-- --------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE('B');
				-- LOC 메저는 CP, CR 관계없이 추가한다. ( 실적구간때문에 Loc 메저를 새로 만들어야 하는데, 기존 계획구간에는 Loc 메저가 있을 수도 있어서 복사시에는 Loc 를 복사하지 않고, 여기에서 한꺼번에 새로 만들어준다.
				-- RTF 가 있는 품목들에 대해서 Unit Price ( LOC ) 를 만들어준다. SalesAmt_LOC / Unit Price ( LOCAL )
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
				(  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
				 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
				 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
				 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
				 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID
				 -- 2021.7.23
				 , SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC
				 , NICK_NAME, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME
				 , APPLICATION, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, ATTRIBUTE3
				 , CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, NVL(A.DIVISION_ID, '-') ,NVL(A.VERSION_NO, '-') ,A.CUTOFF_TYPE ,A.CUTOFF_YYYYMMDD
					 , NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
					 , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.PROJECT_CODE, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-')
					 , MAX(A.DOM_EXP) AS DOM_EXP, NVL(MAX(A.FCST_TYPE), '-') AS FCST_TYPE, NVL(MAX(A.INCOTERMS), '-') AS INCOTERMS, 'LOC' AS MEASURE, NVL(MAX(A.PLANT_SITE_ID), '-') AS PLANT_SITE_ID
					 , NVL(A.YYYYMM  || '01', '-') AS YYYYMMDD, NVL(A.CURRENCY, '-')
					 , NVL(CASE WHEN SUM(A.Qty) <> 0 THEN ROUND(SUM(B.Qty) / SUM(A.Qty), 3)
							ELSE 0 END, 0) AS Qty
					 , p_created_by, SYSDATE, p_created_by, SYSDATE, MAX(A.ATTRIBUTE1) AS ATTRIBUTE1
					 , NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
					 -- 2021.7.23
					 , MAX(A.SOLDTO_CUST_REPORT) AS SOLDTO_CUST_REPORT, MAX(A.OWNER_NAME) AS OWNER_NAME, MAX(A.CUST_GROUP_DTL) AS CUST_GROUP_DTL, MAX(A.PRODUCT_DETAILS) AS PRODUCT_DETAILS
					 , MAX(A.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC, MAX(A.NICK_NAME) AS NICK_NAME, MAX(A.FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL, MAX(A.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
					 , MAX(A.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE, MAX(A.COMPANY_NAME) AS COMPANY_NAME, MAX(A.APPLICATION) AS APPLICATION, MAX(A.APPLICATION_GR) AS APPLICATION_GR, A.COUNTRY_KR_NAME
					 , MAX(A.ROUTE) AS ROUTE, MAX(A.ATTRIBUTE3) AS CELL_MODEL
					 , NVL(A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 , '-')
				FROM (
					SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME
						 , DEPT_ID, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM, CURRENCY, SUM(QTY) AS QTY
						 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						 , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE
						 , SOLDTO_CUST_REPORT
						 , OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
						 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
						 , APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'LOC' AND M.QTY_AMT = 'QTY'
					WHERE DIVISION_ID = P_DIVISION_ID
						--AND MEASURE IN ( 'RTF', 'Business_Plan')
						AND VERSION_NO = V_NEW_VERSION_NO
					GROUP BY  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME
						, DEPT_ID, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, SUBSTR(YYYYMMDD, 1, 6), CURRENCY
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE
						, SOLDTO_CUST_REPORT
						, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
						, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
						, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						) A
				JOIN (
					SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME
						, DEPT_ID, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM, CURRENCY, SUM(QTY) AS QTY
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE
						, SOLDTO_CUST_REPORT
						, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
						, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
						, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'LOC' AND M.QTY_AMT = 'AMT'
					WHERE DIVISION_ID = P_DIVISION_ID
						--AND MEASURE = 'SalesAmt_LOC'
						AND VERSION_NO = V_NEW_VERSION_NO
					GROUP BY DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME
						, DEPT_ID, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, SUBSTR(YYYYMMDD, 1, 6), CURRENCY
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE
						, SOLDTO_CUST_REPORT
						, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
						, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
						, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						) B ON A.PROJECT_CODE = B.PROJECT_CODE AND A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
										AND A.YYYYMM = B.YYYYMM AND A.COMPANY_ID = B.COMPANY_ID AND A.CURRENCY = B.CURRENCY AND A.INCOTERMS = B.INCOTERMS
										AND A.COUNTRY_KR_NAME = B.COUNTRY_KR_NAME
										AND A.CELL_PROD_SITE  = B.CELL_PROD_SITE			--[PJ2024-50611] 소형 매출 프로세스 개선
				GROUP BY   A.DATA_TYPE, A.DIVISION_ID,A.VERSION_NO,A.CUTOFF_TYPE,A.CUTOFF_YYYYMMDD,A.DEPARTMENT_ID,A.DEPARTMENT_NAME,A.DEPT_ID,A.DEPT_NAME,A.END_CUST_REPORT,A.CUST_REPORT,A.PRODUCT_GROUP
							,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.MEASURE,A.YYYYMM, A.CURRENCY, NVL(A.COMPANY_ID, NULL), A.COUNTRY_KR_NAME, A.CELL_PROD_SITE; --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청

DBMS_OUTPUT.PUT_LINE('C');

			-- 자동차 : KRW, USD 메저 생성
			IF ( P_DIVISION_ID LIKE '81%' ) THEN
					-- KRW
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
					 , CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
					 , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.PROJECT_CODE, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-')
					 , A.DOM_EXP, NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'KRW' AS MEASURE, NVL(A.PLANT_SITE_ID, '-')
					 , NVL(A.YYYYMMDD, '-'), NVL(A.CURRENCY, '-')
					 , NVL(A.QTY * EX.EXCHANGE_PRICE, 0)
					 , p_created_by, SYSDATE, p_created_by, SYSDATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
					 , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, NVL(A.COMPANY_ID, '-')
					 , NVL(A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 , '-')
				FROM (
					SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
						 , YYYYMMDD, CURRENCY, QTY
						 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
						 , CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					WHERE DIVISION_ID = P_DIVISION_ID
						AND MEASURE = 'LOC'
						AND VERSION_NO = V_NEW_VERSION_NO
						) A
				JOIN DM_PLN_SALES_REPORT_EXCHANGE_C EX ON A.DIVISION_ID = EX.DIVISION_ID AND A.CUTOFF_TYPE = EX.CUTOFF_TYPE
									AND A.CUTOFF_YYYYMMDD = EX.CUTOFF_YYYYMMDD AND EX.CURRENCY = 'KRW' AND A.CURRENCY = EX.UNIT_CURRENCY
									AND A.YYYYMMDD = EX.YYYYMMDD AND EX.VERSION_NO = V_NEW_VERSION_NO;

DBMS_OUTPUT.PUT_LINE('D');
					-- USD
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
					 , CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
					, NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.PROJECT_CODE, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-')
					, A.DOM_EXP, NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'USD' AS MEASURE, NVL(A.PLANT_SITE_ID, '-')
					, NVL(A.YYYYMMDD, '-'), NVL(A.CURRENCY, '-')
					, NVL(CASE WHEN NVL(EX.EXCHANGE_PRICE, 0) <> 0 THEN ROUND( A.QTY / EX.EXCHANGE_PRICE, 3)
							ELSE 0 END, 0) AS QTY
					, p_created_by, SYSDATE, p_created_by, SYSDATE
					, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
					, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, NVL(A.COMPANY_ID, '-')
					, NVL(A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 , '-')
				FROM (
					SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
						 , YYYYMMDD, CURRENCY, QTY
						 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
						 , CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					WHERE DIVISION_ID = P_DIVISION_ID
						AND MEASURE = 'KRW'
						AND VERSION_NO = V_NEW_VERSION_NO
						) A
				JOIN DM_PLN_SALES_REPORT_EXCHANGE_C EX ON A.DIVISION_ID = EX.DIVISION_ID AND A.CUTOFF_TYPE = EX.CUTOFF_TYPE
									AND A.CUTOFF_YYYYMMDD = EX.CUTOFF_YYYYMMDD AND EX.CURRENCY = 'KRW' AND EX.UNIT_CURRENCY = 'USD'
									AND A.YYYYMMDD = EX.YYYYMMDD AND EX.VERSION_NO = V_NEW_VERSION_NO;


			END IF;

DBMS_OUTPUT.PUT_LINE('E');
			-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 사업부별 메저 생성 ( 사업부별로 특성이 있는 메저들은 수량메저들이고, 40은 없음
			-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF ( P_DIVISION_ID LIKE '81%' ) THEN
				IF ( p_action_type = 'CP' ) THEN
					DELETE FROM DM_PLN_SALES_PLAN_REPORT_C
					WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = V_NEW_VERSION_NO AND MEASURE IN ( 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL');
				END IF;

				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
					 , CELL_PROD_SITE ) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
					 , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(C.PROJECT_CODE, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-')
					 , A.DOM_EXP, NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), NVL(M.O_MEASURE, '-'), NVL(A.PLANT_SITE_ID, '-')
					 , NVL(A.YYYYMMDD, '-'), NVL(A.CURRENCY, '-')
					 , NVL(CASE WHEN M.O_MEASURE IN ('RTF_SYS_RP_CAR', 'RTF_CAR') THEN
								CASE WHEN INSTR(B.ITEM_CLASS_NAME, 'Cell') > 0 AND C.CELL_PER_CAR > 0 THEN A.QTY / C.CELL_PER_CAR
									WHEN  INSTR(B.ITEM_CLASS_NAME, 'Module') > 0  AND C.CELL_PER_CAR > 0 AND C.CELL_PER_MODULE > 0 THEN A.QTY/ ( C.CELL_PER_CAR/ C.CELL_PER_MODULE )
									WHEN  INSTR(B.ITEM_CLASS_NAME, 'Pack') > 0  THEN A.QTY
									ELSE 0
								END
							WHEN M.O_MEASURE IN ('RTF_SYS_RP_CELL','RTF_CELL') THEN
								CASE WHEN INSTR(B.ITEM_CLASS_NAME, 'Cell') > 0 AND C.CELL_PER_CAR > 0 THEN A.QTY
									WHEN ( INSTR(B.ITEM_CLASS_NAME, 'Module') > 0 OR INSTR(B.ITEM_CLASS_NAME, 'Pack') > 0 ) AND C.CELL_PER_MODULE > 0 THEN A.QTY * C.CELL_PER_MODULE
									ELSE 0
								END
						END, 0) AS QTY
					 , p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, NVL(A.COMPANY_ID, '-')
					 , NVL(A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 , '-')
				FROM   DM_PLN_SALES_PLAN_REPORT_C A
				JOIN GT_DMF0044_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
				JOIN GT_DMF0_SCM_MST_SITE_ITEM C ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
				JOIN SCM_MST_SITE D ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID
				JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.O_MEASURE IN ( 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL','RTF_CAR', 'RTF_CELL' ) AND M.PLAN_RESULT = 'PLAN'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON D.END_CUSTOMER = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'DM_CAR_QTY_FORD' AND A.ITEM_ID = LK1.SEGMENT3
				WHERE A.DIVISION_ID = P_DIVISION_ID AND A.VERSION_NO = V_NEW_VERSION_NO
					AND ( M.O_MEASURE NOT IN ( 'RTF_SYS_RP_CAR', 'RTF_CAR') OR LK1.SEGMENT1 IS NULL ) -- FORD 환산건은 별도 처리
					AND D.END_CUSTOMER = 'FORD'
				-- FORD 환산건 추가
				UNION ALL
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, C.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , ROUND(SUM(TO_NUMBER(C.CELL_PER_MODULE) * TO_NUMBER(A.QTY))/MAX(LK1.SEGMENT4), 0) AS QTY
					 , p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM   DM_PLN_SALES_PLAN_REPORT_C A
				JOIN GT_DMF0044_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
				JOIN GT_DMF0_SCM_MST_SITE_ITEM C ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
				JOIN SCM_MST_SITE D ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID
				JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.O_MEASURE IN ( 'RTF_SYS_RP_CAR', 'RTF_CAR' ) AND M.PLAN_RESULT = 'PLAN'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON D.END_CUSTOMER = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'DM_CAR_QTY_FORD' AND A.ITEM_ID = LK1.SEGMENT3
				WHERE A.DIVISION_ID = P_DIVISION_ID AND A.VERSION_NO = V_NEW_VERSION_NO
					AND ( M.O_MEASURE IN ( 'RTF_SYS_RP_CAR', 'RTF_CAR') AND LK1.SEGMENT1 IS NOT NULL ) -- FORD 환산건
					AND D.END_CUSTOMER = 'FORD'
				GROUP BY A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, C.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.CELL_PROD_SITE; --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청

			ELSIF P_DIVISION_ID = '82' THEN
				IF ( p_action_type = 'CP' ) THEN
					DELETE FROM DM_PLN_SALES_PLAN_REPORT_C
					WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = V_NEW_VERSION_NO AND MEASURE IN ( 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL');
				END IF;

DBMS_OUTPUT.PUT_LINE('F');
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
					 , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, NVL(A.DIVISION_ID, '-'), NVL(A.VERSION_NO, '-'), A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'), NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-')
					 , NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'), NVL(A.PROJECT_CODE, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-')
					 , A.DOM_EXP, NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), NVL(M.O_MEASURE, '-'), NVL(A.PLANT_SITE_ID, '-')
					 , NVL(A.YYYYMMDD, '-'), NVL(A.CURRENCY, '-')
					 , NVL(CASE WHEN M.O_MEASURE IN ('RTF_CELL', 'RTF_SYS_RP_CELL') THEN A.QTY * B.CELL_QUANTITY
							WHEN M.O_MEASURE IN ('RTF_ENG', 'RTF_SYS_RP_ENG')	THEN A.QTY * B.ENERGY/1000	-- ENERGY 컬럼값이 KWh 이므로 1,000 으로 나눠준다.
							END, 0) AS QTY
					 , p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, NVL(A.COMPANY_ID, '-')
					 , NVL(A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 , '-')
				FROM   DM_PLN_SALES_PLAN_REPORT_C A
				JOIN GT_DMF0044_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
				JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.O_MEASURE IN ( 'RTF_CELL', 'RTF_ENG','RTF_SYS_RP_CELL', 'RTF_SYS_RP_ENG' ) AND M.PLAN_RESULT = 'PLAN' --[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
				WHERE A.DIVISION_ID = P_DIVISION_ID AND A.VERSION_NO = V_NEW_VERSION_NO
					--and a.item_id = 'EABB00252AA'
					--and a.yyyymmdd = '20191101'
					--and a.scm_site_id = 'Fluence_US_SAN'

				order by measure;
DBMS_OUTPUT.PUT_LINE('G');


			END IF;
			--RAISE_APPLICATION_ERROR(-20001, 'TEST')

			-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 사업부별 메저 끝
			-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 기타매출 복사 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			/*
				기타매출 테이블에서 기타매출 테이블로 복사한다.
				COPY 시에는 실적 기준일이 있을 경우에는 해당 기준일을 기준으로 이전월은 실적으로 보고 해당 기간까지는 실적버전을 복사하고, 이 후 기간은 원본버전을 그대로 복사한다.
			              실적 기준일이 없을 경우에는 그냥 복사한다.
				CREATE 시에는 최신 버전을 그대로 복사한다.
			*/
			-- (인라인 DECLARE 제거: V_ETC_CUTOFF_TYPE/YYYYMMDD는 선언부에 이미 선언됨)
			SELECT MAX(CUTOFF_TYPE), MAX(CUTOFF_YYYYMMDD)
			  INTO V_ETC_CUTOFF_TYPE, V_ETC_CUTOFF_YYYYMMDD
			FROM DM_PLN_SALES_PLAN_REPORT_C
			WHERE DIVISION_ID = P_DIVISION_ID
				AND VERSION_NO = V_NEW_VERSION_NO;

--select V_ETC_CUTOFF_TYPE, V_ETC_CUTOFF_YYYYMMDD, V_NEW_VERSION_NO
			IF p_action_type = 'CR' THEN

				INSERT INTO DM_PLN_SALES_ETC_REPORT_C (
					VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
					, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
					, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
					-- 2021.07.23
					, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
					, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
					, DEPARTMENT_NAME, DEPT_NAME
					 )
				SELECT V_NEW_VERSION_NO, A.DIVISION_ID, A.DATA_SEQ, V_ETC_CUTOFF_TYPE, V_ETC_CUTOFF_YYYYMMDD
					, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_ID ELSE A.DEPARTMENT_ID END AS DEPARTMENT_ID
					, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_ID ELSE A.DEPT_ID END AS DEPT_ID
					, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT
					, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID
					, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.QTY
					, p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
					, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
					-- 2021.07.23
					, FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' )		AS OWNER_NAME
					, B.CUST_GROUP_DTL, C.FORECAST_INFO_SPEC
					, NVL(LK3.ATTRIBUTE1, C.NICK_NAME ) AS NICK_NAME
					, NVL(CASE WHEN REGEXP_LIKE(LK3.ATTRIBUTE2, '^[+-]?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(LK3.ATTRIBUTE2) ELSE 0 END, C.FORECAST_INFO_CELL_PACK_COUNT ) AS FORECAST_INFO_CELL_PACK_COUNT
					, D.SEGMENT2, F.COUNTRY_KR_NAME, B.ROUTE
					, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS DEPARTMENT_NAME
					, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_NAME ELSE LK2.SEGMENT2 END AS DEPT_NAME
				FROM DM_PLN_SALES_ETC_REPORT_C A
				LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
				LEFT OUTER JOIN GT_DMF0044_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
				--LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
				LEFT OUTER JOIN SCM_MST_COUNTRY F ON A.COUNTRY_CODE = F.COUNTRY
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT' ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END AND LK1.SEGMENT3 = 'Y'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 ON A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL'
				WHERE A.DIVISION_ID = P_DIVISION_ID
					AND A.VERSION_NO = ( SELECT A.VERSION_NO
										FROM DM_MDF_VERSION A
										JOIN (
											SELECT MAX(A.CREATION_DATE) AS CREATION_DATE
											FROM DM_MDF_VERSION A
											JOIN DM_PLN_SALES_ETC_REPORT_C B ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_NO = B.VERSION_NO
											WHERE A.DIVISION_ID = P_DIVISION_ID
											) B ON A.CREATION_DATE = B.CREATION_DATE
										WHERE A.DIVISION_ID = P_DIVISION_ID
										ORDER BY A.VERSION_NO DESC
										FETCH FIRST 1 ROWS ONLY
										);
--RAISE_APPLICATION_ERROR(-20001, 'SS')
DBMS_OUTPUT.PUT_LINE('H');

			ELSIF p_action_type = 'CP' THEN
				IF D_RESULT_DATE IS NULL THEN
					INSERT INTO DM_PLN_SALES_ETC_REPORT_C (
						VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
						, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						, COMPANY_NAME, COUNTRY_KR_NAME, CUST_GROUP_DTL, DEPARTMENT_NAME, DEPT_NAME
						, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, NICK_NAME, OWNER_NAME, ROUTE
						  )
					SELECT V_NEW_VERSION_NO, A.DIVISION_ID, A.DATA_SEQ, V_ETC_CUTOFF_TYPE, V_ETC_CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT
						, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID
						, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.QTY
						, p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
						, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
						, CASE WHEN p_update_yn = 'Y' AND NVL(D.SEGMENT2, NULL) IS NOT NULL THEN D.SEGMENT2 ELSE A.COMPANY_NAME END AS COMPANY_NAME
						, CASE WHEN p_update_yn = 'Y' AND NVL(F.COUNTRY_KR_NAME, NULL) IS NOT NULL THEN F.COUNTRY_KR_NAME ELSE A.COUNTRY_KR_NAME END AS COUNTRY_KR_NAME
						, CASE WHEN p_update_yn = 'Y' AND NVL(B.CUST_GROUP_DTL, NULL) IS NOT NULL THEN B.CUST_GROUP_DTL ELSE A.CUST_GROUP_DTL END AS CUST_GROUP_DTL
						, CASE WHEN p_update_yn = 'Y' AND P_DIVISION_ID = '40' AND NVL(LK1.SEGMENT2, NULL) IS NOT NULL THEN LK1.SEGMENT2
								WHEN p_update_yn = 'Y' AND P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_NAME
								ELSE A.DEPARTMENT_NAME
								END AS DEPARTMENT_NAME
						, CASE WHEN p_update_yn = 'Y' AND P_DIVISION_ID = '40' AND NVL(LK2.SEGMENT2, NULL) IS NOT NULL THEN LK2.SEGMENT2
								WHEN p_update_yn = 'Y' AND P_DIVISION_ID = '40' AND LK2.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_NAME
								ELSE A.DEPT_NAME
								END AS DEPT_NAME
						, CASE WHEN p_update_yn = 'Y' AND CASE WHEN REGEXP_LIKE(LK3.ATTRIBUTE2, '^[+-]?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(LK3.ATTRIBUTE2)
																ELSE NVL(C.FORECAST_INFO_CELL_PACK_COUNT,0)
																END <> 0
											THEN CASE WHEN REGEXP_LIKE(LK3.ATTRIBUTE2, '^[+-]?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(LK3.ATTRIBUTE2)
																ELSE NVL(C.FORECAST_INFO_CELL_PACK_COUNT,0) END
								ELSE A.FORECAST_INFO_CELL_PACK_COUNT END AS FORECAST_INFO_CELL_PACK_COUNT
						, CASE WHEN p_update_yn = 'Y' AND NVL(C.FORECAST_INFO_SPEC, NULL) IS NOT NULL THEN C.FORECAST_INFO_SPEC ELSE A.FORECAST_INFO_SPEC END AS FORECAST_INFO_SPEC
						, CASE WHEN p_update_yn = 'Y' AND NVL(LK3.ATTRIBUTE1, C.NICK_NAME ) IS NOT NULL THEN NVL(LK3.ATTRIBUTE1, C.NICK_NAME ) ELSE A.NICK_NAME END AS NICK_NAME
						, CASE WHEN p_update_yn = 'Y' AND NVL(FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' ),'') IS NOT NULL THEN FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' ) ELSE A.OWNER_NAME END AS OWNER_NAME
						, CASE WHEN p_update_yn = 'Y' AND NVL(B.ROUTE, NULL) IS NOT NULL THEN B.ROUTE ELSE A.ROUTE END AS ROUTE
					FROM DM_PLN_SALES_ETC_REPORT_C A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN GT_DMF0044_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
					--LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					LEFT OUTER JOIN SCM_MST_COUNTRY F ON A.COUNTRY_CODE = F.COUNTRY
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT' ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END AND LK1.SEGMENT3 = 'Y'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 ON A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL'
					WHERE A.DIVISION_ID = P_DIVISION_ID
						AND A.VERSION_NO = P_VERSION_NO;
DBMS_OUTPUT.PUT_LINE('I');
				ELSE  -- 실적기준일이 있는 복사일 경우 ( 최신화는 UI 에서 강제체크됨 )

					-- 실적을 복사할 버전을 찾는다.
					SELECT MIN(A.VERSION_NO)
  INTO V_MAX_ETC_RESULT_VERSION_NO
					FROM DM_MDF_VERSION A
					JOIN ( SELECT DIVISION_ID, MIN(ETC_RESULT_MONTH) AS ETC_RESULT_MONTH
							FROM DM_MDF_VERSION
							WHERE DIVISION_ID = P_DIVISION_ID
								AND ETC_RESULT_MONTH >= V_ETC_RESULT_MONTH
								AND VERSION_NO <> V_NEW_VERSION_NO
								AND VERSION_TYPE LIKE 'REPORT_SP%'
								AND SEND_YN <> 'D'
							GROUP BY DIVISION_ID
						) B ON A.DIVISION_ID = B.DIVISION_ID
							AND A.ETC_RESULT_MONTH = B.ETC_RESULT_MONTH
							AND A.VERSION_NO <> V_NEW_VERSION_NO
					WHERE A.VERSION_TYPE LIKE 'REPORT_SP%'
						AND A.SEND_YN <> 'D';

					-- LOOKUP 에 복사할 버전이 지정되어있으면 해당 버전을 사용한다.
					SELECT COUNT(1) SEGMENT2
					INTO v_cnt_1
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
					WHERE LOOKUP_TYPE = 'DM_SR_ETC_VERSION'
					AND SEGMENT1 = P_DIVISION_ID
					AND SEGMENT2 IS NOT NULL;
					IF v_cnt_1 > 0 THEN

						SELECT SEGMENT2
						  INTO V_MAX_ETC_RESULT_VERSION_NO
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
						WHERE LOOKUP_TYPE = 'DM_SR_ETC_VERSION'
							AND SEGMENT1 = P_DIVISION_ID
							AND SEGMENT2 IS NOT NULL;

						SELECT COUNT(*) INTO v_cnt_1
						FROM DM_MDF_VERSION
						WHERE DIVISION_ID = P_DIVISION_ID
						AND VERSION_NO = V_MAX_ETC_RESULT_VERSION_NO;
						IF v_cnt_1 = 0 THEN
							v_log_type := 'INVALID_ETC_VERSION';
							RAISE e_validation;
						END IF;
					END IF;  -- v_cnt_1>0 (룩업 ETC 버전 지정) 블록 종료 [MSSQL 2448]


					SELECT MAX(DATA_SEQ)
  INTO V_MAX_DATA_SEQ
					FROM DM_PLN_SALES_ETC_REPORT_C A
					WHERE A.DIVISION_ID = P_DIVISION_ID
						AND A.VERSION_NO = V_NEW_VERSION_NO;
DBMS_OUTPUT.PUT_LINE('J');
--SELECT V_MAX_ETC_RESULT_VERSION_NO, V_NEW_VERSION_NO, V_ETC_RESULT_MONTH, V_MAX_DATA_SEQ

					INSERT INTO DM_PLN_SALES_ETC_REPORT_C (
						VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
						, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						-- 2021.07.23
						, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
						, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
						, DEPARTMENT_NAME, DEPT_NAME
						 )
					SELECT A.VERSION_NO, A.DIVISION_ID, A.DATA_SEQ, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD

						-- 최신화가 아닐 경우 기존 값 복사, 일치하는 부서가 없으면 DEAFULT 기타 부서로 세팅
						, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_ID ELSE A.DEPARTMENT_ID END AS DEPARTMENT_ID
						, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_ID ELSE A.DEPT_ID END AS DEPT_ID
						, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT
						, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID
						, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
						, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
						-- 2021.07.23
						, FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' )       AS OWNER_NAME
						, B.CUST_GROUP_DTL, C.FORECAST_INFO_SPEC
						, NVL(LK3.ATTRIBUTE1, C.NICK_NAME ) AS NICK_NAME
						, NVL(CASE WHEN REGEXP_LIKE(LK3.ATTRIBUTE2, '^[+-]?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(LK3.ATTRIBUTE2) ELSE 0 END, C.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
						, D.SEGMENT2, F.COUNTRY_KR_NAME, B.ROUTE

						, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS DEPARTMENT_NAME
						, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_NAME ELSE LK2.SEGMENT2 END AS DEPT_NAME
					FROM (
						SELECT
							  V_NEW_VERSION_NO AS VERSION_NO, DIVISION_ID
							, DENSE_RANK() OVER (
									ORDER BY DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
									, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME
									, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CURRENCY, COMPANY_ID
									, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
										 ) AS DATA_SEQ
							, V_ETC_CUTOFF_TYPE AS CUTOFF_TYPE, V_ETC_CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
							, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
							, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY
							, p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
							, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
							, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
							, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
							, DEPARTMENT_NAME, DEPT_NAME
						FROM (
							-- 계획구간
							SELECT DIVISION_ID
								, CUTOFF_TYPE, /* CUTOFF_YYYYMMDD ,*/ DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
								, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
								, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
								, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
								, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
								, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
								, DEPARTMENT_NAME, DEPT_NAME
							FROM DM_PLN_SALES_ETC_REPORT_C A
							WHERE A.DIVISION_ID = P_DIVISION_ID
								AND A.VERSION_NO = P_VERSION_NO
								AND A.YYYYMMDD > d_Result_Date
							-- 실적구간
							UNION ALL
							SELECT A.DIVISION_ID, CUTOFF_TYPE, /* CUTOFF_YYYYMMDD ,*/ DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
								, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
								, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
								, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
								, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
								, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
								, DEPARTMENT_NAME, DEPT_NAME
							FROM DM_PLN_SALES_ETC_REPORT_C A
							WHERE A.DIVISION_ID = P_DIVISION_ID
								AND A.VERSION_NO = V_MAX_ETC_RESULT_VERSION_NO
								AND A.YYYYMMDD <= d_Result_Date
							) A
						) A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN GT_DMF0044_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
					--LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					LEFT OUTER JOIN SCM_MST_COUNTRY F ON A.COUNTRY_CODE = F.COUNTRY
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT' ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END AND LK1.SEGMENT3 = 'Y'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 ON A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL';

				END IF;
			END IF;  -- p_action_type CR/CP (ETC 매출 복사) 종료 [MSSQL 2542]


			-- 1~3 담당이 아니면 기타로 처리
			IF P_DIVISION_ID = '40' THEN
				UPDATE DM_PLN_SALES_ETC_REPORT_C A
				SET A.DEPARTMENT_ID = v_ETC_DEPARTMENT_ID
				  , A.DEPT_ID       = v_ETC_DEPARTMENT_ID
				WHERE A.DIVISION_ID = P_DIVISION_ID
				  AND A.VERSION_NO = V_NEW_VERSION_NO
				  AND NOT EXISTS ( SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
					WHERE A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND B.SEGMENT3 = 'Y' );
			END IF;

--VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
--, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
--, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
--, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10


			-- 기타매출 복사 끝 ------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 20230907
DBMS_OUTPUT.PUT_LINE('K');
			BEGIN
			MERGE INTO DM_PLN_SALES_PLAN_REPORT_C A
			USING ( SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK, A.DIVISION_ID
					FROM (
						SELECT SEGMENT2 AS MODEL, SEGMENT3 AS BIZ_TYPE, SEGMENT4 AS CELL_PACK_COUNT, SEGMENT1 AS DIVISION_ID
						     , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) MODEL_RANK
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL
						WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
					) A
					WHERE MODEL_RANK = '1'
				) LOOKA
			ON ( LOOKA.MODEL = A.ITEM_ID AND LOOKA.DIVISION_ID = A.DIVISION_ID )
			WHEN MATCHED THEN UPDATE SET A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT
				, A.FORECAST_INFO_BIZ_TYPE = LOOKA.BIZ_TYPE
				WHERE A.DIVISION_ID = '40' AND A.VERSION_NO = V_NEW_VERSION_NO;

			END;


		END IF;  -- 요청VERSION COPY (CR,CP) 래퍼 종료


    -- IF @V_TRANCOUNT > 0

-- 트랜잭션 (COMMIT)
    -- 트랜잭션 종료 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공 DISPLAY
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_merge_count) AS EVENT FROM DUAL;

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    d_event_date := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

EXCEPTION
    -- 검증 실패 (구 GOTO ERR_RTN): 롤백 + 메시지 결과셋 반환 후 정상 종료 (원본 동등, 에러 raise 안함)
    WHEN e_validation THEN
        ROLLBACK;
        v_result_msg := CASE v_log_type
            WHEN 'DIVISION_INVALID'    THEN 'Division 값이 존재하지 않습니다.'
            WHEN 'VERSION_NO_INVALID'  THEN 'VERSION 값이 존재하지 않습니다.'
            WHEN 'INVALID_ETC_VERSION' THEN '룩업에 설정된 ETC 버전이 잘못되었습니다.'
            WHEN '이동계획 중복'        THEN v_description
            ELSE NVL(v_log_message, '저장할 수 없습니다.') END;
        v_log_message := '########## END of procedure ##########';
        d_event_date := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_result_msg, d_event_date); END;
        OPEN O_RESULT_CURSOR FOR
        SELECT '1' AS CODE, v_result_msg AS MSG, NULL AS EVENT FROM DUAL;
    -- 실제 런타임 오류: 롤백 + 표준 에러로그 + 전파
    WHEN OTHERS THEN
        ROLLBACK;
        v_log_type := 'ERROR';
        v_log_message := 'EXCEPTION';
        v_description := '';
        d_event_date := SYSDATE;
        DECLARE
            V_SQL_CODE   VARCHAR2(100 CHAR)  := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG VARCHAR2(1000 CHAR) := SQLERRM;
            V_BACKTRACE  VARCHAR2(4000 CHAR) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            V_PROC_INPUT VARCHAR2(4000 CHAR);
        BEGIN
            V_PROC_INPUT := JSON_OBJECT(
                'p_division_id' VALUE p_division_id, 'p_version_no' VALUE p_version_no,
                'p_version_description' VALUE p_version_description, 'p_created_by' VALUE p_created_by,
                'p_result_date' VALUE p_result_date, 'p_action_type' VALUE p_action_type,
                'p_mv_plan_yyyymm' VALUE p_mv_plan_yyyymm, 'p_update_yn' VALUE p_update_yn);
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message,
                v_description, d_event_date, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
            RAISE_APPLICATION_ERROR(-20001,
                '[' || v_program_name || '] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_SQL_ERRMSG ||
                ' / BACKTRACE=' || V_BACKTRACE || ' / PARAMS=' || V_PROC_INPUT);
        END;
END P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY;


PROCEDURE P_DMF0044_SALES_REPORT_DEPT_CREATE 
(
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_ACTION_TYPE       IN  VARCHAR2,   -- T:Transfer, C:Cancel
    P_YYYY              IN  VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_SALES_REPORT_DEPT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191021 kyh    rownumber 가 group by 랑 같이있어서 중복오류, Group By 에 Data_Type 제거 - 수정함
 * 20191023 kyh    Department_Name 가져오는 로직을 Sales Report 와 동일하게 Lookup 을 보도록 수정
 * 20191113 KYH		PACK 일 경우 수량환산
 * 20191118 hwi1993 파라미터 추가 및 데이터타입 변경 및 Cancel 기능 추가
 * 20200512 hwi1993 ETC 매출 테이블 추가
 * 20200525 hwi1993 소형 1~3 담당 외에는 기타로 묶음.
 * 20200610 hwi1993	ETC Data 중 Product Detail 이 빠지는 문제 수정
 * 20210716	HWI1993	상반기과제 ( GDW 마스터정비 ) bp 메저관련 및 기간조정
 * 20220616 hwi1993 [C20220608-000333] GDW 전송시 버전 종류에 따른 데이터 오류 수정 요청의 건
 * 2026/06/05	NextSCM Migration	[PJ202650304] 기존 배포본(미완성 자동변환, INVALID) 재변환. #TEMP_REPORT_C→GTT(GT_DMF0044_DEPT_RPT_C), CURSOR 루프→연도 CROSS JOIN(+ROW_NUMBER PARTITION BY YYYY), UPDATE..FROM→상관 UPDATE/NOT EXISTS, GETDATE→SYSDATE, 로깅/EXCEPTION/O_RESULT_CURSOR 표준. 템플릿=DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE(VALID)
 */
IS
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);

    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;

    v_user_id           VARCHAR2(10 CHAR) := 'mdf_batch';
    v_ori_version_no    VARCHAR2(50 CHAR);
    V_SP_BP             VARCHAR2(2 CHAR);
    v_etc_department_id VARCHAR2(30 CHAR);
    v_bp_cnt            PLS_INTEGER := 0;

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;
    -- 시작 LOG  (END)

    -- 중복 VERSION이 있는경우 삭제후 COPY
    DELETE FROM SCM_MGR.DM_MOBILE_REPORT_DEPT
    WHERE  DIVISION_ID = P_DIVISION_ID
    AND    VERSION_NO  = P_VERSION_NO;

    n_delete_count := SQL%ROWCOUNT;

    IF P_ACTION_TYPE = 'T' THEN -- 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리

        SELECT NVL((SELECT ORI_VERSION_NO FROM SCM_MGR.DM_MDF_VERSION
                     WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO AND ROWNUM = 1), NULL)
          INTO v_ori_version_no FROM DUAL;

        -- GTT 초기화
        DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C;

        -- 20210716 : Business_Plan 존재 여부로 SP/BP 결정
        SELECT COUNT(*) INTO v_bp_cnt
        FROM DM_PLN_SALES_PLAN_REPORT_C A
        WHERE A.DIVISION_ID = P_DIVISION_ID
          AND A.VERSION_NO  = P_VERSION_NO
          AND A.MEASURE = 'Business_Plan'
          AND ROWNUM = 1;

        IF v_bp_cnt > 0 THEN
            V_SP_BP := 'BP';
        ELSE
            V_SP_BP := 'SP';
        END IF;

        -- #TEMP_REPORT_C 적재 (SALES_PLAN + ETC UNION ALL)
        INSERT INTO SCM_MGR.GT_DMF0044_DEPT_RPT_C
            ( DIVISION_ID, PRODUCT_GROUP, MEASURE, YYYYMMDD, ATTRIBUTE1, ATTRIBUTE2, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, QTY )
        SELECT A.DIVISION_ID, A.PRODUCT_GROUP
             , CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
             , A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT
             , CASE WHEN A.MEASURE IN ('RTF','Business_Plan','RTF_SYS_RP') AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
                    ELSE A.QTY
               END AS QTY
          FROM DM_PLN_SALES_PLAN_REPORT_C A
          LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
            ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
         WHERE A.DIVISION_ID = P_DIVISION_ID
           AND A.VERSION_NO  = P_VERSION_NO
           AND A.MEASURE IN ('Business_Plan', 'RTF','RTF_SYS_RP','SalesAmt_KRW')
           AND A.DATA_TYPE = '1'
        UNION ALL
        SELECT A.DIVISION_ID, A.PRODUCT_GROUP
             , CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF'
                    WHEN A.MEASURE = 'RTF_SYS_RP' THEN CASE WHEN V_SP_BP = 'BP' THEN 'RTF' ELSE A.MEASURE END
                    ELSE A.MEASURE
               END AS MEASURE
             , A.YYYYMMDD, A.PRODUCT_DETAILS, A.ATTRIBUTE2, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT
             , CASE WHEN A.MEASURE IN ('RTF','Business_Plan') AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
                    ELSE A.QTY
               END AS QTY
          FROM DM_PLN_SALES_ETC_REPORT_C A
          LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
            ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
         WHERE A.DIVISION_ID = P_DIVISION_ID
           AND A.VERSION_NO  = P_VERSION_NO
           AND A.MEASURE IN ('Business_Plan', 'RTF','RTF_SYS_RP','SalesAmt_KRW');

        -- 2020.05.25 1~3 담당 외에는 기타로 묶는다. (기타 부서코드 조회)
        BEGIN
            SELECT SEGMENT1 INTO v_etc_department_id
            FROM SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT' AND ATTRIBUTE1 = 'Y' AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN v_etc_department_id := NULL;
        END;

        -- GTT 의 미등록 부서 → 기타
        UPDATE SCM_MGR.GT_DMF0044_DEPT_RPT_C A
        SET A.DEPARTMENT_ID = v_etc_department_id
        WHERE NOT EXISTS ( SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                           WHERE A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND B.SEGMENT3 = 'Y' );

        -- 원본 테이블의 미등록 부서 → 기타 (원본 MSSQL 동작 보존)
        UPDATE DM_PLN_SALES_PLAN_REPORT_C A
        SET A.DEPARTMENT_ID = v_etc_department_id
          , A.DEPT_ID = v_etc_department_id
        WHERE A.DIVISION_ID = P_DIVISION_ID
          AND A.VERSION_NO = P_VERSION_NO
          AND NOT EXISTS ( SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                           WHERE A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND B.SEGMENT3 = 'Y' );

        UPDATE DM_PLN_SALES_ETC_REPORT_C A
        SET A.DEPARTMENT_ID = v_etc_department_id
          , A.DEPT_ID = v_etc_department_id
        WHERE A.DIVISION_ID = P_DIVISION_ID
          AND A.VERSION_NO = P_VERSION_NO
          AND NOT EXISTS ( SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                           WHERE A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND B.SEGMENT3 = 'Y' );

        -- CURSOR 루프(연도) 대신 SALES_PLAN 연도 CROSS JOIN + ROW_NUMBER PARTITION BY YYYY
        INSERT INTO SCM_MGR.DM_MOBILE_REPORT_DEPT
             ( DIVISION_ID, VERSION_NO, YYYY, SP_BP_TYPE, UPPER_DEPT_NAME, DEPT_NAME, CUST_INFO
             , PRODUCT_NAME, PRODUCT_DETAIL, MEASURE
             , MM01, MM02, MM03, MM04, MM05, MM06, MM07, MM08, MM09, MM10, MM11, MM12
             , ORI_VERSION_NO, SORT_NO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT A.DIVISION_ID
             , A.VERSION_NO
             , A.YYYY
             , A.SP_BP_TYPE
             , A.DEPARTMENT_NAME
             , A.DEPT_NAME
             , A.CUST_INFO
             , A.PRODUCT_NAME
             , A.PRODUCT_DETAIL
             , CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
             , A.MM01, A.MM02, A.MM03, A.MM04, A.MM05, A.MM06, A.MM07, A.MM08, A.MM09, A.MM10, A.MM11, A.MM12
             , v_ori_version_no AS ORI_VERSION_NO
             , ROW_NUMBER() OVER( PARTITION BY A.YYYY
                                  ORDER BY CASE WHEN A.DEPARTMENT_NAME IS NULL OR A.DEPARTMENT_NAME = '기타' THEN '힣' ELSE A.DEPARTMENT_NAME END
                                         , CASE WHEN A.DEPT_NAME = 'MDF' THEN '힣' ELSE A.DEPT_NAME END
                                         , A.DEPT_NAME
                                         , A.DISPLAY_SEQ
                                         , A.MEASURE) AS SORT_NO
             , v_user_id  AS CREATED_BY
             , SYSDATE    AS CREATION_DATE
             , v_user_id  AS LAST_UPDATED_BY
             , SYSDATE    AS LAST_UPDATE_DATE
        FROM (
                SELECT A.DIVISION_ID
                     , A.VERSION_NO
                     , A.YYYY
                     , A.SP_BP_TYPE
                     , A.DEPARTMENT_NAME
                     , A.DEPT_NAME
                     , A.CUST_REPORT AS CUST_INFO
                     , A.PRODUCT_NAME
                     , A.PRODUCT_DETAIL
                     , A.MEASURE
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '01' THEN A.QTY ELSE 0 END) AS MM01
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '02' THEN A.QTY ELSE 0 END) AS MM02
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '03' THEN A.QTY ELSE 0 END) AS MM03
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '04' THEN A.QTY ELSE 0 END) AS MM04
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '05' THEN A.QTY ELSE 0 END) AS MM05
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '06' THEN A.QTY ELSE 0 END) AS MM06
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '07' THEN A.QTY ELSE 0 END) AS MM07
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '08' THEN A.QTY ELSE 0 END) AS MM08
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '09' THEN A.QTY ELSE 0 END) AS MM09
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '10' THEN A.QTY ELSE 0 END) AS MM10
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '11' THEN A.QTY ELSE 0 END) AS MM11
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '12' THEN A.QTY ELSE 0 END) AS MM12
                     , B.DISPLAY_SEQ
                  FROM (
                        SELECT C.DIVISION_ID
                             , P_VERSION_NO AS VERSION_NO
                             , Y.YYYY       AS YYYY
                             , 'SP'         AS SP_BP_TYPE
                             , NVL((SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT' AND C.DEPARTMENT_ID = SEGMENT1 AND ROWNUM = 1), '') AS DEPARTMENT_NAME
                             , NVL((SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' AND C.DEPT_ID = SEGMENT1 AND ROWNUM = 1), '') AS DEPT_NAME
                             , C.CUST_REPORT
                             , C.END_CUST_REPORT
                             , C.PRODUCT_GROUP AS PRODUCT_NAME
                             , C.ATTRIBUTE1 AS PRODUCT_DETAIL
                             , C.MEASURE
                             , SUBSTR(C.YYYYMMDD, 1, 6) AS YYYYMM
                             , C.QTY
                          FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C C
                          CROSS JOIN ( SELECT DISTINCT SUBSTR(YYYYMMDD, 1, 4) AS YYYY
                                       FROM DM_PLN_SALES_PLAN_REPORT_C
                                       WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO ) Y
                         WHERE 1 = 1
                           AND C.MEASURE IN ('Business_Plan', 'RTF','RTF_SYS_RP','SalesAmt_KRW')
                           AND C.YYYYMMDD LIKE Y.YYYY || '%'
                       ) A
                  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
                    ON A.CUST_REPORT = B.SEGMENT1 AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
                 GROUP BY A.DIVISION_ID, A.VERSION_NO, A.YYYY, A.SP_BP_TYPE, A.DEPARTMENT_NAME, A.DEPT_NAME
                        , A.CUST_REPORT, A.PRODUCT_NAME, A.PRODUCT_DETAIL, B.DISPLAY_SEQ, A.MEASURE
             ) A;

        n_merge_count := SQL%ROWCOUNT;

    END IF;

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    N_LOG_COUNT := n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_VERSION_NO'  VALUE P_VERSION_NO,
            'P_ACTION_TYPE' VALUE P_ACTION_TYPE,
            'P_YYYY'        VALUE P_YYYY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_SALES_REPORT_DEPT_CREATE;


PROCEDURE P_DMF0044_SALES_REPORT_PRODUCT_CREATE 
(
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_ACTION_TYPE       IN  VARCHAR2,   -- T:Transfer, C:Cancel
    P_YYYY              IN  VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_SALES_REPORT_PRODUCT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191113 KYH 팩일 경우 QTY 조정
 * 20191118 hwi1993 파라미터 추가 및 데이터타입 변경, Cancel 기능 추가
 * 20200512 hwi1993 ETC 매출 테이블 추가
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026/06/05	NextSCM Migration	[PJ202650304] 기존 배포본(미완성 자동변환, INVALID) 재변환. CURSOR 루프→3개년 CROSS JOIN, #TEMP_REPORT_C→인라인, GETDATE→SYSDATE, 로깅/EXCEPTION/O_RESULT_CURSOR 표준 적용. 템플릿=DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE(VALID)
 */
IS
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);

    -- LOG 용 변수 설정
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;

    -- local 변수선언
    v_user_id           VARCHAR2(10 CHAR) := 'mdf_batch';

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -----------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
    -----------------------------------------------------------------------------------------------------
    DELETE FROM SCM_MGR.DM_MOBILE_REPORT_PRODUCT
    WHERE  DIVISION_ID = P_DIVISION_ID
    AND    VERSION_NO  = P_VERSION_NO;

    n_delete_count := SQL%ROWCOUNT;
    -----------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (END)
    -----------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (BEGIN)
    -----------------------------------------------------------------------------------------------------
    IF P_ACTION_TYPE = 'T' THEN -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리

        -- CURSOR 루프(yyyy-1, yyyy, yyyy+1) 대신 3개 연도 CROSS JOIN 으로 한번에 처리
        INSERT INTO SCM_MGR.DM_MOBILE_REPORT_PRODUCT
             ( DIVISION_ID
             , VERSION_NO
             , YYYY
             , SP_BP_TYPE
             , PRODUCT_NAME
             , PRODUCT_DETAIL
             , MEASURE
             , MM01, MM02, MM03, MM04, MM05, MM06, MM07, MM08, MM09, MM10, MM11, MM12
             , ORI_VERSION_NO
             , SORT_NO
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT A.DIVISION_ID
             , P_VERSION_NO AS VERSION_NO
             , Y.YYYY        AS YYYY
             , 'SP'          AS SP_BP_TYPE
             , A.PRODUCT_GROUP AS PRODUCT_NAME
             , CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1,'')
                    WHEN A.PRODUCT_GROUP = '원통형' THEN NVL(A.ATTRIBUTE2,'')
                    ELSE ''
               END           AS PRODUCT_DETAIL
             , A.MEASURE
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '01' THEN A.QTY ELSE 0 END) AS MM01
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '02' THEN A.QTY ELSE 0 END) AS MM02
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '03' THEN A.QTY ELSE 0 END) AS MM03
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '04' THEN A.QTY ELSE 0 END) AS MM04
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '05' THEN A.QTY ELSE 0 END) AS MM05
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '06' THEN A.QTY ELSE 0 END) AS MM06
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '07' THEN A.QTY ELSE 0 END) AS MM07
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '08' THEN A.QTY ELSE 0 END) AS MM08
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '09' THEN A.QTY ELSE 0 END) AS MM09
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '10' THEN A.QTY ELSE 0 END) AS MM10
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '11' THEN A.QTY ELSE 0 END) AS MM11
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '12' THEN A.QTY ELSE 0 END) AS MM12
             , NVL((SELECT V.ORI_VERSION_NO FROM SCM_MGR.DM_MDF_VERSION V
                     WHERE V.DIVISION_ID = P_DIVISION_ID AND V.VERSION_NO = P_VERSION_NO AND ROWNUM = 1), '-') AS ORI_VERSION_NO
             , B.DISPLAY_SEQ AS SORT_NO
             , v_user_id   AS CREATED_BY
             , SYSDATE      AS CREATION_DATE
             , v_user_id   AS LAST_UPDATED_BY
             , SYSDATE      AS LAST_UPDATE_DATE
          FROM (
                SELECT A.DIVISION_ID, A.PRODUCT_GROUP
                     , CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
                     , A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2
                     , CASE WHEN A.MEASURE = 'RTF' AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
                            ELSE A.QTY
                       END AS QTY
                  FROM DM_PLN_SALES_PLAN_REPORT_C A
                  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
                    ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
                 WHERE A.DIVISION_ID = P_DIVISION_ID
                   AND A.VERSION_NO  = P_VERSION_NO
                   AND A.MEASURE IN ('RTF','Business_Plan','SalesAmt_KRW')
                UNION ALL
                SELECT A.DIVISION_ID, A.PRODUCT_GROUP
                     , CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
                     , A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2
                     , CASE WHEN A.MEASURE = 'RTF' AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
                            ELSE A.QTY
                       END AS QTY
                  FROM DM_PLN_SALES_ETC_REPORT_C A
                  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
                    ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
                 WHERE A.DIVISION_ID = P_DIVISION_ID
                   AND A.VERSION_NO  = P_VERSION_NO
                   AND A.MEASURE IN ('RTF','Business_Plan','SalesAmt_KRW')
               ) A
          LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
            ON A.PRODUCT_GROUP = B.SEGMENT1 AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
          CROSS JOIN (
                SELECT TO_CHAR(TO_NUMBER(P_YYYY) - 1) AS YYYY FROM DUAL
                UNION ALL
                SELECT P_YYYY AS YYYY FROM DUAL
                UNION ALL
                SELECT TO_CHAR(TO_NUMBER(P_YYYY) + 1) AS YYYY FROM DUAL
               ) Y
         WHERE 1 = 1
           AND A.YYYYMMDD LIKE Y.YYYY || '%'
         GROUP BY A.DIVISION_ID
             , A.PRODUCT_GROUP
             , CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1,'')
                    WHEN A.PRODUCT_GROUP = '원통형' THEN NVL(A.ATTRIBUTE2,'')
                    ELSE ''
               END
             , A.MEASURE
             , B.DISPLAY_SEQ
             , Y.YYYY;

        n_merge_count := SQL%ROWCOUNT;

    END IF;
    -----------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (END)
    -----------------------------------------------------------------------------------------------------

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    N_LOG_COUNT := n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_VERSION_NO'  VALUE P_VERSION_NO,
            'P_ACTION_TYPE' VALUE P_ACTION_TYPE,
            'P_YYYY'        VALUE P_YYYY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_SALES_REPORT_PRODUCT_CREATE;

END PKG_DMF0044;
/
