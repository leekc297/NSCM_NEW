# 검사기 회귀 대조 SCP0037 — 기준 2026-11-07 15:13 (1762행) ↔ 현재 2026-11-07 18:24 (1762행)

- 악화(기준 비FAIL → 현재 FAIL): **1** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 0 · 그 외 변경: 2 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 0 · 새 행 0
- 승격 대기(received): Doc\verify\_checker_golden\SCP0037.received.csv — 확인 뒤 `checker_regress.py SCP0037 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| T-561c65ba | SC1 | SCP0037 화면 | ERROR | FAIL | 조회조건 순서가 Excel 과 다름 — 화면 operation → div → plantsite → material → active ↔ Excel(List 시트 순서 · SCP_화면 |  |

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-6d30ddef | F6 | SCP0037 빈값 저장 | NA | ERROR | [검증엔진 미기동] 검증엔진 테스트 '저장 세부(F1·F6) — 컬럼별 왕복·0 값 저장' 이 측정 전에 실패해 이 행은 실행되지 않음 — TimeoutError: locator. |  |
| V-a7d94ca1 | F1 | SCP0037 2행 동시 저장 | NA | ERROR | [검증엔진 미기동] 검증엔진 테스트 '저장 세부(F1·F6) — 컬럼별 왕복·0 값 저장' 이 측정 전에 실패해 이 행은 실행되지 않음 — TimeoutError: locator. |  |
