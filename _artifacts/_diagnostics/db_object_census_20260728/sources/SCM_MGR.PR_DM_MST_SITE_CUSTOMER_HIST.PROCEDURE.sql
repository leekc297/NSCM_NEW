PROCEDURE         PR_DM_MST_SITE_CUSTOMER_HIST(

    P_DIVISION_ID         IN VARCHAR2
   ,P_SCM_SITE_ID         IN VARCHAR2
   ,P_SOLDTO_CODE         IN VARCHAR2
   ,P_SHIPTO_CODE         IN VARCHAR2
   ,P_REP_YN              IN VARCHAR2
   ,P_CREATED_BY          IN VARCHAR2
   ,P_VALID_YN            IN VARCHAR2 DEFAULT 'Y' -- C20210115-000214 (1)
)
AS
/*
 * Program ID   : PR_DM_MST_SITE_CUSTOMER_HIST
 * Description  : PR_DM_MST_SITE_CUSTOMER_HIST
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20180125 okaniel  Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180726 KHSONG   VALID_YN='N'으로 일괄 업데이트건 History 생성 추가
           (SCM_MST_SITE 에 UPDATE건중 VALID_YN='N'이면 SCM_MST_SITE_CUSTOMER의 데이터를
             VALID_YN='N'으로 일괄 업데이트하면서 HISTORY를 생성)
 * 2020/09/09   P.C.I [C20200909-000203] LOG 표준화 적용
 * 2021/01/18   KUNI  [C20210115-000214] (1)Sales Site (Sales Customer) - Active 이력 저장관련 오류사항
                         단일ROW : SCM_MST_SITE_CUSTOMER.INPUT 값으로 저장
                         (참고) 'ALL' = 'N'
 * 2026-03-10 SSLEE     [PJ20264226] NextSCM Pilot 설계 및 개발
 */

    N_HISTORY_SEQ           NUMBER(10);
    --v_v_program_name        VARCHAR2(150 CHAR) := 'PR_DM_MST_SITE_CUSTOMER_HIST'; -- @v_program_name → $$PLSQL_UNIT
    V_LOG_TYPE              VARCHAR2(30 CHAR); -- START/END/ERROR/...
    N_LOG_COUNT             NUMBER(10) := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    D_EVENT_DATE            TIMESTAMP;
    V_ERR_MSG               VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);
BEGIN

    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSTIMESTAMP;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- 트랜잭션 (START)
    -- BEGIN TRANSACTION PR_DM_MST_SITE_CUSTOMER_HIST; -- Removed

    --------------------------------------------------------------------------------------------
    -- BEGIN TRY
    --------------------------------------------------------------------------------------------

    IF P_SOLDTO_CODE = 'ALL' AND P_SHIPTO_CODE = 'ALL' THEN -- 일괄업데이트 진행건인경우 20180726 KHSONG   History 생성 추가
        INSERT INTO SCM_MGR.SCM_MST_SITE_CUSTOMER_H
        (
            HISTORY_SEQ,
            DIVISION_ID,
            SCM_SITE_ID,
            SOLDTO_CODE,
            SHIPTO_CODE,
            REP_YN,
            VALID_YN,
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
            ATTRIBUTE10,
            HISTORY_CREATION_DATE
        )
        SELECT
            SCM_MGR.SEQ1_SCM_MST_SITE_CUSTOMER_H.NEXTVAL AS HISTORY_SEQ,
            DIVISION_ID,
            SCM_SITE_ID,
            SOLDTO_CODE,
            SHIPTO_CODE,
            REP_YN,
            P_VALID_YN, -- C20210115-000214 (1)   ----    ,'N' AS VALID_YN
            CREATED_BY,
            SYSTIMESTAMP,
            P_CREATED_BY,
            SYSTIMESTAMP,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            SYSTIMESTAMP
        FROM SCM_MGR.SCM_MST_SITE_CUSTOMER
        WHERE DIVISION_ID = P_DIVISION_ID
        AND SCM_SITE_ID   = P_SCM_SITE_ID;

    ELSE -- 일괄업데이트건이 아닌 경우
        N_HISTORY_SEQ := SCM_MGR.SEQ1_SCM_MST_SITE_CUSTOMER_H.NEXTVAL;

        INSERT INTO SCM_MGR.SCM_MST_SITE_CUSTOMER_H
        (
            HISTORY_SEQ,
            DIVISION_ID,
            SCM_SITE_ID,
            SOLDTO_CODE,
            SHIPTO_CODE,
            REP_YN,
            VALID_YN,
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
            ATTRIBUTE10,
            HISTORY_CREATION_DATE
        )
        VALUES
        (
            N_HISTORY_SEQ,
            P_DIVISION_ID,
            P_SCM_SITE_ID,
            P_SOLDTO_CODE,
            P_SHIPTO_CODE,
            P_REP_YN,
            P_VALID_YN, -- C20210115-000214 (1)   ---- 'Y'
            P_CREATED_BY,
            SYSTIMESTAMP,
            P_CREATED_BY,
            SYSTIMESTAMP,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            SYSTIMESTAMP
        );

    END IF;

    COMMIT;

    -- 트랜잭션 (END)
    -- COMMIT WORK; -- Removed

    -- 종료 LOG
    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE := SYSTIMESTAMP;

    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
EXCEPTION
    WHEN OTHERS THEN
        V_ERR_MSG   := SQLERRM;
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        -- 트랜잭션 (END)
        ROLLBACK;

        -- ERROR LOG
        V_LOG_TYPE := 'ERROR';
        V_LOG_MESSAGE := V_ERR_MSG;
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
        D_EVENT_DATE := SYSTIMESTAMP;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        RAISE;
END PR_DM_MST_SITE_CUSTOMER_HIST;