# VMO 컨설팅 검토 2026-11-26 18:03:19

VMO 자가진단과 자동 반영은 돌고 있음(S14 7일 개입 270건 중 맞음 258건, 오판 0건, 11-26 17:42). 한 저장소를 여러 세션이 함께 고치면서 시험 전체 실행이 흔들리고 같은 파일 편집이 겹친 기록이 11-26 하루 4건임. 차주 UI/DB MODE 로 바꾸면 FE 소스 안이 자동 반영되는데 반영 게이트는 VM 시험만 돌리고, 작업 모드 전환 기록도 없어 전환 뒤 효과를 잴 기준일이 없음.

## 현황 진단
| 영역 | 판단 | 근거 |
|---|---|---|
| 파싱 | 강점 | 폼 저장형 시나리오 범위 원장 tools/Harness/rules/form_scen_scope.csv 31화면 확정. 전 화면 미리보기 결과 폼 저장 38화면, 활성 69건, 보류 0건, 측정 보류 0건(CHANGELOG.md:30~31, 17:29:08) |
| 분석 | 약점 | 대조표에 구현 위치 열이 없어 기계 판정을 못 하는 행이 미검증 290행(11화면)과 판정필요 100행(10화면). 제외 사유 서술이 빠진 행 117행(9화면). checker_scan.json 11-26 16:04 clusters X-LOC, X-REASON 기준. 같은 유형 783행은 '대조표 서술 보강 = 문서 작성 대상'으로 무시 목록에 있음(checker_scan_ignore.csv) |
| UI 개발 | 위험 | UI/DB MODE 에서는 nscm-fe, nscm-be 대상 개선안이 자동 반영됨(orch-selfcheck.js:613, 621). 반영 게이트는 구문 검사, VM 시험, 정의 정합, 문장 규칙만 봄(orch-selfcheck.js:483~510). 화면 게이트 tools/Harness/check.js 는 세션 종료 hook 에서만 돌고 VMO 반영 게이트와는 연결되지 않음. 생성기 자체 시험 GEN_SMOKE 는 engine_selfcheck 에 등록됨(engine_selfcheck.py:15, 176) |
| DB 개발 | 약점 | SP 결과 대조(tools/DbConn/golden.py cols.csv → judge)를 실행하지 못한 행 104행(19화면). checker_scan.json 16:04 A7 ERROR 묶음 기준 |
| 보완 | 약점 | S13 U21 24시간 반영 실패 6건(마지막 11-26 13:04 20261125005937_SELF). 11-24 이후 개선안 history 의 '반영 실패' 기록 23건 중 문장 규칙 게이트 언급 4건(18:0x proposals 집계). 실패 사유 중 orch-ladder.js 고정 문구의 가운뎃점 나열이 2회 되풀이됨(20261124064957_SELF_3, 20261125005937_SELF) |
| 시험 | 약점 | S2 11-26 17:37 98파일 중 97 통과, t_run_end.js 1건 FAIL(orch-agent.js:354 예외). 같은 분에 저장소 orch-agent.js 가 수정됨(S3 상세: 저장소 2026-11-26T17:37). CHANGELOG.md:7 17:45 run_all 실행 때 t_om_job.js, t_lk_job.js 실패, 단독 실행 때 ALL PASS, 원인 미확인. run_all.js:12~21 은 실행 중 소스가 바뀌었는지 기록하지 않음. 이번 검토의 단독 재실행은 권한 확인 단계에서 막혀 미실행 |
| CheckList | 위험 | 효력 2026-11-23 15:58 뒤 CheckList 체인 6건의 1판 소요 114분, 84분, 80분, 94분, 1판 없음 2건(CHANGELOG.md:12). 목표 30분(harness.json:48). 미검증 묶음 1위 D1 '조회 후 Insert 했으나 신규행 없음' 687행(SSP0015, SSP0021, SSP0023, SSP0060). 시간 목적 L4 안은 이미 진행 중이라 이번에 새 안 없음 |
| VMO | 약점 | S6 미확인 추적 open 572건, confirmed 0건, dropped 0건. 이 중 창 다시 로드가 필요한 항목 391건, 그 뒤 창 로드 기록이 있는 항목 374건(result.json 17:42). s6 는 앞 60건만 나열하고 묶음 요약이 없음(orch-selfcheck.js:236). 반영 지시문 승인 목록(orch-improve.js:44 'DB 객체, 룰 문서, 시험 계정 설정, 코드 파일 삭제 = 사용자 승인')이 실제 기준(autoApplyAll true, harness.json:50, orch-selfcheck.js:609~615: 예외 = 저장소 밖, .claude/settings, 실행 hook, 작업 모드, AS-IS 소스, DB MODE 의 FE·BE)과 다름 |
| UI/UX | 약점 | 웹뷰 색은 var(--vscode-*) 에 대체값을 두는 방식(orchestra.js:29, 60). 고정색 #e8833a, #1b1b1b 이 남아 있음(orchestra.js:198, 207, 216). history.js 는 aria/role/tabindex 1건이고 @media 는 0건이라 좁은 폭, 키보드 대응은 미확인. 미확인 항목 572건을 요약 없이 60건씩 보여 줘 요약을 먼저 보여 주는 관행과 맞지 않음 |
| 운영 | 위험 | 여러 세션이 같은 파일을 함께 고침. S9 7일 변경 workbench.js 57건(세션 수정 435건), orchestra.js 29건, quick.json 26건(17:16 수집). 11-26 하루에 '다른 세션이 같은 파일 수정 중' 기록 4건(CHANGELOG.md:7, 16, 26, 32). claim_proposal.js:18~25 는 개선안 단위로만 맡고 대상 파일이 겹치는지 보지 않음. BE 로컬 로그 nscm-be/logs/nscm.log 31.9GB, BE 로그 합계 120.6GB(S10 11-25 23:09). logback 설정 변경은 사용자 승인 대상 |

## 개선 로드맵
| 시점 | 항목 | 이유 | 효과 측정 |
|---|---|---|---|
| 지금 | 시험 전체 실행 중 소스가 바뀐 실패를 따로 표시하고 그 파일만 단독으로 1회 다시 실행 | run_all 실패가 단독 실행에서 통과로 바뀐 기록 3건(CHANGELOG.md:7 2건, S6 t_orch_agent.js 16:58 1건)과 17:37 S2 실패 1건이 다른 세션 편집 시각과 겹침. 게이트가 거짓 실패로 반영을 막는지 구분할 자료가 없음 | run_all RESULT 의 changedDuring, rerun 건수. S2 fail 중 rerun 통과 비율(selfcheck history.jsonl). 반영 실패 history 중 시험 실패 사유 건수 |
| 지금 | 세션이 개선안을 맡을 때 다른 세션이 맡은 안과 대상 파일이 겹치면 경고하고 기록 | 11-26 하루에 같은 파일 편집 겹침 기록 4건. 겹친 편집은 시험 결과와 반영 결과를 흔듦 | claim_proposal 겹침 경고 건수(proposal history '대상 파일 겹침'). CHANGELOG 의 '다른 세션' 언급 일별 건수 |
| 지금 | 미확인 추적(S6)을 종류와 경과일로 묶어 요약을 먼저 보여 줌 | open 572건, 닫힌 건 0건. 사람이 어디부터 확인할지 판단할 자료가 없음 | S6 info.groups 종류별 건수, confirmed+dropped 일별 증가 건수 |
| 지금 | 반영 지시문(IMPACT_RULE)의 승인 목록을 autoEligible 실제 기준에서 만들어 씀 | 지시문은 DB 객체, 룰 문서, 시험 계정 설정, 코드 파일 삭제를 승인 대상이라고 적지만 autoApplyAll 기준에서는 자동 반영됨. AI 가 안을 보류하거나 plain 에 틀린 안내를 씀 | claim_proposal hold 사유 중 승인 대상 오판 건수, 시험 t_impact_rule.js 결과 |
| 다음 | 작업 모드 전환을 events.jsonl 에 기록하고 전환 전 점검(기준선 시각, 생성기 자체 시험 결과)을 출력 | events.jsonl 에 scope 기록 0건(18:0x 확인). UI/DB MODE 전환일부터 자동 반영과 되돌림을 셀 기준 시각이 없음 | events.jsonl type scope.change 줄. 전환일부터 7일 동안 nscm-fe, nscm-be 대상 개선안의 applied, reverted 건수 |
| 다음 | UI/DB MODE 에서 FE 화면 폴더를 고치는 개선안의 반영 게이트에 화면 게이트(check.js, 타입 검사와 린트 제외) 연결 | FE 안이 자동 반영되는데 게이트가 VM 시험만 봄. 타입 검사, 린트 자동 실행 금지 지시(2026-09-02)는 유지 | 게이트 text 의 G-FE BLOCK 건수, 반영 뒤 세션 종료 게이트(harness-stop-gate) 실패 건수 |
| 다음 | 대조표 구현 위치 열과 제외 사유 서술 보강(문서 작성 대상) | X-LOC 390행, X-REASON 117행이 기계 판정 밖에 있음 | checker_scan.json clusters X-LOC, X-REASON rows 값 |
| 나중 | workbench.js 를 기능 단위 모듈로 나눔 | 7일 변경 57건, 세션 수정 435건으로 한 파일에 편집이 몰려 겹침과 거짓 실패의 원인이 됨 | S9 workbench.js 7일 변경 건수, claim 겹침 경고 중 workbench.js 비율 |
| 나중 | BE 로컬 파일 로그 수준과 보관 일수 조정(사용자 승인 대상, UI/DB MODE 때 BE 설정 변경) | nscm.log 31.9GB, BE 로그 합계 120.6GB. VM 서버 출력 로그 교체는 반영됐지만 BE 자체 파일 로그는 그대로임 | S10 beLogsGB, beBigFiles |

