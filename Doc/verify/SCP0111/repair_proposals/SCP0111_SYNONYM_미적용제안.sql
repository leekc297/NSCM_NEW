-- SCP0111 앱 계정(SCMP_APP) 시노님 미적용 제안 — 정합검증(CheckList)이 발견한 차단 원인. 적용은 보완실행 단계에서(검토 후).
-- 생성 2026-10-29 09:47 · 근거 Doc/verify/SCP0111/syn_check.csv

-- SCM_LINE_HIERARCHY_CPS_V_SN (LineByOperationPlantId_SCP_ALL): PRIV_MISSING — SCMP_APP.SCM_LINE_HIERARCHY_CPS_V_SN(시노님)→FP_MGR.SCM_LINE_HIERARCHY_CPS_V (SELECT 권한 없음 — 직접·PUBLIC·롤 ['RL_DIC', 'RL_FP_SEL', 'RL_INF_SEL', 'RL_SCM_DML', 'RL_SES', 'RL_SYN'] 모두)  ※ 대상 객체를 확인해 수동 작성
