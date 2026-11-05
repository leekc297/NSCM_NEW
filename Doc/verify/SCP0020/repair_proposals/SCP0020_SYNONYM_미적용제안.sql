-- SCP0020 앱 계정(SCMP_APP) 시노님 미적용 제안 — 정합검증(CheckList)이 발견한 차단 원인. 적용은 보완실행 단계에서(검토 후).
-- 생성 2026-10-29 01:16 · 근거 Doc/verify/SCP0020/syn_check.csv

-- SCM_MST_LINE_SN (LineByOperation): SCMP_APP·PUBLIC 시노님 없음 — SCM_MGR 에는 시노님 →FP_MGR.SCM_LINE_M 로 존재
CREATE OR REPLACE SYNONYM SCMP_APP.SCM_MST_LINE_SN FOR FP_MGR.SCM_LINE_M;
-- SELECT 권한이 없으면: GRANT SELECT ON FP_MGR.SCM_LINE_M TO SCMP_APP;  (DBA_TAB_PRIVS 확인 후)
