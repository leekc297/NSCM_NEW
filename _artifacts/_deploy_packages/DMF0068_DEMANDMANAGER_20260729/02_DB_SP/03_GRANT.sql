-- 03_GRANT.sql — 【SCM_MGR 계정 세션】 애플리케이션 계정에 PKG_DMF0068 실행 권한 부여 (멱등)
--
-- ⚠️ 애플리케이션(BE 접속) 계정은 환경마다 다르다 — 이름을 상수로 박지 말 것.
--      · 클라우드 QA  : **SCMQ_APP** ← 2026-08-06 사용자 확인
--      · 클라우드 DEV : SCMP_APP    ← 2026-07-30 사용자 확인
--      · 사내         : SCMD_APP
--    존재하는 계정 전부에 GRANT (없는 계정에 GRANT 하면 ORA-01917 — 목록 필터로 회피).

DECLARE
  V_CNT NUMBER := 0;
BEGIN
  FOR R IN (SELECT USERNAME FROM ALL_USERS
             WHERE USERNAME IN ('SCMQ_APP','SCMP_APP','SCMD_APP') ORDER BY USERNAME) LOOP
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON SCM_MGR.PKG_DMF0068 TO '||R.USERNAME;
    DBMS_OUTPUT.PUT_LINE('GRANT EXECUTE -> '||R.USERNAME);
    V_CNT := V_CNT + 1;
  END LOOP;
  IF V_CNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20001,
      'SCMQ_APP / SCMP_APP / SCMD_APP 전부 없음 — 이 환경의 애플리케이션 계정을 확인하고 수동 GRANT 할 것');
  END IF;
END;
/

-- 확인 — GRANTEE 에 이 환경의 애플리케이션 계정(QA=SCMQ_APP / DEV=SCMP_APP)이 있어야 한다
SELECT GRANTEE, PRIVILEGE, GRANTOR FROM ALL_TAB_PRIVS WHERE TABLE_NAME = 'PKG_DMF0068';

-- ⚠️ SYNONYM 생성은 이 파일에 없다 (SCM_MGR 로는 ORA-01031).
--    → **`02_DB_SP/04_APP_SYNONYM_ONLY.sql` 을 애플리케이션 계정으로 별도 실행**할 것.
--       클라우드는 **SCMP_APP** 세션. 없으면 조회 시 PLS-00201 → -9994.
