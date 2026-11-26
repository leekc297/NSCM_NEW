# 개념 재정립: VM 고정 문구 문장 규칙 2차(쓰기 경로 전체 검사와 효력 뒤 판정)

## 목적(사용자 원문)

- 2026-11-13 17:3x(memory/feedback_sentence_rule_3_20261113.md): "VM 의 문서(CHECKLIST, 화면분석서, 화면설계서... 모든 EXCEL 문서) 생성 시 설명과 문장에서 아래의 RULE 을 반드시 지키도록 — 1. 수식어 쓰지마 2. 문맥으로 아는 주어는 빼줘 3. 번역투는 빼 줘"
- 같은 날 이어서: "이 3가지 문장을 VM 과 함께 내가 사용하는 클로드의 모든 문장생성에 적용"
- 2026-11-13 18:0x 규칙 4~18 추가: "적용해주세요 · 클로드코드와 VM 전체"
- 같은 메모리 How to apply: "생성기(make_verify_docs · plain_detail · make_test_report · asis_live_doc · make_docs · make_testcases · md2xlsx)에 문장을 새로 넣거나 고치면 그 소스를 검사기에 넣어 위반 0 확인."
- ~/.claude/CLAUDE.md 끝 문단: "원문 인용(라벨·메시지·코드)은 고치지 않는다."

## 지금 개념

1차 재정립 개선안 20261123000643_VISION 이 2026-11-23 19:12 반영됨(CHANGELOG.md 해당 절). 그 뒤 개념은 아래와 같음.

- 대상: VM .js 문자열 중 문장 분류만 셈. 줄 머리 표지와 메뉴 이름 인용은 doc_style.py 가 뺌.
- 차단 방법: VMO 개선안 반영 전후로 위반 수를 비교함(orch-selfcheck.js:394-423, harness.json orch.styleGate true).
- 빠진 경로: Claude Code 세션이 쓴 직후 검사는 hook 등록에서 빠짐. 근거는 selfcheck S13 의 20261123181708_SELF 'hook 등록 제외' 기록과, .claude/settings.json 에 doc_style 항목이 없다는 점임.
- 목적 판정: Overall Review 가 remain(잔량)과 newSum7d(7일 안 점검 사이 증가 합)로 판정함(orch-vision.js:54-76).
- 진단 사다리: 목적 어긋남 연속을 vision 판정 이력만으로 셈(orch-ladder.js:99-100). 반영된 L4 안의 효력 시각을 보지 않음. 구조 묶음은 효력 뒤 근거만 셈(orch-ladder.js:108-121).

한 문장으로 쓰면, 문장 규칙을 지키게 하려고 VMO 가 반영하는 코드만 쓰는 시점에 막고, 목적 판정은 효력 전후를 나누지 않고 셈.

## 어긋난 근거

| 사례 | 근거 | L3 조치 | 그 뒤 |
|---|---|---|---|
| 1차 반영 직후 위반 0건 | proposals/20261123000643_VISION.json 확인 3: 반영 전 workbench.js 119건, 반영 뒤 36개 파일 위반 0, exit 0 | 1차 재정립 반영(11-23 19:12) | 11-24 23:28 S11 위반 3건(selfcheck/result.json checks.S11, files 36) |
| workbench.js L602 'Vibe_Manager ☁️ 클라우드 이관 패키지:', L745 '☁️ 탐색기 이동:' 기호 2건 | workbench.js.bak_20261124_cloudreveal(11-24 11:58)에는 0건, bak_20261124_replay(21:14)에는 1건씩 있음. 같은 시간대 수정 = CHANGELOG.md:94(11-24 12:04 클라우드 이관 README), :28(21:20 이관 목록 링크), 둘 다 사용자 지시로 Claude Code 세션이 고침 | styleGate(VMO 반영 경로만) | 게이트를 거치지 않고 들어옴 |
| orch-usercheck.js L705 수식어 '실제로' 1건 | orch-usercheck.js.bak_20261124_ccwork(08:54)에는 0건, 지금 파일(08:56)에는 1건. CHANGELOG.md:197(11-24 09:01 Claude Code 작업 이력 학습) | 같음 | 같음 |
| 같은 목적 L4 가 효력 전 판정으로 다시 열림 | ladder.json L4\|purpose\|VM고정문구가문장규칙을지킴 evidence 4건(11-20 11:58, 11-21 12:03, 11-22 14:05, 11-23 14:54)이 모두 1차 반영(11-23 19:12) 전임. lastSeenAt 11-25 00:00:36, status open. vision/meta.json lastAt 11-23 14:54이고 그 뒤 Overall Review 없음 | 20261123000946_VISION(효력 뒤 근거만 셈)은 struct 묶음에만 적용됨(orch-ladder.js:108-121) | 1차 반영 뒤 이 목적 L4 재진단 1회 발생(이번) |
| 1차 안이 전환 원장 밖에 있음 | vision/plans.json 원장은 20261124000718_VISION 1건(keys vmoCadence, 원장 생성 11-24 09:29)뿐임. 20261123000643 은 원장 생성 전에 반영됨 | 없음 | '같은 축 L4 재진단 중지' 대상이 아님. 1차 안 단계 4('다음 Overall Review 판정') 확인을 추적하지 않음 |

