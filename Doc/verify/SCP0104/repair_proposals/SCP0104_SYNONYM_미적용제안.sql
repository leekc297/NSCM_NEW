-- SCP0104 앱 계정(SCMP_APP) 시노님 미적용 제안 — 정합검증(CheckList)이 발견한 차단 원인. 적용은 보완실행 단계에서(검토 후).
-- 생성 2026-11-13 09:40 · 근거 Doc/verify/SCP0104/syn_check.csv

-- MENU SCP0104 (SCM_ADM_MNU_M): META_MISSING — 메뉴 메타(SCM_ADM_MNU_M) 에 이 화면 행이 없음(또는 USE_YN=N)  ※ 대상 객체를 확인해 수동 작성

-- PROC_M SCP0104 (SCM_ADM_PROC_M/API_M): META_MISSING — 이 화면의 PROC_M/API_M 배선 행이 없음  ※ 대상 객체를 확인해 수동 작성

-- SCP_MST_CAPA_LINE_MDL_V (CapaDummyCode_SCP_ALL): PRIV_MISSING — SCMP_APP.SCP_MST_CAPA_LINE_MDL_V(시노님)→SCM_MGR.SCP_MST_CAPA_LINE_MDL_V (SELECT 권한 없음 — 직접·PUBLIC·롤 ['RL_DIC', 'RL_FP_SEL', 'RL_INF_SEL', 'RL_SCM_DML', 'RL_SES', 'RL_SYN'] 모두)  ※ 대상 객체를 확인해 수동 작성
