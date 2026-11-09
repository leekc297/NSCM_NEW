# 검사기 회귀 대조 SCP0131 — 기준 2026-11-07 15:31 (1819행) ↔ 현재 2026-11-07 20:32 (1837행)

- 악화(기준 비FAIL → 현재 FAIL): **2** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 3 · 그 외 변경: 30 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 0 · 새 행 18
- 승격 대기(received): Doc\verify\_checker_golden\SCP0131.received.csv — 확인 뒤 `checker_regress.py SCP0131 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-c8cd860a | G3 | SCP0131 화면 | ERROR | FAIL | E2E smoke 공통 'Condition(F6) Period 비저장(기간 조건 제외)' [FAIL] 기간 키 저장됨: fromDate, toDate (공통 요건 11 · CR-0 |  |
| V-11d9fee9 | F2 | SCP0131 시나리오 [자동] 기존행 수정 + 신규행 동시 Save 1회 → 요청에 M·I | ERROR | FAIL | [자동] 기존행 수정 + 신규행 동시 Save 1회 → 요청에 M·I: 저장 요청 없음 · 저장 요청 없음 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출0 |  |

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-e3be1cc0 | G9 | 조회조건 Model/Nickname | FAIL | PASS | 'Model/Nickname' 에 'AMCOME782-A1-0A0,AMCOME782-A1-0K0' 입력 조회 → ITEM_ID 6행 · 'AMCOME782-A1-0A0' 있음 ·  |  |
| V-13d89aae | G9 | [DMF0053 결함 일반화] 조회조건 Project(PROJECT_CODE)·Model/Nickname(I | FAIL | PASS | 규칙 G9 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-e3be1cc0] 조회조건 Model/Nickname: 'Model/Nickname' 에 'AMCOME |  |
| V-19b83fac | G9 | [DMF0045 결함 일반화] 조회조건 Project(PROJECT) · Model/Nickname(ITEM | FAIL | PASS | 규칙 G9 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-e3be1cc0] 조회조건 Model/Nickname: 'Model/Nickname' 에 'AMCOME |  |

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-3a29440b | F1 | SCP0131 화면 | NA | ERROR | [검증엔진 미기동] 검증엔진 테스트 'CRUD — 필수 공란 실제 저장 시도(E3) → 필수 채워 실제 저장·재조회·값 보존·정리(F1·F2·F4·F6)' 이 측정 전에 실패해 이 |  |
| V-ef6e0fe0 | F2 | SCP0131 화면 | NA | ERROR | [검증엔진 미기동] 검증엔진 테스트 'CRUD — 필수 공란 실제 저장 시도(E3) → 필수 채워 실제 저장·재조회·값 보존·정리(F1·F2·F4·F6)' 이 측정 전에 실패해 이 |  |
| V-8d56c801 | F4 | SCP0131 화면 | PASS | ERROR | [검증엔진 미기동] 검증엔진 테스트 'CRUD — 필수 공란 실제 저장 시도(E3) → 필수 채워 실제 저장·재조회·값 보존·정리(F1·F2·F4·F6)' 이 측정 전에 실패해 이 |  |
| V-1986aabd | F6 | SCP0131 화면 | NA | ERROR | [검증엔진 미기동] 검증엔진 테스트 'CRUD — 필수 공란 실제 저장 시도(E3) → 필수 채워 실제 저장·재조회·값 보존·정리(F1·F2·F4·F6)' 이 측정 전에 실패해 이 |  |
| V-d3a39193 | F6 | SCP0131 다른 셀 편집 값 유지 | ERROR | PASS | OPMZ_PLAN_GR_ID 편집 뒤 PRIO_RANK '7' 유지 |  |
| V-df0a5895 | F4 | SCP0131 경계값 저장 | NA | ERROR | [검증엔진 미기동] 검증엔진 테스트 'CRUD — 필수 공란 실제 저장 시도(E3) → 필수 채워 실제 저장·재조회·값 보존·정리(F1·F2·F4·F6)' 이 측정 전에 실패해 이 |  |
| V-cc130142 | H11 | SCP0131 화면 | PASS | 판정필요 | [시험 검사 CM-003 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed)] T98 — 병렬 call-proc |  |
| V-16479b26 | G8 | 조회조건 Model/Nickname | ERROR | PASS | 'Model/Nickname' 에 'amcome782-a1-0a0'(기본 결과 값 'AMCOME782-A1-0A0' 대소문자 반전) 입력 조회 → ITEM_ID 3행 |  |
| V-9dc0b9d8 | G1 | SCP0131 텍스트 부분일치 Model/Nickname | ERROR | PASS | Model/Nickname · 'MCOME782-A1-0A' 부분일치 3행 · 원래 값 포함 |  |
| V-b28c9b7e | G5 | new SCM0002_MaterialByDivisionPopup() | NA | ERROR | [검증엔진 미기동] 검증엔진 테스트 'CRUD — 필수 공란 실제 저장 시도(E3) → 필수 채워 실제 저장·재조회·값 보존·정리(F1·F2·F4·F6)' 이 측정 전에 실패해 이 |  |
| V-8164addc | G5 | popItem.ShowDialog() | NA | ERROR | [검증엔진 미기동] 검증엔진 테스트 'CRUD — 필수 공란 실제 저장 시도(E3) → 필수 채워 실제 저장·재조회·값 보존·정리(F1·F2·F4·F6)' 이 측정 전에 실패해 이 |  |
| V-9005ec0b | M4 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | ERROR | PASS | 규칙 M4 판정 8행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-9385d7a4] ITEM_ID: ITEM_ID: ITEM_ID 더블클릭 → Distribution R |  |
| V-14b33b52 | G1 | [DMF0053 결함 유형] Project·Owner 조회조건(Model/Nickname 정상) | ERROR | PASS | 규칙 G1 판정 6행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2c20da20] 조회조건 Model/Nickname: Model/Nickname 콤보 아님(popup |  |
| V-60c47723 | G1 | [DMF0005 결함 일반화] 텍스트 조회조건 Like 검색(Owner 팝업 User Name/EN) | ERROR | PASS | 규칙 G1 판정 5행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2c20da20] 조회조건 Model/Nickname: Model/Nickname 콤보 아님(popup |  |
| V-bc7a7adc | G1 | [SYS0003 결함 일반화] API Name 조회조건 | ERROR | PASS | 규칙 G1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2c20da20] 조회조건 Model/Nickname: Model/Nickname 콤보 아님(popup |  |
| V-c264be4a | G8 | [SYS0003 결함 일반화] API Name 조회조건 | ERROR | PASS | 규칙 G8 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-16479b26] 조회조건 Model/Nickname: 'Model/Nickname' 에 'amcome |  |
| V-87eed4bb | M4 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME | ERROR | PASS | 규칙 M4 판정 9행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-9385d7a4] ITEM_ID: ITEM_ID: ITEM_ID 더블클릭 → Distribution R |  |
| V-9b17501e | G8 | [DMF0053 결함 일반화] 조회조건 Project(PROJECT_CODE)·Model/Nickname(I | ERROR | PASS | 규칙 G8 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-16479b26] 조회조건 Model/Nickname: 'Model/Nickname' 에 'amcome |  |
| V-15bbd74e | M4 | [DMF0074 결함 일반화] 조회조건 Model/Nickname(MODEL) 팝업 Close(취소) 시 기 | ERROR | PASS | 규칙 M4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [EG-e89c3712] SCP0131 팝업 SCM0002_MaterialByDivisionPopup CON |  |
| V-1d830eb7 | G1 | [DMF0045 결함 일반화] 조회조건 Project(PROJECT) · Model/Nickname(ITEM | ERROR | PASS | 규칙 G1 판정 10행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2c20da20] 조회조건 Model/Nickname: Model/Nickname 콤보 아님(popu |  |
| V-ed2bf6c7 | G8 | [DMF0045 결함 일반화] 조회조건 Project(PROJECT) · Model/Nickname(ITEM | ERROR | PASS | 규칙 G8 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-16479b26] 조회조건 Model/Nickname: 'Model/Nickname' 에 'amcome |  |
| V-c8de8ce2 | G1 | 텍스트 조회조건 Like 검색(Owner 팝업 User Name/EN) | ERROR | PASS | 규칙 G1 판정 5행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2c20da20] 조회조건 Model/Nickname: Model/Nickname 콤보 아님(popup |  |
| V-b04eb014 | G1 | API Name 조회조건 | ERROR | PASS | 규칙 G1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2c20da20] 조회조건 Model/Nickname: Model/Nickname 콤보 아님(popup |  |
| T-3114f582 | G5 | 3 · spdMain.CellClick | NA | ERROR | 행 집계 — 대조표 3 'spdMain.CellClick' 의 G5 8요소: NA:6 · ERROR:2 |  |
| T-731746d6 | G5 | 4 · spdMain.CellDoubleClick | NA | ERROR | 행 집계 — 대조표 4 'spdMain.CellDoubleClick' 의 G5 8요소: NA:6 · ERROR:2 |  |
| T-24b0e192 | G5 | 5 · spdMain.ClipboardPasted | NA | ERROR | 행 집계 — 대조표 5 'spdMain.ClipboardPasted' 의 G5 8요소: NA:6 · ERROR:2 |  |
| T-f5c02117 | X-ROW | SCP0131_SalesSitePriority.btnItemId_Click | PASS | ERROR | 진입점 집계 9검사 — PASS:4 · NA:3 · ERROR:2 |  |
| EG-af11d7fa | H4 | SCP0131 팝업 SCM0002_MaterialByDivisionPopup CELL:ITEM_ID RESI | NA | PASS | 기대 축소 → 조건·버튼 겹침 없음 · 실제 rect {"x":360,"y":315,"w":1200,"h":450} · 겹침 [] · 근거 문서 DM-166 |  |
| EG-9656a930 | M4 | SCP0131 팝업 SCM0002_MaterialByDivisionPopup COND:Model PICK_O | ERROR | PASS | 기대 OK → 대상 칸에 선택 값 · 실제 대상 '' → 'AAEF1001I-A1-000' · OK 버튼 'OK' · 닫힘 true · 대응 컬럼 [ITEM_ID,ROW_NO] · |  |
| EG-7487849c | M4 | SCP0131 팝업 SCM0002_MaterialByDivisionPopup COND:Model PICK_D | ERROR | NA | 기대 더블클릭 → OK 와 같은 결과 · 실제 더블클릭 후 닫히지 않음 — AS-IS 더블클릭 확정 여부 SCM0002_MaterialByDivisionPopup.cs:404 ·  |  |