## 이번에 올린 개선안
1. VM 시험 전체 실행 중 소스가 바뀐 실패 파일만 단독 1회 다시 실행하고 결과를 따로 표시 (20261126180319_VISION) · core · 대상 tools/VibeManager/test/run_all.js, tools/VibeManager/test/t_run_all_changed.js
2. 개선안을 맡을 때 다른 세션이 맡은 안과 대상 파일이 겹치면 경고하고 개선안 이력에 남김 (20261126180320_VISION) · fix · 대상 tools/VibeManager/claim_proposal.js, tools/VibeManager/test/t_claim_overlap.js
3. 자가진단 미확인 추적(S6)을 종류와 경과일로 묶어 요약을 먼저 보여 줌 (20261126180321_VISION) · fix · 대상 tools/VibeManager/orch-selfcheck.js, tools/VibeManager/test/t_s6_group.js
4. 반영 지시문(IMPACT_RULE)의 사용자 승인 목록을 실제 자동 반영 기준에서 만들어 씀 (20261126180321_VISION_2) · fix · 대상 tools/VibeManager/orch-selfcheck.js, tools/VibeManager/orch-improve.js, tools/VibeManager/test/t_impact_rule.js
5. 작업 모드 전환 도구(set_scope.py)가 전환 기록을 events.jsonl 에 남기고 UI/DB MODE 전환 전 점검 결과를 출력 (20261126180322_VISION) · fix · 대상 tools/Harness/verify/set_scope.py
6. UI/DB MODE 에서 FE 화면 폴더를 고치는 개선안의 반영 게이트에 화면 게이트(check.js, 타입 검사와 린트 제외) 추가 (20261126180323_VISION) · core · 대상 tools/VibeManager/orch-selfcheck.js, tools/VibeManager/test/t_gate_fe_page.js
