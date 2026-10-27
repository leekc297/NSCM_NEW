-- 10_APPLY — SCMP_APP 시노님 2건 신설 (전체 F5, 값 입력 없음, 멱등·비파괴)
--   SCMP_APP.SCM_MST_PLANT_SN   → FP_MGR.SCM_PLANT_M   (콤보 SALES_PLANT_DM · PlantByDivisionCompany 등)
--   SCMP_APP.SCM_MST_COMPANY_SN → FP_MGR.SCM_COMPANY_M (콤보 CompanySalesSite · CompanySalesSite_DMF0005 등)
--   이미 있으면 SKIP · 원본 테이블이 없으면 그 건만 중단(나머지는 진행) · 기존 객체 변경 없음
--   읽기 권한은 역할 RL_FP_SEL 로 보유(사내 ZIOUI1 ROLE_TAB_PRIVS 확인) — 클라우드는 90_VERIFY V2 로 확인
SET SERVEROUTPUT ON
SET DEFINE OFF
DECLARE
    PROCEDURE mk(p_syn VARCHAR2, p_tab VARCHAR2) IS
        n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM ALL_SYNONYMS WHERE OWNER = 'SCMP_APP' AND SYNONYM_NAME = p_syn;
        IF n > 0 THEN
            DBMS_OUTPUT.PUT_LINE('SKIP (이미 있음) SCMP_APP.' || p_syn);
            RETURN;
        END IF;
        SELECT COUNT(*) INTO n FROM ALL_OBJECTS WHERE OWNER = 'FP_MGR' AND OBJECT_NAME = p_tab AND OBJECT_TYPE IN ('TABLE', 'VIEW');
        IF n = 0 THEN
            DBMS_OUTPUT.PUT_LINE('중단 — 원본 FP_MGR.' || p_tab || ' 없음(또는 조회 권한 없음). SCMP_APP.' || p_syn || ' 미생성 · 결과 회신');
            RETURN;
        END IF;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE SYNONYM SCMP_APP.' || p_syn || ' FOR FP_MGR.' || p_tab;
            DBMS_OUTPUT.PUT_LINE('CREATED SCMP_APP.' || p_syn || ' -> FP_MGR.' || p_tab);
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('중단 — SCMP_APP.' || p_syn || ' 생성 실패: ' || SQLERRM || ' · 결과 회신');
        END;
    END;
BEGIN
    mk('SCM_MST_PLANT_SN',   'SCM_PLANT_M');
    mk('SCM_MST_COMPANY_SN', 'SCM_COMPANY_M');
END;
/
