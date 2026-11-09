# 검사기 회귀 대조 SCP0084 — 기준 2026-11-07 15:20 (1629행) ↔ 현재 2026-11-08 17:06 (1629행)

- 악화(기준 비FAIL → 현재 FAIL): **0** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 4 · 그 외 변경: 6 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 1 · 새 행 1
- 승격 대기(received): Doc\verify\_checker_golden\SCP0084.received.csv — 확인 뒤 `checker_regress.py SCP0084 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-c9d3bd14 | F1 | SCP0084 화면 | FAIL | PASS | 저장 후 재조회에 수정값 반영 — DB 반영 확인 · 원복 저장·복원 확인(정리 완료) · 수정 저장 경로 강제(edit-save) · 편집 표시 셀이 화면 밖 → 편집 개시되는  |  |
| V-bc91a37c | K3 | SCP0084 화면 | FAIL | PASS | copy PASS: 선택 0,12,0,12 · 0행 MDM_NICK_NAME 표시값 'N32S2' · Ctrl+C 클립보드 'N32S2'(일치) · 우클릭 Copy 'N32S2'( |  |
| V-4e36063c | K3 | [DMF0020 결함 유형] Exchange Rate 그리드 Copy·Header Hide Column | FAIL | NA | copy PASS: 선택 0,12,0,12 · 0행 MDM_NICK_NAME 표시값 'N32S2' · Ctrl+C 클립보드 'N32S2'(일치) · 우클릭 Copy 'N32S2'( |  |
| T-65ada0a9 | X-ROW | SCP0084_LongTermStock.SaveData_Memo | FAIL | ERROR | 진입점 집계 15검사 — NA:7 · ERROR:4 · PASS:4 |  |

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-922eb524 | F6 | SCP0084 화면 | NA | PASS | 수정값·원복값 모두 재조회에 그대로(변형 없음) · 수정 저장 경로 강제(edit-save) · 편집 표시 셀이 화면 밖 → 편집 개시되는 첫 칸 MEMO 로 스크롤 후 후보 40 |  |
| V-f8ae66ab | F5 | SCP0084 원값 복원 상태 해제 | PASS | NA | 값 있는 편집 가능 칸 없음 — 수정 기능 없는 화면 |  |
| V-373ec674 | G4 | 조회조건 Div | PASS | NA | 정적 순서 판정은 SC1(E2E smoke 기준표 순서 · Excel 조회조건 정리 List 시트 기준 · 2026-11-06 사용자 지시) 행으로 일원화 · 원 판정: 조회조건  |  |
| T-74601cc9 | A5 | SCP0084_LongTermStock.CreateSpread | PASS | NA | AS-IS 유효 컬럼 56(Div 81 기준 숨김 제외) ↔ TO-BE 그리드 47: 누락 ENDING_STOCK_CONVERSION_QTY, ENDING_STOCK_QTY, EX |  |
| T-3408d1cb | F4 | PKG_SCP0084.P_SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET | PASS | NA | PKG_SCP0084.P_SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET: SCP0084/main/SAVE — 화면 진입·조회 중 호출 없음(저장 |  |
| T-f230fcbd | A5 | SCP0084_LongTermStock.SetSpreadInit | PASS | NA | AS-IS 유효 컬럼 56(Div 81 기준 숨김 제외) ↔ TO-BE 그리드 47: 누락 ENDING_STOCK_CONVERSION_QTY, ENDING_STOCK_QTY, EX |  |
