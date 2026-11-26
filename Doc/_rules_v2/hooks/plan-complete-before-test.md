# Hook — 계획한 구현을 다 끝낸 뒤 시험 (plan-complete-before-test)

사용자 지시 2026-11-25: "아직 잔여 작업이 D2, D3, D4 가 있는데 SCP0005 를 돌렸다는 점이 잘못된 점 입니다. 필요한 작업이 있으면 먼저 전체를 진행하고 테스트를 진행하도록 하게 해주세요. 이부분은 RULE, HOOK, 하네스에도 등록해서 반복되는 실수를 하지 않도록 해주세요."

## 규칙

1. 승인된 계획(플랜)의 구현 항목은 시작할 때 계획 진행 기록에 등록한다: `python tools/Harness/plan_state.py set "<계획 이름>" <항목>...`
2. 항목 구현이 끝날 때마다 표시한다: `python tools/Harness/plan_state.py done <항목>`
3. 남은 항목이 1개라도 있으면 화면 측정·통합 시험을 하지 않는다. 대상 = run_verify.py, checklist_run.py, row_run.py, e2e_suite.py, eg_chain.py, run-e2e.cmd, playwright test
4. 구현 중에 해도 되는 것 = 컴파일 검사(tsc), 자기 시험(--selftest), engine_selfcheck.py, VM test/run_all.js. 화면을 열거나 DB 에 쓰는 시험은 하지 않는다
5. 항목을 빼려면 사용자가 빼라고 한 경우만: `plan_state.py drop <항목> "<사유>"`
6. 사용자가 '지금 시험하라'고 직접 말한 경우만 명령 앞에 `ALLOW_TEST_BEFORE_PLAN=1`
7. 모든 항목이 끝나면 시험하고, 시험까지 끝나면 `plan_state.py clear`

## 실행 장치

- 실행 hook: `.claude/hooks/check-plan-before-test.ps1` (PreToolUse Bash, PowerShell) — 남은 항목이 있으면 위 명령을 거부
- 하네스: `tools/Harness/plan_state.py`, 기록 `tools/Harness/plan_state.json`
- VM AI 실행 룰: `tools/VibeManager/run-rule.js` 14번(VM, VMW, VMO 의 모든 AI 호출 앞)
- 규칙 원장: `tools/VibeManager/rules/10_RULES_KEEP.md` A-16, VMO 사용자 규칙
