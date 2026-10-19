-- PKG_DMF0003 — standalone 복원 (DROP 직전 원문 = 생성 시점 DB 재조회본 · SCM_MGR 로 실행)
-- ⚠ STEP 1 백업이 아니라 현재 원문을 쓴다: STEP 2 에서 바뀐 standalone(예: DMF0043_GET_MAIN_SPREAD_TITLE → _CORE 호출)을 옛 본문으로 되돌리면 INVALID
SET DEFINE OFF
-- SOURCE-FRESH: SCM_MGR.SCM_ADM_MAIL_SEND PROCEDURE LAST_DDL=2026-09-02 17:30:39 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."SCM_ADM_MAIL_SEND" 

(
    P_TO_MAIL       VARCHAR2
   , P_SUBJECT       VARCHAR2
   , P_BODY_CONTENTS VARCHAR2
   , P_HTML_YN       VARCHAR2
)
/*
    * Program ID   : SCM_ADM_MAIL_SEND
    * Description  : MAIL 발송
    * Program History
    *===================================================================================================
    *   Date       In Charge      Description
    *===================================================================================================
    * 2018/02/21   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
    * 2026/03/23   김준규   [PJ20264226] NextSCM Pilot 설계 및 개발
    *
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
    */
 AS

    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE     VARCHAR2(30 CHAR);
    N_LOG_COUNT    INTEGER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    D_EVENT_DATE   DATE;
    V_TO_MAIL      VARCHAR2(4000 CHAR);
    V_IN_PARA_DATA CLOB;
    V_STEP         VARCHAR2(4000 CHAR) := NULL;
    V_SUBJECT      VARCHAR2(4000 CHAR) := NULL;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT||'.' ||UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := JSON_OBJECT('p_to_mail' VALUE P_TO_MAIL
                                 , 'p_subject' VALUE P_SUBJECT
                                 , 'p_body_contents' VALUE P_BODY_CONTENTS
                                 , 'p_html_yn' VALUE P_HTML_YN);

    /* LOG 용 변수 설정 */

    /* 시작 LOG */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN

        V_TO_MAIL := NULL;
        V_TO_MAIL := P_TO_MAIL;

        IF SYS_CONTEXT('USERENV', 'DB_NAME') NOT LIKE 'OCGSCMP%' THEN
            V_SUBJECT := 'DEV Oracle 개발서버 ' ||P_SUBJECT;
        ELSE
            V_SUBJECT := P_SUBJECT;
        END IF;

        PKG_SEND_MAIL.P_SEND_MAIL(P_TO_MAIL       => P_TO_MAIL
                                 , P_SUBJECT       => V_SUBJECT
                                 , P_BODY_CONTENTS => P_BODY_CONTENTS
                                 , P_HTML_YN       => P_HTML_YN
                                 , P_SENDER        => 'scmpi@lgensol.com'
                                 , P_CC_MAIL       => NULL
                                 , P_BCC_MAIL      => NULL);

        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    END;


EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                            , 'ERROR'
                            , 0
                            , SQLERRM
                            , NULL
                            , SYSDATE
                            , P_IN_PARA_DATA  => V_IN_PARA_DATA
                            , P_SQL_ERR_CODE  => SQLCODE
                            , P_SQL_ERR_MSG   => SQLERRM
                            , P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        RAISE_APPLICATION_ERROR(-20001
                               , '[' ||V_PROGRAM_NAME||'] SQLCODE=' ||SQLCODE||' / SQLERRM=' ||SQLERRM||' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||' / PARAMS=' ||V_IN_PARA_DATA);
END;
/
-- 권한 (SCM_MGR)
GRANT EXECUTE ON SCM_MGR.SCM_ADM_MAIL_SEND TO SCMP_APP;
-- 시노님 (SCMP_APP 로 실행할 것)
-- CREATE OR REPLACE SYNONYM SCMP_APP.SCM_ADM_MAIL_SEND FOR SCM_MGR.SCM_ADM_MAIL_SEND;
-- PROC_M (standalone PROC_NM · 멱등 MERGE)
COMMIT;
