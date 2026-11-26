# 개념 재정립: 창 다시 로드 뒤 작업 재개(reloadResume)

## 목적(사용자 원문)
- U13(2026-11-20 11:14): "VM 에서 작업을 진행하다가 reload 작업을 하면 작업하던 모든 task 가 중지됩니다. reload  후 작업을 재개할 수 없나요? 작업을 재개할 수 있으면 VM 업무 작업에 표기하고 작업재개 버턴 활성화 되도록 해주세요, workbench에서도 보이고 작업재개 버턴 활성화 되도록 해주세요."
- U16(2026-11-20 14:16): "다시 로드 후 작업 재개 시 WORKBENCH 에서는 재개 되는데 VMW 에 재개된 작업이 보이지 않습니다."
- U17(2026-11-20 14:30): "VMW 에 J20261120_115055 목록은 보이지 않습니다."
- U18(2026-11-20 15:04): "CHECKLIST 가 아닌 UI 생성, UI 보완 작업일 때의 작업재개도 중단된 시점이나 그 바로 이전 시점부터 재개되도록 되어야 합니다. 이것도 같이 고민해주세요."
- U23(2026-11-20 19:03): "VMW 에서 작업재개 했는데 WORKBENCH 에서 진행상태가 보이지 않습니다. 확인 요청 합니다."
- 11-23 사용자(CHANGELOG.md:418): "VMO 상황판 18:46 재개 대기 건을 지우려 했으나 Workbench 에도 보이지 않음."
- VMO 목적(memory feedback_vmo_self_heal_restart_20261120): "VMO 대기열·진행 상태는 창 다시 로드를 넘어 이어져야 한다. VMO 가 잘못 멈춘 실행은 끊긴 단계부터 재개할 수 있게 되돌린다"

## 지금 개념
창 다시 로드로 끊긴 실행을 이어 돌리려고, 끊긴 실행의 상태를 세 곳에 따로 둔다. 각 창은 자기 기준으로 그 상태를 찾아 보여 준다.
- VM 체인 단계 기록: .vibe/orch/chain_progress/<runId>.json. 단계 시작마다 쓰고, 창이 닫힐 때 interruptedAt, resumeFrom 을 남긴다(workbench.js:26-28, :156-166).
- VMW 작업 기록: .vibe/jobs/<job>/job.json. 실행 중이던 작업을 불러올 때 '중단됨'으로 바꾸고 화면을 대기로 되돌린다(job-runner.js:93-97). 화면 카드의 재개 표시 s.resume 은 화면 상태가 '대기'일 때만 단계 기록에서 계산해 붙이고, 아니면 지운다(job-runner.js:86-88).
- 단계 안 재개: 측정 도구는 Doc/verify/<ID>/_resume/progress.json 을 쓴다(run_verify.py:402-413, :602). AI 단계는 세션 이어받기를 쓰고, 그 밖의 스크립트 단계는 원문에 VM_RESUME 이 있는지로 판단한다(workbench.js:71-99).
- 찾는 기준이 창마다 다름: Workbench 재개 띠는 화면 ID로 찾는다(workbench.js:1101). VMO 상황판은 전체 목록을 본다(workbench.js:2975). VMW 는 작업 ID와 화면 상태 '대기'로 찾는다(job-runner.js:87-88, jobs.js:83).

## 어긋난 근거
| 사례 | 근거 | L3 조치 | 그 뒤 |
|---|---|---|---|
| U13 재개 수단 없음 | user_checks U13, 사다리 L3,usercheck,U13 근거 12건 | 단계 기록, 재개 단추, 감지기(20261120114810_SELF). 판정 기준을 중단 사건으로 다시 세움(CHANGELOG.md:882-884) | L3 묶음 11-20 20:04 해결. L4,struct,usercheck,U13 은 11-21 15:05 해결. 재발 판정 개념은 concept_20261121_L4_struct_usercheck_U13.md 에서 다룸 |
| U16, U17 VMW 에 재개된 작업이 안 보임 | user_checks U16, U17 | job-runner.js:254 begin 이 'start' 를 보냄, jobs.js:58, :67 이 받은 작업을 표시 | L3,usercheck,U16 은 11-21 20:45 해결. U17 은 pending-detector 상태로 감지기 없음 |
| U18 단계 안을 처음부터 다시 돎 | user_checks U18, CHANGELOG.md:1150-1152 | resumePlan 이 재시작 여부를 표시(workbench.js:89-99). run_verify 단계 지문과 resume.refuse 사건(CHANGELOG.md:427-430) | L3,usercheck,U18 은 11-22 02:00 해결. events.jsonl 의 resume.refuse 는 0줄 |
| 18:3x VMW 재개가 1단계부터 돎 | CHANGELOG.md:1019-1025. 기록 SCP0028_1795165449104 단계 4/8 이 새 실행에서 1/8 로 시작 | runOne 이 단계 기록을 직접 찾음(job-runner.js:142-152). 입장 대기 중 decorate 가 s.resume 을 지운 것이 원인 | 측정 도구 _resume 이 새 실행 ID로 덮여 4/8 지점을 잃음 |
| U23 Workbench 에 재개 진행이 안 보임 | user_checks U23, CHANGELOG.md:986-995 | 남은 프로세스 정리(reapOrphans), postResume 이 저장된 화면 ID를 씀 | L3,usercheck,U23 은 11-21 02:00 해결 |
| 16:06 VMO R14 가 재개 체인을 '중지 뒤 계속 실행'으로 멈춤 | CHANGELOG.md:1125-1127, events.jsonl 1092~1176 | 개입 장부, 오판 복구 restoreInterrupted(job-runner.js:300-305) | 감시기가 옛 프로세스의 중지 기록과 새 실행을 runId 계보 없이 묶은 것이 원인 |
| 11-23 18:46 재개 대기 기록이 VMO 에만 보임 | CHANGELOG.md:417-425. events.jsonl:3221 progress.cut runId WB1_1795427182442_ai, screen '' | screenIdOf, resultDone 삭제, VMO 🗑 단추 | 11-20 다섯 건 뒤에 같은 형태(한 창에만 보임)로 다시 남. user_checks 에는 reloadResume 목적 키로 기록되지 않음 |

