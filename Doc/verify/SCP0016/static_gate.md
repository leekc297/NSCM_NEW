# 정적 게이트 SCP0016 — 2026-11-08 16:15

- 원장 2079행 · 정적 판정 1389행(ERROR 57 · FAIL 7 · NA 882 · PASS 401 · 판정필요 42) · 런타임(E2E) 보류 0행
- **직접 FAIL 1** · 사용자 판정 FAIL 2 · 정적 실측 규칙 41종: A5, A6, A9, B2, B3, B4, B6, C1, C4, D1, D5, DB-SYN, F4, G1, G4, G5, G6, G7, G8, G9, H1, H10, H11, H4, H5, H6, H7, I1, I4, J1, J2, J4, K-SA, K1, K2, K4, M3, M4, X-LOC, X-REASON, X-ROW

## 직접 FAIL(정적)

| row_id | 규칙 | 대상 | 기대 원천 | 증거 |
|---|---|---|---|---|
| V-c34ab6ef | I4 | SCP0016 화면 | DOC:규칙 I4 정의 · 결함원장 유형(Doc/verify/_engin | t() 코드 16개 중 같은 문구의 앞선 코드가 있는데 새로 채번 1: LBL00711↔LBL00309 |

## ERROR 사유(정적)

- 7 규칙 A5 판정 32행 중 FAIL 
- 5 진입점 집계 3검사 — NOT_RUN
- 4 규칙 N1 판정 4행 중 FAIL 0
- 4 규칙 N1 판정 3행 중 FAIL 0
- 3 규칙 H6 판정 19행 중 FAIL 
- 2 규칙 B8 판정 2행 중 FAIL 0
- 2 규칙 G1 판정 5행 중 FAIL 0
- 2 행 집계 — 대조표 D00-4e-00
- 1 규칙 N1 판정 5행 중 FAIL 0
- 1 규칙 A5 판정 36행 중 FAIL 
- 1 규칙 G1 판정 1행 중 FAIL 0
- 1 규칙 G1 판정 2행 중 FAIL 0

## E2E 유래 FAIL(직전 실행 결과 · 이번 게이트 범위 밖 · 숨기지 않음) — 6행

- V-4c0ea927 K3 SCP0016 화면 — copy PASS: 선택 0,22,0,22 · 0행 D_20260824 표시값 '0' · Ctrl+C 클립보드 '0'(일치) · 우클릭 Copy '0'(일치) ／ ctrl PASS: Ctrl+클릭 0행·2행(D_20260824) → 선택 범위 시도1 
- V-41c3986c SC1 SCP0016 화면 — 조회조건 순서가 Excel 과 다름 — 화면 div → operationgroup → pjt → modelnickname → electrode → ver → bucket → period → sum ↔ Excel(List 시트 순서 · SCP_화면별 조
- V-e0565aea K3 [DMF0020 결함 일반화] 결과 그리드 Sort/Filter(동적 주 — hide FAIL: 헤더(D_20260824) 우클릭 → Hide Column → 컬럼 여전히 표시 · Unhide All 복원 · 미포함: Sort/Filter·정렬 후 동작(K1 smoke 행), 동적 Bucket 컬럼
- V-eeadaa8c K3 [DMF0020 결함 유형] Exchange Rate 그리드 Copy·H — copy PASS: 선택 0,22,0,22 · 0행 D_20260824 표시값 '0' · Ctrl+C 클립보드 '0'(일치) · 우클릭 Copy '0'(일치) ／ hide FAIL: 헤더(D_20260824) 우클릭 → Hide Column → 컬럼 
- V-74b29c26 H4 SCP0016 스냅샷 화면샷 1920 — [재실측 스냅샷 화면샷] 기준 Doc\verify\SCP0016\snap\golden\화면샷_1920.png ↔ 실측 C:\Projects\NSCM\Doc\verify\SCP0016\e2e\artifacts\_snap--snap-스냅샷-형상-검사-sn
- V-7753e74e H4 SCP0016 스냅샷 화면샷 1366 — [재실측 스냅샷 화면샷] 기준 Doc\verify\SCP0016\snap\golden\화면샷_1366.png ↔ 실측 C:\Projects\NSCM\Doc\verify\SCP0016\e2e\artifacts\_snap--snap-스냅샷-형상-검사-sn

> 이 게이트는 CheckList 판을 만들지 않는다. E2E 가 필요한 행은 정규 실행(run_verify.py <ID>) 또는 부분 재판정(--only <규칙>)에서 판정한다.
