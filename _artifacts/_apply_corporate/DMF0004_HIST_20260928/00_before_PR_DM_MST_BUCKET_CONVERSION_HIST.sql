-- SOURCE-FRESH: SCM_MGR.PR_DM_MST_BUCKET_CONVERSION_HIST PROCEDURE LAST_DDL=2026-09-02 17:30:30 FETCHED=2026-09-28 20:15 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE           "PR_DM_MST_BUCKET_CONVERSION_HIST" 
(
    P_DIVISION_ID     VARCHAR2
   ,P_SCM_SITE_ID     VARCHAR2
   ,P_INCOTERMS       VARCHAR2
   ,P_YYYYMMDD        VARCHAR2
   ,P_BUCKET_PER      VARCHAR2
   ,P_CONVERSION_TYPE VARCHAR2
   ,P_CREATED_BY      VARCHAR2
    -- 자식 프로시저 성공/에러 셋팅
    --p_OK_description     OUT VARCHAR2
)
/*
    * Program ID   : PR_DM_MST_BUCKET_CONVERSION_HIST
    * Description  : PR_DM_MST_BUCKET_CONVERSION_HIST History
    * Program History
    *===================================================================================================
    *   Date       In Charge      Description
    *===================================================================================================
    * 2018.01.25   okaniel      Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
    * 2020/09/09     P.C.I     [C20200909-000203] LOG 표준화 적용
    * 2026-03-23   김준규        [PJ20264226] NextSCM Pilot 설계 및 개발
    *
    */
 AS

    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE     VARCHAR2(30 CHAR);
    N_LOG_COUNT    INTEGER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    D_EVENT_DATE   DATE;
    N_HISTORY_SEQ  INTEGER;
    V_IN_PARA_DATA CLOB;
    V_STEP         VARCHAR2(4000 CHAR) := NULL;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    -- LOG 용 변수 설정
    -- 시작 LOG
    V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID
                                 ,'p_scm_site_id' VALUE P_SCM_SITE_ID
                                 ,'p_Incoterms' VALUE P_INCOTERMS
                                 ,'p_yyyymmdd' VALUE P_YYYYMMDD
                                 ,'p_bucket_per' VALUE P_BUCKET_PER
                                 ,'p_conversion_type' VALUE P_CONVERSION_TYPE
                                 ,'p_created_by' VALUE P_CREATED_BY);
    V_LOG_TYPE     := 'START';
    V_LOG_MESSAGE  := '########## Start of procedure ##########';
    V_DESCRIPTION  := NULL;
    D_EVENT_DATE   := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    -- 트랜잭션 (START)
    -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
        N_HISTORY_SEQ := SEQ1_DM_MST_BUCKET_CONVERSION_H.NEXTVAL;

        BEGIN

            INSERT INTO DM_MST_BUCKET_CONVERSION_H
                (DIVISION_ID
                ,HISTORY_SEQ
                ,SCM_SITE_ID
                ,PROJECT_CODE
                ,INCOTERMS
                ,ITEM_ID
                ,YYYYMMDD
                ,BUCKET_PER
                ,CONVERSION_TYPE
                ,VALID_YN
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE)
            VALUES
                (P_DIVISION_ID
                ,N_HISTORY_SEQ
                ,P_SCM_SITE_ID
                ,'***'
                ,P_INCOTERMS
                ,'***'
                ,P_YYYYMMDD
                ,P_BUCKET_PER
                ,P_CONVERSION_TYPE
                ,'Y'
                ,P_CREATED_BY
                ,SYSTIMESTAMP
                ,P_CREATED_BY
                ,SYSTIMESTAMP);

        END;

    END;

    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    --p_OK_description := 'OK';     -- 정상적인 로그처리 됐을때 'OK'를 셋팅한다
    --RETURN;
    COMMIT;

    -- END TRY

    -- -----------------------------------------------------------
EXCEPTION
    WHEN OTHERS THEN
        -- -----------------------------------------------------------
        --[C20200909-000203] LOG 표준화 적용
        -- 트랜잭션 (END)
        ROLLBACK;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                            ,'ERROR'
                            ,0
                            ,SQLERRM
                            ,NULL
                            ,SYSDATE
                            ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                            ,P_SQL_ERR_CODE  => SQLCODE
                            ,P_SQL_ERR_MSG   => SQLERRM
                            ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
/
