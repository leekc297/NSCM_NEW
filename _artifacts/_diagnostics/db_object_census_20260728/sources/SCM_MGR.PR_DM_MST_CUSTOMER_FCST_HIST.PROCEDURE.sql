PROCEDURE           "PR_DM_MST_CUSTOMER_FCST_HIST"
(
    P_DIVISION_ID           IN VARCHAR2,
    P_PLAN_WEEK             IN VARCHAR2,
    P_CUSTOMER_CODE         IN VARCHAR2,
    P_SCM_SITE_ID           IN VARCHAR2,
    P_SUMMARY_BUCKET_VALUE  IN VARCHAR2,
    P_MEASURE_GROUP         IN VARCHAR2,
    P_MEASURE               IN VARCHAR2,
    P_VALID_YN              IN VARCHAR2,
    P_CUSTOMER_PSI          IN VARCHAR2,
    P_UPLOAD_UOM            IN VARCHAR2,
    P_UPLOAD_BUCKET_TYPE    IN VARCHAR2,
    P_SUMMARY_BUCKET_TYPE   IN VARCHAR2,
    P_EDI_FCST_YN           IN VARCHAR2,
    P_UPLOAD_USER_ID        IN VARCHAR2,
    P_CREATED_BY            IN VARCHAR2,
    P_UPDATE_BY             IN VARCHAR2/*,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR*/
)
/****************************************************************************************************/
/* Program ID   : PR_DM_MST_CUSTOMER_FCST_HIST
/* Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
/* Program History
/*===================================================================================================
/*   Date       In Charge      Description
/*===================================================================================================
/* 2018. 03. 14    JHBAEK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
/* 2026.03.17   SSLEE          [PJ20264226] NEXTSCM PILOT 설계 및 개발                               */
/*                             UI 항목으로 PACKAGE로 전환                                             */
/****************************************************************************************************/
AS
    n_history_seq   NUMBER;

    -- LOG 용 변수 설정
    v_log_type      VARCHAR2(100  CHAR);   -- START/END/ERROR/...
    n_log_count     PLS_INTEGER := 0;
    v_log_message   VARCHAR2(4000 CHAR);
    v_description   VARCHAR2(4000 CHAR);
    d_event_date    DATE;

    -- EXCEPTION 처리용
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);

BEGIN

    -- 시작 LOG  (START)
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_message := NULL;      /*-- <- 다음 메시지를 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- (1)
    /* HISTIRY INSERT */
    SELECT SCM_MGR.SEQ1_DM_MST_CUSTOMER_FCST_H.NEXTVAL
      INTO n_history_seq
      FROM DUAL;

    INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.DM_MST_CUSTOMER_FCST_H
           (DIVISION_ID,
            HISTORY_SEQ,
            PLAN_WEEK,
            CUSTOMER_CODE,
            SCM_SITE_ID,
            SUMMARY_BUCKET_VALUE,
            MEASURE_GROUP,
            MEASURE,
            VALID_YN,
            CUSTOMER_PSI,
            UPLOAD_UOM,
            UPLOAD_BUCKET_TYPE,
            SUMMARY_BUCKET_TYPE,
            EDI_FCST_YN,
            UPLOAD_USER_ID,
            CREATED_BY,
            CREATION_DATE,
            LAST_UPDATED_BY,
            LAST_UPDATE_DATE,
            ATTRIBUTE1,
            ATTRIBUTE2,
            ATTRIBUTE3,
            ATTRIBUTE4,
            ATTRIBUTE5,
            ATTRIBUTE6,
            ATTRIBUTE7,
            ATTRIBUTE8,
            ATTRIBUTE9,
            ATTRIBUTE10
           )
    VALUES
           (P_DIVISION_ID,
            n_history_seq,
            P_PLAN_WEEK,
            P_CUSTOMER_CODE,
            P_SCM_SITE_ID,
            P_SUMMARY_BUCKET_VALUE,
            P_MEASURE_GROUP,
            P_MEASURE,
            P_VALID_YN,
            P_CUSTOMER_PSI,
            P_UPLOAD_UOM,
            P_UPLOAD_BUCKET_TYPE,
            P_SUMMARY_BUCKET_TYPE,
            P_EDI_FCST_YN,
            P_UPLOAD_USER_ID,
            P_CREATED_BY,
            SYSDATE,
            P_UPDATE_BY,
            SYSDATE,
            NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
           );
    -- (1)

    n_log_count := SQL%ROWCOUNT;

    IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
        COMMIT;
    END IF;

    -- 종료 LOG
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    -- ERROR LOG DB INSERT (외부 TRANSACTION 중복으로 : 충돌발생)
    --BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH_CALL_TRAN($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;  -- TRANSACTION 충돌되므로 주석처리

    /*OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_log_count) AS EVENT FROM DUAL;*/

EXCEPTION
    WHEN OTHERS THEN
        -- 1) ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        v_log_type    := 'ERROR';
        v_log_message := 'EXCEPTION';
        v_description := '';
        d_event_date  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'          VALUE P_DIVISION_ID,
            'P_PLAN_WEEK'            VALUE P_PLAN_WEEK,
            'P_CUSTOMER_CODE'        VALUE P_CUSTOMER_CODE,
            'P_SCM_SITE_ID'          VALUE P_SCM_SITE_ID,
            'P_SUMMARY_BUCKET_VALUE' VALUE P_SUMMARY_BUCKET_VALUE,
            'P_MEASURE_GROUP'        VALUE P_MEASURE_GROUP,
            'P_MEASURE'              VALUE P_MEASURE,
            'P_VALID_YN'             VALUE P_VALID_YN,
            'P_CUSTOMER_PSI'         VALUE P_CUSTOMER_PSI,
            'P_UPLOAD_UOM'           VALUE P_UPLOAD_UOM,
            'P_UPLOAD_BUCKET_TYPE'   VALUE P_UPLOAD_BUCKET_TYPE,
            'P_SUMMARY_BUCKET_TYPE'  VALUE P_SUMMARY_BUCKET_TYPE,
            'P_EDI_FCST_YN'          VALUE P_EDI_FCST_YN,
            'P_UPLOAD_USER_ID'       VALUE P_UPLOAD_USER_ID,
            'P_CREATED_BY'           VALUE P_CREATED_BY,
            'P_UPDATE_BY'            VALUE P_UPDATE_BY
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록   /*-- 에러메시지 DISPLAY --*/
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, v_log_type, n_log_count, v_log_message,
                v_description, d_event_date, V_PROC_INPUT,
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

END PR_DM_MST_CUSTOMER_FCST_HIST;