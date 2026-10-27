-- SYN_SCMP_APP_PLANT_COMPANY_DMF0005_20261025.sql
--   DMF0005 Sales Site Project Model — 그리드 Sales Plant 콤보(SALES_PLANT_DM) HTTP 500 "Sql Error"(-9994) 정정
--
-- 원인(2026-10-25 실측, 정합검증 W3 CRUD 실저장 중 발견):
--   BE 로그 ORA-00942: "SCMP_APP"."SCM_MST_PLANT_SN" 테이블 또는 뷰가 존재하지 않습니다.
--   콤보 SQL(SCM_ADM_CMBO_SQL_M)은 SCM_MGR 기준 시노님 SCM_MST_PLANT_SN / SCM_MST_COMPANY_SN 을 쓴다.
--   SCM_MGR 에는 두 시노님(→ FP_MGR.SCM_PLANT_M / SCM_COMPANY_M)이 있으나 앱계정 SCMP_APP 에는 없다(DBA_SYNONYMS 확인).
--   SELECT 권한은 역할 RL_FP_SEL 로 이미 보유(ROLE_TAB_PRIVS 확인) — 시노님만 누락.
--   영향: Sales Plant 후보 0건 → 화면 가드(salesCompanyGuard)가 입력 Plant 를 지움 → 신규행 저장 불가([Sales Plant] value is required).
--   같은 원인으로 CompanySalesSite·CompanySalesSite_DMF0005(SCM_MST_COMPANY_SN)도 실패한다.
-- 조치: 시노님 2건 신설(비파괴 — 기존 객체 변경 없음). 이미 있으면 건너뛴다(멱등).

DECLARE
  PROCEDURE mk(p_syn VARCHAR2, p_tab VARCHAR2) IS
    n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO n FROM DBA_SYNONYMS WHERE OWNER = 'SCMP_APP' AND SYNONYM_NAME = p_syn;
    IF n = 0 THEN
      EXECUTE IMMEDIATE 'CREATE SYNONYM SCMP_APP.' || p_syn || ' FOR FP_MGR.' || p_tab;
      DBMS_OUTPUT.PUT_LINE('CREATED SCMP_APP.' || p_syn || ' -> FP_MGR.' || p_tab);
    ELSE
      DBMS_OUTPUT.PUT_LINE('SKIP (exists) SCMP_APP.' || p_syn);
    END IF;
  END;
BEGIN
  mk('SCM_MST_PLANT_SN',   'SCM_PLANT_M');
  mk('SCM_MST_COMPANY_SN', 'SCM_COMPANY_M');
END;
/

-- 검증: 2행(SCM_MST_COMPANY_SN → FP_MGR.SCM_COMPANY_M, SCM_MST_PLANT_SN → FP_MGR.SCM_PLANT_M)
SELECT OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME
  FROM DBA_SYNONYMS
 WHERE OWNER = 'SCMP_APP'
   AND SYNONYM_NAME IN ('SCM_MST_PLANT_SN', 'SCM_MST_COMPANY_SN')
 ORDER BY SYNONYM_NAME;
