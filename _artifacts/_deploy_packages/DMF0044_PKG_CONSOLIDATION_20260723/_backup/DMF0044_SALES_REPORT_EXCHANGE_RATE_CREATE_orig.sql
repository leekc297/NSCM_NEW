CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE" 
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
END DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE;