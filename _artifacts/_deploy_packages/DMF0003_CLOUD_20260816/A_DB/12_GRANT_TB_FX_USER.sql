-- SCM_MGR.TB_FX_USER SELECT 권한 — 앱 계정
-- [증상] 셀 콤보 5종이 code=-9994 "Sql Error" 로 조용히 실패 → 그리드가 CODE 를 raw 로 표시
--        TeambyDivisionAuth / SiteByEndCustomerAuth / EndCustomerByDivisionDeptAuth
--        / TeambyDivision / TeambyDivision2
-- [원인] 사내 실측 2026-08-15 — 권한이 SCMD_APP 에만 부여. 시노님은 있으나 시노님은 권한을 주지 않는다.
-- [적용] 환경별 앱 계정이 다르므로(사내 SCMD_APP / QA SCMQ_APP / DEV·운영 SCMP_APP)
--        존재하는 계정 전부에 부여한다. SCM_MGR 로 실행.
SET SERVEROUTPUT ON
BEGIN
  FOR r IN (SELECT USERNAME FROM ALL_USERS
             WHERE USERNAME IN ('SCMD_APP','SCMQ_APP','SCMP_APP')) LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT ON SCM_MGR.TB_FX_USER TO ' || r.USERNAME;
    DBMS_OUTPUT.PUT_LINE('GRANT SELECT ON SCM_MGR.TB_FX_USER TO ' || r.USERNAME);
  END LOOP;
END;
/
-- 검증 (SCMx_APP 행이 SELECT 로 나와야 한다)
SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS
 WHERE OWNER='SCM_MGR' AND TABLE_NAME='TB_FX_USER' ORDER BY 1,2;
