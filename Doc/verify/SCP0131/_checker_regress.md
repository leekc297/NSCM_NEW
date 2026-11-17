# 검사기 회귀 대조 SCP0131 — 기준 2026-11-07 15:31 (1819행) ↔ 현재 2026-11-14 19:46 (1846행)

- 악화(기준 비FAIL → 현재 FAIL): **4** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 5 · 그 외 변경: 243 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 16 · 새 행 43
- 승격 대기(received): Doc\verify\_checker_golden\SCP0131.received.csv — 확인 뒤 `checker_regress.py SCP0131 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-a98bdc43 | K3 | SCP0131 화면 | PASS | FAIL | copy PASS: 선택 0,0,0,0 · 0행 DIVISION_ID 표시값 '81' · Ctrl+C 클립보드 '81'(일치) · 우클릭 Copy '81'(일치) ／ ctrl PA |  |
| V-11d9fee9 | F2 | SCP0131 시나리오 [자동] 기존행 수정 + 신규행 동시 Save 1회 → 요청에 M·I | ERROR | FAIL | [자동] 기존행 수정 + 신규행 동시 Save 1회 → 요청에 M·I: 저장 요청 없음(화면 문구 'Material by DivisionDiv​Operation Group​Mate |  |
| V-05281e8f | K3 | [DMF0020 결함 일반화] 결과 그리드 Sort/Filter(동적 주차 컬럼 W37-0817 등) | NA | FAIL | hide FAIL: 헤더(DIVISION_ID) 우클릭 → Hide Column → 컬럼 여전히 표시 · Unhide All 복원 · 미포함: Sort/Filter·정렬 후 동작( |  |
| V-89f91e1c | K3 | [DMF0020 결함 유형] Exchange Rate 그리드 Copy·Header Hide Column | NA | FAIL | copy PASS: 선택 0,0,0,0 · 0행 DIVISION_ID 표시값 '81' · Ctrl+C 클립보드 '81'(일치) · 우클릭 Copy '81'(일치) ／ hide FA |  |

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-e3be1cc0 | G9 | 조회조건 Model/Nickname | FAIL | PASS | 'Model/Nickname' 에 'AMCOME782-A1-0A0,AMCOME782-A1-0K0' 입력 조회 → ITEM_ID 6행 · 'AMCOME782-A1-0A0' 있음 ·  |  |
| V-2bcf7fcf | E7 | Sales Site Priority.ITEM_ID (Model*) | FAIL | ERROR | ITEM_ID 기존행 r1: 잘못된 값 'ZZ_E2E_BAD_POPUP_KEY' key-in → 셀 값 'ZZ_E2E_BAD_POPUP_KEY'(즉시 메시지 없음) · Save → |  |
| V-8e911390 | E7 | Sales Site Priority.ITEM_ID (Model*) | FAIL | ERROR | ITEM_ID 기존행 r1: 잘못된 값 'ZZ_E2E_BAD_POPUP_KEY' key-in → 셀 값 'ZZ_E2E_BAD_POPUP_KEY'(즉시 메시지 없음) · Save → |  |
| V-13d89aae | G9 | [DMF0053 결함 일반화] 조회조건 Project(PROJECT_CODE)·Model/Nickname(I | FAIL | PASS | 규칙 G9 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-e3be1cc0] 조회조건 Model/Nickname: 'Model/Nickname' 에 'AMCOME |  |
| V-19b83fac | G9 | [DMF0045 결함 일반화] 조회조건 Project(PROJECT) · Model/Nickname(ITEM | FAIL | PASS | 규칙 G9 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-e3be1cc0] 조회조건 Model/Nickname: 'Model/Nickname' 에 'AMCOME |  |

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-3a29440b | F1 | SCP0131 화면 | NA | PASS | 저장 후 재조회에 수정값 반영 — DB 반영 확인 · 원복 저장·복원 확인(정리 완료) · 수정 저장 경로 강제(edit-save) · 저장 키 컬럼 제외 185셀 · [0s] 수 |  |
| V-ef6e0fe0 | F2 | SCP0131 화면 | NA | PASS | 수정 저장 성공(Save 1회) — 수정 저장 경로 강제(edit-save) · 저장 키 컬럼 제외 185셀 · [0s] 수정 입력 완료 · [2s] 저장 응답 SAVE:200 요 |  |
| V-1986aabd | F6 | SCP0131 화면 | NA | PASS | 수정값·원복값 모두 재조회에 그대로(변형 없음) · 수정 저장 경로 강제(edit-save) · 저장 키 컬럼 제외 185셀 · [0s] 수정 입력 완료 · [2s] 저장 응답 S |  |
| V-5ec8ab30 | J2 | SCP0131 화면 | NA | ERROR |  ／ [미검증] 검사기(auth·authcrud spec)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(auth·authcrud sp |  |
| V-e41278d7 | F8 | SCP0131 저장 감사 필드 | NA | ERROR |  ／ [미검증] 검사기(tools/Harness/verify/save_audit.py(정리 백업 루트 행 감사 컬럼 = 저장 계정·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-1ecde8f6 | F7 | SCP0131 저장 연계 테이블 | NA | ERROR |  ／ [미검증] 검사기(tools/Harness/verify/save_audit.py(CRUD 실제 저장 정리 백업 ↔ AS-IS )가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-d3a39193 | F6 | SCP0131 다른 셀 편집 값 유지 | ERROR | PASS | OPMZ_PLAN_GR_ID 편집 뒤 PRIO_RANK '7' 유지 |  |
| V-c97ad313 | I1 | SCP0131 시나리오 [자동] KO 언어 · 변경 없이 저장 → KO 수정사항 없음 알림 | PASS | ERROR | [측정 경로 없음] [자동] KO 언어 · 변경 없이 저장 → KO 수정사항 없음 알림: [측정 경로 없음] 다른 화면 E2E 동시 실행(SCP0127) — 계정 언어 전환 생략( |  |
| V-9dd3e016 | F3 | SCP0131 시나리오 [자동] OPMZ_PLAN_GR_ID 신규 행 콤보 붙여넣기 — 후보 값 반영 | 판정필요 | PASS | [자동] OPMZ_PLAN_GR_ID 신규 행 콤보 붙여넣기 — 후보 값 반영: 기대대로 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출0·요청9 → ins |  |
| V-c50e4cef | F3 | SCP0131 시나리오 [자동] SCM_SITE_ID 신규 행 콤보 붙여넣기 — 후보 값 반영 | 판정필요 | PASS | [자동] SCM_SITE_ID 신규 행 콤보 붙여넣기 — 후보 값 반영: 기대대로 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출0·요청9 → insert: |  |
| V-df0a5895 | F4 | SCP0131 경계값 저장 | NA | PASS | 수정 저장 2회 SQL 오류 없음 — main/SAVE:200 요청={"activeFlag":"M","divisionId":"81","opmzPlanGrId":"PG0031","s |  |
| V-464c0210 | L1 | SCP0131 저장 응답 시간 | NA | ERROR |  ／ [미검증] 검사기(_trace.spec(@trace) W4d 조회 응답시간)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_tr |  |
| V-cc130142 | H11 | SCP0131 화면 | PASS | 판정필요 | [시험 검사 CM-003 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed)] T98 — 병렬 call-proc |  |
| V-8365c8b7 | A7 | SCP0128_GET_SEARCH_INFO | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-ee596c0d | A7 | SCP0131_GET_SALES_SITE_PRIORITY | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-a5d4eae9 | B3 | 조회조건 Div | NA | ERROR | [화면 초기(선택 Div=81)] 원문 ORDER BY 있음·정렬 키 해석 불가 — AS-IS 반환 순서와 다름: TO-BE ['40', '81', '81_HD', '81_HG', |  |
| V-e8cb701b | B7 | 조회조건 Div | NA | ERROR | 판정필요: (a) 저장 SP SCP0131_SAVE_SALES_SITE_PRIORITY 대상 SCP_OPMZ_SALES_SITE_PRIORITY 와 콤보 원천 8종이 읽는 테이블이 |  |
| V-a6a338c0 | C1 | 조회조건 Div | NA | ERROR | 상속(TRACE T-c4fa5910): 'Div' → '40 Mobility & IT Battery' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 ClbDiv |  |
| V-f6de5258 | B3 | 조회조건 Plan Group | NA | ERROR | [화면 초기(선택 Div=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-61b6032f | B4 | 조회조건 Plan Group | NA | ERROR | [화면 초기(선택 Div=81)] AS-IS 원천 실행 불가 — 'dtPlanGroup 원천 대입 미발견(필드 초기화·외부 주입 확인)' · 원천 - · 표현 - → 기계 판정 불 |  |
| V-d81578fa | B7 | 조회조건 Plan Group | NA | ERROR | 판정필요: (a) 저장 SP SCP0131_SAVE_SALES_SITE_PRIORITY 대상 SCP_OPMZ_SALES_SITE_PRIORITY 와 콤보 원천 8종이 읽는 테이블이 |  |
| V-5167139c | G7 | 조회조건 Plan Group | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1) G7 — AS-IS 컨트롤 표시 열(CControl.setListBox·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-2f958030 | B3 | 조회조건 SCM Site | NA | ERROR | [화면 초기(선택 Div=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-0ca33bf4 | B4 | 조회조건 SCM Site | NA | ERROR | [화면 초기(선택 Div=81)] AS-IS 원천 실행 불가 — 'dtScmSite 원천 대입 미발견(필드 초기화·외부 주입 확인)' · 원천 - · 표현 - → 기계 판정 불가  |  |
| V-46806b56 | B7 | 조회조건 SCM Site | NA | ERROR | 판정필요: (a) 저장 SP SCP0131_SAVE_SALES_SITE_PRIORITY 대상 SCP_OPMZ_SALES_SITE_PRIORITY 와 콤보 원천 8종이 읽는 테이블이 |  |
| V-b829c676 | G7 | 조회조건 SCM Site | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1) G7 — AS-IS 컨트롤 표시 열(CControl.setListBox·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-fd66382d | G2 | 조회조건 Model/Nickname | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_verify.spec( |  |
| V-9f615abb | G5 | 조회조건 Model/Nickname | NA | ERROR |  ／ [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [ |  |
| V-16479b26 | G8 | 조회조건 Model/Nickname | ERROR | PASS | 'Model/Nickname' 에 'amcome782-a1-0a0'(기본 결과 값 'AMCOME782-A1-0A0' 대소문자 반전) 입력 조회 → ITEM_ID 3행 |  |
| V-3f800b5b | G8 | 조회조건 Period | NA | ERROR | 'Period' 과 같은 이름의 결과 컬럼 없음(후보 Period · Period Code · Period Name · Period ID) — 결과 대조 불가(조건 ↔ 컬럼 대응  |  |
| V-07dabc14 | B3 | 조회조건 Active | NA | ERROR | [화면 초기(선택 Div=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-84aed110 | B4 | 조회조건 Active | NA | ERROR | [화면 초기(선택 Div=81)] AS-IS 원천 미발견(combo_src 에 이 대상 바인딩 없음) · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W |  |
| V-fc95a639 | B7 | 조회조건 Active | NA | ERROR | 판정필요: (a) 저장 SP SCP0131_SAVE_SALES_SITE_PRIORITY 대상 SCP_OPMZ_SALES_SITE_PRIORITY 와 콤보 원천 8종이 읽는 테이블이 |  |
| V-fae8e0ff | G7 | 조회조건 Active | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1) G7 — AS-IS 컨트롤 표시 열(CControl.setListBox·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-a3843da1 | B3 | Sales Site Priority.OPMZ_PLAN_GR_ID (Plan Group*) | NA | ERROR | [신규행(DIVISION_ID=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-414d33d5 | B4 | Sales Site Priority.OPMZ_PLAN_GR_ID (Plan Group*) | NA | ERROR | [신규행(DIVISION_ID=81)] AS-IS 원천 실행 불가 — 'dtPlanGroup 원천 대입 미발견(필드 초기화·외부 주입 확인)' · 원천 - · 표현 - → 기계 판 |  |
| V-dacb3688 | B3 | Sales Site Priority.SCM_SITE_ID (SCM site*) | NA | ERROR | [신규행(DIVISION_ID=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-6bf75092 | B4 | Sales Site Priority.SCM_SITE_ID (SCM site*) | NA | ERROR | [신규행(DIVISION_ID=81)] AS-IS 원천 미발견(combo_src 에 이 대상 바인딩 없음) · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원 |  |
| V-310b273b | B3 | Sales Site Priority.VALID_YN (Active) | NA | ERROR | [신규행(DIVISION_ID=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-419623b1 | B4 | Sales Site Priority.VALID_YN (Active) | NA | ERROR | [신규행(DIVISION_ID=81)] AS-IS 원천 미발견(combo_src 에 이 대상 바인딩 없음) · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원 |  |
| V-44576ebe | A5 | Sales Site Priority.PRE_KEY_VALUES (PRE_KEY_VALUES) | NA | ERROR | PRE_KEY_VALUES 화면 표시=N (기대 표시 여부 = AS-IS VISIBLE_FLAG 'Y' (TO-BE 'N')) → TO-BE 메타(SHEET_COLUMNS VISI |  |
| V-9dc0b9d8 | G1 | SCP0131 텍스트 부분일치 Model/Nickname | ERROR | PASS | Model/Nickname · 'MCOME782-A1-0A' 부분일치 3행 · 원래 값 포함 |  |
| V-4e1f9823 | G1 | SCP0131 텍스트 부분일치 Period | NA | ERROR |  ／ [미검증] 검사기(smoke 조회조건 동작·_verify)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(smoke 조회조건 동작 |  |
| V-3ee836f3 | M3 | new SCM0002_MaterialByDivisionPopup() | NA | PASS | AS-IS 팝업 문장 'new SCM0002_MaterialByDivisionPopup()' → 팝업 SCM0002_MaterialByDivisionPopup 의 규칙 M3 실측  |  |
| V-f8fbc16a | C3 | OPMZ_PLAN_GR_ID | NA | ERROR | 원천 컬럼 분기 해석 불가 — 조건 'if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e |  |
| V-b6b0a1a8 | C6 | OPMZ_PLAN_GR_ID | NA | ERROR | OPMZ_PLAN_GR_ID='PG0001' 더블클릭+Esc(값 변경 없음) →  — 대상 값을 채우지 못해 판정 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-0c67b6dc | M3 | new SCM0002_MaterialByDivisionPopup() | NA | PASS | AS-IS 팝업 문장 'new SCM0002_MaterialByDivisionPopup()' → 팝업 SCM0002_MaterialByDivisionPopup 의 규칙 M3 실측  |  |
| V-5fae49e3 | H6 | popItem.Form_Load(true, division, operation_group, sItemId,  | NA | PASS | AS-IS 팝업 문장 'popItem.Form_Load(true, division, operation_group,' → 팝업 SCM0002_MaterialByDivisionPopu |  |
| V-744c9da7 | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-1109a968 | K3 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | NA | ERROR | f5 ERROR: 실행 실패: Error: 셀 좌표 확인 실패(0행 · DIVISION_ID): DIV · 미포함: 팝업 그리드(이 시험은 메인 그리드만), Sort/Filter· |  |
| V-4eb95e21 | B3 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | NA | ERROR | 규칙 B3 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-2f958030] 조회조건 SCM Site: [화면 초기(선택 Div=81)]  · 원천 - · 표현  |  |
| V-17d42cc3 | B4 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-bcc59c93 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | NA | ERROR | ctrl PASS: Ctrl+클릭 0행·2행(DIVISION_ID) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함: |  |
| V-5ff2bfae | G2 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | NA | ERROR | 규칙 G2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-fd66382d] 조회조건 Model/Nickname:  ／ [미검증] 검사기(_verify.spec( |  |
| V-626dd0dc | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/ | NA | ERROR | 규칙 B4 판정 5행 중 FAIL 0 · 판정필요 0 · 미검증 5 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-600197cc | E6 | 텍스트 입력 컨트롤(TEXT BOX · FPText) 마우스 드래그 선택 후 Delete/Backspace | PASS | NA | 직접 실측 없음 — 같은 규칙 E6 의 다른 대상 2행 PASS 는 이 결함의 근거가 아님 · 참고 [V-c5828e97] SCP0131 화면 ／ [V-d6e8662f] SCP01 |  |
| V-03e90c7e | H6 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | PASS | ERROR | 규칙 H6 판정 13행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-7a62b2f8] SCP0131 스냅샷 팝업 Model/Nickname: [재실측 스냅샷 팝업] 골든 |  |
| V-ca7bb7d0 | C2 | [DMF0007 결함 유형] 그리드 End Customer→Sales Site cascade | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-8f99cd9f] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-d7d72f30 | B4 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-3ff4a163 | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-c2e877ed | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0131_SAVE_SALES_SITE_PRIORITY 대상 SCP_OPMZ_SALES_SITE_PRIORITY 와 콤보 원천 8종이 읽는 테이블이 |  |
| V-f4db1ff9 | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-22b0aa16 | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0131_SAVE_SALES_SITE_PRIORITY 대상 SCP_OPMZ_SALES_SITE_PRIORITY 와 콤보 원천 8종이 읽는 테이블이 |  |
| V-f9036a46 | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-9d96fe6e | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0131_SAVE_SALES_SITE_PRIORITY 대상 SCP_OPMZ_SALES_SITE_PRIORITY 와 콤보 원천 8종이 읽는 테이블이 |  |
| V-f5654e30 | K3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | NA | ERROR | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,0, |  |
| V-44e4eb4f | B4 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-16f0848e | C3 | [DMF0020 결함 유형] Team·End Customer 컬럼 | NA | ERROR | 규칙 C3 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-b4328f57] ITEM_ID / Model: ITEM_ID 연쇄 원천 컬럼 해석 불가 — AS-IS |  |
| V-ab6f1042 | B4 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-70386d10 | C2 | [DMF0005 결함 일반화] 그리드 Sales Company→Sales Plant · Sales Site→ | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-8f99cd9f] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-e85a4ca8 | C2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | NA | ERROR | 규칙 C2 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [T-3bb0947d] OPMZ_PLAN_GR_ID / Plan Group: OPMZ_PLAN_GR_ID 연 |  |
| V-b10e96bc | C2 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Acti | NA | ERROR | 규칙 C2 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [T-3bb0947d] OPMZ_PLAN_GR_ID / Plan Group: OPMZ_PLAN_GR_ID 연 |  |
| V-a739f810 | B4 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-92cad06e | B5 | [DMF0003 결함 유형] Measure 콤보(입력 가능 Measure) | NA | ERROR | 규칙 B5 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-7f6b97f6 | C2 | [DMF0003 결함 유형] Measure 콤보(입력 가능 Measure) | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-8f99cd9f] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-e2b2792b | C2 | [DMF0003 결함 유형] AS From Site 입력 후 W35~W38 수량 | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-8f99cd9f] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-c537169c | G5 | [DMF0003 결함 유형] Model 팝업(sMdmActive_Sw) | PASS | ERROR | 규칙 G5 판정 6행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-9f615abb] 조회조건 Model/Nickname:  ／ [미검증] 검사기(popup_args_ch |  |
| V-9ff69458 | B5 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | NA | ERROR | 규칙 B5 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-acb194a3 | A5 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | PASS | ERROR | 규칙 A5 판정 24행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-13fe42c2] SCP0131 스냅샷 헤더 Sales Site Priority: [재실측 스냅샷 헤 |  |
| V-42c3685e | A5 | [DMF0082 결함 일반화] 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | PASS | ERROR | 규칙 A5 판정 24행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-13fe42c2] SCP0131 스냅샷 헤더 Sales Site Priority: [재실측 스냅샷 헤 |  |
| V-e0f41a6f | B4 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-c9c3829f | G2 | [DMF0042 결함 일반화] 조회조건 Item Type | NA | ERROR | 규칙 G2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-fd66382d] 조회조건 Model/Nickname:  ／ [미검증] 검사기(_verify.spec( |  |
| V-f73cf61b | K3 | [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | NA | ERROR | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,0, |  |
| V-7cd0606b | E6 | [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | NA | ERROR | ime NA: 신규행 VALUE_DESCRIPTION 선택(편집기 닫힘·포커스 DIV.wj-cell wj-align-left cell-cha) → IME 조합 '한글' → 편집기  |  |
| V-54d66cd7 | E3 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Mod | NA | PASS | 규칙 E3 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-66a8887f] SCP0131 Excel 필수 칸 빈 업로드: Excel Upload 버튼 없음 ·  |  |
| V-e9e51d5f | E4 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Valida | NA | ERROR | 규칙 E4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-c7d5c219] FROM_YYYYMMDD / Valid From: MSG00049 — SpdMain_ |  |
| V-fb4da5bf | B4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | NA | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 3 — [V-414d33d5] Sales Site Priority.OPMZ_PLAN_GR_ID (Plan Group |  |
| V-8f477608 | C2 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-8f99cd9f] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-3c5b32da | B5 | [DMF0003 결함 유형] 신규 행 Measure 후보 | NA | ERROR | 규칙 B5 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-7a37f1b6 | C2 | [DMF0003 결함 유형] 신규 행 Measure 후보 | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-8f99cd9f] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-1be7cd95 | B4 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-5589b5c9 | B5 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit | NA | ERROR | 규칙 B5 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-02a58b8f | B4 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-81040e86 | C2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-8f99cd9f] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-572512d1 | C3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | NA | ERROR | 규칙 C3 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-b4328f57] ITEM_ID / Model: ITEM_ID 연쇄 원천 컬럼 해석 불가 — AS-IS |  |
| V-cba65853 | B5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | NA | ERROR | 규칙 B5 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-23d67d4f | C2 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-8f99cd9f] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-a80987f6 | B4 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-929a726c | B5 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | NA | ERROR | 규칙 B5 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-ee5c3de6 | B7 | [DMF0005 결함 유형] Team 조회조건 후보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0131_SAVE_SALES_SITE_PRIORITY 대상 SCP_OPMZ_SALES_SITE_PRIORITY 와 콤보 원천 8종이 읽는 테이블이 |  |
| V-674f7508 | H6 | [DMF0035 결함 유형] Project/Model/Owner 조회조건 팝업 | PASS | ERROR | 규칙 H6 판정 7행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-7a62b2f8] SCP0131 스냅샷 팝업 Model/Nickname: [재실측 스냅샷 팝업] 골든  |  |
| V-55bfc27d | H6 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | NA | ERROR | 규칙 H6 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-7a62b2f8] SCP0131 스냅샷 팝업 Model/Nickname: [재실측 스냅샷 팝업] 골든  |  |
| V-c25c2fda | B4 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-84aed110] 조회조건 Active: [화면 초기(선택 Div=81)] AS-IS 원천 미발견(co |  |
| V-df70c4ab | H6 | [DMF0005 결함 일반화] 팝업 No. 컬럼(Model/Owner/Project/Version 팝업) | PASS | ERROR | 규칙 H6 판정 7행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-7a62b2f8] SCP0131 스냅샷 팝업 Model/Nickname: [재실측 스냅샷 팝업] 골든  |  |
| V-60c47723 | G1 | [DMF0005 결함 일반화] 텍스트 조회조건 Like 검색(Owner 팝업 User Name/EN) | ERROR | PASS | 규칙 G1 판정 5행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2c20da20] 조회조건 Model/Nickname: Model/Nickname 콤보 아님(popup |  |
| V-bc7a7adc | G1 | [SYS0003 결함 일반화] API Name 조회조건 | ERROR | PASS | 규칙 G1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2c20da20] 조회조건 Model/Nickname: Model/Nickname 콤보 아님(popup |  |
| V-c264be4a | G8 | [SYS0003 결함 일반화] API Name 조회조건 | ERROR | PASS | 규칙 G8 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-16479b26] 조회조건 Model/Nickname: 'Model/Nickname' 에 'amcome |  |
| V-3ef29d8a | B4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회 | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-84aed110] 조회조건 Active: [화면 초기(선택 Div=81)] AS-IS 원천 미발견(co |  |
| V-81318701 | A5 | [DMF0005 결함 유형] Cell Prod. Site (S&OP Report) 컬럼 | PASS | ERROR | 규칙 A5 판정 24행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-13fe42c2] SCP0131 스냅샷 헤더 Sales Site Priority: [재실측 스냅샷 헤 |  |
| V-d3424f02 | B4 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | NA | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 3 — [V-414d33d5] Sales Site Priority.OPMZ_PLAN_GR_ID (Plan Group |  |
| V-2490532a | G5 | [DMF0005 결함 유형] Model 팝업 조회 | PASS | ERROR | 규칙 G5 판정 6행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-9f615abb] 조회조건 Model/Nickname:  ／ [미검증] 검사기(popup_args_ch |  |
| V-3d348e01 | B5 | [SYS0012 결함 유형] 권한 신청 가능 Group 목록 | NA | ERROR | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-61b6032f] 조회조건 Plan Group: [화면 초기(선택 Div=81)] AS-IS 원천 실행 |  |
| V-eca8af05 | K3 | [DMF0035 결함 유형] F5 단축키 | PASS | ERROR | f5 ERROR: 실행 실패: Error: 셀 좌표 확인 실패(0행 · DIVISION_ID): DIV |  |
| V-61765f94 | K3 | [DMF0035 결함 유형] 조회 버튼 단축키 | PASS | ERROR | f5 ERROR: 실행 실패: Error: 셀 좌표 확인 실패(0행 · DIVISION_ID): DIV |  |
| V-5fd46eb7 | C2 | [SCP0007 결함 유형] Insert 행 Div 셀 / 하위 Site | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-8f99cd9f] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-46a3fbce | B4 | [SCP0007 결함 유형] To Site 조회조건 콤보 | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-d64885e5 | B4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-a9dc9bbe | H6 | [DMF0005 결함 일반화] Model Code Change 팝업(MODEL_CODE_CHANGE Moda | PASS | ERROR | 규칙 H6 판정 8행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-7a62b2f8] SCP0131 스냅샷 팝업 Model/Nickname: [재실측 스냅샷 팝업] 골든  |  |
| V-fa08e418 | C3 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME | NA | ERROR | 규칙 C3 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-b4328f57] ITEM_ID / Model: ITEM_ID 연쇄 원천 컬럼 해석 불가 — AS-IS |  |
| V-a3854996 | B4 | [DMF0004 결함 일반화] 조회조건 Sales Site 콤보(SCM_SITE_ID · SiteByEndC | NA | ERROR | 규칙 B4 판정 5행 중 FAIL 0 · 판정필요 0 · 미검증 5 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-3345fe8c | B3 | [DMF0048 결함 일반화] 조회조건 Team(DEPT_ID)·End Customer(END_CUSTOME | NA | ERROR | 규칙 B3 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-2f958030] 조회조건 SCM Site: [화면 초기(선택 Div=81)]  · 원천 - · 표현  |  |
| V-9b17501e | G8 | [DMF0053 결함 일반화] 조회조건 Project(PROJECT_CODE)·Model/Nickname(I | ERROR | PASS | 규칙 G8 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-16479b26] 조회조건 Model/Nickname: 'Model/Nickname' 에 'amcome |  |
| V-1dd27cb4 | B4 | [DMF0053 결함 일반화] 조회조건 Filter 콤보 6종(FilterMyDivision·FilterTe | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-84aed110] 조회조건 Active: [화면 초기(선택 Div=81)] AS-IS 원천 미발견(co |  |
| V-7857ae2c | I1 | [DMF0004 결함 일반화] 변경 없이 Save(F7) 시 안내 메시지 코드(MSG_NO_CHANGE 미등 | ERROR | NA | 규칙 I1 요소 판정에 FAIL 0 · 판정필요 0 · 미검증 1 있으나 이 결함 대상과 직접 일치하는 요소 없음 — 규칙 전반 상속으로 FAIL 을 만들지 않음(원천 행 참조:  |  |
| V-ed2bf6c7 | G8 | [DMF0045 결함 일반화] 조회조건 Project(PROJECT) · Model/Nickname(ITEM | ERROR | PASS | 규칙 G8 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-16479b26] 조회조건 Model/Nickname: 'Model/Nickname' 에 'amcome |  |
| V-47047b01 | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-c020a2e4 | C2 | 그리드 Sales Company→Sales Plant · Sales Site→Company/Plant | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-8f99cd9f] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-566eee1d | A5 | 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | PASS | ERROR | 규칙 A5 판정 24행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-13fe42c2] SCP0131 스냅샷 헤더 Sales Site Priority: [재실측 스냅샷 헤 |  |
| V-db7af565 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | NA | ERROR | ctrl PASS: Ctrl+클릭 0행·2행(DIVISION_ID) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함: |  |
| V-5e305ff1 | G2 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | NA | ERROR | 규칙 G2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-fd66382d] 조회조건 Model/Nickname:  ／ [미검증] 검사기(_verify.spec( |  |
| V-a4f3234f | H6 | 팝업 No. 컬럼(Model/Owner/Project/Version 팝업) | PASS | ERROR | 규칙 H6 판정 7행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-7a62b2f8] SCP0131 스냅샷 팝업 Model/Nickname: [재실측 스냅샷 팝업] 골든  |  |
| V-c8de8ce2 | G1 | 텍스트 조회조건 Like 검색(Owner 팝업 User Name/EN) | ERROR | PASS | 규칙 G1 판정 5행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2c20da20] 조회조건 Model/Nickname: Model/Nickname 콤보 아님(popup |  |
| V-b04eb014 | G1 | API Name 조회조건 | ERROR | PASS | 규칙 G1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2c20da20] 조회조건 Model/Nickname: Model/Nickname 콤보 아님(popup |  |
| V-88171502 | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/ | NA | ERROR | 규칙 B4 판정 5행 중 FAIL 0 · 판정필요 0 · 미검증 5 — [V-0ca33bf4] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-ef884509 | C1 | 조회조건 Division 콤보(DIVISION_ID 단일 선택 화면) · 하위 조회조건 · 전 그리드 | NA | ERROR | 규칙 C1 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-c4fa5910] cboDivision / Division / Div / Div.: 'Div' → '4 |  |
| V-b690465b | G4 | SCP0131 스냅샷 조회조건 Div 40 | NA | ERROR | [재실측 스냅샷 조회조건] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0131\snap\received\조회조건_Div_40.aria.yml 를 sna |  |
| V-80f2ddbe | K4 | SCP0131 스냅샷 버튼 Div 40 | NA | ERROR | [재실측 스냅샷 버튼] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0131\snap\received\버튼_Div_40.aria.yml 를 snap_va |  |
| V-13fe42c2 | A5 | SCP0131 스냅샷 헤더 Sales Site Priority | NA | ERROR | [재실측 스냅샷 헤더] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0131\snap\received\헤더_Sales_Site_Priority.txt 를 |  |
| V-7a62b2f8 | H6 | SCP0131 스냅샷 팝업 Model/Nickname | NA | ERROR | [재실측 스냅샷 팝업] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0131\snap\received\팝업_Model_Nickname.aria.yml 를 |  |
| V-efc6593d | H4 | SCP0131 스냅샷 화면샷 1920 | NA | ERROR | [재실측 스냅샷 화면샷] 골든 없음(승인 전) · 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 차이 — Error: [2mexpect([22m[31mpage[3 |  |
| V-a2e88734 | H4 | SCP0131 스냅샷 화면샷 1366 | NA | ERROR | [재실측 스냅샷 화면샷] 골든 없음(승인 전) · 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 차이 — Error: [2mexpect([22m[31mpage[3 |  |
| AD-c5f29db8 | A7 | SCP0131 SCP0131_GET_SALES_SITE_PRIORITY 공통행 컬럼 값(공통 0행 · 불일치 | NA | ERROR | [VALUES] [차등 검증 #5] main/SEARCH AS-IS SCP0131_GET_SALES_SITE_PRIORITY ↔ TO-BE PKG_SCP0131.P_SCP0131_ |  |
| AD-f29e7da4 | A7 | SCP0131 SCP0131_GET_SALES_SITE_PRIORITY 공통행 컬럼 값(공통 0행 · 불일치 | NA | ERROR | [VALUES] [차등 검증 #7] main/SEARCH AS-IS SCP0131_GET_SALES_SITE_PRIORITY ↔ TO-BE PKG_SCP0131.P_SCP0131_ |  |
| AD-d999ca70 | A7 | SCP0131 SCP0131_GET_SALES_SITE_PRIORITY 공통행 컬럼 값(공통 0행 · 불일치 | NA | ERROR | [VALUES] [차등 검증 #9] main/SEARCH AS-IS SCP0131_GET_SALES_SITE_PRIORITY ↔ TO-BE PKG_SCP0131.P_SCP0131_ |  |
| AD-b98c88df | A7 | SCP0131 SCP0131_GET_SALES_SITE_PRIORITY 공통행 컬럼 값(공통 0행 · 불일치 | NA | ERROR | [VALUES] [차등 검증 #11] main/SEARCH AS-IS SCP0131_GET_SALES_SITE_PRIORITY ↔ TO-BE PKG_SCP0131.P_SCP0131 |  |
| AD-3ac245e9 | A7 | SCP0131 SCP0131_GET_SALES_SITE_PRIORITY 공통행 컬럼 값(공통 0행 · 불일치 | NA | ERROR | [VALUES] [차등 검증 #12] main/SEARCH AS-IS SCP0131_GET_SALES_SITE_PRIORITY ↔ TO-BE PKG_SCP0131.P_SCP0131 |  |
| AD-1779d7b4 | A7 | SCP0131 SCP0131_GET_SALES_SITE_PRIORITY 공통행 컬럼 값(공통 0행 · 불일치 | NA | ERROR | [VALUES] [차등 검증 #13] main/SEARCH AS-IS SCP0131_GET_SALES_SITE_PRIORITY ↔ TO-BE PKG_SCP0131.P_SCP0131 |  |
| AD-24275abb | A7 | SCP0131 SCP0131_GET_SALES_SITE_PRIORITY 공통행 컬럼 값(공통 0행 · 불일치 | NA | ERROR | [VALUES] [차등 검증 #14] main/SEARCH AS-IS SCP0131_GET_SALES_SITE_PRIORITY ↔ TO-BE PKG_SCP0131.P_SCP0131 |  |
| AD-67a382b9 | A7 | SCP0131 SCP0131_GET_SALES_SITE_PRIORITY 공통행 컬럼 값(공통 0행 · 불일치 | NA | ERROR | [VALUES] [차등 검증 #15] main/SEARCH AS-IS SCP0131_GET_SALES_SITE_PRIORITY ↔ TO-BE PKG_SCP0131.P_SCP0131 |  |
| T-7c057ff1 | X-LOC | 1 · btnItemId.Click | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-8537a553 | F4 | 1 · btnItemId.Click | PASS | ERROR | 행 집계 — 대조표 1 'btnItemId.Click' 의 F4 3요소: PASS:2 · ERROR:1 |  |
| T-228e1f68 | E3 | 1 · btnItemId.Click | PASS | ERROR | 행 집계 — 대조표 1 'btnItemId.Click' 의 E3 5요소: PASS:4 · ERROR:1 |  |
| T-7b70ea37 | X-LOC | 2 · cboDivision.SelectedIndexChanged | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-dad5f297 | F4 | 2 · cboDivision.SelectedIndexChanged | PASS | ERROR | 행 집계 — 대조표 2 'cboDivision.SelectedIndexChanged' 의 F4 3요소: PASS:2 · ERROR:1 |  |
| T-03ea9f80 | E3 | 2 · cboDivision.SelectedIndexChanged | PASS | ERROR | 행 집계 — 대조표 2 'cboDivision.SelectedIndexChanged' 의 E3 5요소: PASS:4 · ERROR:1 |  |
| T-a90c6f8f | H6 | 3 · spdMain.CellClick | PASS | ERROR | 행 집계 — 대조표 3 'spdMain.CellClick' 의 H6 8요소: PASS:7 · ERROR:1 |  |
| T-3114f582 | G5 | 3 · spdMain.CellClick | NA | ERROR | 행 집계 — 대조표 3 'spdMain.CellClick' 의 G5 8요소: NA:7 · ERROR:1 |  |
| T-8b091d03 | F4 | 3 · spdMain.CellClick | PASS | ERROR | 행 집계 — 대조표 3 'spdMain.CellClick' 의 F4 3요소: PASS:2 · ERROR:1 |  |
| T-347b3b0f | E3 | 3 · spdMain.CellClick | PASS | ERROR | 행 집계 — 대조표 3 'spdMain.CellClick' 의 E3 5요소: PASS:4 · ERROR:1 |  |
| T-8e3c08bc | X-LOC | 4 · spdMain.CellDoubleClick | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-5b5c6f16 | F4 | 4 · spdMain.CellDoubleClick | PASS | ERROR | 행 집계 — 대조표 4 'spdMain.CellDoubleClick' 의 F4 3요소: PASS:2 · ERROR:1 |  |
| T-b34f56ba | E3 | 4 · spdMain.CellDoubleClick | PASS | ERROR | 행 집계 — 대조표 4 'spdMain.CellDoubleClick' 의 E3 5요소: PASS:4 · ERROR:1 |  |
| T-98fd0a74 | F4 | 5 · spdMain.ClipboardPasted | PASS | ERROR | 행 집계 — 대조표 5 'spdMain.ClipboardPasted' 의 F4 3요소: PASS:2 · ERROR:1 |  |
| T-3a3a3345 | X-LOC | 6 · spdMain.TopChange | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-b2cb7c1c | F4 | 6 · spdMain.TopChange | PASS | ERROR | 행 집계 — 대조표 6 'spdMain.TopChange' 의 F4 3요소: PASS:2 · ERROR:1 |  |
| T-76d10177 | X-LOC | 7 · MSG00004 | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-452674bd | F4 | 7 · MSG00004 | PASS | ERROR | 행 집계 — 대조표 7 'MSG00004' 의 F4 3요소: PASS:2 · ERROR:1 |  |
| T-fffd61a7 | E3 | 7 · MSG00004 | PASS | ERROR | 행 집계 — 대조표 7 'MSG00004' 의 E3 5요소: PASS:4 · ERROR:1 |  |
| T-81e3aa3f | X-LOC | 8 · (없음) | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-e0d5579b | F4 | 8 · (없음) | PASS | ERROR | 행 집계 — 대조표 8 '(없음)' 의 F4 3요소: PASS:2 · ERROR:1 |  |
| T-1b44aeab | E3 | 8 · (없음) | PASS | ERROR | 행 집계 — 대조표 8 '(없음)' 의 E3 5요소: PASS:4 · ERROR:1 |  |
| T-a2f1b4a4 | X-LOC | 9 · (없음, GMessageBoxForException) | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-65aed8b5 | F4 | 9 · (없음, GMessageBoxForException) | PASS | ERROR | 행 집계 — 대조표 9 '(없음, GMessageBoxForException)' 의 F4 3요소: PASS:2 · ERROR:1 |  |
| T-d131dbf6 | E3 | 9 · (없음, GMessageBoxForException) | PASS | ERROR | 행 집계 — 대조표 9 '(없음, GMessageBoxForException)' 의 E3 5요소: PASS:4 · ERROR:1 |  |
| T-4475d612 | X-LOC | 10 · MSG00049 | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-5a02e537 | F3 | SCP0131 화면 | NA | ERROR | 붙여넣기 프로브 전제 부족(기존행 true · 신규행 false) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-2ca7a123 | C3 | TO_YYYYMMDD / Valid To | NA | ERROR | TO_YYYYMMDD 연쇄 원천 컬럼 해석 불가 — AS-IS SpdMain_EditChange:1004 siMain.SetValue(e.Row, siMain.GetColumnIn |  |
| T-f70fdb29 | F4 | 10 · MSG00049 | PASS | ERROR | 행 집계 — 대조표 10 'MSG00049' 의 F4 3요소: PASS:2 · ERROR:1 |  |
| T-199ef21e | E4 | TO_YYYYMMDD / Valid To | NA | ERROR | MSG00049 — SpdMain_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain_EditChange) |  |
| T-5cc952a8 | E4 | MSG00049 | NA | ERROR | MSG00049 — SpdMain_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain_EditChange) |  |
| T-9a318b65 | X-LOC | 11 · MSG00219 | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-846bf895 | C2 | TO_YYYYMMDD / Valid To | NA | ERROR | TO_YYYYMMDD 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) |  |
| T-df84665b | C6 | TO_YYYYMMDD / Valid To | NA | ERROR | TO_YYYYMMDD 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) ／ [미검증]  |  |
| T-eeb08d85 | F4 | 11 · MSG00219 | PASS | ERROR | 행 집계 — 대조표 11 'MSG00219' 의 F4 3요소: PASS:2 · ERROR:1 |  |
| T-6343c81c | X-LOC | 12 · MSG00049 | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-d6f6fa0c | F4 | 12 · MSG00049 | PASS | ERROR | 행 집계 — 대조표 12 'MSG00049' 의 F4 3요소: PASS:2 · ERROR:1 |  |
| T-c7d5c219 | E4 | FROM_YYYYMMDD / Valid From | NA | ERROR | MSG00049 — SpdMain_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain_EditChange) |  |
| T-6f992021 | D1 | 2 · cboDivision.SelectedIndexChanged | PASS | ERROR | 행 집계 — 대조표 2 'cboDivision.SelectedIndexChanged' 의 D1 9요소: PASS:7 · NA:1 · ERROR:1 |  |
| T-93f32274 | H6 | 4 · spdMain.CellDoubleClick | PASS | ERROR | 행 집계 — 대조표 4 'spdMain.CellDoubleClick' 의 H6 8요소: PASS:7 · ERROR:1 |  |
| T-731746d6 | G5 | 4 · spdMain.CellDoubleClick | NA | ERROR | 행 집계 — 대조표 4 'spdMain.CellDoubleClick' 의 G5 8요소: NA:7 · ERROR:1 |  |
| T-b810243e | H6 | 5 · spdMain.ClipboardPasted | PASS | ERROR | 행 집계 — 대조표 5 'spdMain.ClipboardPasted' 의 H6 8요소: PASS:7 · ERROR:1 |  |
| T-24b0e192 | G5 | 5 · spdMain.ClipboardPasted | NA | ERROR | 행 집계 — 대조표 5 'spdMain.ClipboardPasted' 의 G5 8요소: NA:7 · ERROR:1 |  |
| T-4fae7e10 | D1 | 5 · spdMain.ClipboardPasted | PASS | ERROR | 행 집계 — 대조표 5 'spdMain.ClipboardPasted' 의 D1 9요소: PASS:7 · NA:1 · ERROR:1 |  |
| T-c4f71674 | X-LOC | - · InsertButton override 본문 | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-e0b41a51 | D4 | DIVISION_ID / Division | NA | ERROR | 신규행 DIVISION_ID='81' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움: 의도 확인(연쇄 C3/팝업 M4 |  |
| T-ce11c59b | G4 | - · InsertButton override 본문 | PASS | ERROR | 행 집계 — 대조표 - 'InsertButton override 본문' 의 G4 3요소: PASS:2 · ERROR:1 |  |
| T-35cbed20 | D4 | VALID_YN / Valid | NA | ERROR | 신규행 VALID_YN='Y' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움: 의도 확인(연쇄 C3/팝업 M4 결과일 |  |
| T-c4fa5910 | C1 | cboDivision / Division / Div / Div. | NA | ERROR | 'Div' → '40 Mobility & IT Battery' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 ClbDivision_SelectedIndexCha |  |
| T-63c1fc4f | C3 | OPMZ_PLAN_GR_ID / Plan Group | NA | ERROR | OPMZ_PLAN_GR_ID 연쇄 원천 컬럼 해석 불가 — AS-IS SpdMain_ClipboardPasted:1058 if (siMain.ActiveSheet.Cells[iRo |  |
| T-78d956a8 | D1 | SwitchLock(374) · lock(영역1) | PASS | ERROR | 행 집계 — 대조표 SwitchLock(374) 'lock(영역1)' 의 D1 9요소: PASS:7 · NA:1 · ERROR:1 |  |
