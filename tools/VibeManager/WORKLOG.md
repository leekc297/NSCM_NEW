# Vibe_Manager 작업 이력

생성 2026-11-20T10:46:58+09:00 (orch-history.js 가 만든 파일. 직접 고치지 않음)

## 건수

| 구분 | 건수 |
|---|---|
| 변경 | 234 |
| 세션 | 190 |
| VM 실행 | 387 |
| Claude 호출 | 203 |
| 사건 | 114 |
| 개선안 | 42 |
| 검사기 결함 | 38 |
| 룰 변경 | 59 |
| 세션 중 VM 관련 | 103 |
| 세션의 VM 파일 수정(Edit, Write) | 630 |
| 변경 기록의 미확인 항목 | 195 |
| 백업 파일(저장소 / 설치 폴더) | 458 / 219 |
| 기간 | 2026-07-03 ~ 2026-11-20 |

## 영역별(변경, VM 세션)

| 영역 | 건수 |
|---|---|
| VMO | 109 |
| Workbench | 58 |
| CheckList 엔진 | 55 |
| 체인·메뉴 | 53 |
| VM 기타 | 30 |
| Git | 10 |
| 룰·hook | 7 |
| 문서 생성 | 6 |
| 서버 | 5 |
| 업무 작업창 | 4 |

## 7일 안 5회 이상 변경 기록에 나온 파일

| 파일 | 7일 안 횟수 | 시작일 | 전체 횟수 | 세션 수정 수 |
|---|---|---|---|---|
| workbench.js | 62 | 2026-11-14 | 66 | 182 |
| orch-watch.js | 30 | 2026-11-19 | 30 | 62 |
| harness.json | 27 | 2026-11-18 | 32 | 0 |
| run_all.js | 27 | 2026-11-19 | 27 | 1 |
| quick.json | 27 | 2026-11-13 | 54 | 7 |
| orchestra.js | 22 | 2026-11-19 | 22 | 29 |
| extension.js | 20 | 2026-11-17 | 24 | 46 |
| job-runner.js | 18 | 2026-11-19 | 18 | 19 |
| orch-agent.js | 17 | 2026-11-19 | 17 | 36 |
| orch-selfcheck.js | 17 | 2026-11-19 | 17 | 13 |
| orch-improve.js | 15 | 2026-11-19 | 15 | 35 |
| t_orch_watch.js | 14 | 2026-11-19 | 14 | 12 |
| package.json | 13 | 2026-11-17 | 15 | 0 |
| e2e_results.json | 13 | 2026-11-20 | 13 | 0 |
| results.json | 13 | 2026-11-20 | 16 | 0 |
| run_verify.py | 13 | 2026-11-18 | 17 | 0 |
| steps.json | 12 | 2026-11-13 | 25 | 0 |
| doc_style.py | 12 | 2026-11-17 | 13 | 0 |
| CHANGELOG.md | 11 | 2026-11-17 | 11 | 2 |
| _summary.csv | 10 | 2026-11-20 | 16 | 0 |

## 변경 기록 2건 이상에 나온 같은 지시

| 지시 | 건수 |
|---|---|
| "개선안 1번 승인할게요, 반영해주세요." | 2 |

## 2026-11-20

변경 39, 세션 59, VM 실행 48, Claude 호출 57, 사건 86, 개선안 24, 검사기 결함 2

- 10:40 [VMO] VMO 사용자 지적 자가진단(S13) · 중지 뒤 계속 실행(R14) · Overall Review(큰 그림 점검) · Incidents·Fixes 타임라인 · Dictionary 탭
  - 지시: "중지를 했는데 중지가 되지 않고 수행되고 있는 이런것을 찾아서 스스로 개선하는 보완" / "상황을 보고 입력한 내용에 대해서는 모니터링을 통해서 자가진단하고 보완" / "하루에 한번정도는 스스로 큰 그림을 보고 ... 개선 방향을 제안"
  - 파일 16개: orch-watch.js, job.json, orch-heal.js, workbench.js, orch-agent.js, harness.json, tools/VibeManager/user_checks.json, orch-usercheck.js 외
  - 미확인 2건: Overall Review(큰 그림 점검, orch-vision.js): 목적 자료(메모리 feedback_vmo_*, checklist 속도, 플랜, 사용자 지적 원장)와 실행 상태(7일 집계, 자가진단, 사건, 개선안, CheckList 소요표, 최근 변경)로 Claude(읽기 전용)가 목적별 맞음/어긋남/미확인 판단과 개선안(source vision, ID 접미사 VISION)을 냄. / VS Code 실화면(창 다시 로드 뒤), R14 실동작(중지 → 사건 → 자가 복구), 사용자 지적 학습 실호출, Overall Review 실호출 결과
  - 되돌리기 태그: 20261120_r14, 20261120_overall
  - 세션: d1e7f3cd, 1d4cb42c, 03f495b6, 1365d34c, 36c7d0f1, 42600766, 7c2c3699, 82373bdc, a435c93b, d1571c18, 133cbff8, 473c9c4b, 6ff41015, 78af9e01, e610492d, 1357fefa, 26627784, 3f29dae7
- 10:35 [CheckList 엔진] quick.json 🧪 미검증 해소 · 🧯 자동 보완 프롬프트 — AI 적용 지점 재배치
  - 지시: "판단과 정리가 필요한 부분에는 AI 를 활용하고, 지금 AI 를 사용하고 있는 부분에서 불필요한 행위가 있다면 제거" / "UI/DB MODE 로 가면 UI 개발, UI 보완의 전반적인 과정에 다 고민"
  - 파일 7개: criteria.md, port_review.py, repair_apply.py, checklist_run.py, Doc/verify/_ENGINE_MASTER.md, test/run_all.js, quick.json
  - 되돌리기 태그: 20261120_aipts
- 10:30 [VMO] VMO 자가 보완: 측정 추가: 에이전트 Claude 호출 끝 기록에 결과 줄 수신 여부, 마지막 진행 종류, 중지 주체를 남긴다
  - 지시: "개선안 20261120094530_REVIEW_3 승인(VM 자가진단 ). 근거 = 집계 claude calls 73, fail 7. incidents R7 '응답 중 종료' 10건(DMF0042), '미분류' 9건. 실패 로그 4개가 결과 줄 없이 '--- exit 1 ---' 로 끝나고 stderrTail 빈 값: .vibe/logs/2026-11-19"
  - 파일 11개: orch-watch.js, Doc/verify/_llm_usage.csv, tools/Harness/harness.json, tools/VibeManager/extension.js, tools/VibeManager/orch-agent.js, tools/VibeManager/orch-improve.js, tools/VibeManager/orch-watch.js, tools/VibeManager/test/t_orch_agent.js 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self1021
  - 세션: d1e7f3cd, 1d4cb42c, 696c2058, 03f495b6, 1365d34c, 36c7d0f1, 42600766, 7c2c3699, 82373bdc, a435c93b, d1571c18, 133cbff8, 356d1ad5, 473c9c4b, 6ff41015, 78af9e01, e610492d, 1357fefa, 16c64de0, 26627784, 3f29dae7
- 10:21 [VMO] VMO 자가 보완: 실패 서명에서 'log tail:' 머리 줄과 '$ 명령' 줄을 건너뛰고 다음 원인 줄로 서명을 만든다
  - 지시: "개선안 20261120094530_REVIEW_2 승인(VM 자가진단 ). 근거 = incidents topRepeats R2 n=11, sig 'S8.checklistRun / [FAIL] Playwright exit code N - log tail:' 아래 화면 3개(SSP0005, SCP0005, SCP0028). events.jsonl step.en"
  - 파일 8개: Doc/verify/_llm_usage.csv, Doc/verify/SCP0028/llm_cache.json, Doc/verify/SCP0028/llm_usage.csv, tools/VibeManager/orch-usercheck.js, tools/VibeManager/user_checks.json, tools/VibeManager/test/t_orch_events.js, a.py, tools/VibeManager/test/run_all.js
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self1014
  - 세션: d1e7f3cd, 1fcc0bc4
- 10:06 [업무 작업창] 업무 작업 중지 뒤 체인이 다음 단계를 계속 띄우던 결함
  - 지시: "VM 업무 작업 에서 4개의 작업이 수행중이였는데, 제가 중지를 눌렀습니다. 상단에 사용자 중지라는 TEXT 가 보이는데 아직 상황판에는 4개의 작업이 수행중인 것으로 보이고 있습니다."
  - 파일 3개: job.json, workbench.js, test/t_chain_userstop.js
  - 미확인 2건: 지금 돌고 있는 J20261120_060728 은 옛 코드라 창 다시 로드 전까지 계속 진행. / 다시 로드 때 job-runner.dispose 가 남은 프로세스를 끊음(실측 필요)
  - 되돌리기 태그: 20261120_stopchain
  - 세션: 1d4cb42c, 42600766, 133cbff8, 473c9c4b, 78af9e01, e610492d
- 10:00 [VMO] VMO 자가 보완: 측정 추가: 7일 집계에서 중지된 실행을 실패와 따로 센다(단계, 체인, 프로세스)
  - 지시: "개선안 20261120094530_REVIEW 승인(VM 자가진단 ). 근거 = 집계 steps S8.checklistRun n=14 fail=11, chains checklist n=11 ok=0, procFails exits 1:10. events.jsonl job.item.end 를 대조하면 FAIL 11건 중 status cancel 8건(00:33"
  - 파일 40개: orch-improve.js, Doc/e2e/results/SSP0005/artifacts/.last-run.json, Doc/e2e/specs/SCP0028.auth.spec.ts, Doc/e2e/specs/SCP0028.authcrud.spec.ts, Doc/e2e/specs/SCP0028.crud.spec.ts, Doc/e2e/specs/SCP0028.smoke.spec.ts, Doc/e2e/specs/SSP0005.auth.spec.ts, Doc/e2e/specs/SSP0005.authcrud.spec.ts 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0952
  - 세션: d1e7f3cd, 1d4cb42c, 42600766, 133cbff8, 473c9c4b, 78af9e01, e610492d, 1357fefa, 16c64de0, 26627784
- 10:00 [VMO] VMO 탭 이름 영어로 변경
  - 지시: "VMO 의 상황판 / 사건 / 개선안 / 자가진단 / 이력 / 에이전트 / LOG 을 영어로 TABPAGE 명칭을 변경하면 어떤걸 추천하나요?" / "추천안으로 변경"
  - 파일 1개: orchestra.js
  - 미확인 1건: VS Code 실화면(창 다시 로드 뒤)
  - 되돌리기 태그: 20261120_tabname
  - 세션: d1e7f3cd
- 09:58 [VMO] VMO 상황판 '지금 실행 중' 카드에 Workbench 연결 ↗
  - 지시: "VMO 상황판의 지금 실행 중 항목의 오른쪽에 UI 별 작업의 경우 WORKBENCH 연결 아이콘을 추가해주세요."
  - 파일 2개: orchestra.js, workbench.js
  - 미확인 1건: VS Code 실화면(창 다시 로드 뒤), 창 앞으로 가져오기 실동작
  - 되돌리기 태그: 20261120_wbico
  - 세션: d1e7f3cd, 1d4cb42c, 42600766, 133cbff8, 473c9c4b, 78af9e01, e610492d
- 09:50 [VMO] VMO 사건 탭 칸반 · 확장 호스트 응답 없음 원인(paths 반복) 줄임
  - 지시: "VMO 의 사건 TABPAGE 도 DESIGN 변경 해주세요. 3개을 제안" / "B 칸반으로 할게요"
  - 파일 3개: orchestra.js, extension.js, test/run_all.js
  - 미확인 2건: 창 다시 로드 뒤 확장 호스트 응답 없음 횟수 변화(renderer.log 로 비교) / gitDirty 동기 실행은 그대로(에이전트 조치 전후 비교용)
  - 되돌리기 태그: 20261120_kanban, 20261120_pathscache
  - 세션: d1e7f3cd, 696c2058, 133cbff8, 356d1ad5
- 09:26 [VMO] 업무 작업창 B 스튜디오 디자인 · 개선안 자동 반영 기록 시각 표시 정정
  - 지시: "VM 업무 작업 창을 기능은 유지하고 Text 는 줄이고 세련된 느낌으로 Design 변경" / "B 로 진행" / "VMO 개선안 6:54 이후에도 발생 이력이 있다고 회신받았는데, 화면에 표기가 되지 않습니다"
  - 파일 3개: jobs.js, orchestra.js, test/run_all.js
  - 미확인 2건: VS Code 실화면(창 다시 로드 필요 / 지금 도는 CheckList 가 끝난 뒤)
  - 되돌리기 태그: 20261120_designB, 20261120_proptime
  - 세션: d1e7f3cd
- 09:10 [VMO] 다시 시도한 개선안이 또 반영 실패하면 다시 진단
  - 지시: "VMO 개선안을 보면 06:54분 이후는 진단도 조치된 것도 없습니다. 그 이후 시간에는 진단도 조치도 없는 이유 확인해주세요."
  - 파일 3개: orch-selfcheck.js, t_orch_selfapply.js, test/run_all.js
  - 미확인 2건: 실제 VMO 동작(창 다시 로드 필요. / 지금 도는 CheckList 4화면이 끝난 뒤 로드)
  - 되돌리기 태그: 20261120_rerepair
  - 세션: d1e7f3cd, e0fd92f7
- 07:47 [VMO] VMO 자가 보완: VM 창이 끝날 때 job 없이 띄운 체인에도 끝 기록(chain.end ok=false, aborted, why 'VM 창 종료로 중단') 남기기(검증 기대값, 대상 경로 정정)
  - 지시: "개선안 20261120065425_SELF 승인(VM 자가진단 ). 근거 = extension.js deactivate가 job-runner 작업만 정리함. events.jsonl:38 체인 job 값 빈 문자열. 21:53 체인 4건이 끝 기록 없이 사라져 R5 사건 4건 생김. orch-state.js:42 chain.end를 받으면 체인 삭제. 앞선 "
  - 파일 40개: extension.js, orch-state.js, t_chain_abort.js, t_wb_logname.js, run_all.js, result.json, workbench.js, orch-watch.js 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0740
  - 세션: d1e7f3cd, 1d4cb42c, 696c2058, 03f495b6, 1365d34c, 36c7d0f1, 42600766, 7c2c3699, 82373bdc, a435c93b, d1571c18, 133cbff8, 356d1ad5, 473c9c4b, 6ff41015, 78af9e01, e610492d, 1357fefa, 26627784, 3f29dae7
- 07:40 [VMO] VMO 자가 보완: VM 작업 로그 이름에 화면 ID와 실행 번호를 넣어 같은 초에 시작한 실행끼리 로그를 공유하지 않게 함(검증 = 시험만)
  - 지시: "개선안 20261120064043_SELF 승인(VM 자가진단 ). 근거 = events.jsonl:263~265 SCP0005, SCP0014, SCP0028 proc.start 3건의 log 값이 같음(.vibe/logs/2026-11-20T00-33-54_CheckList...log). 지금 workbench.js:499 logF = 초 단위 시각 +"
  - 파일 21개: workbench.js, test/t_wb_logname.js, vm-orchestra.md, Doc/verify/_llm_usage.csv, tools/VibeManager/workbench.js, Doc/verify/SCP0005/_dedup/rule_A1.json, Doc/verify/SCP0005/_dedup/rule_A10.json, Doc/verify/SCP0005/_dedup/rule_A2.json 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0734
  - 세션: 1d4cb42c, 42600766, 133cbff8, 473c9c4b, 78af9e01, e610492d
- 07:34 [VMO] VMO 자가 보완: CheckList 체인 R11 판정 때 이번 체인이 만든 결과 파일만 사용
  - 지시: "개선안 20261120042738_INC 승인(VM 자가진단 ). 근거 = orch-watch.js:108 run_verify.result.json을 시각 확인 없이 읽음. 120행 claudeRan 0이면 그 값으로 R11을 올림. 이번 사건의 결과 파일 ts는 2026-11-19T16:17:57, 체인 시작은 2026-11-20 01:10:46(even"
  - 파일 40개: orch-watch.js, run_verify.result.json, _Division_D4__0.json, Doc/verify/SSP0005/e2e_results.json, Doc/verify/_llm_usage.csv, tools/VibeManager/orch-watch.js, tools/VibeManager/test/t_orch_watch.js, Doc/asislive/SCP0005/run_20261120_072913_acts/acts.json 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0726
  - 세션: d1e7f3cd, 03f495b6, 1365d34c, 36c7d0f1, 7c2c3699, 82373bdc, a435c93b, d1571c18, 6ff41015, e610492d, 1357fefa, 26627784, 3f29dae7
- 07:26 [VMO] VMO 자가 보완: 강제 종료된 실행은 '중지'로 표시하고 동시 실행 로그 파일 이름 겹침 제거
  - 지시: "개선안 20261120042556_INC 승인(VM 자가진단 ). 근거 = workbench.js:463,466 은 종료코드가 0 이 아니면 로그의 마지막 [FAIL]/✖ 줄 5개를 원인으로 씀. 이번 사건 서명이 판정 결과 줄(SsoUserModal ssoUserYn)로 잡힘. workbench.js:437 로그 파일 이름 = 초 단위 시각 + 단계 이름"
  - 파일 40개: workbench.js, Doc/asislive/SCP0028/save_compare.csv, Doc/asislive/SCP0028/scenario_compare.csv, Doc/asislive/SCP0028/scenario_compare_summary.json, Doc/asislive/SCP0028/scenario_matrix.csv, Doc/asislive/SCP0028/scenarios_cov.csv, Doc/asislive/SCP0028/scenarios_spec.csv, Doc/asislive/SCP0028/screen_bundle.json 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0710
  - 세션: 1d4cb42c, 42600766, 133cbff8, 473c9c4b, 78af9e01, e610492d
- 07:08 [VMO] VMO 자가 보완: R11·R10 사건이 지난 실행 결과 건수를 쓰지 않게 함, 동시 실행 로그 파일 분리
  - 지시: "개선안 20261120042237_INC 승인(VM 자가진단 ). 근거 = orch-watch.js:108-121 checklistSnap 이 run_verify.result.json(ts 2026-11-19T16:35:20)을 그대로 읽어 11-20 04:15 사건 제목에 FAIL 29·미검증 278 표시. workbench.js:437 로그 이름이 초 "
  - 파일 40개: orch-watch.js, run_verify.result.json, workbench.js, result.ts, Doc/asislive/SSP0014/latest.json, Doc/asislive/SSP0014/scenarios_cov.csv, Doc/golden/SSP0014/_summary.csv, Doc/golden/SSP0014/_summary.md 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0656
  - 세션: d1e7f3cd, 1d4cb42c, 03f495b6, 1365d34c, 36c7d0f1, 42600766, 7c2c3699, 82373bdc, a435c93b, d1571c18, 133cbff8, 473c9c4b, 6ff41015, 78af9e01, e610492d, 1357fefa, 26627784, 3f29dae7
- 06:32 [VMO] VMO 자가 보완: VM 다시 시작 때 지난 실행을 '사라진 실행(R5)'으로 늦게 올리지 않기, 실행 시작 기록에 화면 ID 채우기
  - 지시: "개선안 20261120005532_INC 승인(VM 자가진단 ). 근거 = events.jsonl:49 proc.start screen "" (명령에 SSP0005 있음). 실행 주인 PID 3764 마지막 사건 21:47:45(events.jsonl:67). 사건 20261120_004835_R5_ALL 은 3시간 뒤 00:48:35 에 올라왔고, 그 사"
  - 파일 19개: orch-watch.js, orch-state.js, checklist_run.py, Doc/verify/SCP0028/a1_live.json, Doc/verify/SCP0028/calls/_grid_main.json, _A5__0.json, __0.json, _A1__0.json 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0625
  - 세션: d1e7f3cd, 03f495b6, 1365d34c, 36c7d0f1, 7c2c3699, 82373bdc, a435c93b, d1571c18, 6ff41015, e610492d, 1357fefa, 26627784, 3f29dae7
- 06:24 [VMO] VMO 자가 보완: VS Code 종료(dispose)로 멈춘 실행도 감시기에 중지로 알려 R1, R2, R11 사건을 만들지 않는다
  - 지시: "개선안 20261120005403_INC 승인(VM 자가진단 ). 근거 = job.json J20261120_003352 note 'VS Code 종료로 중단됨' · job-runner.js:219 dispose() 에 user.stop 없음 · orch-watch.js:125 userStopped, :132, :139, :143 · events.jsonl"
  - 파일 35개: job.json, job-runner.js, orch-watch.js, t_orch_watch.js, _aria_0.json, _1920_1366_0.json, _0.json, _AS-IS_lock_rules_0.json 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0617
  - 세션: d1e7f3cd, 03f495b6, 1365d34c, 36c7d0f1, 7c2c3699, 82373bdc, a435c93b, d1571c18, 6ff41015, e610492d, 1357fefa, 26627784, 3f29dae7
- 06:16 [VMO] VMO 자가 보완: TO-BE 화면이 없는 화면의 CheckList 실패를 반복 오류(R1·R2) 사건에서 제외
  - 지시: "개선안 20261120005146_INC 승인(VM 자가진단 ). 근거 = prereq.py:219-221 FAIL 문구 'TO-BE 화면 미개발이면 CheckList 대상 아님'(rc 6). orch-watch.js:73-77 failure()가 서명 횟수만 세서 같은 원인으로 R1(00:34) 다음 R2(00:48) 생성. Claude 조치가 2회 호출"
  - 파일 40개: prereq.py, orch-watch.js, Doc/asisfacts/screens/SCP0028/combo_values.json, Doc/asisfacts/screens/SSP0005/combo_values.json, Doc/asisfacts/screens/SSP0014/combo_values.json, Doc/e2e/results/SCP0005/_summary.csv, Doc/e2e/results/SCP0005/_summary.md, Doc/e2e/results/SCP0005/results.json 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0609
  - 세션: d1e7f3cd, 03f495b6, 1365d34c, 36c7d0f1, 7c2c3699, 82373bdc, a435c93b, d1571c18, 6ff41015, e610492d, 1357fefa, 26627784, 3f29dae7
- 06:00 [CheckList 엔진] CheckList 전체기능 재점검 / 수정분 재점검 분리
  - 지시: "CHECKLIST 의 기능에 전체기능 재점검 과 수정분 재점검 으로 기능을 분리해서 지금의 기능을 전체기능 재점검으로 유지하고, 수정분 재점검의 경우에는 이전 수행과 달라진 소스의 범위안에서만 테스트를 진행하고 수정"
  - 파일 10개: quick.json, steps.json, checklist_run.py, tools/Harness/verify/source_snap.py, /source_baseline.json, delta_scope.py, run_verify.py, make_verify_docs.py 외
  - 미확인 4건: make_verify_docs.py: 다시 재지 않은 행에 '[이전 측정 유지 측정 시각]', 데이터 규칙(DB_OBJECT)은 '· 데이터 변경 미확인', 요약에 재측정 규칙 수·유지 행 수·마지막 전체 시각 / 실제 수정분 재점검 실행 시간과 판정 비교(전체 재점검과 ledger_diff). / 첫 수정분 재점검은 기준선이 없어 전체로 실행됨.
  - 되돌리기 태그: 20261120_delta
  - 세션: 1365d34c, 36c7d0f1
- 05:45 [VMO] VMO 자가 보완: 작업 목록 중지를 감시기에 알리고 R11 판정에서 사용자 중지와 이전 실행 결과를 뺀다
  - 지시: "개선안 20261120003909_INC 승인(VM 자가진단 ). 근거 = job.json J20261120_003243 note '사용자 중지' · events.jsonl 241~251행 user.stop 없음 · workbench.js:2643 user.stop 생성처 1곳 · orch-watch.js:120 R11 조건 · orch-watch.js:1"
  - 파일 11개: job.json, workbench.js, orch-watch.js, run_verify.result.json, job-runner.js, t_orch_watch.js, tools/VibeManager/CHANGELOG.md, tools/VibeManager/test/t_orch_watch.js 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0539
  - 세션: d1e7f3cd, 1d4cb42c, 03f495b6, 1365d34c, 36c7d0f1, 42600766, 7c2c3699, 82373bdc, a435c93b, d1571c18, 133cbff8, 473c9c4b, 6ff41015, 78af9e01, e610492d, 1357fefa, 26627784, 3f29dae7
- 05:41 [CheckList 엔진] CheckList 속도 개선 남은 항목: AI 검토 행 단위 기억 · 구간별 소요표
  - 지시: "이어서 구현"
  - 파일 6개: tools/Harness/verify/llm_review.py, /llm_rowcache.json, run_verify.py, /run_timing.json, run-e2e.cmd, /results.json
  - 되돌리기 태그: 20261120_rowcache, 20261120_open
- 05:31 [VMO] VMO 자가 보완: 작업 목록 중지를 감시기에 user.stop 으로 알리고 CheckList 체인 R11 판정에서 사용자 중지를 뺀다
  - 지시: "개선안 20261120003742_INC 승인(VM 자가진단 ). 근거 = job.json J20261120_003243 note '사용자 중지' · events.jsonl 241~251행에 user.stop 없음 · user.stop 생성처는 workbench.js:2643 1곳 · orch-watch.js:139 R1 확인, orch-watch.js:1"
  - 파일 12개: job.json, workbench.js, orch-watch.js, job-runner.js, t_orch_watch.js, tools/VibeManager/CHANGELOG.md, tools/VibeManager/job-runner.js, tools/VibeManager/orch-watch.js 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0524
  - 세션: d1e7f3cd, 1d4cb42c, 03f495b6, 1365d34c, 36c7d0f1, 42600766, 7c2c3699, 82373bdc, a435c93b, d1571c18, 133cbff8, 473c9c4b, 6ff41015, 78af9e01, e610492d, 1357fefa, 26627784, 3f29dae7
- 05:30 [CheckList 엔진] CheckList 속도 개선 묶음: 중복 정리(AI) · E2E 동시 실행 · 진입 확인 선행 · AS-IS 실측 원장 기준 재사용
  - 지시: "기능이 누락되지 않으면서 속도를 개선" / "10분에서 진짜 길어야 30분" / "정합성에 문제가 되는 것이라면 방법으로 고려해서는 안됩니다"
  - 파일 15개: tools/Harness/verify/dedup_general.py, Doc/verify/_dedup/general_groups.csv, ledger.py, dedup_screen.py, /dedup_screen.csv, judge.py, tools/E2E/lib/writeguard.ts, e2e_shard.py 외
  - 미확인 3건: 실제 CheckList 실행으로 잰 시간과 원장 판정 차이(ledger_diff). / 동시 실행은 첫 실행이 시험 종류를 기록한 뒤 두 번째 실행부터. / VS Code 실화면
  - 되돌리기 태그: 20261120
- 05:24 [VMO] VMO 자가 보완: 작은 모듈 고정 문구 줄표, 가운뎃점, 틀 정리(시험 파일 포함 재제출)
  - 지시: "개선안 20261120001936_SELF_3 승인(VM 자가진단 S11 S11/prompt-panel.js). 근거 = failed 20261119232524_SELF_3 사유 = orch-selfcheck.js:362 '반영 완료 — 생성물 삭제' 를 test/t_orch_selfapply.js:90 정규식 /반영 완료 — 생성물 삭제/ 가 맞춰 보는데"
  - 파일 23개: prompt-panel.js, orch-selfcheck.js, test/t_orch_selfapply.js, history.js, t_orch_selfapply.js, tabview.js, server-service.js, Doc/tobefacts/db/_export_log.md 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0518
  - 세션: d1e7f3cd, e0fd92f7