정리
- 다섯 지적과 11-20 18:3x, 11-23 18:46 사례에는 공통점이 있다. 끊긴 실행 하나를 세 기록이 따로 들고 있다. 창마다 다른 열쇠(작업 ID와 화면 상태, 화면 ID, 전체 목록)로 찾고, 한 쪽에서 파생값을 지우거나 비워 다른 창과 어긋난다.
- 고친 건마다 파생값 하나를 맞춘 수정이었다. 11-20 에 CHANGELOG 의 재개 관련 절이 12개 생겼다(절 제목에 '재개' 또는 '다시 로드'가 든 절 기준).
- 11-21 뒤 실사용 재개(events.jsonl chain.resume)는 0줄이다. 마지막 재개는 11-20 20:46:19 다. 지금 개념이 실사용에서 맞는지는 미확인이다.

## 대안 개념
### A 재개 원장 1곳, 세 창은 읽기만
- 개념: 끊긴 실행은 runId 계보(resumedFrom) 하나로 표현하고, 그 상태(running, cut, resumed, done, dropped)는 chain_progress 원장 한 곳에만 쓴다. job.json 화면 카드, Workbench 재개 띠, VMO 상황판은 같은 조회 함수 하나로 원장을 읽어 표시만 한다. 단계 안 재개 지점(측정 도구 _resume 경로와 VERIFY_RUN_ID, AI 세션 ID)은 원장에 참조로 둔다.
- 사례별 결과
  - 18:3x: 화면 상태와 상관없이 원장의 cut 이 재개 근거라 지워질 값이 없다.
  - U16, U17, U23: 세 창이 같은 runId 계열을 읽어 한 창에만 보이는 경우가 없다.
  - 11-23 18:46: 쓸 때 화면 ID를 필수로 두어 빈 값 기록이 생기지 않는다.
  - 16:06 R14: 감시기가 원장의 계보로 재개 실행을 가린다.
- 새로 할 일: 원장 상태 필드와 계보 필드, 쓰기 때 화면 ID 필수 검사, 조회 함수 1개. 측정 도구 _resume 을 새 실행이 덮기 전에 원장의 VERIFY_RUN_ID 와 대조. 감지기 U13, U16, U17, U23 을 원장 대조 하나로 다시 정의.
- 버리는 것: job.json 의 s.resume 저장과 decorate 의 삭제 규칙, '화면 상태가 대기일 때만 재개 표시' 조건, 창별 조회 규칙.

### B 끊기지 않는 실행(분리 실행기)
- 개념: 체인 실행을 VS Code 확장 호스트 밖 프로세스로 옮겨 창을 다시 로드해도 실행이 이어진다. 창은 다시 붙어 진행을 읽기만 한다. 재개는 VS Code 종료와 PC 재시작 때만 쓴다.
- 사례별 결과: 다시 로드 사례(U13, U16, U23, 18:3x)는 끊김 자체가 없어진다. U18 과 PC 재시작 경우는 그대로 남는다.
- 근거: 11-20 18:47 실행의 checklist_run, run_verify, Playwright 는 다시 로드 뒤에도 살아 있었다(CHANGELOG.md:988). 다만 Claude CLI 와 창 출력 연결을 분리할 수 있는지는 미확인이다.
- 새로 할 일: 실행기 프로세스, 창 접속과 해제, 실행기 감시. 버리는 것: 다시 로드 때 dispose 가 중단으로 바꾸는 경로(job-runner.js:364, workbench.js:156-166).
- 부담: 체인 실행 코드를 옮겨야 한다. 실행기가 고아가 되면 VMO 가 새로 감시해야 한다.

