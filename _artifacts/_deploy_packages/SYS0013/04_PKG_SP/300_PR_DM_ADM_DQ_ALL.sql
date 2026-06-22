-- ============================================================
-- PR_DM_ADM_DQ_* procedures (VALID only, 6) — INVALID 4개 제외 (SQL Server 잔존)
-- 실행 계정: SCM_MGR · dev/local DDL extract 2026-06-22
-- ============================================================

-- ===== PR_DM_ADM_DQ_CREATE_COLUMN_HIST =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_COLUMN_HIST" 
(
    P_DQ_ID                 IN  VARCHAR2,
    P_COLUMN_NAME           IN  VARCHAR2,
    P_VALUE_YN              IN  VARCHAR2,
    P_VALUE_TYPE            IN  VARCHAR2,
    P_VALID_YN              IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_LAST_UPDATED_BY       IN  VARCHAR2
    -- ,
    -- O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_COLUMN_HIST
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 05    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026.03.24     jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
IS
    V_HISTORY_SEQ       PLS_INTEGER;

    -- LOG 용 변수 설정
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

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

    --------------------------------------------------------------------------------------------
    -- (1)
    /* HISTIRY INSERT */
    --------------------------------------------------------------------------------------------
    V_HISTORY_SEQ := SEQ1_SCM_ADM_DQ_COLUMN_H.NEXTVAL;

    INSERT INTO SCM_MGR.SCM_ADM_DQ_COLUMN_H
    (
         HISTORY_SEQ
        ,DQ_ID
        ,COLUMN_NAME
        ,VALUE_YN
        ,VALUE_TYPE
        ,VALID_YN
        ,CREATED_BY
        ,CREATION_DATE
        ,LAST_UPDATED_BY
        ,LAST_UPDATE_DATE
    )
    VALUES
    (
         V_HISTORY_SEQ
        ,P_DQ_ID
        ,P_COLUMN_NAME
        ,P_VALUE_YN
        ,P_VALUE_TYPE
        ,P_VALID_YN
        ,P_CREATED_BY
        ,SYSDATE
        ,P_LAST_UPDATED_BY
        ,SYSDATE
    );
    -- (1)

    N_LOG_COUNT := SQL%ROWCOUNT;

    -- COMMIT (종료 직전 1회)
    COMMIT;

    --OPEN O_RESULT_CURSOR FOR
    --SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    DBMS_OUTPUT.PUT_LINE($$PLSQL_UNIT||' executed successfully. '||TO_CHAR(N_LOG_COUNT)||' records were processed.');

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
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
            'P_DQ_ID'           VALUE P_DQ_ID,
            'P_COLUMN_NAME'     VALUE P_COLUMN_NAME,
            'P_VALUE_YN'        VALUE P_VALUE_YN,
            'P_VALUE_TYPE'      VALUE P_VALUE_TYPE,
            'P_VALID_YN'        VALUE P_VALID_YN,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
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
END PR_DM_ADM_DQ_CREATE_COLUMN_HIST;
/

-- ===== PR_DM_ADM_DQ_CREATE_HIST =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_HIST" 
(
      P_DQ_ID               IN VARCHAR2
    , P_DIVISION_ID         IN VARCHAR2
    , P_DQ_NAME             IN VARCHAR2
    , P_DESCRIPTION         IN VARCHAR2
    , P_DQ_TEXT             IN VARCHAR2
    , P_VALID_YN            IN VARCHAR2
    , P_ADMIN_ONLY_YN       IN VARCHAR2
    , P_CREATED_BY          IN VARCHAR2
    , P_LAST_UPDATED_BY     IN VARCHAR2
)
AS
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_HIST
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History      SKH_COLUMN_NAME1
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 05    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026/03/06     jcnam      [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
    N_HISTORY_SEQ   NUMBER(10);

    N_LOG_COUNT    PLS_INTEGER := 0;
    D_EVENT_DATE   DATE := SYSDATE;
    V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE    varchar2(4000);
    V_SQL_CODE     varchar2(100);
    V_SQL_ERRMSG   varchar2(1000);
    V_PROC_INPUT   VARCHAR2(4000 CHAR);
    V_LOG_MESSAGE  VARCHAR2(4000 CHAR);
    V_LOG_TYPE     VARCHAR2(30 CHAR) := 'E';
BEGIN
    V_LOG_TYPE     := 'START';
    V_LOG_MESSAGE  := '########## Start of procedure ##########';
    V_DESCRIPTION  := '';
    D_EVENT_DATE   := SYSDATE;

    BEGIN PR_SCM_SYS_LOG_BATCH_CALL_TRAN($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    V_LOG_MESSAGE := NULL;

    V_PROC_INPUT :=
        JSON_OBJECT(
              'p_DQ_ID'            VALUE P_DQ_ID
            , 'p_DIVISION_ID'      VALUE P_DIVISION_ID
            , 'p_DQ_NAME'          VALUE P_DQ_NAME
            , 'p_DESCRIPTION'      VALUE P_DESCRIPTION
            , 'p_DQ_TEXT'          VALUE P_DQ_TEXT
            , 'p_VALID_YN'         VALUE P_VALID_YN
            , 'p_ADMIN_ONLY_YN'    VALUE P_ADMIN_ONLY_YN
            , 'p_CREATED_BY'       VALUE P_CREATED_BY
            , 'p_LAST_UPDATED_BY'  VALUE P_LAST_UPDATED_BY
        );

    SELECT SEQ1_SCM_ADM_DQ_LIST_H.NEXTVAL
      INTO N_HISTORY_SEQ
      FROM DUAL;

    INSERT INTO SCM_ADM_DQ_LIST_H
    (
          HISTORY_SEQ
        , DQ_ID
        , DIVISION_ID
        , DQ_NAME
        , DESCRIPTION
        , DQ_TEXT
        , VALID_YN
        , ADMIN_ONLY_YN
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
    )
    VALUES
    (
          N_HISTORY_SEQ
        , P_DQ_ID
        , P_DIVISION_ID
        , P_DQ_NAME
        , P_DESCRIPTION
        , P_DQ_TEXT
        , P_VALID_YN
        , P_ADMIN_ONLY_YN
        , P_CREATED_BY
        , SYSDATE
        , P_LAST_UPDATED_BY
        , SYSDATE
    );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('success');

    V_LOG_TYPE     := 'END';
    V_LOG_MESSAGE  := '########## END of procedure ##########';
    V_DESCRIPTION  := '';
    D_EVENT_DATE   := SYSDATE;

    BEGIN PR_SCM_SYS_LOG_BATCH_CALL_TRAN($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
            ROLLBACK;
        END IF;

        dbms_output.put_line($$plsql_unit || ' ERROR');
        dbms_output.put_line('SQLCODE : ' || sqlcode);
        dbms_output.put_line('SQLERRM : ' || sqlerrm);
        dbms_output.put_line('BACKTRACE: ' || dbms_utility.format_error_backtrace);

        V_PROC_INPUT :=
            JSON_OBJECT(
                  'p_DQ_ID'            VALUE P_DQ_ID
                , 'p_DIVISION_ID'      VALUE P_DIVISION_ID
                , 'p_DQ_NAME'          VALUE P_DQ_NAME
                , 'p_DESCRIPTION'      VALUE P_DESCRIPTION
                , 'p_DQ_TEXT'          VALUE P_DQ_TEXT
                , 'p_VALID_YN'         VALUE P_VALID_YN
                , 'p_ADMIN_ONLY_YN'    VALUE P_ADMIN_ONLY_YN
                , 'p_CREATED_BY'       VALUE P_CREATED_BY
                , 'p_LAST_UPDATED_BY'  VALUE P_LAST_UPDATED_BY
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
                            V_LOG_TYPE,
                            N_LOG_COUNT,
                            V_LOG_MESSAGE,
                            V_DESCRIPTION,
                            D_EVENT_DATE,
                            V_PROC_INPUT,
                            V_SQL_CODE,
                            V_SQL_ERRMSG,
                            V_BACKTRACE
                            );
        -- RAISE;
END PR_DM_ADM_DQ_CREATE_HIST;
/

-- ===== PR_DM_ADM_DQ_CREATE_PARAMETER_HIST =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_PARAMETER_HIST" 
(
    P_DQ_ID                 IN  VARCHAR2,
    P_PARAMETER_ID          IN  VARCHAR2,
    P_PARAMETER_TYPE        IN  VARCHAR2,
    P_OPERATION_ID          IN  VARCHAR2,
    P_VALID_YN              IN  VARCHAR2,
    P_REP_YN                IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_LAST_UPDATED_BY       IN  VARCHAR2
    --,
    --O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_PARAMETER_HIST
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 05    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026.03.25     jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
IS
    V_HISTORY_SEQ       PLS_INTEGER;

    -- LOG 용 변수 설정
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

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

    --------------------------------------------------------------------------------------------
    -- (1)
    /* HISTIRY INSERT */
    --------------------------------------------------------------------------------------------
    V_HISTORY_SEQ := SEQ1_SCM_ADM_DQ_PARAMETER_H.NEXTVAL;

    INSERT INTO SCM_MGR.SCM_ADM_DQ_PARAMETER_H
    (
         HISTORY_SEQ
        ,DQ_ID
        ,PARAMETER_ID
        ,PARAMETER_TYPE
        ,OPERATION_ID
        ,VALID_YN
        ,REP_YN
        ,CREATED_BY
        ,CREATION_DATE
        ,LAST_UPDATED_BY
        ,LAST_UPDATE_DATE
    )
    VALUES
    (
         V_HISTORY_SEQ
        ,P_DQ_ID
        ,P_PARAMETER_ID
        ,P_PARAMETER_TYPE
        ,P_OPERATION_ID
        ,P_VALID_YN
        ,P_REP_YN
        ,P_CREATED_BY
        ,SYSDATE
        ,P_LAST_UPDATED_BY
        ,SYSDATE
    );
    -- (2)

    N_LOG_COUNT := SQL%ROWCOUNT;

    -- COMMIT (종료 직전 1회)
    COMMIT;

    --OPEN O_RESULT_CURSOR FOR
    --SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    DBMS_OUTPUT.PUT_LINE($$PLSQL_UNIT||' executed successfully. '||TO_CHAR(N_LOG_COUNT)||' records were processed.');

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
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
            'P_DQ_ID'            VALUE P_DQ_ID,
            'P_PARAMETER_ID'     VALUE P_PARAMETER_ID,
            'P_PARAMETER_TYPE'   VALUE P_PARAMETER_TYPE,
            'P_OPERATION_ID'     VALUE P_OPERATION_ID,
            'P_VALID_YN'         VALUE P_VALID_YN,
            'P_REP_YN'           VALUE P_REP_YN,
            'P_CREATED_BY'       VALUE P_CREATED_BY,
            'P_LAST_UPDATED_BY'  VALUE P_LAST_UPDATED_BY
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
END PR_DM_ADM_DQ_CREATE_PARAMETER_HIST;
/

-- ===== PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE" 
(
    P_DQ_ID                 IN  VARCHAR2,     -- 단일값 INPUT (ex : 1)
    P_GROUP_ID              IN  VARCHAR2,     -- 다중값 INPUT (ex : A,B,C)
    P_VALID_YN              IN  VARCHAR2,     -- 단일값 INPUT (ex : Y)
    P_CREATED_BY            IN  VARCHAR2,     -- 단일값 INPUT (ex : Tester)
    P_LAST_UPDATED_BY       IN  VARCHAR2     -- 단일값 INPUT (ex : Tester)
    -- O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_USER_GROUP' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 01. 04    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026.03.25     jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
IS
    V_HISTORY_SEQ       PLS_INTEGER;
    V_DELETE_CNT        PLS_INTEGER := 0;

    -- LOG 용 변수 설정
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

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

    --------------------------------------------------------------------------------------------
    -- MSSQL 원본은 다중값 GROUP_ID를 루프 돌면서 첫번째 루프에서만 DQ_ID 기준 DELETE 수행
    -- Oracle 변환: 루프 불필요, DQ_ID 기준 단건 DELETE로 단순화
    --------------------------------------------------------------------------------------------

    -- 첫번째 DQ_ID 값 기준으로 delete 수행
    DELETE
    FROM SCM_MGR.SCM_ADM_DQ_USER_GROUP
    WHERE DQ_ID = P_DQ_ID;

    V_DELETE_CNT := SQL%ROWCOUNT;
    N_LOG_COUNT  := V_DELETE_CNT;

    -- COMMIT (종료 직전 1회)
    COMMIT;

    --OPEN O_RESULT_CURSOR FOR
    --SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    DBMS_OUTPUT.PUT_LINE($$PLSQL_UNIT||' executed successfully. '||TO_CHAR(N_LOG_COUNT)||' records were processed.');

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
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
            'P_DQ_ID'           VALUE P_DQ_ID,
            'P_GROUP_ID'        VALUE P_GROUP_ID,
            'P_VALID_YN'        VALUE P_VALID_YN,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
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
END PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE;
/

-- ===== PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST" 
(
    p_DQ_ID                IN VARCHAR2,
    p_GROUP_ID             IN VARCHAR2,
    p_VALID_YN             IN VARCHAR2,
    p_CREATED_BY           IN VARCHAR2,
    p_LAST_UPDATED_BY      IN VARCHAR2
)
AS
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 05    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026/03/06     jcnam      [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
    n_history_seq   PLS_INTEGER;
    N_LOG_COUNT    PLS_INTEGER := 0;
    D_EVENT_DATE   DATE := SYSDATE;
    V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE    varchar2(4000);
    V_SQL_CODE     varchar2(100);
    V_SQL_ERRMSG   varchar2(1000);
    V_PROC_INPUT   VARCHAR2(4000 CHAR);
    V_LOG_MESSAGE  VARCHAR2(4000 CHAR);
    V_LOG_TYPE     VARCHAR2(30 CHAR) := 'E';
BEGIN
    v_log_type     := 'START';
    v_log_message  := '########## Start of procedure ##########';
    v_description  := '';
    d_event_date   := SYSDATE;

    PR_SCM_SYS_LOG_BATCH_CALL_TRAN($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    v_log_message := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    BEGIN
        n_history_seq := SEQ1_SCM_ADM_DQ_USER_GROUP_H.NEXTVAL;

        INSERT INTO SCM_ADM_DQ_USER_GROUP_H
        (
            HISTORY_SEQ,
            DQ_ID,
            GROUP_ID,
            VALID_YN,
            CREATED_BY,
            CREATION_DATE,
            LAST_UPDATED_BY,
            LAST_UPDATE_DATE
        )
        VALUES
        (
            n_history_seq,
            p_DQ_ID,
            p_GROUP_ID,
            p_VALID_YN,
            p_CREATED_BY,
            SYSDATE,
            p_LAST_UPDATED_BY,
            SYSDATE
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
                ROLLBACK;
            END IF;

            dbms_output.put_line($$plsql_unit || ' ERROR');
            dbms_output.put_line('SQLCODE : ' || sqlcode);
            dbms_output.put_line('SQLERRM : ' || sqlerrm);
            dbms_output.put_line('BACKTRACE: ' || dbms_utility.format_error_backtrace);

            V_LOG_MESSAGE := 'EXCEPTION';
            V_PROC_INPUT :=
                JSON_OBJECT(
                    'p_DQ_ID'           VALUE p_DQ_ID,
                    'p_GROUP_ID'        VALUE p_GROUP_ID,
                    'p_VALID_YN'        VALUE p_VALID_YN,
                    'p_CREATED_BY'      VALUE p_CREATED_BY,
                    'p_LAST_UPDATED_BY' VALUE p_LAST_UPDATED_BY
            );
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
                                V_LOG_TYPE,
                                N_LOG_COUNT,
                                V_LOG_MESSAGE,
                                V_DESCRIPTION,
                                D_EVENT_DATE,
                                V_PROC_INPUT,
                                V_SQL_CODE,
                                V_SQL_ERRMSG,
                                V_BACKTRACE
                                );
            RAISE;
    END;

    IF v_log_message IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('success');
    END IF;

    v_log_type     := 'END';
    v_log_message  := '########## END of procedure ##########';
    v_description  := '';
    d_event_date   := SYSDATE;

    PR_SCM_SYS_LOG_BATCH_CALL_TRAN($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
END;
/

-- ===== PR_DM_ADM_DQ_EXECUTE_HIST =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_EXECUTE_HIST" 
(
    P_DQ_ID                 IN  VARCHAR2,
    P_DQ_TEXT               IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_LAST_UPDATED_BY       IN  VARCHAR2
    -- ,
    -- O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_DM_ADM_DQ_EXECUTE_HIST
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 05    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026.03.25     jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
IS
    V_HISTORY_SEQ       PLS_INTEGER;

    -- LOG 용 변수 설정
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

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

    --------------------------------------------------------------------------------------------
    -- (1)
    /* HISTIRY INSERT */
    --------------------------------------------------------------------------------------------
    V_HISTORY_SEQ := SEQ1_SCM_ADM_DQ_EXECUTE_H.NEXTVAL;

    INSERT INTO SCM_MGR.SCM_ADM_DQ_EXECUTE_H
    (
         HISTORY_SEQ
        ,DQ_ID
        ,DQ_TEXT
        ,CREATED_BY
        ,CREATION_DATE
        ,LAST_UPDATED_BY
        ,LAST_UPDATE_DATE
    )
    VALUES
    (
         V_HISTORY_SEQ
        ,P_DQ_ID
        ,P_DQ_TEXT
        ,P_CREATED_BY
        ,SYSDATE
        ,P_LAST_UPDATED_BY
        ,SYSDATE
    );
    -- (1)

    N_LOG_COUNT := SQL%ROWCOUNT;

    -- COMMIT (종료 직전 1회)
    COMMIT;

    --OPEN O_RESULT_CURSOR FOR
    --SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    DBMS_OUTPUT.PUT_LINE($$PLSQL_UNIT||' executed successfully. '||TO_CHAR(N_LOG_COUNT)||' records were processed.');

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
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
            'P_DQ_ID'           VALUE P_DQ_ID,
            'P_DQ_TEXT'         VALUE SUBSTR(P_DQ_TEXT, 1, 500),
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
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
END PR_DM_ADM_DQ_EXECUTE_HIST;
/
