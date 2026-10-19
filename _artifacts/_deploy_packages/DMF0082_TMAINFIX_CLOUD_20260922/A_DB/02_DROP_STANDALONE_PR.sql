-- ============================================================================
-- [DMF0082 TMAINFIX 2026-09-22] 02 — standalone PR_DM_PLN_CFM_TO_MKT_FCST 삭제 (+ 가리키는 시노님)
--
--   근거 : 2026-09-15 UIPKG 로 PKG_DMF0082.P_PR_DM_PLN_CFM_TO_MKT_FCST 에 취합 완료.
--          DMF0082 SAVE 는 PKG 내부판만 호출. standalone 은 호출자 없는 잔존본.
--   사내 실측(2026-09-22 ZIOUI1) : 의존자 0 / 소스 참조 = BALANCE_CREATE 주석 1건 / JOB 0 / PROC_M 0 / BE 0
--   ⚠ 반드시 00_PRECHECK [E] 가 EXPECT 와 일치할 때만 실행.
--
--   멱등 : 시노님·프로시저가 이미 없으면 SKIP 메시지만 출력 (ORA-01434 / ORA-04043 무시).
--   순서 : 시노님 먼저 — 프로시저를 먼저 지우면 ALL_SYNONYMS 에서 대상 시노님이 안 보이게 된다(사내 실측).
--   권한 : EXECUTE/DEBUG GRANT 는 DROP PROCEDURE 시 자동 소멸.
-- ============================================================================
SET SERVEROUTPUT ON

DECLARE
    v_cnt PLS_INTEGER := 0;
BEGIN
    FOR r IN (SELECT OWNER, SYNONYM_NAME
                FROM ALL_SYNONYMS
               WHERE TABLE_OWNER = 'SCM_MGR'
                 AND TABLE_NAME  = 'PR_DM_PLN_CFM_TO_MKT_FCST')
    LOOP
        IF r.OWNER = 'PUBLIC' THEN
            EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM "' || r.SYNONYM_NAME || '"';
        ELSE
            EXECUTE IMMEDIATE 'DROP SYNONYM "' || r.OWNER || '"."' || r.SYNONYM_NAME || '"';
        END IF;
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('DROPPED SYNONYM ' || r.OWNER || '.' || r.SYNONYM_NAME);
    END LOOP;
    IF v_cnt = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP : 대상 시노님 없음');
    END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE SCM_MGR.PR_DM_PLN_CFM_TO_MKT_FCST';
    DBMS_OUTPUT.PUT_LINE('DROPPED PROCEDURE SCM_MGR.PR_DM_PLN_CFM_TO_MKT_FCST');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -4043 THEN
            DBMS_OUTPUT.PUT_LINE('SKIP : PR_DM_PLN_CFM_TO_MKT_FCST 이미 없음');
        ELSE
            RAISE;
        END IF;
END;
/
