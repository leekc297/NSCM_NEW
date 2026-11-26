# 개념 재정립과 전환 계획: CheckList 재측정 단위(규칙 → 행)

작성 2026-11-23 15:06. 개선안 20261121120359_VISION(L4, 승인 2026-11-23 14:56). 실측 화면 SCP0028, 원장 `Doc/verify/SCP0028/verify_ledger.csv` 2026-11-21 01:55 판.

## 목적(사용자 원문)

- "CHECKLIST 는 10분에서 진짜 길어야 30분 내에 종료되어야 한다"
- "부분 재측정이 1차보다 시간이 더 많이 소요된 사유도 보완해주세요"(U25)

## 종전 개념

보완 회차마다 직전 FAIL, 판정필요, 미검증 행이 속한 규칙 전체와 그 규칙의 시험 전부를 다시 잼.

- `events.jsonl:2001` 부분 재측정 3회 196.6분(전체 309.5분의 63.5%)
- `delta_scope.json` 2026-11-21 01:01 미해결 79행이 규칙 13개, 대상 행 636행으로 넓어짐

## 새 개념

보완 회차마다 바뀐 검사기, 시험, 화면 소스가 판정하는 행과 미검증 행만, 그 행을 고르는 시험만 다시 잼. 나머지 행은 1차 결과를 둠.

- 미검증 = 원장 result 가 ERROR, NOT_RUN, 빈 값인 행
- FAIL, 판정필요 행은 그 행을 판정하는 검사기와 소스가 바뀌지 않았으면 1차 결과 유지(1차에서 둔 PASS 행과 같은 기준)
- 보완으로 바뀐 PROC, 메타, FE, 검사기, 시험 본문은 종전처럼 영향 규칙 전체를 다시 잼

## 반영한 것(2026-11-23)

### tools/Harness/verify/delta_scope.py
- `code_rules`: 범위에 넣는 직전 행을 미검증 행으로 줄임. 사유 문구에 유지하는 FAIL, 판정필요 행 수 표시
- 결과 `delta_scope.json` 에 unit(row), whole_rules, rows_by_rule 추가
  - whole_rules = 바뀐 시험, 검사기, 화면 소스가 판정하는 규칙. 그 규칙 행 전부가 대상
  - rows_by_rule = 미검증 행과 미검증 분류(`unverified_triage.csv`) 처리 대상 행. 그 행만 대상
- rows_in = 대상 행 수, rows_keep = 원장 행 수 - 대상 행 수
- 단계(eg, suite, diff)는 대상 행으로 정함
- 함수 추가: unverified_rows, triage_rows, row_scope, row_targets, rule_hit, test_hits, row_in_scope
- 자체 시험 11건 → 20건

### tools/Harness/verify/run_verify.py
- `--only` 시험 고르기: VERIFY_DELTA=1 이고 `delta_scope.json` 이 unit row 이면 rows_by_rule 규칙은 대상 행을 고르는 시험만 넣음
- 시험이 행을 고르는지 = `judge.test_ownership` 의 출처 비교(source === 'X'). judge.py 905~911행(T61)이 쓰는 근거와 같음. 출처 비교가 없는 시험은 넣음
- target 정규식 대응과 시나리오(SCN_ONLY)는 대상 행만으로 고름
- 규칙 단위로 두는 것: whole_rules, 원장 비교로 더한 규칙, 판정 파일에 없는 규칙, 대상 행을 고르는 시험을 못 찾은 규칙, 대상 행이 원장에서 사라진 규칙, `verify_ledger.csv.prev` 없음, 판정 파일의 rules 가 `--only` 범위에 없음
- 다시 만든 원장에서 새로 생긴 행과 condition, expected 가 바뀐 행은 대상 행에 넣음
- 다시 돌지 않은 시험의 행은 지난 E2E 결과가 행 단위 병합으로 남음(종전 `--only` 동작)

### tools/VibeManager/quick.json
- 체인 checklist, checklist-delta 5단계 제목 2곳: "보완으로 바뀐 검사기가 판정하는 행과 미검증 행, 그 행의 시험만"

## 실측(SCP0028 원장, 읽기만, 2026-11-23 15:05)

`judge.test_ownership` 과 run_verify 의 시험 고르기 식을 같은 원장에 적용해 셈. CheckList 실행 없음.

| 구분 | 규칙 | 행 | 고르는 시험(전체 76개) |
|---|---|---|---|
| 종전(미해결 행의 규칙 전체) | 14 | 639 | 35 |
| 새 범위를 규칙 단위로 고름 | 2(F4, H11) | 36 | 11 |
| 새 범위를 행 단위로 고름 | 2 | 6(F4 5행, H11 1행) | 5 |

소요 시간은 미측정. 측정 방법 = 다음 SCP0028 체인의 `events.jsonl` chain.end 에서 S8.checklistDelta 회차당 sec.

## 남은 확인(사용자 실행 뒤)

1. SCP0028 에서 행 단위 부분 재측정 1회와 전체 재측정 1회를 같은 시각대에 실행하고 `python tools/Harness/verify/ledger_diff.py` 로 대조. 차이 0건이면 채택, 1건이라도 나오면 새 개념을 버리고 되돌림
2. 다음 SCP0028 체인 chain.end 에서 S8.checklistDelta 회차당 sec 가 1차 측정 sec 보다 작은지 확인
3. 실행 로그의 `[INFO] 재측정 단위 = 행` 줄에서 행 단위 규칙 수와 대상 행 수 확인

## 반영하지 않은 것(승인 대상 밖)

- `tools/VibeManager/steps.json:1557` 제목의 "직전 미해결 행 규칙 포함" 문구
- `tools/VibeManager/quick.json` 120, 122, 216, 218행 hint, confirm 문구(순서 설명이라 그대로 둠)
- 행을 만든 시험 이름 기록: `e2e_results.json` 행에 시험 제목이 없음. 기록하려면 `tools/E2E/lib` 수정 필요. 지금은 스펙 본문의 출처, 규칙 비교로 대응함
- `checklist_run.py --recheck` 경로(VERIFY_DELTA 없음)는 종전 규칙 단위

## 위험

- 출처 비교와 규칙 비교를 따로 쓰는 시험이 있으면 대상 행을 고르는 시험이 빠짐. 그 행은 지난 결과로 남아 미검증이 풀리지 않음. 남은 확인 1번 대조와 다음 회차 미검증 수로 드러남
- 검사기와 소스가 그대로인데 DB 데이터가 바뀌어 결과가 달라지는 FAIL, 판정필요 행은 다음 전체 측정까지 1차 결과로 남음

## 되돌리기

`delta_scope.py`, `run_verify.py`, `quick.json` 을 VMO 백업(태그 20261123_self1456)으로 복원하면 규칙 단위 재측정으로 돌아감. 원장은 실행마다 새로 써서 남는 변경 없음. `delta_scope.json` 의 unit, whole_rules, rows_by_rule 은 종전 코드가 읽지 않음.
