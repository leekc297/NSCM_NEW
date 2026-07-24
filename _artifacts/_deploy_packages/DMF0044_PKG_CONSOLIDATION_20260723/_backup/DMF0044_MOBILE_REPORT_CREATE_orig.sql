CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_MOBILE_REPORT_CREATE" 
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
        SELECT '2' AS DATA_TYPE, DIVISION_ID, VERSION_NO, 'REPORT_SP_W_E' AS CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
        , DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
        , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
        , LAST_UPDATE_DATE, PRODUCT_DETAILS AS ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
        , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS
        , FORECAST_INFO_SPEC, NICK_NAME, CASE WHEN ATTRIBUTE2 IS NOT NULL THEN ATTRIBUTE2 ELSE CELL_MODEL_INFO END AS FORECAST_INFO_CELL_MODEL
        , FORECAST_INFO_CELL_PACK_COUNT, BIZ_TYPE AS FORECAST_INFO_BIZ_TYPE
        , COMPANY_NAME, APPLICATION, APPLICATION_GR, SCM_MGR.FN_GET_COUNTRY_KR_NAME(COUNTRY_CODE) AS COUNTRY_KR_NAME, ROUTE
        , '-' AS CELL_PROD_SITE
        FROM DM_PLN_SALES_ETC_REPORT_C
        WHERE DIVISION_ID = P_DIVISION_ID
        AND   VERSION_NO  = P_VERSION_NO;

        n_merge_count := SQL%ROWCOUNT;

        SCM_MGR.DMF0044_SALES_REPORT_PRODUCT_CREATE(P_DIVISION_ID, P_VERSION_NO, P_ACTION_TYPE, v_yyyy, l_rc);
        SCM_MGR.DMF0044_SALES_REPORT_DEPT_CREATE(P_DIVISION_ID, P_VERSION_NO, P_ACTION_TYPE, v_yyyy, l_rc);
        SCM_MGR.DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE(P_DIVISION_ID, P_VERSION_NO, P_ACTION_TYPE, v_yyyy, l_rc);

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
END DMF0044_MOBILE_REPORT_CREATE;