- 05:22 [업무 작업창] 업무 작업 내용을 같은 화면 ID 의 Workbench 창과 공유(Console, 단계 보드, 이력)
  - 지시: "VM 업무 작업으로 작업을 기동 시, WORKBENCH 을 열어 해당 화면을 지정했을 때, CONSOLE 에 업무작업으로 진행되고 있던 작업의 내용이 cONSOLE 창에 보이도록 기능 추가해주세요. 업무작업의 모든 항목은 WORKBENCH 와 공유되어야 합니다. 이는 HISTORY 에도 마찬가지 입니다."
  - 파일 3개: workbench.js, test/run_all.js, t_job_mirror.js
  - 미확인 3건: VS Code 실화면(창 다시 로드 필요). / 실제 CheckList 업무 작업을 돌리는 동안 Workbench Console 에 보이는 모습. / 중지 버튼으로 실제 화면이 멈추는지
  - 되돌리기 태그: 20261120_mirror
  - 세션: 1d4cb42c, 42600766, 133cbff8, 473c9c4b, 78af9e01, e610492d
- 05:20 [업무 작업창] VS Code 종료로 끊긴 업무 작업 = 사용자 중지로 알림
  - 파일 2개: job-runner.js, test/t_job_runner.js
  - 미확인 1건: 미확인: 실제 창 다시 로드 때 사건 0건(다음 로드 때 확인)
  - 되돌리기 태그: 20261120_ustop
  - 세션: d1e7f3cd, 1365d34c, 36c7d0f1
- 05:07 [VMO] VMO 사건: 창 다시 로드로 생긴 사건을 사용자 확인 필요에서 뺌 · 일괄 닫기 · 이력 자동 수집 체크
  - 지시: "VMO 사건 목록을 보면 RELOAD 때문에 발생한 프로세스 에 대한 부분은 사용자 확인 필요 항목에서 제외시켜 주세요. 그리고 일괄 닫기 기능도 추가해주세요." / "VMO 이력 의 경우 '지금 수집' 옆에 자동수립 버턴 CHECK버튼으로 추가해주세요."
  - 파일 8개: orch-watch.js, orchestra.js, workbench.js, orch-history.js, harness.json, test/run_all.js, t_orch_reloadmark.js, t_orch_histauto.js
  - 미확인 2건: VS Code 실화면(창 다시 로드 필요). / 일괄 닫기 버튼, 자동 수집 체크를 눌러 본 결과
  - 되돌리기 태그: 20261120_reload
  - 세션: d1e7f3cd, 1d4cb42c, 03f495b6, 1365d34c, 36c7d0f1, 42600766, 7c2c3699, 82373bdc, a435c93b, d1571c18, 133cbff8, 473c9c4b, 6ff41015, 78af9e01, e610492d, 1357fefa, 26627784, 3f29dae7
- 04:33 [VMO] 에이전트 대화로 멈춘 화면은 실패 사건 없음 · 요청 파일로 화면 하나 중지, 다시 실행
  - 지시: "VMO 에이전트를 통해서 SCP0028, SSP0014 CHECKLIST 을 중지시켰습니다." / "고쳐주세요"
  - 파일 8개: orch-watch.js, orch-agent.js, job-runner.js, .done.json, .claude/agents/vm-orchestra.md, test/run_all.js, t_orch_userstop.js, t_job_runner.js
  - 미확인 2건: VS Code 실화면(창 다시 로드 필요). / 실제 에이전트 대화가 요청 파일을 쓰는지
  - 되돌리기 태그: 20261120_ustop
  - 세션: d1e7f3cd, 1d4cb42c, 03f495b6, 1365d34c, 36c7d0f1, 7c2c3699, 82373bdc, a435c93b, d1571c18, 6ff41015, e610492d, 1357fefa, 26627784, 3f29dae7
- 04:26 [VMO] VMO 자가 복구: 화면 진입 실패 → 원인 → 해결 → 확인 → 그 화면 다시 실행 · 업무 작업창 세부 진행 표시
  - 지시: "2개 화면이 열리지 않았을 때, 이를 캐치해서 원인을 찾고, 해결을 해서, 해결한 후에 정상적으로 기동이 되도록 하는 것을 사람이 확인해서 따로 하기 전에 자가진단을 통해서 진행하는 것이 가장 큰 목적중에 하나" / "스크립트 1/7 의 시작상태에서 진도가 나가지 않는 것으로 보임"
  - 파일 13개: orch-heal.js, screen_sync.py, job-runner.js, jobs.js, job.json, orch-agent.js, orch-watch.js, tools/CommonSync/screen_sync.py 외
  - 미확인 3건: VS Code 실화면(창 다시 로드 필요). / 실제 빠진 공용 파일을 common_sync 로 받는 동작(지금 빠진 파일 0건이라 받기 경로는 시험에서 가짜로 대체). / 실제 R13 → 자가 복구 → 다시 실행 전 과정 실동작
  - 되돌리기 태그: 20261120_heal, 20261120_prog, 20261120_r13, 20261120_deps
  - 세션: d1e7f3cd, 1d4cb42c, 696c2058, 03f495b6, 1365d34c, 36c7d0f1, 7c2c3699, 82373bdc, a435c93b, d1571c18, 133cbff8, 356d1ad5, 6ff41015, e610492d, 1357fefa, 26627784, 3f29dae7
- 04:12 [VMO] 체인 실행 중에도 VMO 자가진단 계속 · 화면 진입 실패 반복 사건(R13) · 화면 소스 받기에 빠진 공용 파일 확인
  - 지시: "VMO 가 자동반영 기록이 00:59 분 이후에 어떤 것도 발생시키지 않았습니다." / "CHECKLIST 수행 시 아래 사유때문에 화면을 오픈하지 못했습니다. 그러면 VMO 가 이를 확인해서 오류를 조치했어야 하는데 조치를 하지 못했습니다."
  - 파일 12개: orch-selfcheck.js, packages/shared/src/lib/paste.ts, tools/CommonSync/screen_sync.py, tools/Harness/verify/run_verify.py, orch-watch.js, screen_sync.py, .claude/agents/vm-orchestra.md, paste.ts 외
  - 미확인 5건: VS Code 실화면(창 다시 로드 필요). / 실제 vite 변환 오류 응답으로 R13 문구 추출(시험은 흉내 서버). / screen_sync 가 빠진 파일을 common_sync 로 받는 실동작(지금은 빠진 파일 0건).
  - 되돌리기 태그: 20261120_chainrun, 20261120_r13, 20261120_deps
  - 세션: d1e7f3cd, e0fd92f7, 03f495b6, 1365d34c, 36c7d0f1, 7c2c3699, 82373bdc, a435c93b, d1571c18, 6ff41015, e610492d, 1357fefa, 26627784, 3f29dae7
- 01:15 [VMO] VMO 자가 보완: doc_style.py JS 소스 검사에서 주석과 정규식 리터럴 제외(확인 기준 정정 재제출)
  - 지시: "개선안 20261120001936_SELF_2 승인(VM 자가진단 S11 S11/extension.js). 근거 = failed 20261119232523_SELF 2회 실패 사유 = 확인 기준 'tabview.js 위반 0' 불충족. 결과 기록(result.verify_result)은 extension.js 51 → 40, tabview.js 2 → 1,"
  - 파일 8개: extension.js, tabview.js, workbench.js, tools/Docs/doc_style.py, doc_style.py, -chromium/error-context.md, Doc/tobefacts/db/_export_log.md, orchestra.js
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0109
  - 세션: d1e7f3cd, 1d4cb42c, 696c2058, 42600766, 133cbff8, 356d1ad5, 473c9c4b, 78af9e01, e610492d
- 01:04 [VMO] VMO 자가 보완: S8 개선안 효과 판정에서 S9 반복 수정 key 제외
  - 지시: "개선안 20261120001936_SELF 승인(VM 자가진단 S8 S8/20261119232524_SELF). 근거 = orch-selfcheck.js:190 은 selfKey 가 지금 점검 결과에 있으면 fail 로 올림. 개선안 20261119232524_SELF 의 selfKey 는 S9/file/workbench.js 이고 orch-selfchec"
  - 파일 7개: orch-selfcheck.js, workbench.js, diag_in.json, t_webview_syntax.js, a.js, result.json, tools/VibeManager/test/t_orch_selfcheck.js
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0059
  - 세션: d1e7f3cd, 1d4cb42c, 407fa98a, e0fd92f7, 42600766, 133cbff8, 473c9c4b, 78af9e01, e610492d
- 01:0x [VMO] VMO 기능 탭 삭제 · Task Log 는 Log 하위 탭 · 창 로드로 끊긴 실행은 알림 1건
  - 지시: "VMO 에 기능 TABPAGE 는 삭제해주세요." / "창 로드로 끊긴 실행을 사건 대신 알림으로 처리하게 고칠까요? 네"
  - 파일 6개: orchestra.js, orch-watch.js, test/t_orch_reloadcut.js, test/run_all.js, extension.js, workbench.js
  - 미확인 2건: VS Code 실화면(창 다시 로드 필요). / 다음 창 로드 때 끊긴 실행이 알림 1건으로 남는 모습.
  - 되돌리기 태그: 20261120_tabdel, 20261120_reloadcut
  - 세션: d1e7f3cd, 1d4cb42c, 696c2058, 03f495b6, 1365d34c, 36c7d0f1, 42600766, 7c2c3699, 82373bdc, a435c93b, d1571c18, 133cbff8, 356d1ad5, 473c9c4b, 6ff41015, 78af9e01, e610492d, 1357fefa, 26627784, 3f29dae7
- 00:5x [업무 작업창] 업무 작업창: 기본 = 부하가 허용하면 동시 · 최대 5화면 · 최근 선택
  - 지시: "VM 업무화면 에서 실행방식 : 부하가 허용하면 동시을 DEFAULT, 최대 5화면 으로 초기값, 그리고 선택에 최근 선택 기능 추가해주세요."
  - 파일 6개: jobs.js, .vibe/jobs/recent_sel.json, tools/Harness/harness.json, job-runner.js, test/t_jobs_recent.js, test/run_all.js
  - 미확인 2건: VS Code 실화면(창 다시 로드 필요). / 실제 5화면 동시 실행(부하 입장 기준에 따라 실제 동시 수는 달라짐).
  - 되돌리기 태그: 20261120_jobsdef
  - 세션: 1365d34c, 36c7d0f1
- 00:4x [VMO] 창 다시 로드로 끊긴 반영 정리 · S8 개선안 효과 판정 범위
  - 지시: "로드함, 정상"
  - 파일 2개: orch-selfcheck.js, test/run_all.js
  - 미확인 2건: VS Code 실화면. / 창 다시 로드 뒤 굳은 안 1건이 다시 대기로 돌아가 자동 반영되는 모습.
  - 되돌리기 태그: 20261120_stale
  - 세션: d1e7f3cd, e0fd92f7
- 00:15 [VMO] VMO 자가 보완: workbench.js 83~1100줄 실행 로그와 알림 문구에서 줄표와 가운뎃점 나열 제거(1차 71건)
  - 지시: "개선안 20261119232524_SELF_4 승인(VM 자가진단 S11 S11/workbench.js). 근거 = .vibe/orch/selfcheck/doc_style/workbench.js.style.csv 333행 중 L83~L1100 구간 121행 = 줄표 71, 가운뎃점 3, 이모지 35, 그 밖 12. 예: L83, L119, L127, L13"
  - 파일 7개: workbench.js, .vibe/orch/selfcheck/doc_style/workbench.js.style.csv, tools/Harness/harness.json, tools/VibeManager/orch-state.js, tools/VibeManager/workbench.js, tools/Docs/doc_style.py, workbench.js.style.csv
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0009
  - 세션: 1d4cb42c, 42600766, a435c93b, 133cbff8, 473c9c4b, 78af9e01, e610492d, 26627784
- 00:04 [VMO] VMO 자가 보완: extension.js 알림과 트리 문구에서 줄표 제거(18건), '모두' 1건 삭제
  - 지시: "개선안 20261119232524_SELF_2 승인(VM 자가진단 S11 S11/extension.js). 근거 = .vibe/orch/selfcheck/doc_style/extension.js.style.csv 51행 중 사용자에게 보이는 문자열의 줄표 = L50, L51, L227, L229, L230, L261, L272, L305, L321, L32"
  - 파일 6개: extension.js, .vibe/orch/selfcheck/doc_style/extension.js.style.csv, pipeline.js, tools/VibeManager/extension.js, tools/Docs/doc_style.py, extension.js.style.csv
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261120_self0000
  - 세션: 696c2058, 133cbff8, 356d1ad5
- 00:0x [VMO] 상황판 A 관제실 · 하단 시간별 흐름 · 반영 실패 자동 해결 · 되돌림 충돌 방지 · 기동 알림 중복
  - 지시: "A 관제실" / "기본은 관제실 컨셉으로 하고,, 하단에 시간별 흐름 의 메인 챠트를 추가해주세요." / "반영실패가 발생할때 제가 지정하지 않아도 오류를 찾아서 보완하고 해결하도록 하려는 것이 목적입니다."
  - 파일 7개: orchestra.js, orch-state.js, orch-selfcheck.js, orch-improve.js, workbench.js, test/run_all.js, doc_style.py
  - 미확인 3건: VS Code 실화면(창 다시 로드 필요). / 실제 반영 실패에서 VMO 가 스스로 진단해 고친 안을 반영하는 모습(가짜 claude 시험으로만 확인). / 승인 대기 중 "고친 안"이 필요한 실패 안 1건(20261119232523_SELF doc_style.py, 20261119232524_SELF_3 문구 6개 모듈)은 다음 tick 부터 진단 대상.
  - 되돌리기 태그: 20261120_boardA, 20261120_repair, 20261120_snapfix, 20261120_srvnote
  - 세션: d1e7f3cd, 1d4cb42c, e0fd92f7, 42600766, a435c93b, 133cbff8, 473c9c4b, 78af9e01, e610492d, 1357fefa, 16c64de0, 26627784
