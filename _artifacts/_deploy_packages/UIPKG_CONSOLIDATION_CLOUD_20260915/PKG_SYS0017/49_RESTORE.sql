-- PKG_SYS0017 — standalone 복원 (DROP 직전 원문 = 생성 시점 DB 재조회본 · SCM_MGR 로 실행)
-- ⚠ STEP 1 백업이 아니라 현재 원문을 쓴다: STEP 2 에서 바뀐 standalone(예: DMF0043_GET_MAIN_SPREAD_TITLE → _CORE 호출)을 옛 본문으로 되돌리면 INVALID
SET DEFINE OFF
-- SOURCE-FRESH: SCM_MGR.PR_SCM_ADM_RECIPIENT_ASSIGN_HIST PROCEDURE LAST_DDL=2026-09-15 18:45:01 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."PR_SCM_ADM_RECIPIENT_ASSIGN_HIST" 

(
    P_USE_TYPE        IN VARCHAR2
  , P_CATEGORY_ID     IN VARCHAR2
  , P_USER_ID         IN VARCHAR2
  , P_CREATED_BY      IN VARCHAR2
  , P_CREATION_DATE   IN VARCHAR2
  , P_LAST_UPDATED_BY IN VARCHAR2
)
/*
 * Program ID   : PR_SCM_ADM_RECIPIENT_ASSIGN_HIST
 * Description  : SMS/MAIL 수신자 History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.20   ygkim      Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
 */
AS
    N_HISTORY_SEQ INTEGER;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'PR_SCM_ADM_RECIPIENT_ASSIGN_HIST';
    V_LOG_TYPE VARCHAR2(30 CHAR);
    V_LOG_MESSAGE VARCHAR2(1000 CHAR);
    V_DESCRIPTION VARCHAR2(500 CHAR);
    D_EVENT_DATE DATE;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    /* 시작 LOG */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
        SELECT SEQ1_SCM_ADM_RECIPIENT_ASSIGN_H.NEXTVAL
          INTO N_HISTORY_SEQ
          FROM DUAL;

        BEGIN
            INSERT
              INTO SCM_ADM_RECIPIENT_ASSIGN_H
                 ( HISTORY_SEQ
                 , USE_TYPE_CODE
                 , CATEGORY_ID
                 , USER_ID
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            VALUES ( N_HISTORY_SEQ
                   , P_USE_TYPE
                   , P_CATEGORY_ID
                   , P_USER_ID
                   , P_CREATED_BY
, TO_DATE(P_CREATION_DATE, 'YYYYMMDD')   -- ★ 여기만 바뀜 (원래: P_CREATION_DATE)
--                   , P_CREATION_DATE
                   , P_LAST_UPDATED_BY
                   , SYSTIMESTAMP );
        END;
    END;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_USE_TYPE' VALUE P_USE_TYPE
          , 'P_CATEGORY_ID' VALUE P_CATEGORY_ID
          , 'P_USER_ID' VALUE P_USER_ID
          , 'P_CREATED_BY' VALUE P_CREATED_BY
          , 'P_CREATION_DATE' VALUE P_CREATION_DATE
          , 'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', N_LOG_COUNT, 'EXCEPTION'
              , '', SYSDATE, V_PROC_INPUT
              , V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001
          , '[' ||$$PLSQL_UNIT||'] SQLCODE=' ||V_SQL_CODE||
            ' / SQLERRM=' ||V_SQL_ERRMSG||
            ' / BACKTRACE=' ||V_BACKTRACE||
            ' / PARAMS=' ||V_PROC_INPUT
        );
        RAISE;

END PR_SCM_ADM_RECIPIENT_ASSIGN_HIST;
/
-- 권한 (SCM_MGR)
GRANT EXECUTE ON SCM_MGR.PR_SCM_ADM_RECIPIENT_ASSIGN_HIST TO SCMP_APP;
-- 시노님 (SCMP_APP 로 실행할 것)
-- CREATE OR REPLACE SYNONYM SCMP_APP.PR_SCM_ADM_RECIPIENT_ASSIGN_HIST FOR SCM_MGR.PR_SCM_ADM_RECIPIENT_ASSIGN_HIST;
-- PROC_M (standalone PROC_NM · 멱등 MERGE)
COMMIT;
