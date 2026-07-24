CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_SAVE_TEXTBOX" 
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
END DMF0044_SAVE_TEXTBOX;