## 대안 개념

### A 쓰기 경로 전체를 쓰는 시점에 검사하고, 새어 든 위반은 L1 로 정리하고, 효력 뒤 판정만 셈

- 쓰기 경로 2개에서 검사함.
  - VMO 반영: styleGate 를 유지함.
  - Claude Code 세션: Write, Edit 대상이 tools/VibeManager/*.js 이면 쓴 직후 hook 이 doc_style.py 로 그 파일만 검사함. 반영 전보다 위반이 늘면 줄 번호와 고치는 법을 출력하고, 같은 세션이 그 자리에서 고침.
- hook 이 없는 경로(편집기에서 사람이 고침)는 S11 점검이 기준선보다 늘어난 위반을 L1 정리 개선안(fix, 자동 반영)으로 올림. 하루 주기로 파일마다 정리하던 방식을 새로 생긴 건만 정리하는 방식으로 바꿈.
- 목적 판정은 '효력 뒤 Overall Review 시점 잔량 0건, 새어 든 위반은 24시간 안에 정리됨'으로 바꿈.
- 진단 사다리: 목적 L4 안이 반영되면 효력 시각 전 판정은 연속에서 뺌. 반영된 L4 안은 plans.json 원장에 넣음.
- 목적 충족: 원문이 정한 범위 '클로드코드와 VM 전체'가 쓰기 경로 2개와 맞음.
- 어긋난 사례가 A 에서는: ☁️ 2건과 '실제로' 1건은 쓴 세션에서 hook 출력을 보고 고치거나, 다음 S11 점검(24시간 주기)의 L1 정리로 닫힘. 이번 재진단은 효력 전 판정 4건이 빠져 열리지 않음.
- 새로 할 일: hook 스크립트 1개와 .claude/settings.json 등록, orch-selfcheck.js S11 신규분 L1 정리, orch-ladder.js 목적 묶음 효력 필터, orch-vision.js 판정 기준 문구, plans.json 원장 편입.
- 버리는 것: newSum7d(7일 증가 합) 판정. 사람 경로에서 들어온 위반 1건이 7일 동안 어긋남을 만듦.

### B 쓴 직후 차단

- hook 이 위반 증가를 찾으면 쓰기를 거부함(exit 2). 유입은 0건이 됨.
- 어긋난 사례: 3건은 들어오지 못함.
- 위험: 분류가 틀리면 사용자가 시킨 작업이 막힘. 표지 문구를 고치다 반영 실패한 기록이 2건 있음(20261119232523_SELF, 20261119232524_SELF_3). 사람 경로는 B 로도 막지 못함.
- 버리는 것: 없음.

### C 지금 개념 유지, 진단 사다리만 고침

- 효력 필터만 넣음. 다음 Overall Review 에서 newSum7d 가 3이 되어 어긋남이 다시 쌓이고, 3회 뒤 L4 가 다시 열림. 유입 경로는 그대로 남음.

## 권장안과 이유

A 를 권장함.

- 반영 직후 0건에서 3건으로 늘어난 3건 모두 VMO 반영 밖 경로(Claude Code 세션, 11-24 08:54~08:56, 11:58~21:14)로 들어옴. 쓰는 시점 검사가 VMO 반영 한 경로에만 있는 것이 원인임.
- B 는 유입을 막지만 분류 오류 때 사용자 작업을 멈춤. 사람 경로가 남아 판정 0건을 보장하지도 못함.
- C 는 유입 경로를 그대로 둠.
- 진단 사다리 효력 필터는 A, C 공통으로 필요함. 효력 전 판정 4건으로 묶음이 열린 사례가 이번에 측정됨.

## 전환(바뀌는 것 · 버리는 것 · 단계 · 확인 · 위험 · 되돌리기)

- 바뀌는 파일: tools/VibeManager/orch-ladder.js(99-100 목적 묶음 효력 필터), orch-selfcheck.js(S11 신규분 L1 정리 개선안), orch-vision.js(54-76 판정 수치와 문구), .vibe/orch/vision/plans.json(20261123000643 편입), test/t_orch_ladder.js, t_orch_selfcheck.js. 승인 대상: 새 실행 hook 스크립트(.claude/hooks), .claude/settings.json 등록.
- 버리는 것: newSum7d 판정, S11 파일별 하루 주기 전체 정리 흐름.
- 단계 1(사다리): 목적 묶음 연속 계산에서 같은 목적 키의 반영 L4 안 효력 시각 전 판정을 뺌. 1차 안을 plans.json 에 넣음. 확인 = 시험 '반영 L4 효력 전 판정 4건 → 묶음 안 올림', '효력 뒤 어긋남 3건 → 올림' PASS. ladder.json 이 묶음을 resolved 또는 보류로 표시함.
- 단계 2(L1 정리): S11 점검이 이전 결과보다 늘어난 문장 위반을 fix 개선안으로 올림. 확인 = 지금 3건(workbench.js L602, L745, orch-usercheck.js L705)으로 정리 개선안 1건이 생기고, 반영 뒤 doc_style.py 위반 0, test/run_all.js PASS.
- 단계 3(hook, 승인): Write, Edit 뒤 tools/VibeManager/*.js 이면 그 파일 doc_style.py 전후 비교 결과를 출력함. 차단하지 않음. 확인 = '—' 를 넣은 Edit 1건에서 경고 출력, 위반 없는 Edit 에서는 출력 없음.
- 단계 4(판정): Overall Review 지시문을 '효력 뒤 잔량 0, 새어 든 위반 24시간 안 정리'로 바꿈. 확인 = 다음 Overall Review 의 이 목적 근거에 효력 시각, 잔량, 정리 소요 시간이 들어 있음.
- 위험: hook 출력이 세션 문맥을 늘림. 막는 법 = 위반이 늘었을 때만 출력함. L1 자동 정리가 원문 인용을 고칠 수 있음. 막는 법 = 이름 인용과 표지는 1차 분류 규칙(quick.json, steps.json 이름, JS_MARKERS)을 그대로 씀.
- 되돌리기: 단계마다 .bak_<날짜>_concept 백업과 개선안 탭 되돌리기를 씀. hook 은 settings.json 등록 줄을 삭제함. 효력 필터와 L1 정리는 harness.json orch 설정 키 하나로 끌 수 있게 둠.

## 반증

- 단계 3 뒤 7일 안에 24시간 넘게 남은 새 위반이 측정되면, hook 출력을 세션이 고치지 않는다는 뜻임. 그때 B 를 다시 봄.
- 새 위반의 출처 대부분이 Claude Code 와 VMO 밖(편집기 직접 수정)이면 hook 효과가 없음. 그때 L1 정리 주기를 줄이는 쪽을 봄.
- 효력 뒤 Overall Review 3회 연속으로 이 목적이 어긋남이면 이 재정립이 틀린 것임.

## 미확인

- 1차 안 효력 시각(반영 뒤 첫 창 로드): activations.jsonl 마지막 4건(11-24 19:45~21:49)만 확인함.
- 11-24, 11-25 Overall Review 미실행 원인: 메모리에 11-24 AI 주간 한도 94% 멈춤 기록이 있음. orch-vision.js 가 그 멈춤을 따르는지는 미확인. 지금 ai_usage.json 주간 pct 0.
- Claude Code 세션이 hook 출력을 보고 그 자리에서 고치는 비율: 미측정.
- 11-24 23:28 이후 S11 수치: 미측정. 측정 방법 = python tools/Docs/doc_style.py tools/VibeManager/*.js --out <임시 폴더> --quiet.