- 세션 696c2058 "extension.js 줄표 제거 개선안 반영" 00:02~00:03, 지시 1건, VM 파일 수정 19건(extension.js 19)
- 세션 e0fd92f7 "VM 고정 문구 줄표·가운뎃점 제거" 00:07~00:09, 지시 1건, VM 파일 수정 19건(prompt-panel.js 8, orch-selfcheck.js 5, flow-panel.js 3, history.js 2, chain-runner.js 1)
- 세션 63629feb "VibeManager 실행 로그 문구 줄표·가운뎃점 정리" 00:11~00:14, 지시 1건
- 세션 4466dd55 "VM 자가진단 점검" 00:16~00:19, 지시 1건
- 세션 351501b7 "SCP0005 CheckList 실행 실패" 00:33~00:37, 지시 1건, 화면 SCP0005
- 세션 6ed377a6 "SCP0005 CheckList 체인 미완료 오류" 00:37~00:39, 지시 1건, 화면 SCP0005, SCP0028, SSP0005
- 세션 bbf62529 "SCP0014 CheckList 실행 실패" 00:39~00:40, 지시 1건, 화면 SCP0014, SCP0005, SCP0028, SSP0005
- 세션 25b1b6e6 ".claude/agents/vm-orchestra.md 를 먼저 읽고 그 순서, 조치 등급, 지킬 것, 결과" 00:48~00:50, 지시 1건, 화면 SCP0005, SCP0028, SSP0005, SSP0014
- 세션 a066e8f0 "SCP0014 CheckList 반복 실패" 00:51~00:51, 지시 1건, 화면 SCP0014, SCP0005, SCP0028
- 세션 c892228c "SSP0005 CheckList 반복 오류" 00:51~00:53, 지시 1건, 화면 SSP0005, SCP0005
- 세션 58218b0c "vm-orchestra R5 진행 없음 사건 분석" 00:54~00:55, 지시 1건, 화면 SCP0028
- 세션 a37c45b0 "VM 오케스트라 R5 진행 없음 SCP0028" 00:55~00:58, 지시 1건, 화면 SCP0028, SSP0005, SCP0005, SSP0014
- 세션 6a9f09f8 "VM 오케스트라 R5 진행 없음 사건 조치" 00:58~00:59, 지시 1건, 화면 SCP0005, SSP0014, SSP0005, SCP0028
- 세션 407fa98a "S8 개선안 효과 판정 S9 key 제외" 01:01~01:02, 지시 1건, VM 파일 수정 1건(t_orch_selfcheck.js 1)
- 세션 fc2c2245 "doc_style.py JS 주석·정규식 제외 개선" 01:06~01:06, 지시 1건
- 세션 670b454e ".claude/agents/vm-orchestra.md 의 지킬 것과 "VM 자가진단" 절을 따른다. 이번 " 01:07~01:08, 지시 1건
- 세션 b5c5a398 "doc_style.py JS 주석·정규식 제외" 01:11~01:13, 지시 1건
- 세션 58469f7e "SCP0028, SSP0014 작업 중단" 04:12~04:15, 지시 3건, 화면 SCP0028, SSP0014
- 세션 1d4cb42c "SCP0028 CheckList 체인 오류" 04:15~04:22, 지시 1건, VM 파일 수정 2건(orch-agent.js 1, workbench.js 1), 화면 SCP0028, SCP0005, SSP0005
- 세션 932e2553 "SSP0014 CheckList 수행 실패" 04:22~04:25, 지시 1건, 화면 SSP0014, SCP0005, SSP0005
- 세션 8bc5e527 "SSP0014 CheckList 체인 오류" 04:26~04:27, 지시 1건, 화면 SSP0014, SCP0005, SSP0005
- 세션 68d816e5 "VibeManager 고정 문구 기호 정리" 05:20~05:22, 지시 1건
- 세션 1365d34c "작업 목록 중지 user.stop 감시기 반영" 05:26~05:29, 지시 1건, VM 파일 수정 3건(job-runner.js 1, orch-watch.js 1, t_orch_watch.js 1)
- 세션 03f495b6 "작업 목록 중지 R11 판정 수정" 05:33~05:34, 지시 1건, VM 파일 수정 5건(orch-watch.js 3, t_orch_watch.js 2)
- 세션 00573c8a "VM 자가진단 repair_20261120003909" 05:37~05:38, 지시 1건
- 세션 03c353e5 "작업 목록 중지 R11 판정 수정" 05:40~05:43, 지시 1건
- 세션 7c2c3699 "VM 오케스트라 R2 반복 집계 중복 제거" 05:52~05:55, 지시 1건, VM 파일 수정 9건(orch-watch.js 8, t_orch_watch.js 1), 화면 SCP0005, SSP0005
- 세션 55cbfc35 "repair_20261120005059_INC 반영 실패" 05:57~05:58, 지시 1건
- 세션 82373bdc "VM 오케스트라 R2 반복 집계 개선" 06:03~06:05, 지시 1건, VM 파일 수정 11건(orch-watch.js 10, t_orch_watch.js 1), 화면 SCP0005, SSP0005
- 세션 d1571c18 "TO-BE 화면 없는 CheckList 실패 제외" 06:11~06:14, 지시 1건, VM 파일 수정 2건(orch-watch.js 1, t_orch_watch_skip_notarget.js 1)
- 세션 36c7d0f1 "VS Code 종료 중지 감시기 알림 수정" 06:19~06:22, 지시 1건, VM 파일 수정 3건(job-runner.js 1, orch-watch.js 1, t_orch_watch.js 1)
- 세션 a435c93b "VM 감시 R5 사건 보정" 06:27~06:30, 지시 1건, VM 파일 수정 4건(orch-state.js 2, orch-watch.js 1, t_orch_watch_gone.js 1), 화면 SSP0005, SCP0028
- 세션 42600766 "VM 작업 로그 파일명 충돌 수정" 06:35~06:39, 지시 1건, VM 파일 수정 5건(t_wb_logname.js 4, workbench.js 1), 화면 SCP0005, SCP0014, SCP0028
- 세션 66b3f90d "repair_20261120005819_INC 개선안 반영 실패" 06:39~06:40, 지시 1건
- 세션 133cbff8 "VM 창 종료 시 체인 끝 기록 남기기" 06:45~06:52, 지시 1건, VM 파일 수정 6건(workbench.js 4, extension.js 1, t_chain_abort.js 1)
- 세션 661e37f9 "VM 실패 개선안 원인 진단" 06:52~06:54, 지시 1건
- 세션 e610492d "R11·R10 사건 결과 건수, 로그 파일 분리" 06:59~07:06, 지시 1건, VM 파일 수정 4건(orch-watch.js 2, workbench.js 1, t_orch_watch.js 1)
- 세션 78af9e01 "workbench.js 로그 파일 이름 겹침과 중지 표시" 07:12~07:23, 지시 1건, VM 파일 수정 5건(workbench.js 4, t_wb_stopmark.js 1), 화면 SCP0005, SSP0005
- 세션 6ff41015 "orch-watch.js R11 체인 결과 파일 판정" 07:29~07:31, 지시 1건, VM 파일 수정 3건(t_orch_watch.js 2, orch-watch.js 1)
- 세션 473c9c4b "VM 작업 로그 이름 화면 ID 추가" 07:37~07:37, 지시 1건, VM 파일 수정 1건(workbench.js 1), 화면 SCP0005, SCP0014, SCP0028
- 세션 356d1ad5 "VM 창 종료 시 체인 끝 기록 남기기" 07:43~07:45, 지시 1건, VM 파일 수정 1건(extension.js 1)
- 세션 b036e257 "SSP0014 CheckList 미검증 해소" 07:43~10:07, 지시 2건, 화면 SSP0014
- 세션 395409cc "SCP0028 CheckList 미검증 해소" 07:48~09:57, 지시 2건, 화면 SCP0028
- 세션 ac61cea7 "SCP0005 CheckList 미검증 해소" 08:28~10:07, 지시 2건, 화면 SCP0005
- 세션 860e3f49 "Vibe_Manager 최근 7일 실행 분석" 09:16~09:29, 지시 1건, 화면 SCP0028, SCP0005, SSP0005, SSP0014, DMF0042, SCP0014
- 세션 c1dc2609 "SSP0005 CheckList 미검증 해소" 09:42~10:16, 지시 2건, 화면 SSP0005
- 세션 8710ce1e "vm-orchestra SSP0005 단계 지연" 09:46~09:47, 지시 1건, 화면 SSP0005, SCP0005, SCP0028, SSP0014
- 세션 5f3e57dd "SCP0028 CheckList 재수행 실행 누락" 09:47~09:50, 지시 1건, 화면 SCP0028, SCP0005, SSP0005, SSP0014
- 세션 16c64de0 "orch-improve 중지 실행 집계 분리" 09:54~09:58, 지시 1건, VM 파일 수정 8건(orch-improve.js 7, t_orch_improve.js 1), 화면 SCP0005, SSP0005, SCP0028, SCP0014, SSP0014
- 세션 1fcc0bc4 "VM 실패 서명 머리 줄 건너뛰기 개선" 10:03~10:06, 지시 1건, VM 파일 수정 3건(t_orch_events.js 2, orch-events.js 1), 화면 SSP0005, SCP0005, SCP0028
- 세션 940d7126 "repair_20261120005059_INC 반영 실패" 10:11~10:13, 지시 1건
- 세션 df956117 "Repair_20261120094530_REVIEW_2 반영 실패" 10:13~10:14, 지시 1건
- 세션 c00b4fb3 "VM 실패 서명 머리 줄 건너뛰기" 10:16~10:19, 지시 1건, 화면 SSP0005, SCP0005, SCP0028
- 세션 1357fefa "VM 에이전트 Claude 호출 측정 기록 개선" 10:23~10:27, 지시 1건, VM 파일 수정 15건(orch-agent.js 7, orch-improve.js 4, orch-watch.js 2, t_orch_agent.js 2), 화면 DMF0042
- 세션 26627784 "사라진 대기 시간 측정 보정" 10:32~10:36, 지시 1건, VM 파일 수정 6건(orch-improve.js 3, orch-state.js 1, orch-watch.js 1, t_orch_watch_gone.js 1), 화면 DMF0042
- 세션 9b1e01ea "repair_20261120094530_REVIEW_4 반영 실패" 10:36~10:36, 지시 1건
- 세션 3f29dae7 "orch-watch 중지 뒤 잠금 정리" 10:39~10:41, 지시 1건, VM 파일 수정 4건(orch-watch.js 3, t_orch_lock_repeat.js 1), 화면 SCP0005, SCP0028, SSP0005, SSP0014
- 세션 54f838a2 ".claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 사용자 지적 학습이" 10:43~10:44, 지시 1건, 화면 SCP0028
- 세션 c47846f7 "Repair_20261120094531_REVIEW 반영 실패" 10:44~10:46, 지시 1건
- VM 실행 48건: SCP0005 chain_checklist 5, SCP0005 S8.checklistRun 5, SCP0028 chain_checklist 4, SCP0028 S8.checklistRun 4, SSP0005 chain_checklist 4, SSP0005 S8.checklistRun 4, SSP0014 chain_checklist 3, SSP0014 S8.checklistRun 3, SCP0005 S8.checklistRecheck 2, SSP0005 claude 2
- 사건: 사건 R12 VM 자가진단 S13 사용자 지적: U9 업무 작업 기록 불일치 J20261120_003352 (open)
- 사건: 사건 R12 VM 자가진단 S13 사용자 지적: U9 업무 작업 기록 불일치 J20261120_054831 (open)
- 사건: 사건 R12 VM 자가진단 S13 사용자 지적: U9 업무 작업 기록 불일치 J20261120_060728 (open)
- 사건: 사건 R7 Claude 비정상 종료 (exit 1). 응답 중 종료 (need-user)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: orch-events.js 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: CHANGELOG.md 내용 다름 (resolved)
- 사건: 사건 R9 죽은 잠금. _run.admit.lock (PID 7540 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.dbwin.SCP0028.lock (PID 7472 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.verify.SCP0028.lock (PID 7472 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.dbwin.SSP0005.lock (PID 7540 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.verify.SSP0005.lock (PID 7540 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.admit.lock (PID 42752 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.dbwin.SCP0005.lock (PID 42752 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.verify.SCP0005.lock (PID 42752 없음) (resolved)
- 사건: 사건 R5 종료 기록 없이 사라진 실행. 프로세스 CheckList 재수행 — 미검증 행만 가능하면 그 규칙만(--only), 아니면 처음부터 → 재분류 · 🔎 CheckList 체인 3단계 (need-user)
- 사건: 사건 R3 단계 지연. 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 12908초(최근 3회 중앙값 6058초의 2.1배) (need-user)
- 사건: 사건 R12 VM 자가진단 S7 VMO 자기 상태: 감시기 tick 멈춤 (resolved)
- 사건: 사건 R9 죽은 잠금. _run.admit.lock (PID 40892 없음) (resolved)
- 사건: 사건 R12 VM 자가진단 S2 시험: t_chain_abort.js 실패 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: workbench.js 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S2 시험: t_wb_logname.js 실패 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: CHANGELOG.md 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: orch-watch.js 내용 다름 (resolved)
- 사건: 사건 R7 Claude 비정상 종료 (exit 1). 응답 중 종료 (resolved)
- 사건: 사건 R9 죽은 잠금. _run.admit.lock (PID 18576 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.dbwin.SCP0005.lock (PID 5080 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.verify.SCP0005.lock (PID 5080 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.dbwin.SCP0028.lock (PID 18576 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.dbwin.SSP0005.lock (PID 17016 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.dbwin.SSP0014.lock (PID 38620 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.verify.SCP0028.lock (PID 18576 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.verify.SSP0005.lock (PID 17016 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.verify.SSP0014.lock (PID 38620 없음) (resolved)
- 사건: 사건 R12 VM 자가진단 S2 시험: t_job_prog.js 실패 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: CHANGELOG.md 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: orch-watch.js 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: CHANGELOG.md 내용 다름 (resolved)
- 사건: 사건 R7 Claude 비정상 종료 (exit 1). 응답 중 종료 (resolved)
- 사건: 사건 R9 죽은 잠금. _run.admit.lock (PID 25188 없음) (resolved)
- 사건: 사건 R11 Claude 없이 끝난 체인. SCP0005 FAIL 27 · 미검증 392 남음 (closed)
- 사건: 사건 R11 Claude 없이 끝난 체인. SSP0005 FAIL 3 · 미검증 434 남음 (closed)
- 사건: 사건 R2 같은 오류 반복 SCP0005 5회 — 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 실패 (exit 1) — 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (closed)
- 사건: 사건 R2 같은 오류 반복 SSP0005 5회 — 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 실패 (exit 1) — 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (closed)
- 사건: 사건 R11 Claude 없이 끝난 체인. SCP0028 FAIL 29 · 미검증 278 남음 (closed)
- 사건: 사건 R2 같은 오류 반복 전 화면 9회 — 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 실패 (exit 1) — 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (closed)
- 사건: 사건 R11 Claude 없이 끝난 체인. SSP0014 FAIL 40 · 미검증 293 남음 (closed)
- 사건: 사건 R1 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 실패 (exit 1) — 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (closed)
- 사건: 사건 R9 죽은 잠금. _run.admit.lock (PID 29164 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.dbwin.SCP0005.lock (PID 21880 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.dbwin.SCP0028.lock (PID 22056 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.dbwin.SSP0005.lock (PID 29164 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.e2e.SCP0005.lock (PID 9632 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.e2e.SCP0028.lock (PID 34428 없음) (resolved)
- 사건: 사건 R9 죽은 잠금. _run.verify.SSP0005.lock (PID 29164 없음) (resolved)
- 사건: 사건 R2 같은 오류 반복 SCP0005 2회 — 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 실패 (exit 1) — 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (resolved)
- 사건: 사건 R2 같은 오류 반복 SCP0005 2회 — 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 실패 (exit 1) — 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (resolved)
- 사건: 사건 R2 같은 오류 반복 SCP0014 2회 — 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 실패 (exit 6) — 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (resolved)
- 사건: 사건 R2 같은 오류 반복 SSP0005 2회 — 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 실패 (exit 1) — 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (resolved)
- 사건: 사건 R7 Claude 비정상 종료 (exit 1). 미분류 (resolved)
- 사건: 사건 R7 Claude 비정상 종료 (exit 1). 응답 중 종료 (resolved)
- 사건: 사건 R7 Claude 비정상 종료 (exit 1). 응답 중 종료 (resolved)
- 사건: 사건 R5 종료 기록 없이 사라진 실행. 프로세스 CheckList 수행 — run_verify 전체(AI 검토 포함: 사용자의견 처리·AS-IS 사실 검토·판정 검토·설명 문장) → 미검증 분류(unverified_triage) · 🔎 CheckList 체인 1단계 (resolved)
- 사건: 사건 R5 종료 기록 없이 사라진 실행. 체인 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (resolved)
- 사건: 사건 R5 종료 기록 없이 사라진 실행. 프로세스 CheckList 수행 — run_verify 전체(AI 검토 포함: 사용자의견 처리·AS-IS 사실 검토·판정 검토·설명 문장) → 미검증 분류(unverified_triage) · 🔎 CheckList 체인 1단계 (resolved)
- 사건: 사건 R5 종료 기록 없이 사라진 실행. 체인 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (resolved)
- 사건: 사건 R5 종료 기록 없이 사라진 실행. 체인 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (resolved)
- 사건: 사건 R5 종료 기록 없이 사라진 실행. 체인 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (resolved)
- 사건: 사건 R5 종료 기록 없이 사라진 실행. Claude 에이전트 대화 (resolved)
- 사건: 사건 R11 Claude 없이 끝난 체인. SSP0005 FAIL 3 · 미검증 434 남음 (resolved)
- 사건: 사건 R1 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 실패 (exit 1) — 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (resolved)
- 사건: 사건 R1 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 실패 (exit 1) — 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (resolved)
- 사건: 사건 R1 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 실패 (exit 6) — 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (closed)
- 사건: 사건 R11 Claude 없이 끝난 체인. SCP0005 FAIL 27 · 미검증 392 남음 (closed)
- 사건: 사건 R1 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) 실패 (exit 1) — 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) (closed)
- 사건: 사건 R9 죽은 잠금. _run.dbwin.SCP0005.lock (PID 23408 없음) (closed)
- 사건: 사건 R12 VM 자가진단 S8 개선안 효과: 자가 보완 뒤에도 남음: workbench.js 83~1100줄 실행 로그와 알림 문구에서 줄표와 가운뎃점 나열 제거(1차 71건) (resolved)
- 사건: 사건 R12 VM 자가진단 S8 개선안 효과: 자가 보완 뒤에도 남음: extension.js 알림과 트리 문구에서 줄표 제거(18건), '모두' 1건 삭제 (resolved)
- 사건: 사건 R12 VM 자가진단 S8 개선안 효과: 자가 보완 뒤에도 남음: VM 파일 수정 직후 120초 안에는 가벼운 점검에서 S3 를 빼고 무거운 점검에서만 판정 (resolved)
- 사건: 사건 R12 VM 자가진단 S2 시험: t_orch_selfapply.js 실패 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: orch-improve.js 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: orch-selfcheck.js 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: orch-state.js 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: orchestra.js 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: workbench.js 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: CHANGELOG.md 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S8 개선안 효과: 자가 보완 뒤에도 남음: workbench.js 웹뷰 스크립트를 t_webview_syntax.js 구문 시험 대상에 추가 (resolved)
- 개선안: 개선안 측정 추가: 사라진 대기의 대기 시간을 발견 시각이 아닌 마지막 생존 확인 시각까지로 잰다(옛 기대 시험 1건 포함) (pending)
- 개선안: 개선안 하위 프로세스 소멸 뒤 10초 유예하고 그동안 proc.end 가 없을 때만 R5(사라진 실행)로 올린다 (pending)
- 개선안: 개선안 R3 단계 지연 기준을 화면별 통계로 분리 (pending)
- 개선안: 개선안 측정 추가: 7일 집계에서 중지된 실행을 실패와 따로 센다(단계, 체인, 프로세스) (applied)
- 개선안: 개선안 실패 서명에서 'log tail:' 머리 줄과 '$ 명령' 줄을 건너뛰고 다음 원인 줄로 서명을 만든다 (applied)
- 개선안: 개선안 측정 추가: 에이전트 Claude 호출 끝 기록에 결과 줄 수신 여부, 마지막 진행 종류, 중지 주체를 남긴다 (applied)
- 개선안: 개선안 측정 추가: 사라진 대기의 대기 시간을 발견 시각이 아닌 마지막 생존 확인 시각까지로 잰다 (superseded)
- 개선안: 개선안 중지 직후 남은 잠금은 사건 없이 지우고 처리 기록만 남긴다 (approved)
- 개선안: 개선안 VM 창이 끝날 때 job 없이 띄운 체인에도 끝 기록(chain.end ok=false, aborted, why 'VM 창 종료로 중단') 남기기(검증 기대값, 대상 경로 정정) (applied)
- 개선안: 개선안 VM 작업 로그 이름에 화면 ID와 실행 번호를 넣어 같은 초에 시작한 실행끼리 로그를 공유하지 않게 함(검증 = 시험만) (applied)
- 개선안: 개선안 CheckList 체인 R11 판정 때 이번 체인이 만든 결과 파일만 사용 (applied)
- 개선안: 개선안 강제 종료된 실행은 '중지'로 표시하고 동시 실행 로그 파일 이름 겹침 제거 (applied)
- 개선안: 개선안 R11·R10 사건이 지난 실행 결과 건수를 쓰지 않게 함, 동시 실행 로그 파일 분리 (applied)
- 개선안: 개선안 VM 창이 끝날 때 job 없이 띄운 체인에도 끝 기록(chain.end ok=false, why 창 종료) 남기기 (superseded)
- 개선안: 개선안 VM 작업 로그 이름에 화면 ID와 procId를 넣어 같은 초에 시작한 실행끼리 로그를 공유하지 않게 함 (superseded)
- 개선안: 개선안 VM 다시 시작 때 지난 실행을 '사라진 실행(R5)'으로 늦게 올리지 않기, 실행 시작 기록에 화면 ID 채우기 (applied)
- 개선안: 개선안 VS Code 종료(dispose)로 멈춘 실행도 감시기에 중지로 알려 R1, R2, R11 사건을 만들지 않는다 (applied)
- 개선안: 개선안 TO-BE 화면이 없는 화면의 CheckList 실패를 반복 오류(R1·R2) 사건에서 제외 (applied)
- 개선안: 개선안 R2 반복 집계에서 같은 실행의 실패를 한 번만 세고, VS Code 종료로 끊긴 실행은 반복 집계에서 뺀다 (apply-failed)
- 개선안: 개선안 작업 목록 중지를 감시기에 알리고 R11 판정에서 사용자 중지와 이전 실행 결과를 뺀다 (applied)
- 개선안: 개선안 작업 목록 중지를 감시기에 user.stop 으로 알리고 CheckList 체인 R11 판정에서 사용자 중지를 뺀다 (applied)
- 개선안: 개선안 S8 개선안 효과 판정에서 S9 반복 수정 key 제외 (applied)
- 개선안: 개선안 doc_style.py JS 소스 검사에서 주석과 정규식 리터럴 제외(확인 기준 정정 재제출) (applied)
- 개선안: 개선안 작은 모듈 고정 문구 줄표, 가운뎃점, 틀 정리(시험 파일 포함 재제출) (applied)
- 검사기 결함: 검사기 결함 T450~T456 2026-11-20 08:3x~08:5x · SCP0005 미검증 해소 · CheckList 07:35 원장
- 검사기 결함: 검사기 결함 T430~T449 2026-11-20 07:5x~08:2x · SCP0028 미검증 해소 · CheckList 07:38 원장

## 2026-11-19

변경 47, 세션 36, VM 실행 61, Claude 호출 51, 사건 28, 개선안 18, 검사기 결함 2

- 23:59 [VMO] VMO 자가 보완: workbench.js 웹뷰 스크립트를 t_webview_syntax.js 구문 시험 대상에 추가
  - 지시: "개선안 20261119232524_SELF 승인(VM 자가진단 S9 S9/file/workbench.js). 근거 = tools/VibeManager/workbench.js:1261 function html(wb, p, state) 가 :3239 module.exports 에 없음. tools/VibeManager/test/t_webview_syntax.j"
  - 파일 9개: workbench.js, tools/VibeManager/workbench.js, tools/VibeManager/test/t_webview_syntax.js, tools/VibeManager/CHANGELOG.md, CHANGELOG.md, test/run_all.js, t_webview_syntax.js, tools/VibeManager/server-service.js 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261119_self2355
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 11ce998e, adda3df7
- 23:5x [VMO] 서버 상태 측정: 측정 중 재호출 때 옛 상태를 남기던 결함 정정
  - 지시: "로드함, 정상" / "종료 뒤 상태 down"
  - 파일 8개: t_server_service.js, server-service.js, test/t_server_service.js, test/run_all.js, doc_style.py, tabview.js, workbench.js, extension.js
  - 미확인 3건: 22:45 되돌려진 문구 개선안의 같은 시험 실패도 이 경로로 설명됨(미확인으로 남겼던 항목). / VS Code 실화면(상태 표시줄 정정은 창 다시 로드 뒤 적용). / 대기 3건(extension.js, 작은 모듈 6개, workbench.js 1차 71건)의 자동 반영.
  - 되돌리기 태그: 20261119_self8
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 11ce998e, adda3df7
- 23:49 [VMO] 2026-11-19 23:49 VMO 디자인 — 반투명 강화 · 크기 축소 · 부하 상단 한 줄
  - 파일 1개: orchestra.js
  - 미확인 1건: VS Code 실화면은 창 다시 로드 뒤 미확인.
  - 되돌리기 태그: 20261119_glass2
  - 세션: d1e7f3cd
- 23:4x [VMO] VMO 자동 반영 하루 상한 해제 · 건너뛴 사유 표시
  - 지시: "하루 상한 6건은 어디서 설정했나요? 하루 상한 지금은 해제해주세요."
  - 파일 5개: orch-selfcheck.js, orchestra.js, workbench.js, tools/Harness/harness.json, test/run_all.js
  - 미확인 1건: 창 로드 뒤 VMO 가 대기 5건을 스스로 반영하는 모습.
  - 되돌리기 태그: 20261119_self7
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 915764f4, 933b1562, be754539, ed77e474, 11ce998e
- 23:25 [VMO] VMO 자가 보완: job-runner.js, server-service.js 고정 문구에서 줄표 제거(29건)
  - 지시: "개선안 20261119220749_SELF_3 승인(VM 자가진단 S11 S11/job-runner.js). 근거 = 입력 key S11/job-runner.js(기호 12), S11/server-service.js(기호 34). .vibe/orch/selfcheck/doc_style/job-runner.js.style.csv 12행이 줄표(L47, L60"
  - 파일 9개: job-runner.js, server-service.js, .vibe/orch/selfcheck/doc_style/job-runner.js.style.csv, server-service.js.style.csv, tools/VibeManager/test/t_job_par.js, t_job_par.js, tools/VibeManager/job-runner.js, tools/VibeManager/server-service.js 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261119_self2320
  - 세션: d1e7f3cd, adda3df7
- 23:20 [VMO] VMO 자가 보완: R5 진행 없음 판정에 E2E 산출물 수정 시각 반영
  - 지시: "개선안 20261119205920_INC 승인(VM 자가진단 ). 근거 = tools/VibeManager/orch-watch.js:170 은 로그 무출력 시간만 cfg.stallSec 과 비교함. 이번 사건 quiet_sec 624. Doc/e2e/specs/_trace.spec.ts 에 상한 20~30분 테스트 3개(1371줄 W4c 1,800,000m"
  - 파일 3개: tools/VibeManager/orch-watch.js, Doc/e2e/specs/_trace.spec.ts, tools/VibeManager/test/t_orch_watch.js
  - 미확인 2건: cfg.stallSec 설정값과 E2E 단계 예외 처리 유무는 미확인. / VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261119_self2315
  - 세션: d1e7f3cd, b96a7c6b, b994a142, bf6d91d6, dec1beda, 5e4c4b2a
- 23:1x [VMO] VMO 자동 반영 기준을 출처에서 대상으로 · 생성물 삭제 7일 기준 · 실패 1회 재시도 · 개선안 탭 분리
  - 지시: "개선안에 보이는 항목들은 제가 확인해서 승인하기 어려운 항목입니다. 이부분은 자동승인 대상으로 되어야 할 것 같은데" / "권장대로 진행해주세요. 로그 삭제 기준은 7일로 할게요."
  - 파일 16개: orch-selfcheck.js, orchestra.js, workbench.js, harness.json, .claude/agents/vm-orchestra.md, job-runner.js, server-service.js, test/run_all.js 외
  - 미확인 4건: 92 가 나온 원인은 미확인(같은 시각에 실행 중인 VMO 와 명령줄 점검이 같은 출력 폴더 .vibe/orch/selfcheck/doc_style 을 씀). / VS Code 실화면(창 다시 로드 필요, 개선안 탭의 자동 반영 기록 표 포함). / 창 로드 뒤 VMO 가 스스로 자동 반영, 자동 삭제하는 모습.
  - 되돌리기 태그: 20261119_self6
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 915764f4, 933b1562, b994a142, be754539, bf6d91d6, dec1beda, ed77e474, 11ce998e, adda3df7
- 22:5x [VMO] 시험 t_server_service.js 고정 포트 5599 → 빈 포트 · 시험 파일 변경도 재점검 대상
  - 지시: "확인하고 수정"
  - 파일 4개: t_server_service.js, test/t_server_service.js, orch-selfcheck.js, test/run_all.js
  - 미확인 2건: 22:45 되돌려진 개선안 20261119220749_SELF_3(문구 29건)의 같은 시험 실패 원인은 미확인(그때 VMO 주기 점검은 꺼져 있었음). / VS Code 실화면(fingerprint 변경은 창 다시 로드 뒤 적용).
  - 되돌리기 태그: 20261119_self5, 20261119_self1
  - 세션: d1e7f3cd, 915764f4, 933b1562, be754539, ed77e474
- 22:40 [VMO] VMO 자가 보완: S6 미확인 원장: 기능 설명 줄 제외, '미확인:' 줄 문장 단위 분리, 'VS Code 화면' 항목을 창 로드 기록과 연결
  - 지시: "개선안 20261119220749_SELF_2 승인(VM 자가진단 S6 S6/CL:2026-11-19:1dt58td#5db5f5186f). 근거 = 입력 key S6/CL:2026-11-19:1dt58td#173850d3ab, #5db5f5186f, #83dd6e11b0 = tools/VibeManager/CHANGELOG.md 12, 13, 15줄(Q3,"
  - 파일 9개: tools/VibeManager/CHANGELOG.md, tools/VibeManager/orch-history.js, CHANGELOG.md, tools/VibeManager/orch-selfcheck.js, orch-history.js, orch-selfcheck.js, unverified.json, tools/VibeManager/test/t_orch_history.js 외
  - 미확인 7건: 낱말 '미확인'이 화면 항목 이름으로 들어 있음. / tools/VibeManager/orch-history.js:92-94 가 낱말 포함만으로 미확인 항목에 넣음. / :93 은 '미확인:' 줄을 가운뎃점으로만 나눠 CHANGELOG.md 23줄의 5개 문장이 1건(#063a3fe3c4)이 됨.
  - 되돌리기 태그: 20261119_self2235
  - 세션: d1e7f3cd, 915764f4, 933b1562, be754539, ed77e474
- 22:35 [VMO] VMO 자가 보완: VM 파일 수정 직후 120초 안에는 가벼운 점검에서 S3 를 빼고 무거운 점검에서만 판정
  - 지시: "개선안 20261119220749_SELF 승인(VM 자가진단 S3 S3/orch-selfcheck.js). 근거 = 입력 key S3/orch-improve.js, S3/orch-selfcheck.js, S3/orchestra.js, S3/workbench.js(저장소 수정 22:03, 점검 22:05:27). tools/VibeManager/orch-s"
  - 파일 8개: orch-selfcheck.js, orch-improve.js, orchestra.js, workbench.js, tools/VibeManager/orch-selfcheck.js, raised.json, tools/VibeManager/test/t_orch_selfcheck.js, good.js
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261119_self2230
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 915764f4, 933b1562, b994a142, be754539, bf6d91d6, dec1beda, ed77e474, 11ce998e
- 22:30 [VMO] VMO 자가 보완: VMO 켜고 끄기의 harness.json 교체에 EPERM 재시도 적용, 쓰기 실패를 오류 기록에 남김
  - 지시: "개선안 20261119215147_SELF_3 승인(VM 자가진단 S5 ). 근거 = 오류 기록 서명 'orch-history.writeJson / EPERM: operation not permitted, rename <path> -> <path>'(.vibe/orch/vm_errors_dev_20261119_2147.jsonl 1행, 2026-11-19 "
  - 파일 10개: orch-history.js, orch-selfcheck.js, orch-agent.js, harness.json, orch-improve.js, tools/VibeManager/orch-agent.js, tools/VibeManager/orch-improve.js, tools/VibeManager/orch-watch.js 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261119_self2226
  - 세션: d1e7f3cd, b96a7c6b, 915764f4, 933b1562, b994a142, be754539, bf6d91d6, dec1beda, ed77e474, 5e4c4b2a
- 22:15 [VMO] VMO 자가 보완: VMO 3개 모듈 고정 문구에서 줄표와 가운뎃점 나열 제거(62건)
  - 지시: "개선안 20261119215147_SELF_4 승인(VM 자가진단 S11 S11/orch-agent.js). 근거 = 입력 key S11/orch-agent.js(기호 23), S11/orch-improve.js(기호 23), S11/orch-watch.js(기호 16). .vibe/orch/selfcheck/doc_style/orch-agent.js.st"
  - 파일 9개: orch-agent.js, orch-improve.js, orch-watch.js, .vibe/orch/selfcheck/doc_style/orch-agent.js.style.csv, CLAUDE.md, tools/VibeManager/orch-agent.js, tools/VibeManager/orch-improve.js, tools/VibeManager/orch-watch.js 외
  - 미확인 1건: VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261119_self2208
  - 세션: d1e7f3cd, b96a7c6b, b994a142, bf6d91d6, dec1beda, 5e4c4b2a
- 22:0x [VMO] VMO 자가 보완 자동 반영 전환 · Claude 허용 도구 인자 정정
  - 지시: "자가 진단은 VM 의 현상태를 자기가 점검하고 진단해서 보완이 필요하면 보완을 진행해야 합니다." / "권장대로 자동 보완으로 변경해주세요."
  - 파일 11개: orch-selfcheck.js, orchestra.js, workbench.js, orch-agent.js, harness.json, .claude/agents/vm-orchestra.md, job-runner.js, server-service.js 외
  - 미확인 4건: 종전에는 --allowedTools 의 Bash(node *) 가 공백에서 쪼개져 node 명령이 "This command requires approval" 로 거부됨(22:08~22:21 자가 보완 3건 실패 원인, 20:59 개선안 20261119205920_INC 의 "검증 실패: 미실행"과 같은 문구). / VS Code 실화면(창 다시 로드 필요). / 창 다시 로드 뒤 VMO 가 주기 tick 에서 스스로 자동 반영하는 모습.
  - 되돌리기 태그: 20261119_self3, 20261119_self4
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 915764f4, 933b1562, b994a142, be754539, bf6d91d6, dec1beda, ed77e474, 11ce998e, adda3df7
- 21:5x [VMO] VMO 자가진단 개선안 1 반영: 변경 게이트 감시 대상에 tools/CommonSync 추가
  - 지시: "개선안 1번 승인할게요, 반영해주세요."
  - 파일 5개: run_verify.py, tools/CommonSync/screen_sync.py, engine_selfcheck.py, tools/Harness/verify/engine_selfcheck.py, scripts/rules/inventory_check.py
  - 되돌리기 태그: 20261119_self2
- 21:1x [VMO] VMO 작업 이력 취합 · VM 자가진단 S1~S12 · 자가 보완 반영 절차
  - 지시: "VMO 의 추가 기능으로 지금까지 클로드코드, 클로드를 통해서 VM 보완, 그리고 작업을 진행한 이력을 다 취합해서 어떤 작업을 했는지 정리하고, VMO가 가동중일 때 VM 의 보완필요 부분을 찾아서 자가진단하고 보완할 수 있도록 기능을 추가해주세요."
  - 파일 37개: /.claude/plans/vm-ui-snug-mountain.md, orch-errlog.js, extension.js, workbench.js, orchestra.js, jobs.js, orch-history.js, meta.json 외
  - 미확인 5건: VS Code 실화면(창 다시 로드 필요). / 가동 중 주기 점검(시작 45초 뒤 첫 실행, 10분 주기)과 첫 이력 수집 자동 실행. / 실제 Claude 로 자가 보완 반영(가짜 claude 로만 확인).
  - 되돌리기 태그: 20261119_self1
  - 세션: 26317e78, d171d1d6, d1e7f3cd, b96a7c6b, 915764f4, 933b1562, b994a142, be754539, bf6d91d6, dec1beda, ed77e474, 11ce998e, 5e4c4b2a, adda3df7
- 20:1x [VMO] VMO 개선안 2 반영: VMO 에이전트 호출은 종료 전 게이트 건너뜀 · 결과 뒤 비정상 종료 처리
  - 지시: "개선안 2번 승인할게요, 반영해주세요."
  - 파일 3개: orch-agent.js, tools/Harness/hooks/harness-stop-gate.ps1, t_orch_agent.js
  - 미확인 1건: 비용 숫자'는 실제 Claude 호출이 필요해 미실행.
  - 되돌리기 태그: 20261119_prop2
  - 세션: d1e7f3cd, b994a142, bf6d91d6, dec1beda
- 20:1x [VMO] VMO 개선안 1 반영: 종료 전 hook 제한 60초 → 960초 · 게이트 시작·끝 기록
  - 지시: "개선안 1번 승인할게요, 반영해주세요."
  - 파일 6개: check.js, run_verify.py, .claude/settings.json, harness-stop-gate.ps1, tools/Harness/hooks/harness-stop-gate.ps1, settings.json
  - 미확인 1건: 실제 화면 게이트 실행과 960초 제한의 실동작은 미확인(지금 DB MODE 라 게이트가 돌지 않음).
  - 되돌리기 태그: 20261119_dbmode, 20261119_prop1
- 19:5x [VMO] VMO 개선안 4 반영: 끝 사건 없이 사라진 대기 · Claude 호출을 집계에 포함
  - 지시: "개선안 4번 승인할게요, 반영해주세요."
  - 파일 7개: orch-improve.js, orch-watch.js, orch-agent.js, t_orch_improve.js, t_orch_state_old.js, test/t_orch_improve.js, test/t_orch_state_old.js
  - 되돌리기 태그: 20261119_prop4
  - 세션: d1e7f3cd, b96a7c6b, b994a142, bf6d91d6, dec1beda, 5e4c4b2a
- 19:5x [VMO] VMO 개선안 3 반영: 잠금에 실행 주체 기록 · 같은 죽은 잠금 3회부터 묶음 사건
  - 지시: "개선안 3번 승인할게요, 반영해주세요."
  - 파일 10개: tools/Harness/verify/run_verify.py, orch-watch.js, .vibe/orch/lock_history.json, orch-agent.js, orch-state.js, orchestra.js, t_orch_watch.js, t_orch_lock_repeat.js 외
  - 미확인 2건: 실제 DMF0042 실행이 남긴 잠금의 부모 사슬(다음 실행부터 기록됨) / VS Code 실화면(창 다시 로드 필요).
  - 되돌리기 태그: 20261119_prop3
  - 세션: d1e7f3cd, b96a7c6b, b994a142, bf6d91d6, dec1beda, 5e4c4b2a
- 18:5x [VMO] VMO: 에이전트 탭 = 위 Console · 아래 프롬프트 창 · 켜고 끄기 스위치 · Log 탭 맨 뒤
  - 지시: "VMO 에이전트의 프롬프트 창을 하단에 배치하고 상단에 Console 창으로 · 프롬프트 입력의 Key와 대기기능, Boarder Width 와 그림자등을 Workbench 의 프롬프트 창과 동일한 기능으로" / "우측 상단의 중지 를 버튼형식으로 해서 켜고 끌 수 있도록" / "VMO TAB 순서에 LOG 을 제일 뒤로"
  - 파일 8개: orchestra.js, orch-agent.js, tools/Harness/harness.json, orch-watch.js, orch-improve.js, tools/VibeManager/test/t_orch_agent_q.js, workbench.js, harness.json
  - 미확인 1건: VS Code 실화면과 실제 Claude 응답 중 '지금 보내기'는 미확인.
  - 되돌리기 태그: 20261119_agprompt
  - 세션: 26317e78, d171d1d6, d1e7f3cd, b96a7c6b, b994a142, bf6d91d6, dec1beda, 11ce998e, 5e4c4b2a
- 18:5x [VMO] VMO 기능 탭: 아래에 Task Log 이름과 영역 항상 표시
  - 지시: "아래에 TASK LOG 명칭과 영역을 표기"
  - 미확인 1건: VS Code 실화면 미확인(창 다시 로드 필요).
  - 되돌리기 태그: 20261119_tlbottom
- 18:5x [VMO] VMO 창 탭 이름 '공통 기능' → '기능'
  - 지시: "공통기능은 기능으로 변경"
  - 파일 2개: quick.json, package.json
  - 미확인 1건: VS Code 실화면 미확인(창 다시 로드 필요).
  - 세션: d171d1d6, d1e7f3cd
- 18:4x [VMO] VMO 창: 명칭 VMO · 반투명 대시보드 · 공통 기능 전체 영역 · Log 하위 탭 · 아이콘 버튼 · Workbench FE/BE Log 제거
  - 지시: "VM 오케스트라의 명칭을 VMO 로" / "공통기능의 하위를 전체 영역으로 채우고 디자인을 세련되게 · 상황판도 반투명으로 비치게 하고 DASHBOARD 형태로" / "WORKBENCH 의 LOG 창에 있는 BE, FE LOG 는 삭제"
  - 파일 2개: orchestra.js, workbench.js
  - 미확인 2건: VS Code 실화면은 미확인(창 다시 로드 필요). / VS Code 웹뷰의 배경 번짐(backdrop-filter) 표시도 미확인.
  - 되돌리기 태그: 20261119_dash, 20261119_logtab, 20261119_nolog, 20261119_orchname
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 11ce998e
- 18:4x [VMO] 오케스트라 창 명칭 = 'VM Orch'
  - 지시: "VM 오케스트라 의 명칭을 영문으로" / "아니면 VM Orch 로 변경"
  - 파일 4개: orchestra.js, .claude/agents/vm-orchestra.md, quick.json, package.json
  - 미확인 1건: VS Code 실화면 미확인(창 다시 로드 필요).
  - 되돌리기 태그: 20261119_orchname
  - 세션: d171d1d6, d1e7f3cd
- 18:3x [체인·메뉴] 사이드바 제목줄 아이콘 = 흰색 계열 1색으로 통일
  - 지시: "VIBE MANAGER 우측의 아이콘도 WHITE 계열 1 COLOR 로 아이콘 통일"
  - 파일 2개: -dark.svg, package.json
  - 미확인 1건: VS Code 실화면 미확인(창 다시 로드 필요 — 아이콘은 package.json 을 다시 읽을 때 바뀜).
  - 되돌리기 태그: 20261119_icons
- 18:2x [VMO] 오케스트라: 창 다시 로드 뒤 실측 · 감시기 정정 · AI 검토 상한 삭제
  - 지시: "로드함, 정상" / "상한 5 USD 는 삭제해주세요... ULTRA 사용중입니다."
  - 파일 9개: servers.json, orch-watch.js, orch-state.js, Doc/asisfacts/.../combo_values.json, CHANGELOG.md, harness.json, t_orch_state_old.js, tools/VibeManager/test/t_orch_state_old.js 외
  - 미확인 2건: 18:16:53 에 시작한 감시기가 17:49:03 의 wait.start 줄을 읽은 경로(시험 t_orch_state_old.js 에서 시작 전 줄은 다시 읽지 않음을 확인). / 재현되면 추가 조사.
  - 되돌리기 태그: 20261119_orchfix1
  - 세션: d1e7f3cd, b96a7c6b, b994a142, bf6d91d6, dec1beda, 5e4c4b2a
- 18:1x [VMO] 오케스트라 P9·P10: 업무 작업 동시 실행 · 생성·보완 업무 추가
  - 지시: "CHECKLIST 을 10개 화면을 선택해서 순차적으로 돌리고 싶을 때(이때 부하가 허락하면 멀티실행)" / "고를 수 있는 업무에 UI 생성이나 보완은 왜 추가가 되지 않았나요? · UI/DB 모드에서 고를 수 있으면 됩니다"
  - 파일 10개: job-runner.js, tools/E2E/e2e.config.json, harness.json, run_verify.py, chain-runner.js, workbench.js, quick.json, jobs.js 외
  - 미확인 1건: 기존 화면 건너뜀과 실제 생성 체인의 창 없는 실행, 실제 CheckList 동시 실행(플랜 7절 검증 15), VS Code 실화면은 미확인.
  - 되돌리기 태그: 20261119_orchp9, 20261119_orchp10
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 11ce998e, adda3df7
- 18:0x [VMO] 오케스트라 P8: 업무 작업창 1차 — 업무 1개 × 화면 여러 개 순차 실행
  - 지시: "화면설계서를 메뉴에 있는 화면을 멀티로 선택해서 한꺼번에 생성 · CHECKLIST 을 10개 화면을 선택해서 순차적으로 · UI 에 종속되지 않고 업무기능에 종속되는 작업창"
  - 파일 9개: job-runner.js, quick.json, /job.json, SUMMARY.md, jobs.js, flow-panel.js, tools/VibeManager/test/t_job_runner.js, package.json 외
  - 미확인 2건: 실제 업무(문서 생성·CheckList)를 실제 화면에 돌린 사례와 VS Code 실화면은 미확인(플랜 7절 검증 13·14 미실행). / 참고: 18:07 quick.json·package.json 쓰기가 1회 실패(OSError 22 / UNKNOWN, 원인 미확인)해 임시 파일 → 교체 방식으로 다시 적용함.
  - 되돌리기 태그: 20261119_orchp8
  - 세션: d171d1d6, d1e7f3cd, adda3df7
- 17:5x [VMO] 오케스트라 P7: 창 없는 체인 실행기 ChainRunner
  - 지시: "UI 에 종속되지 않고 업무기능에 종속되는 작업창도 추가"
  - 파일 4개: chain-runner.js, workbench.js, tools/VibeManager/test/t_chain_runner.js, FULLRUN.md
  - 미확인 1건: 플랜 7절 검증 12(같은 화면에서 추출 전후 FULLRUN.md 비교)는 VS Code 실행이 필요해 미실행.
  - 되돌리기 태그: 20261119_orchp7
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 11ce998e
- 17:4x [VMO] 오케스트라 P6: CheckList 반복 대응
  - 지시: "CHECKLIST 에도 클로드 AI 가 반영되고 있는줄 알았는데, 반영되지 않고 있으면서, 계속 오류만 반복"
  - 파일 13개: /llm_usage.csv, quick.json, unverified_triage.json, harness.json, Doc/verify/_llm_usage.csv, fixlist.csv, test/t_orch_agent_diag.js, _unverified_decisions.md 외
  - 미확인 2건: 수정 권한(B 등급)으로 실제 사건을 조치한 사례는 미실행. / Flow 보드·요약 문구의 VS Code 실화면은 미확인.
  - 되돌리기 태그: 20261119_orchp6
  - 세션: 26317e78, d171d1d6, d1e7f3cd, b96a7c6b, 11ce998e, 5e4c4b2a
- 17:3x [VMO] 오케스트라 P5: 상시 개선안 — 제시 → 사용자 승인 → 반영
  - 지시: "상시 활동의 경우 개선안을 제시하고 사용자 승인후에 반영될 수 있도록"
  - 파일 10개: orch-improve.js, .vibe/orch/digest.json, orch-agent.js, harness.json, tools/VibeManager/test/t_orch_improve.js, t_orch_agent.js, t_orch_watch.js, workbench.js 외
  - 미확인 2건: 실제 Claude 로 분석·반영한 사례는 미실행. / VS Code 실화면 미확인.
  - 되돌리기 태그: 20261119_orchp5
  - 세션: 26317e78, d171d1d6, d1e7f3cd, b96a7c6b, b994a142, bf6d91d6, dec1beda, 11ce998e, 5e4c4b2a
- 17:2x [VMO] 오케스트라 P4: 에이전트 조치
  - 지시: "오류발생 시 조치하거나 보완할 수 있도록 · CheckList 만 한정된 것이 아니고 UI 생성 및 보완 등 모든 활동에 관여"
  - 파일 8개: orch-agent.js, server_guard.py, .claude/agents/vm-orchestra.md, tools/Harness/harness.json, workbench.js, tools/VibeManager/test/t_orch_agent.js, t_orch_agent_real.js, harness.json
  - 미확인 3건: 실제 사건에 실제 Claude 가 조치한 사례는 미실행. / R6 서버 재기동 코드 조치는 시험 미실행. / VS Code 실화면 미확인(창 다시 로드 필요).
  - 되돌리기 태그: 20261119_orchp4
  - 세션: 26317e78, d171d1d6, d1e7f3cd, b994a142, bf6d91d6, dec1beda, 11ce998e
- 16:5x [VMO] 오케스트라 P0~P3: 사건 기록 · 서버 분리 · 오케스트라 창 · 감시기
  - 지시: "VM 의 기능을 UI 별 기능과 공통기능으로 분리 · BE LOG, FE LOG 창을 이쪽으로 이동 · BE, FE 기동상태 항상 표시 · VM 을 모니터링 하고 문제해결을 직접 진행하는 AI 에이전트를 오케스트라 기능으로"
  - 파일 21개: /.claude/plans/vm-ui-snug-mountain.md, build_vsix.py, recheck.js, extension.js, orch-events.js, workbench.js, tools/Harness/verify/orch_event.py, run_verify.py 외
  - 미확인 2건: VS Code 실화면·실제 체인 실행·BE/FE 실기동은 미확인(창 다시 로드 필요). / 플랜 7절 검증 1~6·11 미실행.
  - 되돌리기 태그: 20261119_orch, 20261119_orchp2
  - 세션: 26317e78, d171d1d6, d1e7f3cd, b96a7c6b, b994a142, bf6d91d6, dec1beda, 11ce998e, 5e4c4b2a, adda3df7
- 16:5x [CheckList 엔진] 환경설정 = 🧠 AI 검토 켜기/끄기
  - 지시: "VM 환경설정에 AI 검토 켜고 끄는 항목 추가"
  - 파일 7개: quick.json, steps.json, tools/Harness/verify/set_llm_review.py, tools/Harness/harness.json, set_llm_review.py, harness.json, workbench.js
  - 미확인 1건: VS Code 화면 미확인.
  - 되돌리기 태그: 20261119_llmset
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 11ce998e
- 16:4x [CheckList 엔진] CheckList AI 검토 연결
  - 지시: "CheckList 의 각각의 단계별 판단을 할 때 필요하면 클로드코드를 활용"
  - 파일 6개: quick.json, steps.json, opinion_intake.py, Doc/verify/_ENGINE_MASTER.md, tools/Harness/harness.json, workbench.js
  - 미확인 1건: VS Code 화면·Flow 보드 표시 미확인.
  - 되돌리기 태그: 20261119_llm
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 11ce998e
- 14:1x [체인·메뉴] Flow 단계 카드 = 제목 뒤 공백 대신 상세 상태 · 체인 제목 괄호 설명 제거
  - 지시: "CheckList 수행 뒤에 공백이 있고 뒤쪽 상세 STATUS 는 안 보임 · 공백을 유지한 이유?"
  - 미확인 1건: VS Code 화면 미확인.
  - 되돌리기 태그: 20261119_gap
- 11:2x [Workbench] Flow 보드 이름 = 괄호 설명 빼고 표시
  - 지시: "4/8 하위의 1/80 같은 하위 step 이 잘려서 안 보임 · CheckList 수행 (…) 과 하위 작업의 ( ) 설명 문장 삭제"
  - 파일 2개: quick.json, FULLRUN.md
  - 미확인 1건: VS Code 화면 미확인.
  - 되돌리기 태그: 20261119_short
  - 세션: d171d1d6, d1e7f3cd
- 11:1x [체인·메뉴] 프롬프트창 새 창·원격 아이콘 = '/' 명령 메뉴 안으로
  - 지시: "프롬프트 창의 새창, 리모트 아이콘은 명령 아이콘 하위에"
  - 미확인 1건: VS Code 화면 미확인.
  - 되돌리기 태그: 20261119_cmdmenu
- 11:1x [Workbench] 프롬프트창 작업 모드 = 드롭다운 선택
  - 지시: "프롬프트 창에 추가된 mode 는 dropdown 으로 선택"
  - 파일 1개: set_scope.py
  - 미확인 1건: VS Code 화면·실제 변경 미확인.
  - 되돌리기 태그: 20261119_modedd
- 11:1x [Workbench] 프롬프트창 테두리 = 평소 은은하게 · 커서 있을 때 얇게 + 그림자
  - 지시: "커서가 없을 때는 투명도를 높여 은은하게 · 커서가 갔을 때는 두께를 줄이고 그림자가 보이는 느낌"
  - 미확인 1건: VS Code 화면 미확인.
  - 되돌리기 태그: 20261119_pbox
- 11:0x [Workbench] 답변·최종 보고 앞 초록 세로 막대 = 반투명
  - 지시: "최종 보고나 결과 앞 초록색 세로 bar · 같은 색감 · 반투명으로 은은하게"
  - 되돌리기 태그: 20261119_bar
- 10:5x [Workbench] Console HTML 틀 머리 버튼 = 배경 없는 아이콘
  - 지시: "건수 현황 및 html 형태로 보일 때 상단의 접기, 브라우저로 열기 2개 버튼은 투명한 형태의 아이콘으로"
  - 미확인 1건: VS Code 화면 미확인.
  - 되돌리기 태그: 20261119_hvicon
- 10:5x [Workbench] 작업 모드 = 프롬프트창 모델 옆 표시 · Console 안내 줄 제거
  - 지시: "작업 모드 표기가 항상 Console 창에 표기됨 · 보이지 않게 · 프롬프트창 엔진 옆에 표기(DB Mode, UI&DB Mode)"
  - 파일 1개: harness.json
  - 미확인 1건: VS Code 화면 미확인.
  - 되돌리기 태그: 20261119_modechip
- 10:2x [Workbench] 답변·결과 = Markdown 정리 형태로 표시
  - 지시: "답변이나 작업 결과를 나열할 때 Claude Code 처럼 정리된 형태로 · 지금은 나열된 text 안에서 결과를 찾아야 함"
  - 미확인 1건: VS Code 화면 미확인.
  - 되돌리기 태그: 20261119_md
- 10:1x [CheckList 엔진] 단계 안 작업 = 하위 단계 표시 · 🧪 미검증 해소 메뉴 = 보완까지만, CheckList 재수행은 승인 때만
  - 지시: "미검증 해소 후 CheckList 수행 때 진행 step 이 제대로 보이지 않음 · 하나의 동작에서 다른 job 을 수행할 때 sub 단위 step 으로" / "CheckList 체인 안 미검증 해소 = 해소 뒤 CheckList 자동 재수행 · 미검증 해소 메뉴 직접 실행 = 해소만, CheckList 는 사용자 승인 때만"
  - 파일 4개: run_verify.py, quick.json, workbench.js, checklist_run.py
  - 미확인 1건: VS Code 실행·승인 창 미확인.
  - 되돌리기 태그: 20261119_substep
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 11ce998e
- 09:3x [Workbench] Console 현황판 글자 축소 · 후속 작업 안내 접기
  - 지시: "건수 표기 DASHBOARD 만 폰트가 큼 · 줄여 달라" / "후속 작업 안내(프로세스 17개 목록)는 줄여 표기하고 클릭할 때만 상세"
  - 파일 3개: tools/Docs/screen_status.py, run_verify.py, e2e_suite.py
  - 미확인 1건: VS Code 화면 표시 미확인.
  - 되돌리기 태그: 20261119_hvfold
- 09:1x [체인·메뉴] 체인 조건부 단계 = 실행이 정해질 때 STEP 추가
  - 지시: "CheckList 작업 시 최초부터 3단계 보완까지 전체 STEP 으로 표기됨 · CheckList 작업만 진행하고 필요할 때 STEP 추가"
  - 파일 3개: quick.json, workbench.js, FULLRUN.md
  - 미확인 1건: VS Code 체인 실행 미확인.
  - 되돌리기 태그: 20261119_dynstep
  - 세션: 26317e78, d171d1d6, d1e7f3cd, 11ce998e
- 세션 1b3e5376 "DM 운영 속도개선" 09:18~18:14, 지시 5건, 화면 DMF0082
- 세션 adb6b365 "**[작업 모드 = DB MODE — 환경설정 값 · 아래 본문보다 이 문단이 우선한다]** DB 객체(PK" 09:22~10:04, 지시 1건, 화면 SCP0096
- 세션 d171d1d6 "SCP0111 CheckList 미검증 해소" 10:24~11:00, 지시 3건, VM 파일 수정 10건(extension.js 4, recheck.js 2, workbench.js 2, flow-panel.js 1, quick.json 1), 화면 SCP0111
- 세션 f98cd180 "SCP0111 CheckList 미검증 해소" 12:24~13:44, 지시 2건, 화면 SCP0111
- 세션 9cee8c43 "tools/Harness/verify/llm_call.py 의 1번째 줄을 Read 로 읽고 JSON 하나만" 16:12~16:13, 지시 1건
- 세션 c639852d "SSP0014 CheckList 미검증 해소" 16:18~17:25, 지시 2건, 화면 SSP0014
- 세션 d1e7f3cd "VM 기능 분리 및 오케스트라 에이전트 계획" 16:30~2026-11-20 10:45, 지시 65건, VM 파일 수정 187건(workbench.js 54, orchestra.js 29, extension.js 12, jobs.js 9, job-runner.js 7), 화면 SCP0028
- 세션 81932e1b "SCP0028 CheckList 미검증 해소" 16:35~17:25, 지시 2건, 화면 SCP0028
- 세션 5e94a827 "SCP0005 CheckList 미검증 해소" 17:08~17:29, 지시 3건, 화면 SCP0005
- 세션 5a94924a ".claude/agents/vm-orchestra.md 의 조치 등급과 지킬 것을 따른다. 사건 없이 온 사" 17:26~17:28, 지시 1건
- 세션 8f0f5ce2 ".claude/agents/vm-orchestra.md 를 먼저 읽고 그 순서, 조치 등급, 지킬 것, 결과" 17:48~17:49, 지시 1건, 화면 SCP0111, DMF0068, DMF0004, DMF0042, DMF0035, DMF0005
- 세션 ac8ed9a1 "DMF0042 dbwin 대기 지연" 18:18~18:21, 지시 1건, 화면 DMF0042
- 세션 dccadc4a "DMF0042 dbwin 대기 지연" 18:29~18:30, 지시 1건, 화면 DMF0042
- 세션 9ee164e6 "vm-orchestra DMF0042 기동 출처" 18:31~18:36, 지시 1건, 화면 DMF0042
- 세션 eb6d0a98 "Vibe_Manager 7일 실행 집계" 19:32~19:35, 지시 1건, 화면 DMF0042
- 세션 48e8235d "CheckList run_verify 진행 없음" 20:57~20:59, 지시 1건, 화면 SCP0005, SSP0014, SCP0028, SSP0005
- 세션 cde8f9e0 ".claude/agents/vm-orchestra.md 의 지킬 것과 "VM 자가진단" 절을 따른다. 이번 " 21:48~21:51, 지시 1건
- 세션 b96a7c6b "orch-watch R5 진행 없음 판정 개선" 21:50~21:52, 지시 1건, VM 파일 수정 4건(orch-watch.js 3, t_orch_watch.js 1)
- 세션 fc243515 "Vibe_Manager 자가진단" 22:05~22:07, 지시 1건
- 세션 bf6d91d6 ".claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 사용자가 승인한 개" 22:07~22:08, 지시 1건, VM 파일 수정 5건(orch-agent.js 2, orch-improve.js 1, orch-watch.js 1, t_orch_agent_q.js 1)
- 세션 b994a142 ".claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 사용자가 승인한 개" 22:10~22:13, 지시 1건, VM 파일 수정 50건(orch-agent.js 18, orch-improve.js 17, orch-watch.js 15)
- 세션 ed77e474 ".claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 사용자가 승인한 개" 22:16~22:18, 지시 1건, VM 파일 수정 7건(t_orch_selfcheck.js 5, orch-selfcheck.js 2)
- 세션 be754539 ".claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 사용자가 승인한 개" 22:20~22:21, 지시 1건, VM 파일 수정 7건(t_orch_selfcheck.js 3, orch-history.js 2, orch-selfcheck.js 1, t_orch_history.js 1)
- 세션 5ff14712 "Bash 도구로 다음 명령 1개를 그대로 실행하고 결과 줄만 답한다. 다른 명령은 실행하지 않는다. node" 22:22~22:22, 지시 1건
- 세션 dec1beda ".claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 사용자가 승인한 개" 22:28~22:29, 지시 1건, VM 파일 수정 7건(t_orch_agent_q.js 3, orch-agent.js 2, orch-improve.js 1, orch-watch.js 1)
- 세션 915764f4 ".claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 사용자가 승인한 개" 22:32~22:33, 지시 1건, VM 파일 수정 3건(t_orch_selfcheck.js 2, orch-selfcheck.js 1)
- 세션 933b1562 ".claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 사용자가 승인한 개" 22:37~22:39, 지시 1건, VM 파일 수정 8건(orch-history.js 3, t_orch_selfcheck.js 3, orch-selfcheck.js 1, t_orch_history.js 1)
- 세션 adda3df7 ".claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 사용자가 승인한 개" 22:42~22:43, 지시 1건, VM 파일 수정 24건(server-service.js 13, job-runner.js 10, t_job_par.js 1)
- 세션 421256de ".claude/agents/vm-orchestra.md 의 지킬 것과 "VM 자가진단" 절을 따른다. 이번 " 23:04~23:04, 지시 1건
- 세션 5e4c4b2a ".claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 사용자가 승인한 개" 23:17~23:18, 지시 1건, VM 파일 수정 4건(orch-watch.js 3, t_orch_watch.js 1)
- 세션 5a898c98 "Vibe_Manager 자가진단" 23:18~23:20, 지시 1건
- 세션 00ee996a ".claude/agents/vm-orchestra.md 의 지킬 것과 "VM 자가진단" 절을 따른다. 이번 " 23:22~23:25, 지시 1건
- 세션 6d82dc18 ".claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 사용자가 승인한 개" 23:22~23:23, 지시 1건
- 세션 167506ee "doc_style.py 주석 백틱 짝지음 수정" 23:43~23:45, 지시 1건
- 세션 285d33aa "doc_style.py 주석 백틱 짝지음 오류 수정" 23:53~23:55, 지시 1건
- 세션 11ce998e "workbench.js 웹뷰 구문 시험 추가" 23:57~23:58, 지시 1건, VM 파일 수정 3건(t_webview_syntax.js 2, workbench.js 1)
- VM 실행 61건: SCP0096 claude 9, SCP0111 claude 5, SCP0005 claude 3, SCP0028 claude 3, SCP0028 S8.checklistRecheck 3, SSP0014 claude 3, SSP0014 S8.checklistRecheck 3, SCP0028 chain_checklist 2, SCP0028 S8.checklistRun 2, SSP0005 chain_checklist 2
- 사건: 사건 R12 VM 자가진단 S2 시험: t_server_service.js 실패 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: CHANGELOG.md 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S2 시험: t_orch_selfapply.js 실패 (resolved)
- 사건: 사건 R12 VM 자가진단 S2 시험: t_orch_selfcheck.js 실패 (resolved)
- 사건: 사건 R7 Claude 비정상 종료 (exit 1). 응답 중 종료 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: CHANGELOG.md 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: orch-watch.js 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S2 시험: t_server_service.js 실패 (resolved)
- 사건: 사건 R7 Claude 비정상 종료 (exit 1). 미분류 (resolved)
- 사건: 사건 R12 VM 자가진단 S2 시험: t_server_service.js 실패 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: CHANGELOG.md 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: orch-improve.js 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: orch-selfcheck.js 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: orchestra.js 내용 다름 (resolved)
- 사건: 사건 R12 VM 자가진단 S3 설치본 차이: workbench.js 내용 다름 (resolved)
- 사건: 사건 R9 죽은 잠금 — _run.admit.lock (PID 41328 없음) (resolved)
- 사건: 사건 R7 Claude 비정상 종료 (exit 1) — 미분류 (closed)
- 사건: 사건 R5 진행 없음 — CheckList 수행 — run_verify 전체(AI 검토 포함: 사용자의견 처리·AS-IS 사실 검토·판정 검토·설명 문장) → 미검증 분류(unverified_triage) · 🔎 CheckList 체인 1단계 로그 10분 무출력 (closed)
- 사건: 사건 R9 죽은 잠금 — _run.dbwin.DMF0042.lock (PID 34744 없음) (resolved)
- 사건: 사건 R9 죽은 잠금 — _run.dbwin.DMF0042.lock (PID 41500 없음) (resolved)
- 사건: 사건 R9 죽은 잠금 — _run.dbwin.DMF0042.lock (PID 15388 없음) (resolved)
- 사건: 사건 R9 죽은 잠금 — _run.dbwin.DMF0042.lock (PID 36412 없음) (resolved)
- 사건: 사건 R9 죽은 잠금 — _run.dbwin.DMF0042.lock (PID 12036 없음) (resolved)
- 사건: 사건 R7 Claude 비정상 종료 (exit 1) — 응답 중 종료 (closed)
- 사건: 사건 R9 죽은 잠금 — _run.dbwin.DMF0042.lock (PID 1364 없음) (resolved)
- 사건: 사건 R9 죽은 잠금 — _run.dbwin.DMF0042.lock (PID 9380 없음) (resolved)
- 사건: 사건 R4 대기 지연 — DMF0042 dbwin 29분째 (closed)
- 사건: 사건 R9 죽은 잠금 — _run.dbwin.DMF0042.lock (PID 36104 없음) (resolved)
- 개선안: 개선안 doc_style.py 소스 검사에서 JS 주석과 잘못 짝지은 백틱 구간 제외 (superseded)
- 개선안: 개선안 workbench.js 웹뷰 스크립트를 t_webview_syntax.js 구문 시험 대상에 추가 (applied)
- 개선안: 개선안 extension.js 알림과 트리 문구에서 줄표 제거(18건), '모두' 1건 삭제 (applied)
- 개선안: 개선안 작은 모듈 6개 고정 문구에서 줄표와 가운뎃점 나열 제거(prompt-panel, orch-selfcheck, history, orchestra, flow-panel, chain-runner) (superseded)
- 개선안: 개선안 workbench.js 83~1100줄 실행 로그와 알림 문구에서 줄표와 가운뎃점 나열 제거(1차 71건) (applied)
- 개선안: 개선안 VM 파일 수정 직후 120초 안에는 가벼운 점검에서 S3 를 빼고 무거운 점검에서만 판정 (applied)
- 개선안: 개선안 S6 미확인 원장: 기능 설명 줄 제외, '미확인:' 줄 문장 단위 분리, 'VS Code 화면' 항목을 창 로드 기록과 연결 (applied)
- 개선안: 개선안 job-runner.js, server-service.js 고정 문구에서 줄표 제거(29건) (applied)
- 개선안: 개선안 변경 게이트 감시 대상에 tools/CommonSync 추가 (applied)
- 개선안: 개선안 서버 로그 2개 삭제(.vibe/logs be_bootrun, 58,885,136,326바이트) (pending)
- 개선안: 개선안 VMO 켜고 끄기의 harness.json 교체에 EPERM 재시도 적용, 쓰기 실패를 오류 기록에 남김 (applied)
- 개선안: 개선안 VMO 3개 모듈 고정 문구에서 줄표와 가운뎃점 나열 제거(62건) (applied)
- 개선안: 개선안 R5 진행 없음 판정에 E2E 산출물 수정 시각 반영 (applied)
- 개선안: 개선안 종료 전 hook 제한 60초를 정적 게이트 소요 시간 이상으로 변경 (applied)
- 개선안: 개선안 오케스트라 에이전트의 Claude 호출에서는 종료 전 게이트를 건너뜀 (applied)
- 개선안: 개선안 측정 추가: 잠금 파일에 실행 주체 기록, 같은 죽은 잠금 3회부터 묶음 사건 1건 (applied)
- 개선안: 개선안 측정 추가: 끝 사건 없이 사라진 대기와 Claude 호출을 집계에 포함 (applied)
- 개선안: 개선안 R4 대기 지연 판정 전에 대기 프로세스 생존 확인 (applied)
- 검사기 결함: 검사기 결함 T338~T342 2026-11-19 10:2x~10:4x · SCP0111 미검증 해소 라운드 3
- 검사기 결함: 검사기 결함 T323~T332 2026-11-19 00:0x~00:2x · SCP0096 미검증 해소 라운드 4

## 2026-11-18

변경 20, 세션 5, VM 실행 31, Claude 호출 17, 검사기 결함 2

- 20:1x [CheckList 엔진] CheckList 체인 미검증 보완 반복 · 재실행 행 처리 누락 정정
  - 지시: "SCP0096 전체 미검증 제거 요청 뒤 34건 남음 · 한 번에 제거하지 못한 사유 확인 후 보완"
  - 파일 4개: unverified_history.csv, unverified_resolve.py, triage.json, quick.json
  - 미확인 1건: VS Code 체인 실행 미확인.
  - 되돌리기 태그: 20261118_loop
- 20:00 [CheckList 엔진] 숫자 답 현황판을 턴마다 표시
  - 지시: "간단한 질문에 답이 숫자가 있을때는 DASHBOARD 을 요청했었는데 그게 표현되지 않았습니다"
  - 파일 2개: screen_status.py, workbench.js
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261118_dashturn
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 19:0x [Workbench] 실행 중 프롬프트 = 중지 없이 진행 중인 응답에 추가 지시로 반영
  - 지시: "VM 작업 진행 중 프롬프트를 입력하면 돌고 있던 작업이 중지되고 새로 입력한 명령이 수행됨 · 클로드코드처럼 중지되지 않고 추가되도록"
  - 파일 1개: workbench.js
  - 미확인 1건: VS Code 실화면 미확인(창 다시 로드 필요).
  - 되돌리기 태그: 20261118_inject
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 18:3x [CheckList 엔진] 🔎 CheckList 체인 = 1. CheckList 수행 → 2. 검증 보완 → 3. CheckList 재수행
  - 지시: "미검증 있으면 미검증에 대한 보완을 진행하고, 다시 CHECKLIST 수행 · 미검증 항목에 대해서만 별도 CHECK 가능하면 가장 좋고, 그게 아니면 처음부터 · 1 단계 CHECKLIST수행, 2단계 검증 보완, 3단계 CHECKLIST 재수행으로 보이면"
  - 파일 5개: tools/Harness/verify/checklist_run.py, steps.json, quick.json, workbench.js, checklist_run.py
  - 미확인 1건: VS Code 실화면·실제 체인 실행 미확인.
  - 되돌리기 태그: 20261118_3step
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 18:1x [CheckList 엔진] 단계 수선(🧪 미검증 해소 등) Claude 실행을 그 단계 카드 안 하위로 표시
  - 지시: "CheckList 체인의 '미검증 해소' 단계가 수선 중일 때 Claude 실행 카드가 단계 밖 별도 블록으로 그려짐 → 하위 프로세스로 보이게."
  - 파일 1개: workbench.js
  - 미확인 1건: VS Code 실화면 미확인(창 다시 로드 필요 — 진행 중 체인은 다시 로드하면 끊김).
  - 되돌리기 태그: 20261118_repairnest
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 18:0x [CheckList 엔진] CheckList 시작 때 화면 UI 소스 Download & Merge (DB MODE 만)
  - 지시: "CHECKLIST 수행 시 UI 해당 소스에 대해서 GIT 확인 후 최신소스 변경 분 있으면 다운로드" / "DOWNLOAD & MERGE 되어야 합니다. (DB MODE 일때만)"
  - 파일 7개: tools/CommonSync/common_sync.py, state.json, tools/CommonSync/screen_sync.py, harness.json, /screen_sync.json, tools/Harness/verify/run_verify.py, quick.json
  - 되돌리기 태그: 20261118_paths
- 17:0x [CheckList 엔진] 미검증 해소 = 전체 목록 → 일괄 보완 → CheckList 전체 1회
  - 지시: "전체 목록을 보고, 미검사 대상에 대해서는 필요한 작업을 일괄로 먼저 한 후에 미검사 없이 전체 검증 절차" / "CHECKLIST 의 로직에 반영되어서 앞으로도 이렇게"
  - 파일 6개: workbench.js, quick.json, /_unverified_plan.md, unverified_classes.csv, unverified_resolve.py, Doc/verify/_ENGINE_MASTER.md
  - 되돌리기 태그: 20261118_unverified
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 15:48 [Workbench] Console 탭 HTML 틀 = VS Code 테마 색 따름
  - 지시: "DARK THEME 일 때는 테마에 맞춰서 BACKCOLOR 을 맞춰주세요"
  - 파일 2개: workbench.js, tools/Docs/screen_status.py
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261118_htmltheme
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 15:41 [Workbench] 건수 현황 질문 = VM 이 현황판 HTML 을 Console 탭에 직접 표시
  - 지시: "DASHBOARD 형태의 HTML 이 CONSOLE 창에 보이도록 보완요청했는데, 계속 TEXT BASE 로만 보입니다"
  - 파일 4개: screen_status.py, workbench.js, tools/Docs/screen_status.py, Doc/verify/SSP0020/status.json
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261118_htmlauto
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 15:23 [Workbench] Console 탭 HTML 표시, 화면 건수 현황판
  - 지시: "건수 현황 같은 답변은 GRID 나 DASHBOARD 형태로" / "생성된 html 을 Console 창에 보이도록" / "필요한 정보만 Simple 하게"
  - 파일 6개: tools/Docs/screen_status.py, checklist_counts.json, work_ledger_summary.json, /status.json, workbench.js, screen_status.py
  - 미확인 1건: VS Code 실화면과 어두운 테마 표시 미확인.
  - 되돌리기 태그: 20261118_htmlview
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 15:13 [CheckList 엔진] CheckList 뒤 미검증 자동 해소
  - 지시: "CHECKLIST 생성 시 미검증 항목이 발생하면 미검증을 해소하도록 하는 기능을 CHECKLIST 에 추가"
  - 파일 11개: tools/Harness/verify/unverified_classes.csv, tools/Harness/verify/unverified_resolve.py, /unverified_triage.csv, unverified_history.csv, steps.json, quick.json, _unverified_work.md, _unverified_decisions.md 외
  - 미확인 1건: 실제 CheckList 체인·Claude 보완 실행과 VS Code 실화면은 미확인.
  - 되돌리기 태그: 20261118_unverified
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 13:43 [CheckList 엔진] CheckList = 테스트 단계: E2E 4종 포함 · 판정에 빠져 있던 E2E 기능 시험 반입
  - 지시: "CheckList 생성 시 테스트의 모든 단계까지를 테스트하고 CheckList 을 생성 · 테스트 4단계가 CheckList에 포함되고 CheckList가 테스트 단계로 · 누락된 기능테스트가 있으면 CheckList에 넣도록"
  - 파일 12개: prereq.py, tools/Harness/verify/e2e_suite.py, run-e2e.cmd, users.json, /e2e_suite.json, tools/Harness/verify/e2e_suite_ingest.py, run_verify.py, e2e_suite.py 외
  - 미확인 3건: 결과 기록이 없는 종류 = ERROR '[미측정]' 행 1개. / VS Code 실화면 미확인. / 실행 시간 증가 미측정.
  - 되돌리기 태그: 20261118_e2esuite, 20261118_teststage
- 13:4x [CheckList 엔진] Status E2E 4종 타일 삭제
  - 지시: "checklist는 테스트의 전 단계를 포함하므로, Status 의 순서상 3.CheckList 는 9번 자리로 이동하고, Smoke 부터 권한별 CRUD 의 4단계 테스트는 없어도"
  - 파일 1개: workbench.js
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261118_noe2etile
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 13:35 [Workbench] Status · Flow 단계를 파싱부터 완료까지 바뀐 순서로
  - 지시: "파싱부터 완료까지의 변경된 순서를 Status, Flow 에도 변경된 Task로 보완"
  - 파일 8개: flow-panel.js, /screen_bundle.json, run_verify.result.json, checklist_counts.json, REPAIR.md, fe_gate.json, CHECK.md, workbench.js
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261118_stages
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 13:31 [Workbench] Workbench 상단 탭 순서 Console · Status · Log · History
  - 지시: "workbench 의 tabpage순서를 Console / UI Status(Status 로 변경) / Log / History 로 변경"
  - 파일 1개: workbench.js
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261118_taborder
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 13:26 [Workbench] Workbench Log 하위 탭(Task·FE·BE) + 공통 최신·지우기 · History 탭 하나(Revision·Task)
  - 지시: "LOG TABPAGE 내 TASK LOG, FE LOG, BE LOG 3개을 TABPAGE 로 LAYOUT 변경 · 최신과 지우기 기능은 공통 적용" / "Revision, Task History 를 History 하나로 · 내부에 Revision, Task 2개의 Tabpage"
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261118_logtabs, 20261118_histtab
- 13:21 [룰·hook] NSCM 전환 단계 · 완료 정의(현재 화면) · 룰·Hook·하네스 최신 기준 정리
  - 지시: "VM 의 NSCM 전환 단계, 완료 정의 - 현재 화면, 룰,Hook,하네스 3개 CATEGORY 에 대한 기능 및 메뉴을 최신 기준으로 맞도록 보완"
  - 파일 17개: steps.json, make_ui_test_sheet.py, quick.json, extension.js, run_verify.result.json, /screen_bundle.json, fe_gate.json, pkg_gate.json 외
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261118_reorg, 20261118_menu3
  - 세션: 0af975be
- 13:11 [CheckList 엔진] 자동 보완 = CheckList 기준으로만: 사전 단계 실패 시 중단, 최신 판단 보강, 같은 원인 묶음
  - 지시: "보완 > 자동보완, 자동보완 반복 의 경우에 CheckList을 확인해서 보완을 진행할 수 있도록 하는 Rule" / "1,2,3,4 의 추천안으로 진행"
  - 파일 8개: workbench.js, /fixlist.csv, fixlist.csv, tools/Harness/verify/verify_if_stale.py, _user_verdicts_direct.csv, static_verdicts.csv, /action_summary.csv, verify_if_stale.py
  - 미확인 1건: VM 실화면 실행 미확인.
  - 되돌리기 태그: 20261118_fixgate
  - 세션: 0af975be, 26317e78, 709cda2a, c4a09bc4
- 13:1x [문서 생성] 생성 전체 체인 3종: 파싱, 실측, TestResultList 단계 보강
  - 지시: "생성 > ID하나로 전체 의 경우에도 파싱,실측,와 생성 후 CheckList, Test 의 전 과정이 누락되지 않도록" / "TestResultList 결과파일은 현재와 동일하게 유지"
  - 파일 1개: save_scenario.json
  - 미확인 1건: 체인 실제 실행, VS Code 실화면 미확인.
  - 되돌리기 태그: 20261118_full
- 13:05 [문서 생성] 분석·문서 메뉴 정리: Excel 폴더 삭제, 테스트결과서 → TestResultList
  - 지시: "분석,문서 아래의 EXCEL 폴더 는 메뉴 삭제" / "테스트결과서는 TestResultList 로 명칭 변경"
  - 파일 2개: quick.json, steps.json
  - 미확인 1건: VS Code 실화면 미확인(창 다시 로드 필요).
  - 되돌리기 태그: 20261118_menu
- 세션 c4a09bc4 "SCP0096 DB 모드 대조표 점검" 14:54~15:27, 지시 7건, VM 파일 수정 3건(workbench.js 3), 화면 SCP0096
- 세션 709cda2a "SCP0096 화면 DB 모드 검증" 15:35~15:50, 지시 3건, VM 파일 수정 2건(workbench.js 2), 화면 SCP0096
- 세션 0f4238f8 "SCP0096 DB 모드 CHECKLIST 건수현황" 15:55~15:58, 지시 1건, 화면 SCP0096
- 세션 a7ec3805 "SCP0111 CHECKLIST 실행 오류 원인" 16:28~20:02, 지시 5건, 화면 SCP0111
- 세션 10d8da3f "SCP0096 CheckList 미검증 해소" 23:56~2026-11-19 09:11, 지시 11건, 화면 SCP0096
- VM 실행 31건: SCP0096 claude 12, SCP0111 claude 5, SCP0111 S8.unverified 3, SCP0111 chain_checklist 3, SCP0111 S8.verify 3, SCP0096 chain_checklist 1, SCP0096 S8.checklistRun 1, SCP0096 S8.verify 1, SCP0104 menu_git-common-sync 1, SCP0104 menu_git-upload 1
- 검사기 결함: 검사기 결함 T320~T322 2026-11-18 19:1x~19:4x · SCP0111 미검증 해소 라운드 2
- 검사기 결함: 검사기 결함 T314~T319 2026-11-18 18:1x · SCP0111 미검증 해소 라운드 1

## 2026-11-17

변경 12, 세션 8, VM 실행 33, Claude 호출 18

- 18:0x [룰·hook] DB MODE FE 가이드 = 문장 규칙 19 업무 단어 + 가이드 문서 틀
  - 지시: "EXCEL 이나 문서에 자연스러운 단어로 변경하도록 보완하는 것을 적용하였습니다. FE 가이드 생성시에도 이 RULE 적용"
  - 파일 12개: rules/50_DOC_STYLE.md, plain_detail.py, workbench.js, 50_DOC_STYLE.md, doc_style.py, tools/Docs/doc_style_rules.csv, rules/10_RULES_KEEP.md, FE_GUIDE_20261117_1736.md 외
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261117_feguide, 20261117_plainword
  - 세션: 26317e78, 3eef00a3, a3162921, daafccf3
- 17:26 [Git] Source Backup — 폴더 묶음별 add · 수정 중 파일만 제외
  - 지시: "Source Backup 오류 다시 발생 · 원인 확인 및 보완 · 폴더로 분할 · 수정 중 파일 때문이면 그 파일만 제외하고 나머지는 올림"
  - 파일 2개: workbench.js, DMF0042/combo_values.json
  - 미확인 2건: 충돌 원인 자체는 미확인. / VM 실화면 실행 미확인.
  - 되돌리기 태그: 20261117_bkfix
  - 세션: 26317e78, a3162921, daafccf3
- 16:06 [Git] Source Backup 실패 보완, 남은 index.lock 자동 정리, 단계별 실행
  - 지시: "VM 의 SOURCE BACKUP 기능이 실패하였습니다. 원인 확인해서 보완"
  - 파일 1개: workbench.js
  - 미확인 4건: 11-11 강제 종료 경위(중지 버튼인지 창 닫기인지)는 미확인. / VS Code 실화면 미확인. / 남은 위험(미측정): 미추적 파일 70,619개, 2,396,598,755 bytes(Doc/asislive 59,229개 774MB, _artifacts/_apply_corporate .pkl 74개 524MB, Doc/UI_CHECKLIST xlsx 1,195개 446MB).
  - 되돌리기 태그: 20261117_backup
  - 세션: 26317e78, a3162921, daafccf3
- 15:49 [Workbench] Workbench Revision · Task History 검색
  - 지시: "Revision, Task History 각각 검색 기능 추가"
  - 파일 2개: history.js, workbench.js
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261117_hsearch
  - 세션: 26317e78, a3162921, daafccf3
- 15:12 [체인·메뉴] 사이드바 제목 'Vibe Manager 2.0.1' 복원 · VM 로고 버튼 제거
  - 지시: "Vibe Manager 다음 버전 표시를 다시 나오게 · VM 아이콘은 안 보이게"
  - 파일 3개: package.json, extension.js, menu-view.js
  - 되돌리기 태그: 20261117_title, 20261117_logo, 20261117_unlogo
  - 세션: 26317e78
- 15:03 [Workbench] Workbench Log·Task Log 탭 통합 · 3칸 세로 + 분할 막대
  - 지시: "Log, Task Log 2개 탭을 하나로 · Log 탭 아래 Task Log, FE Log, BE Log 세로 배치 · Split Bar 로 크기 조절"
  - 파일 1개: workbench.js
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261117_logs
  - 세션: 26317e78, a3162921, daafccf3
- 15:00 [체인·메뉴] VM 로고 = 사이드바 제목 줄 아이콘 버튼 맨 앞
  - 지시: "VM 아이콘을 기능 아이콘과 같은 줄 맨 왼쪽에 · 2줄로 나옴"
  - 파일 4개: package.json, media/vibe-color.svg, extension.js, menu-view.js
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261117_logo
  - 세션: 26317e78
- 14:51 [체인·메뉴] 사이드바 제목 글자 숨김 · 로고로 대체
  - 지시: "Vibe_Manager 2.0.1 자리에 아이콘을 넣고 글자를 대체"
  - 파일 1개: package.json
  - 미확인 1건: VS Code 실화면 미확인.
  - 되돌리기 태그: 20261117_title
- 14:35 [체인·메뉴] 메뉴 창 로고 줄 · 제목 밑줄 삭제 · 주황 강조색 → 글자색
  - 지시: "메뉴 창 상단 Vibe Manager 앞에 Workbench 로고 · Vibe_Manager 의 '_' 삭제 · 주황 부분 White 톤 일괄 · Menu Category·이모지 색 = 글자색"
  - 파일 3개: package.json, menu-view.js, media/vibe-color.svg
  - 미확인 1건: VS Code 사이드바 실화면 미확인.
  - 되돌리기 태그: 20261117_brand
  - 세션: 26317e78
- 14:31 [Workbench] Revision History → Revision 나머지 3곳
  - 지시: "나머지 3곳도 변경"
  - 파일 3개: package.json, history.js, quick.json
  - 되돌리기 태그: 20261117_rev
  - 세션: 26317e78
- 13:55 [Workbench] Workbench 탭 이름 Revision History → Revision
  - 지시: "WORKBENCH 의 REVISION HISTORY 을 Revision 으로 명칭 변경"
  - 파일 4개: workbench.js, package.json, quick.json, history.js
  - 되돌리기 태그: 20261117_rev
  - 세션: 26317e78, a3162921, daafccf3
- 13:35 [Workbench] Console 보드 반투명
  - 지시: "Console 창 Board 박스와 Layout 을 반투명으로 은은하게"
  - 파일 1개: workbench.js
  - 미확인 1건: VS Code 웹뷰 실화면은 미확인(창 다시 로드 후 확인).
  - 되돌리기 태그: 20261117_glass
  - 세션: 26317e78, a3162921, daafccf3
- 세션 bc1cecdb "SCP0104 AS-IS 액션 대조 검증" 10:43~10:54, 지시 1건, 화면 SCP0104
- 세션 26317e78 "VM 고도화" 11:37~2026-11-19 23:49, 지시 70건, VM 파일 수정 100건(workbench.js 87, menu-view.js 10, history.js 2, extension.js 1), 화면 SCP0111, DMF0042, SCP0096, SSP0014
- 세션 eacfaa82 "SCP0104 CHECKLIST 보완과 UI_TEST 시트" 13:40~13:42, 지시 1건, 화면 SCP0104
- 세션 3eef00a3 "SOP 탭 데이터 조회 조건 확보, E2E·런처 보완" 15:44~17:17, 지시 5건, VM 파일 수정 5건(10_RULES_KEEP.md 5), 화면 SSP0020, SCP0104
- 세션 a3162921 "SCP0104 AS-IS 액션 대조표" 15:53~16:12, 지시 3건, VM 파일 수정 1건(workbench.js 1), 화면 SCP0104
- 세션 daafccf3 "P_SCP0111_SAVE_PSI_ADMIN V_ACTIVE_FLAG 분기" 17:16~18:33, 지시 12건, VM 파일 수정 3건(50_DOC_STYLE.md 2, workbench.js 1), 화면 SCP0111
- 세션 501c8447 "SCP0111 화면 DB 모드 CheckList" 20:10~20:14, 지시 1건, 화면 SCP0111
- 세션 fb1fbaaf "시험 저장으로 새로 생긴 행 정리 결함 보완" 21:38~2026-11-18 05:01, 지시 7건, 화면 SSP0020
- VM 실행 33건: SCP0111 claude 13, SCP0104 claude 5, SCP0104 menu_git-upload 2, SCP0111 S1.liveScenCov 1, SCP0111 S1.liveCond 1, SCP0111 S1.liveScenCmp 1, SCP0111 S1.liveScenMatrix 1, SCP0111 S1.liveScenSpec 1, SCP0111 S8.verify 1, SCP0111 S1.liveScen 1

## 2026-11-16

변경 2, 세션 4, VM 실행 1, Claude 호출 1, 룰 변경 1

- 15:0x [CheckList 엔진] CheckList 폴더 Doc/CheckList → Doc/UI_CHECKLIST
  - 지시: "VM 과 현재 작업 중인 세션에서 사용중인 CHECKLIST 폴더를 Doc/CheckList 에서 Doc/UI_CHECKLIST 로 변경 · 이전 파일은 옮기고 · 앞으로 이 폴더를 생성"
  - 파일 7개: make_verify_docs.py, workbench.js, steps.json, quick.json, CLAUDE.md, .claude/rules/03-analysis-docs.md, 03-analysis-docs.md
  - 되돌리기 태그: 20261116_uichk
- 14:5x [CheckList 엔진] CheckList 생성 시 UI 테스트 Excel 같이 생성
  - 지시: "Checklist 생성 후 Doc/UI_TEST(SCP&SSP) 폴더 내에 Test Excel 문서도 같이 생성하도록 VM 보완"
  - 파일 3개: menu.csv, /ui_test_rows.json, tools/Harness/verify/make_ui_test_sheet.py
  - 되돌리기 태그: 20261116_uitest
- 세션 606ec324 "품질 DB DM 데이터 운영 DB 이관" 09:49~15:10, 지시 5건, 화면 SSP0020
- 세션 8c443789 "SSP0020 조회 데이터 미조회 문제" 13:47~18:46, 지시 9건, 화면 SSP0020
- 세션 4d5604da "SSP0045 SHIP REQ·PLAN 데이터 출처" 16:56~17:09, 지시 1건, 화면 SSP0045
- 세션 f4e1d597 "SHIP_PLAN_40" 18:51~2026-11-18 11:24, 지시 5건, 화면 DMF0053
- VM 실행 1건: SSP0045 claude 1
- 룰 변경: §0 CheckList·ActionItemList 폴더 `Doc/CheckList` → `Doc/UI_CHECKLIST`(사용자 지시 · 파일 1,112개 이동) · UI 테스트 Excel 폴더 `Doc/UI_TEST(SCP&SSP)` 1줄 추가. 함께 정정: 하네스 6개(make_verify_docs · judge · regress · run_verify

## 2026-11-14

변경 1, 세션 1, VM 실행 4, Claude 호출 1

- 01:2x [체인·메뉴] AS-IS 실측 메뉴 26개 → 1개 (판 2.0.9)
  - 지시: "AS-IS 실측 부터 AS-IS 실측 묶음 까지를 하나의 AS-IS 실측 메뉴로 생성하고 실행하면 전체 과정을 수행" / "사용자는 상세 프로세스를 각각 수행할 수 없습니다"
  - 파일 6개: quick.json, steps.json, asis_live_screen.py, /save_scenario.json, workbench.js, asis_live_scen_event.py
  - 되돌리기 태그: 20261114_live1
  - 세션: 5b182146, 74dc56c3
- 세션 74dc56c3 "SSP0020 BE 기동 실패 원인 보완" 01:13~01:50, 지시 1건, VM 파일 수정 2건(quick.json 2), 화면 SSP0020
- VM 실행 4건: SCP0104 S8.verify 1, SSP0020 S8.verify 1, SSP0020 claude 1, SSP0020 menu_multi 1

## 2026-11-13

변경 7, 세션 5, VM 실행 32, Claude 호출 28, 검사기 결함 2, 룰 변경 3

- 18:1x [룰·hook] 문장 규칙 4~18 — 사람이 쓴 업무 문서처럼 (판 2.0.8)
  - 지시: "문서를 보는 사용자가 AI 가 작성한 문서라고 인식하는 것을 줄이려고" / "적용해주세요 · 클로드코드와 VM 전체"
  - 파일 4개: /.claude/CLAUDE.md, CLAUDE.md, 50_DOC_STYLE.md, 03-analysis-docs.md
  - 세션: 5b182146
- 17:4x [룰·hook] 문장 규칙 3개 — 수식어 금지 · 아는 주어 생략 · 번역투 금지 (판 2.0.7)
  - 지시: "VM 의 문서(모든 EXCEL 문서) 생성 시 설명과 문장에서 반드시 — 1. 수식어 쓰지마 2. 문맥으로 아는 주어는 빼줘 3. 번역투는 빼 줘" / "VM 과 함께 내가 사용하는 클로드의 모든 문장생성에 적용"
  - 파일 9개: rules/50_DOC_STYLE.md, tools/Docs/doc_style_rules.csv, tools/Docs/doc_style.py, /.claude/CLAUDE.md, CLAUDE.md, .claude/rules/03-analysis-docs.md, 10_RULES_KEEP.md, workbench.js 외
  - 세션: 5b182146, ec66cd53
- 15:30 [CheckList 엔진] 작업 `S6.regen`(룰 반영 후 GAP 재실행 · gap.js) 삭제
  - 지시: "GAP 분석은 2026-10-30 폐지(CheckList 로 대체)됐고 이 작업은 메뉴·체인·VM 코드 어디에도 연결되지 않고 Flow 패널 단계 목록에만 보였다."
  - 파일 4개: steps.json, gap.js, quick.json, scripts/rules/inventory_check.py
  - 되돌리기 태그: 20261113_s6regen
- 15:1x [Workbench] 프롬프트 — 실행 중에도 전송(대기열) + 지금 보내기 (판 2.0.6)
  - 지시: "실행 중일 때도 프롬프트를 입력하고 전송 · 현재 작업에서 감안하거나 완료 후 순차 반영 · 즉시 반영이 안 되면 프롬프트 하단에 지금 보내기"
- 07:16 [체인·메뉴] AS-IS 실측 작업 4종 추가 — 필수 조건 채움 · 조건 대조 · 조건 시나리오 반복 · 소스 분기 시나리오 도출 (판 2.0.8)
  - 지시: "지금 하는 모든 작업은 vm에 기능으로 추가되어야 하는 기능입니다."
  - 파일 8개: steps.json, asis_live_batch.py, asis_live_cond.py, asis_live_scen_loop.py, asis_live_scen_src.py, quick.json, asis_live_scen_cov.py, asis_live_scen_run.py
  - 미확인 2건: VS Code 에서 메뉴를 실제로 눌러 본 것은 아님 / 설치 폴더 반영·VSIX 재설치는 기존 절차대로 별도.
  - 되돌리기 태그: 20261113_asislive
- 시각 없음 [Workbench] + 워크벤치 탭 이름 Claude → Console (판 2.0.5)
  - 지시: "Claude 탭 Flow 보드" / "chat"
- 시각 없음 [CheckList 엔진] AS-IS 실측 — 화면 단위 묶음 · CheckList 자동 구동 · 창/Excel 정리 · 그룹(권한) 지정 (판 2.0.9)
  - 지시: "나머지 전체 실행은 지금 진행하지 않을게요. … 실제 AS-IS 런처 실행으로 필요한 데이터 취합 및 기준설정 부분은 화면별 CHECKLIST 작업 시 구동되도록" / "POPUP 이 너무 많이 띄워져 있습니다" / "EXCEL 확인 후 종료"
  - 파일 22개: tools/AsisLive/asis_live_screen.py, asis_live_scen_run.py, run_verify.py, asis_live_auto.py, asis_live_screen.py, tools/AsisLive/asis_live_excel.py, asis_live_winwatch.py, asis_live_scen_cmp.py 외
  - 미확인 2건: VS Code 에서 새 메뉴 클릭 / 설치 폴더 반영(사용자 절차).
  - 되돌리기 태그: 20261113_livescreen
- 세션 d7117b4a "TO-BE SCP, SSP 조회조건 대소문자·LIKE 적용 현황" 09:00~13:02, 지시 7건
- 세션 eb690416 "SSP0020 소스 다운로드 및 머지" 09:20~09:26, 지시 1건, 화면 SSP0020
- 세션 ec66cd53 "MD·Hook·Rule·하네스 현행 기준 전체 정리" 14:46~2026-11-14 11:27, 지시 24건, VM 파일 수정 2건(10_RULES_KEEP.md 2)
- 세션 21c90110 "VM 생성엔진·검사엔진 전체 오류 점검·보완" 14:52~17:26, 지시 9건, 화면 SCP0016
- 세션 8ec86c90 "사내 PKG 빈 문자열 비교 구문 영향 점검" 18:04~21:50, 지시 8건
- VM 실행 32건: 공통 claude 27, SCP0104 S8.verify 2, SSP0020 S8.verify 2, SSP0020 claude 1
- 검사기 결함: 검사기 결함 T284 기존 결과 파일 'w' 재열기 Errno 22 — 반입 도구가 죽어 행 누락
- 검사기 결함: 검사기 결함 T276~T283 엔진 전체 점검(다른 세션 의뢰 — "화면마다 다른 종류의 오류") — 실행 기록 전수 수집으로 찾은 엔진 결함
- 룰 변경: 전수 점검(사용자 승인 묶음 ①): §3 hook 카탈로그 수 153 → 156(디스크 실측) · §5 실행 hook 목록에 하네스 3종(check-asis-harness · harness-gen-context · harness-stop-gate) 추가. 근거 `Doc/_rules_consolidation/2026-11-13_INVENTORY_정리안.md`
- 룰 변경: 상시 문서 정정(사용자 승인 "상시 문서만 정정"): §0 "React 19" → "React 18"(실측 nscm-fe/node_modules/react 18.3.1 · apps/web package.json ^18.3.0) · §3 screen-completion-gate "8 게이트" → "11 게이트 G1~G11"(hook §0 표 기준). 함께 정
- 룰 변경: §1-2 reference 화면 "DMF0004~0007" → "DMF0004~0006"(사용자 확정 2026-11-13 "3개(0004~0006)"). 함께 정정: `RULESET_MASTER.md` §1 · `10_RULES_KEEP.md` 원칙 3 · `hooks/pre-write.md` 점검 항목.

## 2026-11-12

변경 10, 세션 3, VM 실행 15, Claude 호출 5

- 17:37 [CheckList 엔진] AS-IS 실측(AS-IS Live) 작업 2종 추가 — 런처를 실제 구동해 화면 열기·조회 → 덤프·캡처·서버 호출 수집 (판 2.0.6)
  - 지시: "VM 에서 파싱부터 개발, 보완, 테스트, CHECKLIST·문서작성까지 일련의 과정에서 AS-IS 런처를 직접 구동시켜 화면을 실행하고 그 결과를 확인"
  - 파일 15개: /.claude/plans/velvet-conjuring-lake.md, steps.json, tools/AsisLive/asis_live_run.py, tools/AsisLocal/asis_env_check.py, quick.json, run.json, calls.json, controls.json 외
  - 미확인 1건: 3 미측정
  - 되돌리기 태그: 20261112_live
- 16:3x [체인·메뉴] Server 메뉴 = To-Be / As-Is 중분류 + As-Is 실행 3종 (판 2.0.5)
  - 지시: "Server 하위의 현재 메뉴를 To-Be 중간 Category 밑으로 · As-Is 를 To-Be 다음에 만들어 IIS 기동 + GSCM.Launcher.exe 실행 묶음 1개, IIS 기동, 런처 실행 3개 메뉴 추가"
  - 파일 1개: tools/AsisLocal/asis_iis.cmd
- 14:0x [서버] 아이콘 색 = VM 아이콘 색으로 통일 (판 2.0.4)
  - 지시: "메뉴의 이모지 단색, 메뉴 상단의 아이콘, WORKBENCH 상단 아이콘을 VM 아이콘이 사용하는 COLOR 로 단색을 맞추면"
  - 파일 2개: media/vibe-color.svg, light.svg
  - 미확인 1건: VS Code 실제 창 확인은 미실행.
- 11:0x [Workbench] ++ 프롬프트 입력 전 안내 문구 단순화 (판 2.0.3)
  - 지시: "프롬프트 창에 입력 전에 나오는 가이드 메세지를 SIMPLE 하게 (영문으로)"
  - 미확인 1건: VS Code 실제 창 확인은 미실행.
- 10:4x [Git] ⬇️🔀 Source Download & Merge(BE) 메뉴 분리 + BE 로컬 환경 보호 보강 (판 2.0.5)
  - 지시: "Source Download & Merge 에서 BE 는 제거 · (BE) 메뉴를 추가해 필요할 때만 · 로컬 작업환경을 해치지 않게(로컬은 SSO 접속 안 함 · 사용자 ID 로그인 유지) · application.yml mybatis 4키와 config-local.yml system-cd 는 환경설정이라 DB MODE 에서도 적용"
  - 파일 2개: last_summary_be.json, tools/CommonSync/README.md
  - 미확인 1건: VS Code 실제 창에서 두 메뉴 실행은 미실행.
  - 되돌리기 태그: 20261112_be, 20261112_split
- 10:0x [Git] ⬇️🔀 Source Download & Merge 에 BE(nscm-be) 추가 + BE 작업환경 보호 (판 2.0.4)
  - 지시: "공통소스 다운로드 처리 시 BE 의 소스도 다운로드" / "VM 의 SOURCE DOWN & MERGE 에도 BE 추가" / "BE 다운로드 시 로컬 작업환경을 해치는 명령은 차단"
  - 파일 1개: state.json
  - 미확인 2건: VS Code 실제 창에서 메뉴 실행은 미실행. / BE 컴파일(gradlew build)은 미실행.
  - 되돌리기 태그: 20261112_be
- 09:3x [체인·메뉴] + 아코디언 메뉴 단계 들여쓰기 (판 2.0.3)
  - 지시: "GROUP 과 실제 메뉴가 구분되도록, 상단 CATEGORY 글자가 시작하는 지점에 MENU 아이콘이 시작 · 중분류가 있어도 마찬가지 · TREE LINE 없이 TREE 구조처럼 단계 구분"
  - 미확인 1건: VS Code 실제 창 확인은 미실행.
- 09:2x [체인·메뉴] 사이드바 메뉴 = 아코디언 (판 2.0.3)
  - 지시: "메뉴 구성을 현재 이모지와 COLOR 유지한 채로 … 리본메뉴가 아닌 아코디언 메뉴로"
  - 미확인 1건: VS Code 실제 창 확인은 미실행.
  - 되돌리기 태그: 20261112_acc
- 09:2x [CheckList 엔진] ++ DB MODE 에서 일괄 생성 작업 차단 (판 2.0.2)
  - 지시: "DB 모드에서는 FLOW 의 BATCH RUN 이나 ID 기준 일괄생성 등의 작업은 진행되지 않도록"
  - 파일 1개: tools/Harness/harness.json
  - 미확인 1건: UI/DB MODE 에서 실제 체인 실행과 VS Code 실제 창 확인은 미실행.
- 시각 없음 [체인·메뉴] 체인 5종에 AS-IS 실측 선택 단계 · 보완·변환 프롬프트 5종에 실측 참고 문단 (판 2.0.7)
  - 파일 3개: /latest.json, summary.md, quick.json
  - 되돌리기 태그: 20261112_live
- 세션 9d3f36a3 "DMF0021 SAVE 버튼 미표시" 09:43~13:41, 지시 14건, 화면 DMF0021
- 세션 2e21d4c4 "SSP0200 REPOEST INFO 패널 접기/펼치기 고정" 14:36~15:07, 지시 4건, 화면 SSP0200, DMF0008
- 세션 901f0232 "SSP0202 화면 REQUEST CONFIRM DETAIL 영역 변경" 15:10~15:24, 지시 1건, 화면 SSP0202
- VM 실행 15건: 공통 menu_app 4, SSP0200 claude 4, SSP0202 S1.live 1, 공통 menu_terminal 1, 공통 menu_multi 1, SSP0202 menu_work-mode 1, SSP0202 claude 1, SSP0200 menu_work-mode 1, DMF0021 menu_git-common-sync 1

## 2026-11-11

변경 8, 세션 3, VM 실행 12, Claude 호출 6

- 21:4x [체인·메뉴] + FLOW 열 = 체인이 순서대로 실행하는 단계만 (판 2.0.2)
  - 지시: "흐름에서 벗어나는 별도의 액션은 FLOW 에서 제외 — PKG 가 전체 흐름에서 순서대로 진행되면 유지, 별도 작업이면 제외"
  - 파일 1개: quick.json
  - 미확인 1건: VS Code 실제 창 확인은 미실행.
- 21:3x [Workbench] FLOW 화면 재구성 (판 2.0.2)
  - 지시: "Smoke·CRUD·Auth·Auth×CRUD 를 Test 하나로 · 문서와 Excel 도 하나로 · 6 수선 → 보완 · 상단 Header 고정 · Doc/gen 삭제 · 끝까지 → 일괄작업 영문 · Header 명칭 영문 · 파이프라인 삭제 · 현재 기준 Step 으로, 누락은 감안해 보완 · 디자인 세련되게"
  - 파일 1개: flow-panel.js
  - 미확인 1건: VS Code 실제 창 확인은 미실행.
  - 세션: 5b182146
- 20:5x [체인·메뉴] 사이드바 머리글 = 'Vibe_Manager <버전>' (판 2.0.1)
  - 지시: "Vibe_Manager 뒤에 버전을 보여 주고 ': 전체 메뉴' 는 삭제"
  - 파일 2개: build_vsix.py, package.json
  - 세션: 5b182146
- 20:4x [체인·메뉴] + 사이드바 메뉴 이름 = 언어 설정을 따름 (판 2.0.1)
  - 지시: "현재 설정이 한글인데 메뉴가 영문으로 나온다 — 한글일 때는 한글로, 영문으로 바꾸면 영문 메뉴"
  - 파일 1개: extension.js
  - 미확인 1건: VS Code 실제 창 확인은 미실행.
- 시각 없음 [체인·메뉴] 사이드바 메뉴 = D2 형(왼쪽 좁은 레일 + 한 줄 목록) — 아이콘 타일·아래 아이콘 탭 인식성 개선 (판 2.0.1)
  - 지시: "모바일 형태의 아이콘 형태로 VM 메뉴를 수정했는데 인식성이 떨어진다" / "D2 적용"
  - 파일 1개: extension.js
  - 미확인 1건: **VS Code 실제 창 확인은 미실행**(창 다시 로드 후 사용자 확인 필요).
  - 되돌리기 태그: 20261111_d2
- 시각 없음 [체인·메뉴] 사이드바 메뉴 = 모바일 홈 화면형 · 프롬프트 창 = Claude Code 입력창 형태 (판 2.0.0)
  - 지시: "VM 메뉴를 모바일 홈 화면처럼" / "컬러 이모지 배제, 단일 색상" / "메뉴명의 (설명) 제거, 메뉴명 전체 영문"
  - 파일 4개: menu-view.js, quick.json, workbench.js, extension.js
  - 미확인 1건: **VS Code 실제 창 확인은 미실행**(창 다시 로드 후 사용자 확인 필요).
  - 세션: 0af975be, 5b182146, f775979f
- 시각 없음 [체인·메뉴] 보완·생성 결과를 엔진이 실측으로 증명 — 자동보완 체인 3단계 추가 · PKG/META 메뉴 증명 단계(proofTasks) · S8 작업 6종 (판 1.9.45)
  - 지시: "적용 후 확인"
  - 파일 3개: layer_diagnosis.csv, repair_close.json, steps.json
  - 미확인 1건: 3 = 미측정).
- 시각 없음 [Workbench] 작업 종료 시 Flow 보드에 클릭 링크(📂 폴더 · 📄 README · 🗂 A_DB) — 클라우드 이관 패키지(수정본·전체) (판 1.9.44)
  - 지시: "클라우드 이관 패키지 선택 시 작업 종료 시 링크를 제공해서 VM 창에서 링크 선택할 수 있도록"
  - 파일 1개: cloud_pkg.py
- 세션 26e66e94 "DMF0021 LOC 메저 중복 row" 09:21~10:16, 지시 5건, 화면 DMF0021
- 세션 5b182146 "DM 운영 DB 데이터 이관(QA>LIVE)" 19:28~2026-11-14 01:22, 지시 46건, VM 파일 수정 8건(menu-view.js 2, workbench.js 2, build_vsix.py 1, flow-panel.js 1, 50_DOC_STYLE.md 1), 화면 SCP0104, SSP0020
- 세션 0c23e6da "DMF0021 Flow Gate 작업" 22:34~22:37, 지시 1건, 화면 DMF0021
- VM 실행 12건: DMF0021 claude 6, DMF0021 menu_git-upload 3, DMF0021 S5.cloudApplied 1, DMF0021 menu_git-common-sync 1, DMF0021 S5.cloudMod 1

## 2026-11-10

세션 55, VM 실행 18, Claude 호출 1

- 세션 5957f715 "SSP0015 Shipment PSI 화면 As-is 분석" 13:22~13:28, 지시 1건, 화면 SSP0015
- 세션 636ea622 "SSP0021 출하계획 As-is 분석" 13:22~13:29, 지시 1건, 화면 SSP0021
- 세션 66d4bffc "SSP0060 As-is 분석 문서 작성" 13:22~13:29, 지시 1건, 화면 SSP0060
- 세션 e58b224c "SSP0015 Shipment PSI 화면 설계 및 테스트" 13:28~13:38, 지시 1건, 화면 SSP0015
- 세션 9867a9de "SSP0060 Shipment Plan 화면 설계 및 단위테스트 문서" 13:29~13:37, 지시 1건, 화면 SSP0060, SCP0009
- 세션 bb338275 "SSP0021 Shipment Plan 화면 설계 문서" 13:29~13:37, 지시 1건, 화면 SSP0021, SCP0009
- 세션 1bf2c9aa "SSP0023 Shipment Plan 화면 As-is 분석" 13:37~13:42, 지시 1건, 화면 SSP0023
- 세션 8ff5726c "SSP0200 Shipment Change Request 분석" 13:37~13:42, 지시 1건, 화면 SSP0200
- 세션 cbea187f "SSP0003 Shipment change request confirm" 13:38~13:42, 지시 1건, 화면 SSP0003
- 세션 87fc7635 "SSP0003 선적 변경 요청 확정 화면 분석" 13:42~13:48, 지시 1건, 화면 SSP0003
- 세션 ca1ddc2d "SSP0200 Shipment Change Request 분석서 작성" 13:42~13:47, 지시 1건, 화면 SSP0200
- 세션 cea12a82 "SSP0023 Shipment Plan 분석서 작성" 13:42~13:48, 지시 1건, 화면 SSP0023
- 세션 3e821221 "ORACLE @ PARAMETER 최대 사이즈 제약" 13:44~13:54, 지시 3건
- 세션 1b21dca8 "DMF0045 화면 As-is 분석" 13:47~13:50, 지시 1건, 화면 DMF0045
- 세션 444ec9bf "SSP0202 Shipment change request confirm 화면 As-is 분석" 13:48~13:53, 지시 1건, 화면 SSP0202
- 세션 52eaca72 "SSP0201 shipment change request 분석" 13:48~13:54, 지시 1건, 화면 SSP0201
- 세션 56f52d64 "DMF0045 ShipmentRequest 전환 산출물 작성" 13:50~13:55, 지시 1건, 화면 DMF0045, SCM0001
- 세션 15125040 "SSP0202 출하변경요청 확정 화면 설계" 13:53~13:58, 지시 1건, 화면 SSP0202, SCM0001
- 세션 c3480c9b "SSP0201 Shipment Change Request 분석서" 13:54~14:00, 지시 1건, 화면 SSP0201, SSP0026
- 세션 dbf523a3 "SSP0012 출하계획 확정 상세 화면" 13:55~13:57, 지시 1건, 화면 SSP0012
- 세션 9925018e "SSP0012 Shipment Plan Confirm 전환 분석" 13:57~14:00, 지시 1건, 화면 SSP0012, SCM0001
- 세션 52eb6cd4 "SSP0017 화면 NSCM 전환" 13:58~14:01, 지시 1건, 화면 SSP0017
- 세션 259df262 "SSP0026 Shipment request As-is 분석" 14:00~14:06, 지시 1건, 화면 SSP0026, DMF0045
- 세션 3a036900 "SSP0019 Shipment Change History 화면" 14:00~14:02, 지시 1건, 화면 SSP0019
- 세션 94956626 "SSP0017 Inventory Raw 화면 설계" 14:01~14:04, 지시 1건, 화면 SSP0017
- 세션 4ec050ab "SSP0019 Shipment Change History 화면 설계" 14:02~14:05, 지시 1건, 화면 SSP0019
- 세션 9d8da8a9 "SSP0024 화면 NSCM 전환 명세" 14:04~14:08, 지시 1건, 화면 SSP0024
- 세션 ccc4e094 "SSP0020 Delegate 화면 As-is 분석" 14:05~14:08, 지시 1건, 화면 SSP0020
- 세션 83b4b542 "SSP0026 Shipment Request Pack 전환 산출물" 14:06~14:12, 지시 1건, 화면 SSP0026, DMF0045
- 세션 f775979f "TO-BE TABLE" 14:07~2026-11-11 16:35, 지시 19건, VM 파일 수정 5건(workbench.js 5)
- 세션 106aca4c "SSP0024 Shipment Master Electrode 분석서 작성" 14:08~14:12, 지시 1건, 화면 SSP0024
- 세션 262e1326 "SSP0020 Delegate 화면 As-is 분석서 작성" 14:08~14:10, 지시 1건, 화면 SSP0020
- 세션 91d648fa "SSP0024 Material 검색 DB 객체" 14:09~14:14, 지시 1건, 화면 SSP0024
- 세션 2f588052 "SCP0033 Shipment Semi Dept Day" 14:10~14:12, 지시 1건, 화면 SCP0033
- 세션 125a1eb3 "SSP0045 출하요청 NSCM 전환" 14:12~14:15, 지시 1건, 화면 SSP0045
- 세션 9f3439ff "SCP0033 Shipment Semi Dept Day" 14:12~14:14, 지시 1건, 화면 SCP0033
- 세션 d08f58aa "SSP0025 Shipment Requestor PIC As-is 분석" 14:12~14:15, 지시 1건, 화면 SSP0025
- 세션 8e1d6958 "SSP0005 출하 작업일 화면" 14:14~14:17, 지시 1건, 화면 SSP0005
- 세션 45c17465 "SSP0025 Shipment Requestor PIC 전환 산출물" 14:15~14:19, 지시 1건, 화면 SSP0025, SSP0002
- 세션 98b4d4cd "SSP0045 Shipment Request 화면 전환 설계" 14:15~14:19, 지시 1건, 화면 SSP0045, SCM0001
- 세션 c0f88bde "SSP0005 Shipment Working Day 화면 분석" 14:17~14:19, 지시 1건, 화면 SSP0005, SCP0009
- 세션 730aa450 "SSP0014 Shipment Model PIC 화면 As-is 분석" 14:19~14:21, 지시 1건, 화면 SSP0014
- 세션 8aa27220 "SCP0005 Distribution Route 화면 As-is 분석" 14:19~14:23, 지시 1건, 화면 SCP0005
- 세션 f61093a5 "SSP0022 출하 요청 화면 As-is 분석" 14:19~14:24, 지시 1건, 화면 SSP0022
- 세션 b46cbc43 "SSP0014 Shipment Model PIC 전환 산출물" 14:21~14:23, 지시 1건, 화면 SSP0014
- 세션 27099756 "SCP0028 Shipment Lot Size 화면" 14:23~14:26, 지시 1건, 화면 SCP0028
- 세션 a9635912 "SCP0005 Distribution Route 전환 산출물" 14:23~14:26, 지시 1건, 화면 SCP0005
- 세션 74c4ef70 "SSP0022 Shipment Request(Electrode) 전환 산출물" 14:24~14:30, 지시 1건, 화면 SSP0022
- 세션 cb21d82d "SCP0028 Shipment Lot Size 분석서 작성" 14:26~14:29, 지시 1건, 화면 SCP0028
- 세션 aec965ee "Oracle MAX_STRING_SIZE 확장 시 인덱스" 14:45~14:57, 지시 3건
- 세션 0af975be "VM 기능개선" 17:07~2026-11-20 10:38, 지시 259건, VM 파일 수정 31건(menu-view.js 19, workbench.js 8, extension.js 3, CHANGELOG.md 1), 화면 SCP0104, SSP0020, SCP0096, SSP0021, SCP0041, SCP0034
- 세션 06ebb860 "SSP0005 Shipment Working Day 화면" 17:27~17:30, 지시 1건, 화면 SSP0005
- 세션 22c45376 "SSP0005 Shipment Working Day 분석 문서" 17:30~17:33, 지시 1건, 화면 SSP0005, SCP0009
- 세션 0d514785 "SCP0096 Shipment Working Day OSP 화면" 17:50~17:52, 지시 1건, 화면 SCP0096
- 세션 f1588cec "SCP0096 Shipment Working Day OSP 화면 분석" 17:52~17:56, 지시 1건, 화면 SCP0096, SCP0009
- VM 실행 18건: SSP0024 S8.verifyIfStale 3, SSP0200 S8.verify 2, SSP0024 S5.cloudMod 1, SSP0024 claude 1, SCP0033 S8.verify 1, SSP0021 S8.verify 1, SSP0023 S8.verify 1, SSP0003 S8.verify 1, SSP0060 S8.verify 1, SSP0015 S8.verify 1

## 2026-11-09

세션 3, VM 실행 7

- 세션 090e6644 "VM 고도화" 09:24~2026-11-16 15:10, 지시 101건, 화면 SSP0024, SSP0060, SSP0025, SCP0131, SCP0084, SCP0127
- 세션 554e9abd "DMF0082 조회 속도개선 _1104 PKG" 11:18~19:18, 지시 21건, 화면 DMF0082
- 세션 63914f79 "DMF0035 MONTHLY 조회 BUCKET 펼침" 17:52~18:38, 지시 1건
- VM 실행 7건: SSP0024 S8.verify 2, SSP0025 S8.verify 2, SCP0108 menu_git-upload 1, SSP0024 menu_git-common-sync 1, SCP0108 S8.verify 1

## 2026-11-07

검사기 결함 3

- 검사기 결함: 검사기 결함 T142~T146 chain6b(08:22~14:05 · 6화면 재실행) 결과 감사
- 검사기 결함: 검사기 결함 T129~T140 6화면 PoC 확대(SCP0037·SCP0084·SCP0122·SCP0131·SCP0127·SCP0016 · chain6 00:29~07:06) 결과 감사
- 검사기 결함: 검사기 결함 T123~T128 "CheckList 정합성 추가 보완" — 조치필요에 안 오른 FAIL·판정필요·미검증 감사(SCP0127 v14 · SCP0016 v17)

## 2026-11-06

변경 2, 세션 5, VM 실행 17, Claude 호출 1, 검사기 결함 17

- 시각 없음 [VM 기타] 패널 가로 축소 시 맨 아래 항목 유지 — 채팅·로그 상자가 바닥에 붙어 있던 상태면 크기 변경 뒤 자동으로 맨 아래로(ResizeObserver) (판 1.9.43)
  - 지시: "VM UI 를 가로로 줄였을 때 마지막 항목이 보이도록 VSCROLL 을 맨 아래로"
- 시각 없음 [CheckList 엔진] 화면 ID 중간 폴더(동시 실행 격리) · CheckList 진행 = 단계 i/7 · 세부 j/M · 테스트 n/N (판 1.9.42)
  - 지시: "results.json 을 UI ID 별로 … 다른 작업에 영향을 미치지 않도록 세션별/UI별로 파일을 다르게" / "UI_ID 별 작업은 중간 폴더로 UI_ID 를 넣어서" / "변경된 폴더의 결과를 찾아서 사용할 때 제대로 찾도록"
  - 파일 19개: results.json, Doc/e2e/results/results.json, _summary.csv, run-e2e.cmd, report.js, _summary.csv/.md, gen-e2e.js, _index.csv 외
  - 미확인 1건: VS Code 창 표시는 미확인(다시 로드 후 사용자 확인 필요).
  - 되돌리기 태그: 20261106
  - 세션: 6aa08eb9
- 세션 d2e46f91 "Tailscale 원격접속 로그인 정보" 09:02~17:35, 지시 5건
- 세션 6aa08eb9 "VM 보완 세션" 10:12~19:01, 지시 24건, VM 파일 수정 9건(extension.js 5, workbench.js 3, flow-panel.js 1), 화면 SCP0084, SCP0122, SCP0131, SCP0037, SCP0127
- 세션 8c236fa5 "DMF0082 속도" 17:27~18:27, 지시 5건, 화면 DMF0082
- 세션 7c290b41 "SCP0037 저장 실패 MSG0006 코드 확인" 17:40~17:43, 지시 1건, 화면 SCP0037
- 세션 d055956d "SSP분석" 18:45~2026-11-11 19:11, 지시 36건, 화면 SSP0005, SCP0005
- VM 실행 17건: SCP0016 S8.verify 3, SCP0037 S8.verify 3, SCP0084 S8.verify 2, SCP0122 S8.verify 2, SCP0037 claude 1, SCP0127 S8.verify 1, SCP0131 S8.verify 1, SCP0122 chain_testreport 1, SCP0122 S8.verifyIfStale 1, SCP0122 S8.report 1
- 검사기 결함: 검사기 결함 T59 필수 조회조건이 비어 조회가 막혀도 엔진이 응답 대기(120s)만 반복 → SCP0016 CheckList 7시간 · 측정 0
- 검사기 결함: 검사기 결함 T60 probe.editable/startEdit 가 Wijmo 편집기 예외를 그대로 던져 그리드 컬럼 프로브·CRUD 테스트 전체 중단
- 검사기 결함: 검사기 결함 T61 judge 무판정/미기동 귀속이 테스트 제목의 규칙 코드만 봄 → RULE_SCREEN 전용 테스트가 COLUMN H2 를 '무판정' ERROR 로 가져감
- 검사기 결함: 검사기 결함 T62 coverage.py num_editable 이 EditButton SwitchLock(TOGGLE) 해제를 무시 · F6 '숫자 편집 칸 없음' 미분류
- 검사기 결함: 검사기 결함 T64 기존행 수정 저장 시험이 저장 키 컬럼을 편집 → 업무 중복 차단 · 자동 복원 불가로 사내 DB 잔존
- 검사기 결함: 검사기 결함 T65 prereq smoke 재사용 기준이 FE 소스뿐 → 엔진 보완(T57) 전 smoke 결과를 재사용해 같은 ERROR 재발
- 검사기 결함: 검사기 결함 T63 결번 — 'Edit 토글 진입' 보완은 되돌림
- 검사기 결함: 검사기 결함 T66 종료코드 규약 — CheckList 를 만든 실행이 exit 10(오류)으로 끝남 → VM '오류' 표시
- 검사기 결함: 검사기 결함 T67 저장 시험 범위 — 빈 칸 제외 · 붙여넣기에 다른 행 값 복사 · 편집기 오류 묵음
- 검사기 결함: 검사기 결함 T68 동시 CheckList — 공용 smoke 잠금 무력 · 공용 생산 잠금 경합 · 부하 무관 무제한 동시 실행
- 검사기 결함: 검사기 결함 T69~T80 SCP0122 v3 조치 필요 9건 · SCP0037 v2 32건 — 오류 아닌데 FAIL(사용자 확인 "추가/수정/삭제 저장 정상")
- 검사기 결함: 검사기 결함 T81 smoke 잠금 방식 통일 — 사용자 지시 "한쪽 방식으로 통일 · 중복 수행해도 괜찮도록"
- 검사기 결함: 검사기 결함 T82~T89 SCP0084 CheckList v3 조치 필요 29건 사용자 재확인 — "대부분 오류가 아닌데 오류로 판정"
- 검사기 결함: 검사기 결함 T91~T102 SCP0037 조치 필요 12건·SCP0016 38건 사용자 재확인 — 조사(서브에이전트 3건 소스·메타 판독)로 원인 확정 · 검사기 수정
- 검사기 결함: 검사기 결함 T106~T113 SCP0127 조치 필요 1~11 사용자 재확인(사용자 표기 'SCP0016') — 엔진 공통 보완
- 검사기 결함: 검사기 결함 T114~T116 SCP0131 CheckList v5 조치 필요 1~13 사용자 재확인 — 엔진 공통 보완
- 검사기 결함: 검사기 결함 T117~T122 사용자 결정 "나머지는 진행" — SCP0016 11·17·20번 · SCP0127 G1·E7 · 2-b Team · diff 오매핑

## 2026-11-05

변경 1, 세션 3, VM 실행 13, 검사기 결함 4

- 시각 없음 [체인·메뉴] 화면 ID 첫 입력 무반응 보완 — 확정 창에 ID 를 바로 치고 Enter 한 번으로 지정 (판 1.9.41)
  - 지시: "VM 에서 UI ID 미지정 상태에서 최초 UI ID 입력하면 반응하지 않습니다, 한번더 입력해야 입력됩니다."
  - 파일 1개: workbench.js
  - 미확인 1건: 실제 창 조작 확인은 미실행(VS Code 창 다시 로드 후 사용자 확인 필요).
  - 되돌리기 태그: 20261105
  - 세션: bde15641
- 세션 fdb91da8 "새 PC Claude Code 설정 이전" 18:40~20:36, 지시 11건
- 세션 f1a7d600 "VM 설치파일 확장 설치" 18:41~18:48, 지시 2건
- 세션 bde15641 "속도개선" 20:18~2026-11-06 18:24, 지시 17건, VM 파일 수정 1건(workbench.js 1), 화면 SCP0037, SCP0125
- VM 실행 13건: SCP0131 S8.verify 2, SCP0016 S8.verify 2, SCP0127 S8.verify 2, SCP0084 S8.verify 2, SCP0084 menu_git-upload 2, SCP0037 S8.verify 1, SCP0122 S8.verify 1, 공통 menu_multi 1
- 검사기 결함: 검사기 결함 T55 judge META I1/I4 가 같은 규칙의 E2E 실측 행(시나리오·권한 시험)을 덮어씀 → 놓친 결함
- 검사기 결함: 검사기 결함 T56 coverage.py 의 E1 '기능 있음' 휴리스틱이 AS-IS 잠금 사실을 보지 않음 → 커버리지 게이트(rc 10) 오판
- 검사기 결함: 검사기 결함 T57 smoke 공통 기능 — 앞 단계가 남긴 다이얼로그가 Search Area 스위치 클릭을 가로챔 → '변화 감지 못함' ERROR(3 화면)
- 검사기 결함: 검사기 결함 T58 run_verify 동적 포트 고갈 게이트가 netstat 줄 수로 셈 → Bound 소켓 고갈을 못 봄 → E2E 무의미 실행

## 2026-11-04

변경 2, VM 실행 3, 검사기 결함 6

- 시각 없음 [Workbench] 작업 실패 시 원인 줄 표시 — 로그의 [FAIL]/[ERROR] 줄을 작업창·채팅·Flow 보드·VS Code 알림에 (판 1.9.40)
  - 지시: "VM CHECKLIST 작업 수행 시 오류 발생 — 작업창에 어떤 오류인지가 보이지 않습니다. 오류 발생 시 어떤 오류가 발생했는지 쉽게 인지할 수 있도록 알려주세요."
  - 파일 5개: files.csv, FULLRUN.md, _checker_defects.md, facts_combosrc.py, gen_golden_cases.py
  - 되돌리기 태그: 20261104
- 시각 없음 [CheckList 엔진] E2E 테스트 메뉴 단계 폐지 · 자동보완 = CheckList → 오류분 보완 → 재판정 반복 (판 1.9.39)
  - 지시: "E2E 테스트 메뉴단계는 없애 주세요. 자동보완 시 CHECKLIST 작업을 진행하고 오류분에 대해서 자동보완되도록 하는 구조로 진행해주세요."
  - 파일 2개: steps.json, fixlist.csv
- VM 실행 3건: SCP0122 S8.verify 2, SCP0111 menu_git-upload 1
- 검사기 결함: 검사기 결함 T49 upload 단계 take() 가 업로드 모달을 닫음
- 검사기 결함: 검사기 결함 T50 dbq.py 50행 상한으로 기대값 원천이 잘림 → 허위 FAIL
- 검사기 결함: 검사기 결함 T51 팝업 안 버튼 클릭 뒤 알림 수거가 팝업을 닫음 · poprow 그리드 탐색 한 방식
- 검사기 결함: 검사기 결함 T52 컬럼 설정 시험 — 메타 기준 무시·미실행을 FAIL 로·0행 조건 상시 차단
- 검사기 결함: 검사기 결함 T53 AS-IS Pack variant 에 .sln 미등록 표기가 섞여 CheckList 가 파일 0건으로 중단
- 검사기 결함: 검사기 결함 T54 화면에 그려지지 않은 동적 칸을 '잠김'으로 판정(dynlock·type)

## 2026-11-03

변경 1, VM 실행 8, Claude 호출 4

- 시각 없음 [VM 기타] ☁️ 수정본 대상 누락 보완 · 이관 기준선 = 완료 표시로만 이동 (판 1.9.38)
  - 지시: "이전 작업에서 1021 폴더를 만들었는데, 수정본 클릭 시 그 폴더를 알려주거나 수정본만 추출하면 되는데 새 수정본에 적용 대상이 누락된다."
- VM 실행 8건: SCP0111 claude 4, SCP0111 menu_work-mode 1, SCP0111 menu_git-upload 1, SCP0111 S5.cloudMod 1, SCP0096 menu_git-common-sync 1

## 2026-11-02

변경 1, VM 실행 2, 룰 변경 1

- 시각 없음 [체인·메뉴] + 환경설정 🧭 작업 모드(DB MODE / UI/DB MODE) · ☁️ 메뉴 4→2 · 🧯 메뉴 2→1 (판 1.9.37)
  - 지시: "환경설정에서 DB MODE, UI/DB MODE 선택 · UI/DB = 제약 없이 개발, Git Download & Merge 때 로컬 보호 · DB = DB·META 만, FE 는 가이드만, Git Download & Merge 때 로컬 보호 안 함 · CheckList 는 모드 무관 전체" / "클라우드 이관도 모드로 자동 선택, 메뉴 4개 → 2개" / "자동 보완, 자동 보완(DB) 도 하나로"
  - 파일 7개: tools/Harness/harness.json, set_scope.py, .claude/hooks/check-work-mode.ps1, gen.js, repair-loop.js, cloud_pkg.py, common_sync.py
  - 되돌리기 태그: 20261102
- VM 실행 2건: SCP0096 menu_git-upload 1, SCP0096 menu_git-common-sync 1
- 룰 변경: §1-8 작업 모드(UI/DB MODE · DB MODE) · §5 `check-work-mode` 추가 — 이 달 파일이 없어 2026-11-13 전수 점검 때 소급 기록(CLAUDE.md 본문에 날짜 표기 있음).

## 2026-10-31

룰 변경 1

- 룰 변경: §1-9 감·예측 답변 금지 추가(사용자 지시 · hook #126 §0-1 · attach-context · 하네스 프롬프트 공통)

## 2026-10-30

변경 6, VM 실행 5, Claude 호출 5, 룰 변경 6

- 시각 없음 [Workbench] + Task History 신설 · 작업 이력 → Revision History · 기본 일자별 (판 1.9.36)
  - 지시: "History 초기값 = 일자별(화면별은 내 작업본이 아닌 화면이 먼저 보임)" / "VM 메뉴·프롬프트 입력 작업 내역을 이력으로 보기" / "현재 작업 이력·WorkBench History = Revision History, 추가 기능 = Task History, Overview & Reports 에"
  - 되돌리기 태그: 20261030_hist
- 시각 없음 [CheckList 엔진] − GAP 분석 폐지 → CheckList 로 대체 (판 1.9.35)
  - 지시: "CheckList 가 완성되면 GAP 분석은 필요 없음 → 제거"
  - 파일 7개: gap.js, gap.csv, prereq.py, make_docs.py, md2xlsx.py, /fixlist.csv, tools/Harness/gap.js
  - 되돌리기 태그: 20261030_gap
- 시각 없음 [CheckList 엔진] + 클라우드 이관 = 결정적 빌더 · 수정본/전체 4종 · PKG 보완 · META 생성 및 보완 · 자동 보완(DB) (판 1.9.34)
  - 지시: "클라우드 이관(DB) 1시간 넘게 걸림 — 생성·보완 때 미리 만들고, 요청하면 취합만. 미리 만들지 않았어도 5분 안에"
  - 파일 2개: tools/CloudPkg/cloud_pkg.py, manifest.json
  - 되돌리기 태그: 20261030
- 시각 없음 [체인·메뉴] + 📋 테스트결과서 메뉴 (판 1.9.33)
  - 지시: "CheckList 작업 후 작업 내역에 대해서 테스트결과서를 생성 — 항목별 Group, 상세 내역을 테스트 내역과 결과로, 사용자의 언어로 보기 편하게 Excel, 필요하면 화면 캡처 포함, 메뉴는 UI CheckList 하단에(차후 UI CheckList 에 포함 예정이나 지금은 별도)"
  - 파일 7개: tools/Harness/verify/make_test_report.py, index_verify.json, index_trace.json, tools/Harness/rules/label_alias.csv, rules/10_RULES_KEEP.md, 40_SEARCH_COND.md, check.js
- 시각 없음 [서버] + 서버 기동 완료 → 상단 스피너 중지 (판 1.9.32)
  - 미확인 1건: 기동 중·시간 초과(완료 미확인)·다른 작업 실행 중에는 기존대로 스피너 표시.
- 시각 없음 [Workbench] + 탭 명칭 = 화면 ID 반영 (판 1.9.31)
- VM 실행 5건: SCP0100 claude 2, SCP0041 claude 2, SCP0125 claude 1
- 룰 변경: 정합검증 원천 확장 1단계 — sources_extract.py: DM 단위테스트·GAP 분석 종합·SCP&SSP DMF0045 xlsx 전 시트·셀·이미지 → Doc/verify/sources/ MD+CSV(누락 0 보고 _extract_report.md) · 2단계(설계 결정 CSV·공통요건 CR·G8/G9/E7 검사기) 진행 중
- 룰 변경: 정합검증 원천 확장 2단계 — 651행 행별 분류(DEFECT 376·DESIGN 211·OPEN 21·REQ 25·INFO 18) → defects_baseline/classified 확장 · design_decisions.csv 211(judge DESIGN_NA) · CR-078~091 · 규칙 G9/E7/F9/F10/H11/H12/G10 · 검사기 
- 룰 변경: 검사기 결함 T10(도구 오류 문구가 산출물 생성을 깨뜨림) — SCP0100 07:46 run_verify exit 8: K1 '필터 적용 시험 불가' 증거의 Playwright ANSI 제어문자(ESC [2m)가 원장 24행 → openpyxl IllegalCharacterError. 보완: make_verify_docs.xl_safe(모든 문자열 셀 
- 룰 변경: CheckList 열 순서 변경(사용자 지시) — 영역/대상/결과/설명(구 쉬운 설명)/기대(AS-IS·규칙)/AS-IS 근거/조건/정답/… · make_verify_docs LH/LW_BY/lrow 이름 기반 · regress.py 설명 열 독자 '설명'·'쉬운 설명' 둘 다 · README 기록
- 룰 변경: 테스트결과서 신설(사용자 요청) — make_test_report.py: CheckList 원장을 영역→검사 규칙→항목 그룹(Excel outline)·테스트 내역·기대·실제 상세·겪는 일·캡처로 Doc/테스트결과서/ xlsx · 스펙 afterEach FAIL 캡처(e2e/shots/index_*.json) · run_verify 캡처 초기화 · Vibe
- 룰 변경: TO-BE 룰 CR-092(사용자 지시) — SCP·SSP 컬럼·조회조건 명칭 Valid→Active 일괄: 정본 tools/Harness/rules/label_alias.csv · confirmed_requirements CR-092 · _trace.spec H5(COL·PCOL, tools/E2E/lib/labelalias.ts) · judge H5_C

## 2026-10-29

변경 3, VM 실행 17, Claude 호출 7, 룰 변경 2

- 시각 없음 [CheckList 엔진] + 완료 판정 = 후속 작업(자식 프로세스) 종료까지 (판 1.9.30)
  - 파일 2개: run_verify.py, rules/10_RULES_KEEP.md
- 시각 없음 [Workbench] + Enter 전송 · 질문 줄 한 줄 표시 (판 1.9.29)
  - 지시: "프롬프트 창도 Claude 와 같이 **Enter = 전송 · Shift+Enter = 줄바꿈**(워크벤치 입력창·프롬프트 패널 둘 다) · 한글 IME 조합 중 Enter(isComposing·keyCode 229)는 조합 확정만 하고 전송하지 않음 · Ctrl+Enter 도 전송 · ↑/↓ 이력 탐색 유지 · 버튼·안내 문구 갱신."
- 시각 없음 [Workbench] + LITE 질의 = Step 상황판 없이 질문 + 결과만 (판 1.9.29)
  - 지시: "Step Status 가 필요 없는 LITE 질의(산출물 없는 질문·확인)는 상황판(현재 Step/전체·진행바·도구/수정/경과·Step 카드)을 띄우지 않고 위 질문 + 아래 결과만."
- VM 실행 17건: SCP0096 claude 9, SCP0020 claude 2, SCP0041 claude 2, SCP0100 claude 2, SCP0111 claude 2
- 룰 변경: VibeManager 1.9.30: 워크벤치 완료 판정 = Claude result 뒤 자식 프로세스(run_verify·playwright 등) 종료까지('보고 완료 · 후속 작업 진행 중' · 중지 시 함께 종료될 후속 작업 표시) · KEEP H20(검증 실행을 띄운 턴은 끝날 때까지 턴 종료 금지) — 사고: VM#2 '완료' 표시 중 SCP0020
- 룰 변경: 정합검증 라운드 42 — 검증엔진 미기동 재발 방지(검사기 결함 유형 T9): E2E 로그인 재시도(풀 고갈)·서버 점검 12×5초 재시도·동시 E2E 상한 슬롯(verifyMaxConcurrent 3)·대기 루프 시간 상한·judge '[검증엔진 미기동]' ERROR·로컬 BE maxPoolSize 10→40(재기동 시 적용)

## 2026-10-28

변경 4, VM 실행 11

- 시각 없음 [CheckList 엔진] + 창별 독립 E2E(하네스 측: tools/E2E/runlock.js 화면별 잠금 · run_verify 대기 · golden/gen-e2e/prereq 공용 파일 보호) — 2026-10-28 (판 1.9.28)
- 시각 없음 [서버] + 창별 화면 ID 독립 · 탭 명칭 VM#n · 재기동 아이콘 (판 1.9.28)
- 시각 없음 [Workbench] + Workbench 다중 창 — 명령은 현재 선택된 창에서 실행 (판 1.9.28)
- 시각 없음 [체인·메뉴] + 생성·보완 ↔ 정합검증 연결 · 메뉴 재편 (판 1.9.28)
  - 지시: "생성 시 생성 후 정합검증 / 자동 보완 시 정합검증이 최신이 아니면 정합검증 후 보완 / 보완은 정합검증 '조치 필요' 항목을 일괄 보완 / 정합검증은 소스를 수정하지 않는다."
  - 파일 15개: tools/Harness/verify/prereq.py, pack.ps1, /prereq.json, verify/verify_if_stale.py, run_verify.result.json, workbench.js, /fixlist.csv, prereq.py 외
  - 되돌리기 태그: 20261028
- VM 실행 11건: SCP0096 claude 5, SCP0020 claude 1, SCP0100 S3.agent 1, SCP0020 S3.agent 1, SCP0111 S3.agent 1, SCP0041 S3.agent 1, SCP0096 S3.agent 1

## 2026-10-27

변경 1

- 시각 없음 [CheckList 엔진] + UI Status 문서 = 같은 문서는 마지막 버전만 (판 1.9.28)
  - 지시: "UI STATUS TAB 문서에는 동일 문서의 경우 제일 마지막에 생성된 버전의 문서만 표기"
  - 되돌리기 태그: 20261027

## 2026-10-26

변경 1

- 시각 없음 [CheckList 엔진] + 독립 판정·근거 등급·결과 봉투 (판 1.9.28)
  - 파일 12개: tools/Harness/e2e-judge.js, tools/Harness/verify/evidence_check.py, Doc/e2e/_human_review.md, verify/weaken_check.py, fixlist.csv, decisions.py, /E2E_REPAIR.result.json, /CHECK.result.json 외
  - 되돌리기 태그: 20261026, 20261026_pre

## 2026-10-23

변경 4, VM 실행 4

- 시각 없음 [CheckList 엔진] **🔎 화면 정합검증 (AS-IS vs TO-BE → 정합검증서·보완대상목록)**(사용자 지시: 사람이 단위테스트에서 찾은 오류를 시스템이 전부 도출 · 보완  (판 1.9.28)
  - 파일 8개: Doc/verify/defects_baseline.csv, tools/Harness/verify/detect_rules.csv, tools/Harness/rules/confirmed_requirements.csv, tools/Harness/verify/run_verify.py, Doc/verify/README.md, tools/Harness/harness.json, /fixlist.csv, steps.json
- 시각 없음 [VM 기타] **액션 대조표 = 문서 보강 단계**(사용자 지시: 개발된 UI·흐름 무영향): 기존 화면 문서 위치 Doc/gen → `Doc/asisfacts/screens (판 1.9.27)
  - 파일 1개: /__asis-actions__.md
- 시각 없음 [CheckList 엔진] **AS-IS 액션 대조표 연결**(사용자 지시): AsisFacts 액션 추출(actions.csv) → `__asis-actions__.md`(신규 화면 페이 (판 1.9.26)
  - 파일 4개: actions.csv, __asis-actions__.md, tools/Harness/actions-checklist.js, /__asis-actions__.md
- 시각 없음 [문서 생성] **참고자료: SCP·SSP 화면 VALIDATION 취합**(사용자 지시): `Doc/화면분석서/{SCP/SSP}_화면_VALIDATION_취합_<최신>.md` (판 1.9.25)
  - 파일 3개: _INDEX.md, new_screen.md, port_pkg.md
- VM 실행 4건: SCP0007 claude 1, SCP0007 S3.agent 1, SCP0007 S4.one 1, SCP0122 claude 1

## 2026-10-22

변경 11, VM 실행 14

- 시각 없음 [Workbench] **☁️ 클라우드 이관 패키지 2종**(사용자 지시): (전체: FE·BE·PKG·META·MENU) · **(DB)**(PKG·META·MENU, 폴더 `_CL (판 1.9.24)
  - 파일 6개: tools/DbConn/meta_apply.py, _PKG.sql, /_pkg_applied.json, registration.sql, PKG.sql, 10_RULES_KEEP.md
- 시각 없음 [체인·메뉴] **메뉴 이름**(사용자 지시): 👀 등록 미리보기 → **META 미리보기** · ✅ 등록 커밋 → **META 커밋** · ↩️ 되돌리기 → **되돌리기(P (판 1.9.23)
  - 파일 1개: steps.json
- 시각 없음 [문서 생성] **📝 문서 생성 = MD + Excel 한 번에**(사용자 지시): 📗 문서 Excel 메뉴를 흡수(삭제). 체인(chainId docs) — AS-IS 파 (판 1.9.22)
- 시각 없음 [Workbench] **FLOW ★ 끝까지**(사용자 지시): 종전엔 `S5.pipeline`(새 화면 생성 7단계)이라 이미 만든 화면에서 '기존 생성분 삭제/중지' 확인창이 떴다 (판 1.9.21)
- 시각 없음 [체인·메뉴] **🩹 E2E 오류 보완 = 한 번에 끝까지**(사용자 지시: 🔧 기대값 보정 기능을 🩹 에 포함 · 사용자는 오류 상세를 알 필요 없음). 🔧 메뉴 삭제 (판 1.9.20)
- 시각 없음 [CheckList 엔진] **사고(SCP0122 15:25~15:58)**: 🩹 E2E 오류 보완 → Claude 판정 a=0 b=0 c=1(화면·DB 결함 없음, E2E 기대값 결함) (판 1.9.19)
  - 파일 2개: Doc/e2e/_expectation_issues.md, lib/crud.ts
- 시각 없음 [체인·메뉴] **CRUD 실패 → 권한별 CRUD SKIP**(사용자 지시): 같은 저장 경로라 CRUD 가 실패하면 권한별 CRUD 결과는 의미가 없다. 의존표 `E2E_D (판 1.9.18)
  - 파일 2개: FULLRUN.md, run-e2e.cmd
- 시각 없음 [Workbench] **🎬 E2E 전체 4단계 = Flow 보드 4단계**(사용자 지시 "4단계 중 어느 단계인지·무슨 작업인지 안 보임"): 종전엔 `run-e2e.cmd all (판 1.9.17)
  - 파일 7개: run-e2e.cmd, steps.json, tools/CommonSync/common_sync.py, state.json, d.ts, procedures.d.ts, UPLOAD_PREP.md
  - 미확인 2건: 5 BE/FE 미기동)는 나머지 미실행. / 재시도 5 일치 확인(모의 검증, 웹뷰 실화면 미확인).
- 시각 없음 [체인·메뉴] **메뉴 창 상단 아이콘 순서**(사용자 지시): Workbench 를 맨 앞으로. order 가 없어 앞에 붙던 FLOW·History 포함 전 아이콘에 명시  (판 1.9.16)
- 시각 없음 [체인·메뉴] **탭 자동 전환 제거**(사용자 지시): Claude 창을 보는 중 작업 실행·BE/FE 기동·종료·체인 시작·소스 업로드 이벤트가 Log / Task Log  (판 1.9.15)
  - 지시: "사용자가 직접 누른 이동(서버 실패 알림의 'Log 보기' · 히스토리 명령 · 파일/FLOW 탭 열기 · 전송 · 프롬프트 채우기)은 그대로 이동."
- 시각 없음 [CheckList 엔진] **사고(10-21 SSP0015)**: 이미 구현·커밋된 화면(10-14 커밋본 20파일)에 🚀 ID 하나로 전체 를 실행 → 파싱·Agent(18분)·GAP (판 1.9.14)
  - 파일 7개: pipeline.js, /register.json, gen.js, quick.json, steps.json, register.json, __asis-mapping__.md
- VM 실행 14건: SCP0122 S5.pipeline 7, SCP0122 claude 2, SSP0015 S1.packone 2, SCP0122 S4.one 1, SCP0122 S3.agent 1, SCP0122 S1.packone 1

## 2026-10-21

변경 11, VM 실행 24

- 시각 없음 [체인·메뉴] **🛠️ 기존 화면 보완(Claude · 골격 재생성 금지) — 입력 전에 실행되던 문제**(사용자 신고): 종전엔 메뉴 선택 즉시 준비 턴이 Claude 로  (판 1.9.13)
  - 파일 1개: quick.json
- 시각 없음 [CheckList 엔진] **E2E 전체 진단**(사용자: "E2E 에서 계속 오류가 나며 멈춘다"): 10-21 smoke 14회 중 실패 원인은 ① 생성기 기대값(조회조건 카탈로그·A (판 1.9.12)
  - 파일 1개: Doc/e2e/_expectation_issues.md
- 시각 없음 [체인·메뉴] **체인이 E2E smoke 단계에서 조용히 종료된 사고(19:28 SCP0100 🚒)**: smoke FAIL → 🩹 수선 2 호출 시점에 Claude 가  (판 1.9.11)
  - 파일 1개: check.js
- 시각 없음 [Workbench] + 하네스/E2E 보강 (판 1.9.10)
  - 파일 2개: check.js, lges.ts
- 시각 없음 [체인·메뉴] **"🩹 E2E 오류 보완을 지시했는데 오류 지속" 원인 2가지 보완**: ① 메뉴에서 직접 실행하면 `${kind}/${round}/${step}` 이 치환되 (판 1.9.10)
  - 파일 2개: E2E_REPAIR.md, quick.json
- 시각 없음 [Git] **⬆️ Source Backup 자동화**(사용자 지시): 커밋 메시지 입력창·확인창 없이 `git add -A → commit -m "BACKUP_YYYYMM (판 1.9.9)
  - 파일 1개: quick.json
- 시각 없음 [VM 기타] + 하네스 보강 (판 1.9.8)
  - 파일 5개: supply/group-code-management/utils/group-code-management.save.ts, ko.json, check.js, harness.json, CHECK.md
- 시각 없음 [Workbench] **동적 탭이 '버튼만 생기고 내용은 안 보이는' 사고 수정**(사용자 신고: 전환 흐름 대시보드·FLOW 진척·소스 전후 diff 등 전부): 원인 = FLOW (판 1.9.8)
  - 파일 3개: .csv/.md, tools/Docs/make_docs.py, __asis-mapping__.md
- 시각 없음 [체인·메뉴] **새 화면 체인에 자동 보완·수선 내장**(사용자 지시: "ID 하나로 전체로 만든 화면이 🧯 자동보완의 40+ 단계 보정을 거치지 않아 제대로 생성되지 않았 (판 1.9.7)
  - 파일 5개: quick.json, FULLRUN.md, _summary.csv, check.js, /E2E_REPAIR.md
- 시각 없음 [체인·메뉴] **E2E 미실행 사고(🎬 E2E 전체 4단계 가 1~3초 만에 '완료')**: 원인 = 다른 run-e2e(수동 실행)가 공용 `Doc\e2e\_run.log (판 1.9.6)
  - 파일 8개: runlock.js, report.js, results.json, __asis-mapping__.md, register.json, run-e2e.cmd, steps.json, quick.json
  - 미확인 1건: **E2E 미실행 사고(🎬 E2E 전체 4단계 가 1~3초 만에 '완료')**: 원인 = 다른 run-e2e(수동 실행)가 공용 `Doc\e2e\_run.log` 를 쥐고 있어 배치의 모든 `>> _run.log` 리다이렉트가 "다른 프로세스가 사용 중" 으로 실패 → probe·권한 메타·스펙 생성·Playwright 가 하나도 돌지 않았는데 마지막 명령(report)의 0 이 반환.
- 시각 없음 [체인·메뉴] **체인 E2E 무실행 → "완료" 오판 보완**(SCP0100 사고): ① VS Code 루트 `c:\…`(소문자) 와 설정 `C:\…` 가 섞여 Playwri (판 1.9.5)
  - 파일 3개: playwright.config.ts, run-e2e.cmd, _summary.csv
- VM 실행 24건: SCP0100 claude 17, SCP0100 S4.one 3, SSP0015 S4.one 1, SSP0015 S5.pipeline 1, SSP0015 S3.agent 1, SSP0015 S1.packone 1

## 2026-10-20

변경 19, VM 실행 7

- 시각 없음 [CheckList 엔진] + 하네스 보강 3 (판 1.7.7)
- 시각 없음 [CheckList 엔진] + 하네스 보강 2 (판 1.7.7)
  - 파일 7개: check.js, gen.js, gap.js, lib/dyncol.js, gen.js/templates.js, register.json, quick.json
- 시각 없음 [체인·메뉴] **체인 단계 세분화**(사용자 지시 "너무 큰 작업이 하나로 묶여 있다"): 새 화면 pipeline 1단계 → **7단계**(FE 골격 → 등록 SQL → P (판 1.9.4)
  - 파일 5개: tools/Harness/pipeline.js, /_pipeline_steps.json, PIPELINE.md, tools/E2E/report.js, _summary.csv
- 시각 없음 [CheckList 엔진] **명령형 항목도 Workbench 탭으로**(1.9.0 에서 빠진 것): 🛰️ 전환 흐름 대시보드 → HTML 탭(단계×게이트 판정, 작업 실행·🔄 갱신 버 (판 1.9.3)
  - 파일 1개: steps.json
- 시각 없음 [체인·메뉴] **체인 즉시 시작**: 🚀/🧩/📏/🚒 체인은 화면 ID 확정(QuickPick) 뒤 두 번째 모달 확인창 없이 바로 시작(비차단 알림 + Task Log (판 1.9.2)
- 시각 없음 [체인·메뉴] **E2E CRUD = 실제 저장**(사용자 지시): Insert 없는 셀 편집 저장형도 값 변경 → Save → 재조회 반영 확인 → 원래 값 복원 Save → (판 1.9.1)
  - 파일 5개: users.json, run-e2e.cmd, gen-e2e.js, tools/E2E/users.json, _index.csv
- 시각 없음 [Workbench] **Workbench 내부 탭(열기 류 전부)**: 새 창·외부 프로그램을 만드는 기능(Workbench 새 창 · Open Browser(NSCM) · E2E  (판 1.9.0)
  - 파일 2개: quick.json, tabview.js
- 시각 없음 [체인·메뉴] **Flow 보드**(Claude 탭): 체인(🚀/🧩/📏/🚒)과 메뉴·스테퍼에서 실행한 **단일 작업**도 텍스트 로그가 아니라 보드로 — 헤더(🧭 Fl (판 1.8.9)
  - 파일 1개: run-e2e.cmd
- 시각 없음 [Workbench] **E2E 테스트 단계 4종**: smoke · crud · auth · **authcrud(계정별 권한 CRUD, 신설)**. FLOW/UI Status 단계  (판 1.8.8)
  - 파일 9개: Doc/e2e/results/_summary.csv, lib/crud.ts, gen-e2e.js, .authcrud.spec.ts, report.js, run-e2e.cmd, quick.json, steps.json 외
  - 미확인 1건: FLOW/UI Status 단계 9~12 = `9 Smoke / 10 CRUD / 11 Auth / 12 Auth×CRUD`(판정 = `Doc/e2e/results/_summary.csv` 의 kind 열, 결과 없고 스펙만 있으면 '미실행'), UI Status 타일 4종, 스테퍼 클릭 = S7.smoke/crud/auth/authcrud, DoD 패널 E2E 결과 종류별 합계
- 시각 없음 [문서 생성] **UI Status 문서(Excel) 칩 열기 오류 수정**: "An error occurred opening an external program — 지정된 파 (판 1.8.7)
- 시각 없음 [Git] **Source Backup push 인증**: quick.json 항목에 `credUser: leekc297` 추가, push 명령에만 `git -c crede (판 1.8.6)
  - 파일 1개: quick.json
- 시각 없음 [Workbench] **Agent Model 기본값 Opus 5.5**: 설정 `vibeManager.agentModel` 기본 `claude-sonnet-4-5` → `claude (판 1.8.5)
  - 파일 2개: tools/AsisFacts/agent.ps1, agent.ps1
- 시각 없음 [Workbench] **Claude 탭 = 상황판**: 프롬프트 1회가 보드 1개. 맨 위 헤더에 **현재 Step / 전체 Step** · 현재 Step 제목 · 진행바 · 지금  (판 1.8.4)
  - 파일 1개: VibeManager/quick.json
- 시각 없음 [체인·메뉴] **언어 설정** `vibeManager.language` (`en` 기본 / `ko`): 사이드바 메뉴 그룹·항목(quick.json `title_en`/`la (판 1.8.3)
  - 파일 3개: quick.json, steps.json, tools/Docs/make_docs.py
- 시각 없음 [Git] **이력 시각 = 로컬 시간**(사용자 지적): 저장 `toISOString()`(UTC) → `nowLocal()`(`YYYY-MM-DDTHH:mm:ss+09: (판 1.8.2)
  - 파일 1개: check.js
- 시각 없음 [VM 기타] **Server(Start/Finish)**: 그룹 `Server Start`→`Server(Start/Finish)` · `Start BE & FE`→`🔁 B (판 1.8.1)
  - 미확인 1건: 미실행 안내
- 시각 없음 [Workbench] **명칭**: 패널 제목 `Vibe_Manager 워크벤치` → `Vibe_Manager Workbench`(새 창 `#n`) · 명령 팔레트 `Vibe_Mana (판 1.8.0)
  - 파일 1개: gap.js
- 시각 없음 [서버] **BE 기동 실패 수정**: `gradlew.bat` 이 `'is not recognized'` 로 실패 — 이 PC 는 `NoDefaultCurrentDire (판 1.7.9)
  - 파일 1개: quick.json
- 시각 없음 [서버] **메뉴 라벨 정리(사용자 지시)**: 그룹 `서버`→`서버 기동`(`🔁 둘 다`→`BE&FE 기동` · `🌐 브라우저`→`브라우저 실행`) · 그룹 `소스` (판 1.7.8)
- VM 실행 7건: SCP0100 claude 3, SCP0100 S4.one 1, SCP0100 S5.pipeline 1, SCP0100 S3.agent 1, SCP0100 S1.packone 1

## 2026-10-19

변경 18, Claude 호출 1

- 시각 없음 [Git] + 하네스 보강 (판 1.7.7)
  - 파일 11개: REPAIR.md, gen.js, pipeline.js, check.js, Doc/tobefacts/db/proc_params.csv, registration.sql, proc_meta.csv, flow.csv 외
- 시각 없음 [Workbench] **GAP 클릭 "✗ … (exit undefined)" 경고 · E2E 스모크 '실행 중' 고착 수정**: 원인 = FLOW 셀·프로그램 ID 단계 작업·DoD (판 1.7.7)
  - 파일 1개: gap.js
- 시각 없음 [Workbench] **프롬프트 우측 버튼**: `📤 전송 (Ctrl+Enter)` · `⏹️ 중지` · `🧹 지우기` 를 프롬프트 입력창 오른쪽에 세로 배치(전송 버튼이 남는  (판 1.7.6)
  - 파일 1개: quick.json
- 시각 없음 [VM 기타] **새 화면 생성 중지(400) 수정**: 원인 = 하네스·워크벤치가 PATH 의 `claude`(`~/.local/bin` **2.1.123**, 4월 설치 후 (판 1.7.5)
  - 파일 3개: repair-loop.js, REPAIR.md, new-screen.ps1
- 시각 없음 [체인·메뉴] **워크벤치 좌측 메뉴 영역 제거**: 전체 메뉴는 사이드바(`vibeManager.menu`) 하나로 — 워크벤치는 Claude 대화·작업 출력·프롬프트를 전체 (판 1.7.4)
- 시각 없음 [체인·메뉴] **전체 메뉴 단일 정의**: `menuSections()` 하나로 워크벤치 아코디언과 사이드바 트리를 같이 그림. 구성 = quick.json 6그룹(서버·소스 (판 1.7.3)
  - 파일 1개: quick.json
- 시각 없음 [체인·메뉴] **모델 목록 복원**: 하단에 모델 드롭다운 재도입 — `기본(Claude Code /model·settings)` · Opus 5.5 · Fable 5.1 · (판 1.7.2)
- 시각 없음 [룰·hook] **실행창 자동승인**: 기본 Claude 모드를 `bypassPermissions`(🔓 자동승인)로 변경 — 워크벤치(`-p` stream-json)에서 허용 (판 1.7.1)
  - 파일 1개: .claude/settings.json
- 시각 없음 [체인·메뉴] **원칙 재천명**: VibeManager 는 Claude Code 흉내 금지 — **Claude Code 공식 기능은 그대로 통과시키고**, 신규화면 개발용 하 (판 1.7.0)
  - 파일 2개: quick.json, steps.json
- 시각 없음 [체인·메뉴] **사이드바 Prompt 뷰 제거 → 워크벤치가 첫 화면**: `vibeManager.prompt` WebviewView 등록 삭제. 활성화 시 `vibeMana (판 1.6.0)
  - 파일 2개: tools/DbConn/list_asis_programs.py, quick.json
- 시각 없음 [Workbench] **패널 탭 아이콘**: 에디터 탭에 Vibe_Manager 로고(vibe.svg/vibe-color.svg) 표시 — 테마 라이트/다크 대응 (판 1.5.0)
  - 파일 2개: vibe.svg/vibe-color.svg, quick.json
- 시각 없음 [체인·메뉴] 왼쪽 하단에 **새 화면** 버튼 추가(사이드바 프롬프트 패널 · 워크벤치 양쪽) — 클릭 시 화면ID 입력창(형식 검증 DMF0052/SCP0096 등) → w (판 1.4.2)
- 시각 없음 [Git] 터미널 완전 제거: 사이드바 프롬프트/빠른 실행은 워크벤치로 전달, git 업로드·병합도 패널 스트리밍(GIT_TERMINAL_PROMPT=0), "터미널에서 열 (판 1.4.1)
  - 파일 1개: vibe.svg
- 시각 없음 [Workbench] **워크벤치**(vibeManager.openWorkbench, 상태 표시줄 클릭): 에디터 한 장을 3분할 — 왼쪽 빠른 실행/단계 트리(+FLOW·이력 버튼) (판 1.4.0)
- 시각 없음 [Git] 빠른 실행 추가: 소스(업로드 leekc297/NSCM_NEW · 공통소스 가져오기/병합 eunjoo-hwang/nscm-fe · 상태), 분석·문서(AS-IS  (판 1.3.1)
  - 파일 2개: tools/Docs/md2xlsx.py, env.json
- 시각 없음 [체인·메뉴] **Claude 프롬프트 패널**(사이드바 최상단): 입력 → 전용 터미널 "Claude Code (Vibe)" 의 대화형 `claude` 에 그대로 전달(Cla (판 1.3.0)
  - 파일 2개: quick.json, .vibe/quick.json
- 시각 없음 [룰·hook] 룰 이관: `tools/VibeManager/rules/` 신설 — `00_ENV.md`+`env.json`(환경 단일 출처), `10_RULES_KEEP.md` (판 1.2.2)
  - 파일 7개: 00_ENV.md, env.json, 10_RULES_KEEP.md, 20_RULES_SKIP.md, 30_HOOK_DISPOSITION.csv, check.js, check-pkg.js
- 시각 없음 [VM 기타] S5: 등록 되돌리기(`<ID>_revert.sql` 미리보기/커밋), 파이프라인 `--regen-pkg`(이식된 PKG 보존이 기본이 됨) (판 1.2.1)
  - 파일 2개: _revert.sql, probe-accounts.js

## 2026-10-16

변경 3

- 시각 없음 [VM 기타] **완료 정의(DoD) 패널** 신설: 현재 화면의 DOD.md(B01~B21 ✅/❌), FE 게이트 BLOCK/WARN(클릭 → 파일:라인), PKG 게이트,  (판 1.2.0)
  - 파일 3개: DOD.md, pipeline.js, framework.js
- 시각 없음 [문서 생성] 작업 종류 `python` / `cmd` 추가 (설정 `vibeManager.pythonCommand`) (판 1.1.0)
  - 파일 7개: probe.py, export_tobe_meta.py, dbconn.json, tools/DbConn/dbconn.json, recon.js, repair-loop.js, check.js
- 시각 없음 [CheckList 엔진] 2026-10-16 (판 1.0.0)

## 2026-08-07

룰 변경 1

- 룰 변경: : SYS0017 재작업 13건 근본원인 감사 — 문서 부재 0건, 원인=이행 게이트 부재·메타 값 미검증·규약 미인지·런타임 검증 0. 게이트 6건 보강+수평 결함 수정 착수 (상세: <긴 문자열>.md)

## 2026-07-24

룰 변경 1

- 룰 변경: : 룰 #118 신설(mssql-ci-collation-parity — MSSQL 암묵 등가 상실 2형: CI collation 리터럴 미매칭[VMI DELETE·MAKE_CUST_FCST 'Customer Fcst'→"└ EXCEL만 표시" 사고, fix=UPPER IN+전 오브젝트 sweep·주석 오탐 금지] + '.0' 표기 사문 REPLACE[Div

## 2026-07-23

룰 변경 1

- 룰 변경: : 룰 3종 신설(#115 titleset-cache-immunization — DMF0003 DEPT_ID/MEASURE 캐시 오염 3층 면역[SP MF_BASE whitelist+모달 columnType='C'/dedup/selectableOnly+메타 정정, 검증=회귀 해시+오염주입 IMMUNE] / #116 sp-parallel-dml-txn-gua

## 2026-07-21

룰 변경 1

- 룰 변경: : ROUTE_PATH 전환(route-paths.ts 폐기·BE무컴파일)+클라우드 Router(viewRegistry 아키텍처) 로컬 보완 / 배분 공통 룰 확정(@shared/bucket-distribution, DMF0021 저장태그 규약 교정+월→주 / DMF0082 5갭 / DMF0003 월요일 폴백·AS체크박스 비표시) / 이관 3종 재취합(GT

## 2026-07-20

룰 변경 10

- 룰 변경: (1) docs(UI분석서): hook #105 확장 최종 — UI분석서=10시트(전체흐름[§1-B: DM 6단계+위치★+PKG·SP/테이블(META 5분류)/Measure 저장대상]+제약매트릭스 내부구조) · 단위테스트 시트 전면 제외 · 이전소스_차이점(GSCM_20260512↔GSCM diff, 없으면 "변경분 없음"+판정법: 도구 재생성 vs 실변경
- 룰 변경: (2) feat(UI분석서 6본): DMF0003 v2.1(정본)/DMF0082 v2.3/DMF0021 v2.1/DMF0042 v2.0/DMF0044 v2.1/DMF0049 v1.0(신규 — MSG00096 클라 그룹 게이트+EDIT_FLAG 비대칭·SHEET_MEASURE 3·배선 0행·원본 결함 3건 실측·diff 변경분 없음) + 선행 산출물 MD 1
- 룰 변경: (3) chore(DB): 사내 Oracle IP 100.65.143.121(Tailscale) 왕복 후 121.162.245.167 원복 — Tailscale 2521 불통은 서버측(ol9-db) firewalld/리스너 원인 진단(서버 조치 대기)
- 룰 변경: (4) feat(DMF0003): AS-IS 최신 결재 2건(E20260402 AS개선/E20260604 기준수요) TO-BE 반영 — FE 9건(SCP 차단 MSG00096·시간창 게이트 2종·AS FROM SITE MSG00113/00476·FCST_TYPE W/S 콤보 스왑·SAVE authority·spreadTitle LOAD 분기·Measure 
- 룰 변경: (5) fix(DMF0003): 조회 UX 3건 + 룰 3건 명문화 — ① 최초 조회 시 Sum 체크박스 false 인데 SUM 컬럼 노출 → mainDynamicColumns leaf config visible 을 표시 규칙(활성=true/상위합계=sumYn/드릴=false)으로 명시(imperative effect 는 runtime 토글 계속 담당) ②
- 룰 변경: (6) feat(DMF0003): 클라우드 전체 이관 패키지 재취합 — _deploy_packages/DMF0003_20260720_1625/ (fe 25파일 전체 + sql 7[메타 863행 전수 MERGE: MNU/API24/BTN24/PROC212/COLUMNS96/MEASURE47/권한75/CMBO27/MSG75/LOOKUP282] + sp 26[s
- 룰 변경: (7) refactor(DMF0003): 저장 SP PKG 병합 (UI별 PKG 원칙, 사용자 명시) — standalone DMF0003_SAVE_MKT_FCST → PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST 멤버(본문 무수정 헤더만 멤버화+END 라벨 교정, p_authority 16 반영본). 사내 PKG body VALID(al
- 룰 변경: (8) fix(DMF0003): titleSet 저장 권한 AS-IS 파리티 정정 + 관리자 판정 조회범위 규명 — 사용자 실측 지적(DM Planner AS-IS 저장 정상). 근원: SP SCM0002_SET_TITLESET_POPUP·팝업 그룹 게이트 없음(p_user_id 개인 저장, 권한 무관) → "ADMIN/DM ADMIN/DM Viewer"는
- 룰 변경: (9) fix(DMF0003): W/S 편집모드 MSG00113 "필수 입력 컬럼이 없습니다" 근본 해소 — EditButton 필수 Column Check(.cs L891~) 에서 사업부 필수컬럼 부재 시 차단인데, AS-IS 는 PROJECT_CODE·PLANT_SITE_ID·AS_FROM_SITE 가 VISIBLE='Y'(사용자 확인)인데 TO-BE 
- 룰 변경: (10) docs(DMF0003 UI분석서 v2.3): 사용자 지시로 관리자 판정 기능·ADMIN titleSet 저장 기능 전용 행 제거 — MATRIX_권한 관리자판정/VALIDATION취합 관리자판정/전체흐름 titleSet SP·TITLESET_USER 테이블/SP_LOOKUP GET_ADMIN_GROUP 행 삭제(머지 해제 후). SP-동작 서술 

## 2026-07-15

룰 변경 9

- 룰 변경: (1) feat(DMF0021): Sales Plan 신규 화면 개발 — FE 21파일 4,167줄(sales-plan/ — forecast-price 골격+mkt-fcst 그리드 계열, editLock 112→R1~R6 엔진, validation 141 분류, __asis-mapping__ 38/120/141 전행 체크오프) + 배선 4점 + 사내 메타 
- 룰 변경: (2) fix(DMF0021): E2E 1차 회신 3건 — ① No 코너 헤더 가로/세로 단일 머지(hook #108 — HierarchicalMergeManager TopLeft 케이스 추가) ② 편집권한 미표시 근본원인 = TO-BE 세션에 권한그룹 전 계층 부재(session.groupId 유령 필드 — mkt-fcst/forecast-price 계보
- 룰 변경: (3) fix(DMF0021)+rule: Grid Column 표시 정비 — hook #113 ui-category-division-direct-compare 신설(사용자 명시: 하드코딩/화이트리스트/attr1·3 우회 금지, DIVISION_ID=PR_GET_SHEET_COLUMN_LIST 서버 직접 비교[실측 40=46/81=32/''=62행]). ME
- 룰 변경: (4) fix(DMF0021): 편집권한 미동작 근본원인 2단 해소 — ① P_USERINFO 그룹(CMBO SalesPlanUserAuthGroup, BE 경유 ADMIN 선두 검증) ② DATAEX·SPREAD_TITLE의 숨김 필수 컬럼 조건 DEFAULT_FLAG=''(Oracle ''=NULL 항상 거짓, 부록C 함정)→NVL(,'N')<>'Y' 
- 룰 변경: (5) verify(DMF0021): 82 편집 기준 실측 확정 — 82 편집 measure=SalesAmt_LOC만(RTF는 82 권한그룹 미등재·editAuth N). 기타매출 원천=DM_PLN_SALES_ETC_PLAN(ITEM_ID='ETC' 특수행, 마스터 미존재→파생 ①경로 N_)이며 82 데이터는 과거 1건+9/21~12/1 4건뿐 → 7월 조
- 룰 변경: (6) fix(DMF0021): 40 RTF_SYS_RP 편집불가 — authGroup 콤보 도착 전 Search/persist filters 재사용 시 userGroup=사용자ID 조회로 editAuth='N' 응답 잔존하는 race → 그룹 확정 시 setFilter 재생성(새 queryKey 자동 재조회) 방어. 유의: RTF+Monthly 는 당월(
- 룰 변경: (7) diag(DMF0021): 40 노랑 0 최종 판정 — SQL_LOG 실측으로 사용자 브라우저 호출의 P_USERINFO='<계정>'(옛 번들 실행) 확인 + authGroup 콤보 호출 0건 + vite 서빙 모듈에는 신규 코드 포함(1건 grep) = 브라우저 하드 리프레시 미수행이 원인. FE/SP/메타/권한 전 계층 검증 완료 상태
- 룰 변경: (8) feat(DMF0042): Business Plan 신규 화면 — 메타 P0a/P0b+P1~P6 사내 적용(MNU_URL=business-plan/MSG00675~680 18행/API 23/BTN 23/PROC_M 12본 116행[SAVE=PKG판]/TITLESET 'Biz Plan' 168/USER_GR 60/CMBO BizPlanUserAuthG
- 룰 변경: (9) fix(DMF0042): P0c — 빈 Project/Model/Owner 조회 전멸 신규 결함 (BE 스모크 실측: ''=NULL bind → FN_STRING_SPLIT(NULL)=0행 INNER JOIN 전멸 + CASE WHEN p IS NULL THEN p LIKE=UNKNOWN 2중. AS-IS MSSQL ''≠NULL 변환함정, hook

## 2026-07-14

룰 변경 9

- 룰 변경: docs(rules): 사용자 명시 룰 2건 반영 — ① **Figma=디자인 참조 only, 정책 판단 금지**(figma-layout-parity-mandatory **§1.5 신설** + screen-analysis-workbook-standard §0 경계 + RULESET_MASTER §3.1/§4·00_INDEX 동기 — 정책 소스=AS-IS 원
- 룰 변경: docs(DMF0003): spdMain 이벤트 3종(ComboSelChange L2311/Changed L2883~4330 1,448줄/CellClick L5451) 전량 정독 상세 분석 MD 생성 — Doc/화면설계서/DMF0003_spdMain_이벤트3종_상세분석.md (cascade 7분기/Validation 12종/신규행 중복 7·8키/일↔주↔월 
- 룰 변경: (2) docs(DMF0003): spdMain 이벤트 3종 **데이터 연계 Excel** 신규 — Doc/화면설계서/DMF0003_spdMain_이벤트3종_분석_v1.0.xlsx (6시트: 분기전수 38행[BR-*] × 데이터원천 19[DS-*] × MSG × **권한별 차이 10항목**[실측 USER_GR 16그룹·GET_ADMIN_GROUP 9행·'D
- 룰 변경: (3) fix(docs): DMF0020 편집제어 오기재 정정 (사용자 확정: **40·81·81_계열·EE계열 전체 편집불가 — 82만 편집**) — DM_분석_마인드맵.html(② 매트릭스 11행 flip + ③ DMF0020 페이지·트리·격차 서술 11곳) + DMF0020_SalesFuturePrice_UI분석서_**v1.0**.xlsx(시트9 ga
- 룰 변경: (4) docs(DMF0003): 이벤트 분석 한계 해소 — AS-IS DB(LGCE_SCMDEV) 직결로 UP_FX_GETCOMMONDATALIST_DM FCST_TYPE 분기 실측(그룹 분기='DM Planner (W/S)' 정확일치 단 1개: 일반 그룹=SALES_TYPE_CODE 12종[WS/WSF 는 ATTRIBUTE2='Y' 제외] / W-S 플
- 룰 변경: (5) docs(DMF0003): 이벤트 Excel 보강 — 시트6 FCST_TYPE 을 권한 매트릭스형(그룹 열×코드 행, O/-)으로 재구성 + 시트7 Measure 제약 실측 신설(§A 저장 시간창 권한×사업부[GET_ADMIN_GROUP_MEASURE 30행+SAVE SP E20260604-000994: SCP Planner=81 일요일/81_계열 
- 룰 변경: (6) docs(DMF0003): 이벤트 Excel 시트 순서 변경 — 4.AS_WS_효과 ↔ 5.권한별_차이 스왑(권한 계열 5·6·7 연속 배치) + 상호참조 15셀 정합. v1.0 잠금(열람 중)으로 **v1.1 승격 정본** (v1.0 은 잠금 해제 시 정리)
- 룰 변경: (7) docs(DMF0003): 이벤트 Excel(v1.1) 시트8 종속메저_실측 신설 — GET SP(DMF0003_GET_MKT_FCST_DATA 5,973줄) 실측: §A 선택→종속 삽입 규칙 전수(CUST_FCST→DM_MST_CUSTOMER_FCST 하위 동적 삽입[' └ ' SORT+0.1] / **82+MKT_FCST_RP→RTF_SYS_RP
- 룰 변경: (8) feat(DMF0082): Division 81/40 테이블 분기 사내 적용 — SP 4종(SAVE 36치환·V81-00~11 / PKG GET 11개소 / CURRENT 5개소 / 팝업 7개소) LIKE '81%' 시 DM_PLN_MKT_FCST·SCM_MST_FUTURE_PRICE 계열 분기(40 원문 무수정), 81 GET END_CUSTOME

## 2026-07-13

룰 변경 2

- 룰 변경: docs(rules): DMF0082 조회/SavePrice 최적화 룰 승격 — hook #110 sp-multiselect-filter-and-conversion-pitfalls(멀티선택 GTT+skip + SP변환 3대 폭발/오정합) + #111 <긴 문자열>(상관→set-based MERGE/GROUP BY·V$SQL 진단·라이브 재배포 락운영·GTT
- 룰 변경: (2) docs(rules): 조회조건 룰 신설 — 원천 `Doc/SCP_DM_화면별 조회조건 정리_260122_v0.4.xlsx` List 시트 953행/99화면 **전수** MD 변환(`_rules_v2/_mapping/search_conditions_scp_dm.md`, 카운트 1:1 검증) + 신규 hook **#112 search-condition

## 2026-07-09

룰 변경 6

- 룰 변경: feat(SYS0013): FE 전면 재개발(16→15파일, EditTracker/useProcMutation 표준 수렴) + PKG_SYS0013 통합(멤버 10→15, SAVE 3종 _H 이력 보강) + 격차 2종(Validate 사전검증·EXECUTE_HIST) + 메타 배선(API_M/PROC_M data키/BTN/CMBO 2/MSG 2) — 상세:
- 룰 변경: fix(DMF0008): Status Update ORA-30926 — PR_DM_DNM_EDI_CALLOFF_STATUS Sales Site MERGE dedup(최종 수정분 채택, 사용자 확정) 사내 적용 + 클라우드 이관 패키지 v3 (_dmf0008_status_refetch_20260709_artifacts)
- 룰 변경: fix(DMF0008): 클라우드 Status Update 3중 원인 해결 확인 — SP dedup v2 + API_M 오배선 정정(STATUS_UPDATE→조회SP 연결돼 성공토스트+무동작). 패키지 05 스크립트
- 룰 변경: docs(ui_analysis_meet): 회의록 2건(0707/0709) → 화면별 분석참고 MD 4건+README 추출 (DMF0003/DMF0082/DMF0021/COMMON — 단락 전수 9+14, DMF0082 LOOKUP 확장 방침 40→40·81·81_ 반영)
- 룰 변경: docs(ui_analysis_meet): DM 프로세스 정리 PPT(35슬라이드) → DM_프로세스정리_rev1.0_참고.md 전수 추출 (run 1,877 대사 PASS, SP 인벤토리 46건, 메저 정의표 포함)
- 룰 변경: docs(DMF0003): 분기·종속 인터랙티브 마인드맵 HTML 생성 (Doc/화면설계서/DMF0003_분기종속_마인드맵.html) — 전체프로세스 흐름+화면슬롯 프레임 + 4대분기축(Division/권한/FCST_TYPE/메저) + 권한별 FCST_TYPE(W/S→SALES_TYPE_CODE2) + 권한×메저×시간(GET_ADMIN_GROUP_MEASU

## 2026-07-08

룰 변경 1

- 룰 변경: : hook #108 `ui-grid-corner-no-header`(No. 코너 가로/세로 머지+라벨 공통 표준 — 사용자 지정 + 커스텀 MergeManager 시 동적 1단 수동 머지) + #109 `oracle-nls-implicit-conversion`(세션 NLS 암묵 형변환 — DMF0014 클라우드 저장 -9994 근본원인) 신설. 부록 C-

## 2026-07-03

룰 변경 4

- 룰 변경: : DMF0003 PSI 고객수요분석 영역 구현 — SP 시트명 소문자 교정('psi'/'carFcst') + 변환결함 7건 fix(SSCM_MGR/NEXT_DAY NLS/'#,#'/GTT NCLOB) + API_M 9·PROC_M 68·BTN_MPG 36 배선 + FE 4신규(<긴 문자열>). 패키지 DMF0003_PSI_20260703. 상세: work
- 룰 변경: (2): DMF0020 조회 SP 튜닝 — 실측 규명(V$SQL 문장별 귀속: 가설 분할FUNCTION 아님) + 변환결함 3건 fix(over_range ORA-12899 컬럼뒤섞임·ORA-00923 AS ROWNUM·Template 주석조인 86s→0.4s) + GROUP_ID MERGE(52.8만행)→INSERT 선계산. 회귀 8시나리오 dump di
- 룰 변경: (3): DMF0003 평문 AS-IS 정합 — PSI 패널 제거(사용자 결정)+Color 체크박스 제거(false 경로 1:1)+우클릭 PR 4기능 복구(PROC_M/API_M 0행+SP 결함 4건: 대소문자/커서 미오픈/ORA-22950/INVALID)+FE 격차 8건+콤보 메타 기반·cascade·Model 아이콘·자동입력('S'). 신규 LBL 채번
- 룰 변경: (3): DMF0003 오후 세션 룰 승격 — 신규 hook 4(#102 custom-context-menu-standard 우클릭 dismiss 레이스 / #103 pivot-header-drilldown SUM 헤더 드릴 / #104 sp-side-effect-test-gate 저장 SP 테스트 게이트 / #105 screen-analysis-workb