### C 개념 유지, 사다리 축 판정만 보정
- 개념: 재개 구조는 그대로 둔다. L4 같은 축 판정(orch-ladder.js:103-105)이 감지기 효력 뒤 지적과 미해결 지적만 세게 한다.
- 사례별 결과: 이번 묶음 5건은 모두 해결된 L3 묶음에 속해 L4 후보에서 빠진다. 11-23 18:46 사례처럼 목적 키 없이 들어온 재발은 여전히 묶이지 않는다.
- 버리는 것: 없음. 한계: 세 기록이 따로 도는 구조가 남아 다음 파생값 어긋남을 막지 못한다.

## 권장안과 이유
A 를 권장한다.
- 일곱 사례가 모두 '같은 실행을 창마다 다른 기록, 다른 열쇠로 본다'는 한 원인으로 묶인다. A 는 그 원인을 없앤다.
- B 는 다시 로드 사례만 없애고, 단계 안 재개(U18)와 PC 재시작 경우는 남긴다. 체인 실행 이동은 11-19 P7 에서도 하지 않은 변경이다(project_vm_orchestra_plan_20261119).
- C 는 VMO 가 같은 축을 다시 올리지 않게 할 뿐이고, 11-23 18:46 형태의 재발을 막지 못한다. C 의 사다리 보정은 별도 L3 후보로 남긴다.

## 전환(바뀌는 것 · 버리는 것 · 단계 · 확인 · 위험 · 되돌리기)
- 바뀌는 파일: tools/VibeManager/workbench.js(progWrite, resumable, abortRunningChains, postResume, boardData), job-runner.js(decorate, runOne, adopt), jobs.js(재개 단추 조건), orch-usercheck.js(U13, U16, U17, U23 감지기), orch-watch.js(R14 계보 판정), tools/Harness/verify/run_verify.py(_resume 덮어쓰기 전 원장 대조), test/t_chain_resume.js, t_job_resume.js, t_orch_usercheck.js.
- 버리는 것: s.resume 저장, decorate 삭제 규칙, 화면 상태 '대기' 조건, 창별 조회 규칙.
- 단계
  1. 원장 필드 추가: state, resumedFrom 계보, screen 필수, inner 참조. 옛 기록은 읽을 때 state 를 interruptedAt 으로 계산한다. 확인: t_chain_resume 에 11-23 18:46 기록(screen '') 재현을 넣고 쓰기 거부 또는 화면 ID 채움 1건 PASS.
  2. 조회 함수 1개로 세 창 통일. 확인: 같은 원장 파일 하나로 VMW, Workbench, VMO 조회 결과의 runId 집합이 같다는 시험.
  3. job-runner 의 s.resume 저장 제거. 확인: 11-20 18:35 J20261120_180409 순서(입장 대기 중 화면 갱신) 재현 시험에서 재개가 4/8 단계부터 시작.
  4. run_verify 의 _resume 덮어쓰기 전 대조. 확인: 원장 VERIFY_RUN_ID 와 다르면 resume.refuse 1줄을 남기고 덮지 않음.
  5. 감지기 U13, U16, U17, U23 을 원장 대조로 재정의하고 R14 에 계보 판정 추가. 확인: t_orch_usercheck, t_orch_ledger(16:06 사고 재현) PASS. 창 다시 로드 1회 뒤 원장 cut 1건이 ui.json job, wb 보고에 같은 runId 로 있음.
- 위험: 실행 중 체인이 옛 형식 기록을 쓰는 동안 반영하면 표시가 어긋난다. 반영은 실행 중 체인 0개일 때만 한다. 단계 4는 CheckList 실행 경로라 체인 뒤로 미룬다.
- 되돌리기: 단계별 .bak_<날짜>_resumeledger 사본으로 복원. 원장에는 필드만 더하므로 옛 코드가 새 기록을 읽어도 무시한다.

## 반증
- 전환 뒤 세 창이 같은 원장을 읽는데도 한 창에만 재개가 보이는 지적이 나오면, 원인은 저장 구조가 아니고 웹뷰 갱신 시점이다. 그러면 A 는 틀렸다. 확인 방법: ui.json 의 job, wb 보고 시각과 원장 갱신 시각 대조.
- 재개 실패가 단계 안 재개 거부(resume.refuse)에 몰리면 원인은 측정 도구 지문이다. 지금 resume.refuse 는 0줄이다.
- 지금 개념이 맞다면, 11-27(5건이 7일 창을 벗어나는 날)까지 실사용 재개 1회 이상에서 감지기 실패 0건이 보여야 한다. 지금 실사용 재개는 11-21 뒤 0회라 미확인이다.

## 미확인
- 11-21 뒤 실사용 재개 0회(events.jsonl chain.resume 마지막 11-20 20:46:19)라 지금 코드의 실화면 동작은 미확인.
- U17 은 감지기 없음(pending-detector).
- 11-23 18:46 사례가 user_checks 에 목적 키 reloadResume 으로 오르지 않은 이유(학습기 분류)는 미확인.
- B 의 Claude CLI 분리 실행 가능 여부는 미확인.
- 추가 확인 후보: orch-ladder.js:103-105 같은 축 판정이 해결된 지적까지 세는 문제(C 안). 다음 L3 진단 대상.