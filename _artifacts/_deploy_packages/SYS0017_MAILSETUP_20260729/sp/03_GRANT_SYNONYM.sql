-- 03_GRANT_SYNONYM.sql — 【SCM_MGR 계정 세션】 애플리케이션 계정에 실행 권한 부여 (멱등)
--
-- ⚠️ 애플리케이션(BE 접속) 계정은 환경마다 다르다 — 이름을 상수로 박지 말 것.
--      · 클라우드 : SCMP_APP   ← 2026-07-30 사용자 확인 (변경됨)
--      · 사내     : SCMD_APP
--    존재하는 계정에만 GRANT 하도록 동적 처리한다 (없는 계정에 GRANT 하면 ORA-01917).

DECLARE
  V_CNT NUMBER := 0;
BEGIN
  FOR R IN (SELECT USERNAME FROM ALL_USERS
             WHERE USERNAME IN ('SCMP_APP','SCMD_APP') ORDER BY USERNAME) LOOP
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON SCM_MGR.PKG_SYS0017 TO '||R.USERNAME;
    DBMS_OUTPUT.PUT_LINE('GRANT EXECUTE -> '||R.USERNAME);
    V_CNT := V_CNT + 1;
  END LOOP;
  IF V_CNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20001,
      'SCMP_APP / SCMD_APP 둘 다 없음 — 이 환경의 애플리케이션 계정을 확인하고 수동 GRANT 할 것');
  END IF;
END;
/

-- 확인 — GRANTEE 에 이 환경의 애플리케이션 계정(클라우드=SCMP_APP)이 있어야 한다
SELECT GRANTEE, PRIVILEGE, GRANTOR FROM ALL_TAB_PRIVS WHERE TABLE_NAME = 'PKG_SYS0017';

-- ⚠️ SYNONYM 생성은 이 파일에 없다 (SCM_MGR 로는 ORA-01031).
--    → **`sp/04_APP_SYNONYM_ONLY.sql` 을 애플리케이션 계정으로 별도 실행**해야 한다.
--       클라우드는 **SCMP_APP** 세션. 이것이 없으면 조회 시 PLS-00201 → -9994.
