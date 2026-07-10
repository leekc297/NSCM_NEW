-- ============================================================================
-- DMF0014 클라우드(SCMD_APP) 실행권한 — 신규/재배포 객체 GRANT + SYNONYM
--   클라우드 BE = SCMD_APP 계정 접속. CREATE OR REPLACE 는 기존 GRANT 를 보존하나,
--   객체가 클라우드 DB 에 신규이거나 GRANT 누락 시 -9994 방지 위해 재적용.
-- ============================================================================
GRANT EXECUTE ON SCM_MGR.PKG_DMF0014                        TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.PR_DM_PLN_CUST_FCST_TO_MKT_FCST     TO SCMD_APP;

-- SYNONYM (SCMD_APP 스키마에서 미접두 참조) — 없으면 생성
CREATE OR REPLACE SYNONYM SCMD_APP.PKG_DMF0014                    FOR SCM_MGR.PKG_DMF0014;
CREATE OR REPLACE SYNONYM SCMD_APP.PR_DM_PLN_CUST_FCST_TO_MKT_FCST FOR SCM_MGR.PR_DM_PLN_CUST_FCST_TO_MKT_FCST;

-- 검증
SELECT TABLE_NAME, PRIVILEGE FROM DBA_TAB_PRIVS
 WHERE GRANTEE='SCMD_APP' AND TABLE_NAME IN ('PKG_DMF0014','PR_DM_PLN_CUST_FCST_TO_MKT_FCST');
