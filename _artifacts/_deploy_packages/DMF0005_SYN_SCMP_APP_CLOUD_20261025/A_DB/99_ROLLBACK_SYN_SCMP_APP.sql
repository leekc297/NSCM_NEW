-- 99_ROLLBACK — 10_APPLY 가 만든 SCMP_APP 시노님 2건 제거 (전체 F5, 값 입력 없음)
--   대상이 FP_MGR.SCM_PLANT_M / SCM_COMPANY_M 인 경우에만 DROP(다른 대상을 가리키는 동명 시노님은 손대지 않음)
--   ⚠ 원복하면 DMF0005 Sales Plant·Company 콤보가 다시 ORA-00942 로 실패한다
SET SERVEROUTPUT ON
SET DEFINE OFF
DECLARE
    PROCEDURE rm(p_syn VARCHAR2, p_tab VARCHAR2) IS
        n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM ALL_SYNONYMS
         WHERE OWNER = 'SCMP_APP' AND SYNONYM_NAME = p_syn AND TABLE_OWNER = 'FP_MGR' AND TABLE_NAME = p_tab;
        IF n = 0 THEN
            DBMS_OUTPUT.PUT_LINE('SKIP (없음 또는 다른 대상) SCMP_APP.' || p_syn);
            RETURN;
        END IF;
        BEGIN
            EXECUTE IMMEDIATE 'DROP SYNONYM SCMP_APP.' || p_syn;
            DBMS_OUTPUT.PUT_LINE('ROLLED BACK — DROP SCMP_APP.' || p_syn);
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('중단 — SCMP_APP.' || p_syn || ' 제거 실패: ' || SQLERRM || ' · 결과 회신');
        END;
    END;
BEGIN
    rm('SCM_MST_PLANT_SN',   'SCM_PLANT_M');
    rm('SCM_MST_COMPANY_SN', 'SCM_COMPANY_M');
END;
/
