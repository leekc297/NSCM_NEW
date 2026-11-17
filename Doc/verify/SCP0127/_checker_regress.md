# 검사기 회귀 대조 SCP0127 — 기준 2026-11-06 19:43 (1620행) ↔ 현재 2026-11-14 19:21 (1743행)

- 악화(기준 비FAIL → 현재 FAIL): **5** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 9 · 그 외 변경: 253 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 32 · 새 행 155
- 승격 대기(received): Doc\verify\_checker_golden\SCP0127.received.csv — 확인 뒤 `checker_regress.py SCP0127 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-b2ba2199 | F2 | SCP0127 시나리오 [자동] 기존행 수정 + 신규행 동시 Save 1회 → 요청에 M·I | ERROR | FAIL | [자동] 기존행 수정 + 신규행 동시 Save 1회 → 요청에 M·I: 저장 요청 없음(화면 문구 'Material by DivisionDiv​Operation Group​Mate |  |
| V-7c59138f | D1 | main.TYPE_APPLY_DAY (Day*) | NA | FAIL | [화면 오류] 신규행 r0 TYPE_APPLY_DAY 셀 편집 시작 시 편집기 생성 오류 — TYPE_APPLY_DAY: ** Assertion failed in Wijmo: Nu |  |
| V-c85fd492 | K3 | [DMF0020 결함 일반화] 결과 그리드 Sort/Filter(동적 주차 컬럼 W37-0817 등) | NA | FAIL | hide FAIL: 헤더(VALUE_TYPE) 우클릭 → Hide Column → 컬럼 여전히 표시 · Unhide All 복원 · 미포함: Sort/Filter·정렬 후 동작(K |  |
| V-e5c25444 | K3 | [DMF0020 결함 유형] Exchange Rate 그리드 Copy·Header Hide Column | NA | FAIL | copy PASS: 선택 0,0,0,0 · 0행 VALUE_TYPE 표시값 'MAX' · Ctrl+C 클립보드 'MAX'(일치) · 우클릭 Copy 'MAX'(일치) ／ hide  |  |
| T-90086cae | X-ROW | SCP0127_PrecedeSafetyStockDay.SpdMain_TopChange | PASS | FAIL | 진입점 집계 1검사 — FAIL:1 |  |

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-a6593ee3 | G1 | 조회조건 Plan Group | FAIL | ERROR | [멀티선택 Plan Group] 선택할 옵션 없음(후보 1) — 후보가 1개 이하라 선택 변경 검사 불가(콤보 원천 오류·데이터 없음: B1/B4·DB-SYN 참조) | 사용자(대화) |
| V-65334b39 | K3 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | FAIL | ERROR | f5 ERROR: 실행 실패: Error: 셀 좌표 확인 실패(0행 · VALUE_TYPE): DIV · 미포함: 팝업 그리드(이 시험은 메인 그리드만), Sort/Filter·정 |  |
| V-694ecd88 | L1 | 조회조건 텍스트 입력 중 그리드 | FAIL | PASS | 조회(Division ALL) 응답 164ms(요청~응답 164ms · 벽시계 1346ms) · 534행 — 기준 10초(화면 규칙 L1: 조회·저장·키 이동 응답 기준 이내) |  |
| V-d0ab9be3 | K3 | [DMF0035 결함 유형] F5 단축키 | FAIL | ERROR | f5 ERROR: 실행 실패: Error: 셀 좌표 확인 실패(0행 · VALUE_TYPE): DIV |  |
| V-025c2690 | K3 | [DMF0035 결함 유형] 조회 버튼 단축키 | FAIL | ERROR | f5 ERROR: 실행 실패: Error: 셀 좌표 확인 실패(0행 · VALUE_TYPE): DIV |  |
| T-2180ea12 | X-ROW | SCP0127_PrecedeSafetyStockDay.FindButton | FAIL | PASS | 진입점 집계 3검사 — PASS:3 |  |
| T-6d4f4de1 | X-ROW | SCP0127_PrecedeSafetyStockDay.FindData_Main | FAIL | ERROR | 진입점 집계 14검사 — PASS:10 · ERROR:3 · NA:1 |  |
| T-77e04cec | X-ROW | SCP0127_PrecedeSafetyStockDay.SpdMain_CellDoubleClick | FAIL | ERROR | 진입점 집계 19검사 — PASS:7 · NA:6 · ERROR:6 |  |
| T-2091ecef | X-ROW | SCP0127_PrecedeSafetyStockDay.btnItemId_Click | FAIL | ERROR | 진입점 집계 9검사 — PASS:4 · NA:3 · ERROR:2 |  |

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-04a557dd | F8 | SCP0127 저장 감사 필드 | NA | ERROR |  ／ [미검증] 검사기(tools/Harness/verify/save_audit.py(정리 백업 루트 행 감사 컬럼 = 저장 계정·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-087a24da | F7 | SCP0127 저장 연계 테이블 | NA | ERROR |  ／ [미검증] 검사기(tools/Harness/verify/save_audit.py(CRUD 실제 저장 정리 백업 ↔ AS-IS )가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-d6ece6ac | F6 | SCP0127 저장 행 수 불변 | ERROR | PASS | 수정 저장 1회 DB 전후 대조 — SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY(키 DIVISION_ID,SCM_SITE_ID,OPMZ_PLAN_GR_ID,STAG |  |
| V-34580e4e | F8 | SCP0127 수정 감사 컬럼 | ERROR | PASS | 변경 행 1 감사 컬럼 대조: Created 불변 · Updated 갱신 · 수정자=저장 계정 |  |
| V-8a5762d8 | F6 | SCP0127 다른 셀 편집 값 유지 | ERROR | PASS | VALUE_TYPE 편집 뒤 TYPE_APPLY_DAY '7' 유지 |  |
| V-1d8e9d97 | F3 | SCP0127 시나리오 [자동] OPMZ_PLAN_GR_ID 신규 행 콤보 붙여넣기 — 후보 값 반영 | 판정필요 | PASS | [자동] OPMZ_PLAN_GR_ID 신규 행 콤보 붙여넣기 — 후보 값 반영: 기대대로 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청11 → in |  |
| V-815a4900 | F3 | SCP0127 시나리오 [자동] SCM_SITE_ID 신규 행 콤보 붙여넣기 — 후보 값 반영 | 판정필요 | PASS | [자동] SCM_SITE_ID 신규 행 콤보 붙여넣기 — 후보 값 반영: 기대대로 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청11 → insert |  |
| V-5b251894 | F3 | SCP0127 시나리오 [자동] STAGE 신규 행 콤보 붙여넣기 — 후보 값 반영 | 판정필요 | PASS | [자동] STAGE 신규 행 콤보 붙여넣기 — 후보 값 반영: 기대대로 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청11 → insert:534행· |  |
| V-b43681b8 | E2 | SCP0127 기간 칸 글자 입력 | NA | PASS | 기간 칸 글자 입력 거부 — '2026.11.09' → '2026.11.09' |  |
| V-cc3442e9 | E2 | SCP0127 기간 역전 조회 | NA | ERROR | [측정 경로 없음] 기간을 뒤집어 넣지 못함 · 대조군도 안 들어감(From '2026.11.09' · To '2027.11.08') |  |
| V-be4291fe | A5 | SCP0127 Division 컬럼 40/PRECEDE / SAFETY STOCK DAY | PASS | ERROR | PRECEDE / SAFETY STOCK DAY · [측정 경로 없음] 시트 'PRECEDE / SAFETY STOCK DAY' 그리드를 화면에서 확정 못 함 — 보이는 그리드:  |  |
| V-2380654f | A5 | SCP0127 Division 컬럼 81/PRECEDE / SAFETY STOCK DAY | PASS | ERROR | PRECEDE / SAFETY STOCK DAY · [측정 경로 없음] 시트 'PRECEDE / SAFETY STOCK DAY' 그리드를 화면에서 확정 못 함 — 보이는 그리드:  |  |
| V-321cb6bf | A5 | SCP0127 Division 컬럼 82/PRECEDE / SAFETY STOCK DAY | PASS | ERROR | PRECEDE / SAFETY STOCK DAY · [측정 경로 없음] 시트 'PRECEDE / SAFETY STOCK DAY' 그리드를 화면에서 확정 못 함 — 보이는 그리드:  |  |
| V-774c60c6 | E4 | SCP0127 키 중복 신규행 | ERROR | PASS | main · 저장 전 차단 '신규 입력 데이터 중 중복된 데이터가 있습니다.' |  |
| V-ac62f20c | A7 | SCP0127_GET_SEARCH_INFO | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-ddf1ef4a | A7 | SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-f7b44616 | B7 | 조회조건 Div | NA | ERROR | 판정필요: (a) 저장 SP SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY 대상 SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY 와 콤보 원천 1 |  |
| V-9f87b220 | C1 | 조회조건 Div | NA | ERROR | 상속(TRACE T-c478530d): 'Div' → '40 Mobility & IT Battery' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 ClbDiv |  |
| V-1e4b99b9 | B3 | 조회조건 Plan Group | NA | ERROR | [화면 초기(선택 Div=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-1b55d6cd | B4 | 조회조건 Plan Group | NA | ERROR | [화면 초기(선택 Div=81)] AS-IS 원천 실행 불가 — 'dtPlanGroup 원천 대입 미발견(필드 초기화·외부 주입 확인)' · 원천 - · 표현 - → 기계 판정 불 |  |
| V-ee231d54 | B7 | 조회조건 Plan Group | NA | ERROR | 판정필요: (a) 저장 SP SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY 대상 SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY 와 콤보 원천 1 |  |
| V-01a989f3 | G4 | 조회조건 Plan Group | PASS | NA | 조회조건 순서는 판정 대상 제외(CR-098 · 사용자 지시 2026-11-09 — Excel 대조는 사용여부·EDIT 형태까지만) · 참고 원 판정: 조회조건 순서가 기준표(CR |  |
| V-4575ebc0 | G7 | 조회조건 Plan Group | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1) G7 — AS-IS 컨트롤 표시 열(CControl.setListBox·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-7b647e98 | B3 | 조회조건 SCM Site | NA | ERROR | [화면 초기(선택 Div=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-3e960c1b | B4 | 조회조건 SCM Site | NA | ERROR | [화면 초기(선택 Div=81)] AS-IS 원천 실행 불가 — 'dtScmSite 원천 대입 미발견(필드 초기화·외부 주입 확인)' · 원천 - · 표현 - → 기계 판정 불가  |  |
| V-f46335ba | B7 | 조회조건 SCM Site | NA | ERROR | 판정필요: (a) 저장 SP SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY 대상 SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY 와 콤보 원천 1 |  |
| V-67f0db41 | G7 | 조회조건 SCM Site | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1) G7 — AS-IS 컨트롤 표시 열(CControl.setListBox·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-c6e3a4d5 | B3 | 조회조건 Stage | NA | ERROR | [화면 초기(선택 Div=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-b16b10d4 | B4 | 조회조건 Stage | NA | ERROR | [화면 초기(선택 Div=81)] AS-IS 원천 실행 불가 — 'dtStage 원천 대입 미발견(필드 초기화·외부 주입 확인)' · 원천 - · 표현 - → 기계 판정 불가 —  |  |
| V-fd593af5 | B7 | 조회조건 Stage | NA | ERROR | 판정필요: (a) 저장 SP SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY 대상 SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY 와 콤보 원천 1 |  |
| V-d3b0c25b | G7 | 조회조건 Stage | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1) G7 — AS-IS 컨트롤 표시 열(CControl.setListBox·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-1afe7a0b | G2 | 조회조건 Model/Nickname | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_verify.spec( |  |
| V-5d949b97 | G5 | 조회조건 Model/Nickname | NA | ERROR |  ／ [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [ |  |
| V-be4e0c36 | B3 | 조회조건 Type | NA | ERROR | [화면 초기(선택 Div=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-b9748b80 | B4 | 조회조건 Type | NA | ERROR | [화면 초기(선택 Div=81)] AS-IS 원천 실행 불가 — 'dtType 원천 대입 미발견(필드 초기화·외부 주입 확인)' · 원천 - · 표현 - → 기계 판정 불가 — 수 |  |
| V-c54a0b0a | B7 | 조회조건 Type | NA | ERROR | 판정필요: (a) 저장 SP SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY 대상 SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY 와 콤보 원천 1 |  |
| V-c763c3ef | G7 | 조회조건 Type | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1) G7 — AS-IS 컨트롤 표시 열(CControl.setListBox·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-83220f59 | G1 | 조회조건 Period | ERROR | NA | Period 콤보 아님(period) — 멀티선택 검사 대상 아님 |  |
| V-dcb89f72 | G2 | 조회조건 Period | NA | PASS | E2E smoke 조회조건 'Period' [OK] 기간 '2026.11.09' ~ '2027.11.08' → 조회 정상 — ALL/다중 사양은 @verify G2 미실행(6개 초 |  |
| V-134963e6 | G8 | 조회조건 Period | NA | ERROR | 'Period' 과 같은 이름의 결과 컬럼 없음(후보 Period · Period Code · Period Name · Period ID) — 결과 대조 불가(조건 ↔ 컬럼 대응  |  |
| V-36616078 | B3 | 조회조건 Active | NA | ERROR | [화면 초기(선택 Div=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-18ab60a9 | B4 | 조회조건 Active | NA | ERROR | [화면 초기(선택 Div=81)] AS-IS 원천 미발견(combo_src 에 이 대상 바인딩 없음) · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W |  |
| V-e512c105 | B7 | 조회조건 Active | NA | ERROR | 판정필요: (a) 저장 SP SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY 대상 SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY 와 콤보 원천 1 |  |
| V-430c3b07 | G7 | 조회조건 Active | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1) G7 — AS-IS 컨트롤 표시 열(CControl.setListBox·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-714c4b6b | D1 | main.VALUE_TYPE (Type*) | NA | ERROR | 신규행 r0 VALUE_TYPE 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확 |  |
| V-67a777a0 | D1 | main.VALUE_TYPE (Type*) | NA | ERROR | 기존행 r0 VALUE_TYPE 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확 |  |
| V-ccfb9ca1 | B3 | main.VALUE_TYPE (Type*) | NA | ERROR | [신규행(DIVISION_ID=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-ea149b7a | B4 | main.VALUE_TYPE (Type*) | NA | ERROR | [신규행(DIVISION_ID=81)] AS-IS 원천 미발견(combo_src 에 이 대상 바인딩 없음) · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원 |  |
| V-d1f8bb33 | A2 | main.VALUE_TYPE (Type*) | ERROR | PASS | VALUE_TYPE: 원값 'MAX' → 표시 'MAX' (이름 'MAX') · AS-IS 조회 시점 코드(TextCell · 콤보는 Insert/Edit 때만) |  |
| V-63594f20 | E5 | main.VALUE_TYPE (Type*) | ERROR | PASS | VALUE_TYPE: 목록 밖 'ZZ_E2E_NOT_IN_LIST' 입력 → 값 'MIN' |  |
| V-adb7652c | H2 | main.VALUE_TYPE (Type*) | ERROR | PASS | VALUE_TYPE: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-3145b171 | D1 | main.DIVISION_ID (Div*) | NA | ERROR | 신규행 r0 DIVISION_ID 편집=false — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 |  |
| V-cc4e0c1d | D1 | main.DIVISION_ID (Div*) | NA | ERROR | 기존행 r0 DIVISION_ID 편집=false — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 |  |
| V-b63ede6c | H2 | main.DIVISION_ID (Div*) | ERROR | PASS | DIVISION_ID: 기존행 편집=false 표시 일치 · 신규행 편집=false 표시 일치 |  |
| V-14ab9e51 | D1 | main.OPMZ_PLAN_GR_ID (Plan Group*) | NA | ERROR | 신규행 r0 OPMZ_PLAN_GR_ID 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬 |  |
| V-b3d335a6 | D1 | main.OPMZ_PLAN_GR_ID (Plan Group*) | NA | ERROR | 기존행 r0 OPMZ_PLAN_GR_ID 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬 |  |
| V-e6b3efd4 | B3 | main.OPMZ_PLAN_GR_ID (Plan Group*) | NA | ERROR | [신규행(DIVISION_ID=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-3022f4f4 | B4 | main.OPMZ_PLAN_GR_ID (Plan Group*) | NA | ERROR | [신규행(DIVISION_ID=81)] AS-IS 원천 실행 불가 — 'dtPlanGroup 원천 대입 미발견(필드 초기화·외부 주입 확인)' · 원천 - · 표현 - → 기계 판 |  |
| V-2b94640a | A2 | main.OPMZ_PLAN_GR_ID (Plan Group*) | ERROR | PASS | OPMZ_PLAN_GR_ID: 원값 'PG0001' → 표시 'E129A_E128A' (이름 'E129A_E128A') · AS-IS 조회 시점 코드(TextCell · 콤보는 I |  |
| V-a4f7deea | E5 | main.OPMZ_PLAN_GR_ID (Plan Group*) | ERROR | PASS | OPMZ_PLAN_GR_ID: 목록 밖 'ZZ_E2E_NOT_IN_LIST' 입력 → 값 'PG0001' |  |
| V-8fe0942a | D5 | main.OPMZ_PLAN_GR_ID (Plan Group*) | ERROR | PASS | OPMZ_PLAN_GR_ID: AS-IS COMBO ↔ TO-BE dataType=String · dataMap=Y |  |
| V-2c16ab6c | H2 | main.OPMZ_PLAN_GR_ID (Plan Group*) | ERROR | PASS | OPMZ_PLAN_GR_ID: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-607c293d | D1 | main.SCM_SITE_ID (SCM site*) | NA | ERROR | 신규행 r0 SCM_SITE_ID 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면  |  |
| V-aec014ec | D1 | main.SCM_SITE_ID (SCM site*) | NA | ERROR | 기존행 r0 SCM_SITE_ID 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면  |  |
| V-5a67b3f1 | B3 | main.SCM_SITE_ID (SCM site*) | NA | ERROR | [신규행(DIVISION_ID=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-ca2185bc | B4 | main.SCM_SITE_ID (SCM site*) | NA | ERROR | [신규행(DIVISION_ID=81)] AS-IS 원천 미발견(combo_src 에 이 대상 바인딩 없음) · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원 |  |
| V-bc61f9e7 | A2 | main.SCM_SITE_ID (SCM site*) | ERROR | PASS | SCM_SITE_ID: 원값 'WA00-A' → 표시 'WA00-A' (이름 'WA00-A') · AS-IS 조회 시점 코드(TextCell · 콤보는 Insert/Edit 때만) |  |
| V-b675cc28 | E5 | main.SCM_SITE_ID (SCM site*) | ERROR | PASS | SCM_SITE_ID: 목록 밖 'ZZ_E2E_NOT_IN_LIST' 입력 → 값 'AC00-A' |  |
| V-7f23c498 | H2 | main.SCM_SITE_ID (SCM site*) | ERROR | PASS | SCM_SITE_ID: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-27d0af67 | D1 | main.ITEM_ID (Model*) | NA | ERROR | 신규행 r0 ITEM_ID 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규 |  |
| V-e6d2a829 | D1 | main.ITEM_ID (Model*) | NA | ERROR | 기존행 r0 ITEM_ID 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규 |  |
| V-15592311 | H2 | main.ITEM_ID (Model*) | ERROR | PASS | ITEM_ID: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-acabf1fc | D1 | main.STAGE (Stage*) | NA | ERROR | 신규행 r0 STAGE 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으 |  |
| V-c8f746e1 | D1 | main.STAGE (Stage*) | NA | ERROR | 기존행 r0 STAGE 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으 |  |
| V-5016e015 | B3 | main.STAGE (Stage*) | NA | ERROR | [신규행(DIVISION_ID=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-5955897b | B4 | main.STAGE (Stage*) | NA | ERROR | [신규행(DIVISION_ID=81)] AS-IS 원천 미발견(combo_src 에 이 대상 바인딩 없음) · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원 |  |
| V-52eb466c | A2 | main.STAGE (Stage*) | ERROR | PASS | STAGE: 원값 'ASSY' → 표시 'ASSY' (이름 'ASSY') · AS-IS 조회 시점 코드(TextCell · 콤보는 Insert/Edit 때만) |  |
| V-3225e5f6 | E5 | main.STAGE (Stage*) | ERROR | PASS | STAGE: 목록 밖 'ZZ_E2E_NOT_IN_LIST' 입력 → 값 'ASSY' |  |
| V-0026c117 | H2 | main.STAGE (Stage*) | ERROR | PASS | STAGE: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-e6b6c2ee | D1 | main.FROM_YYYYMMDD (Valid From*) | 판정필요 | ERROR | 신규행 r0 FROM_YYYYMMDD 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이 |  |
| V-1e9177ce | D1 | main.FROM_YYYYMMDD (Valid From*) | NA | ERROR | 기존행 r0 FROM_YYYYMMDD 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이 |  |
| V-99a5021d | D5 | main.FROM_YYYYMMDD (Valid From*) | ERROR | PASS | FROM_YYYYMMDD: AS-IS DATE ↔ TO-BE dataType=Date · dataMap=N · editor · format=yyyy-MM-dd |  |
| V-9bc03409 | E2 | main.FROM_YYYYMMDD (Valid From*) | ERROR | PASS | 신규행 r0 FROM_YYYYMMDD: '2026-10-33' 입력 → 값 '2099-12-30T15:00:00.000Z' (입력 전 '2099-12-30T15:00:00.000Z |  |
| V-c1df84df | H2 | main.FROM_YYYYMMDD (Valid From*) | ERROR | PASS | FROM_YYYYMMDD: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-7afa3bc4 | D1 | main.TO_YYYYMMDD (Valid To*) | 판정필요 | ERROR | 신규행 r0 TO_YYYYMMDD 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면  |  |
| V-35882f43 | D1 | main.TO_YYYYMMDD (Valid To*) | NA | ERROR | 기존행 r0 TO_YYYYMMDD 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면  |  |
| V-11d266ea | D5 | main.TO_YYYYMMDD (Valid To*) | ERROR | PASS | TO_YYYYMMDD: AS-IS DATE ↔ TO-BE dataType=Date · dataMap=N · editor · format=yyyy-MM-dd |  |
| V-c0756d5a | E2 | main.TO_YYYYMMDD (Valid To*) | ERROR | PASS | 신규행 r0 TO_YYYYMMDD: '2026-10-33' 입력 → 값 '2099-12-30T15:00:00.000Z' (입력 전 '2099-12-30T15:00:00.000Z') |  |
| V-cb18f5c9 | H2 | main.TO_YYYYMMDD (Valid To*) | ERROR | PASS | TO_YYYYMMDD: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-dedb398a | D1 | main.TYPE_APPLY_DAY (Day*) | NA | ERROR | 기존행 r0 TYPE_APPLY_DAY 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼 |  |
| V-cd226197 | D5 | main.TYPE_APPLY_DAY (Day*) | ERROR | PASS | TYPE_APPLY_DAY: AS-IS NUMBER ↔ TO-BE dataType=Number · dataMap=N · editor |  |
| V-0904a747 | H2 | main.TYPE_APPLY_DAY (Day*) | ERROR | PASS | TYPE_APPLY_DAY: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-286fa147 | H13 | main.TYPE_APPLY_DAY (Day*) | NA | PASS | TYPE_APPLY_DAY r0 값 '-1' 글자색 rgb(165, 0, 52) |  |
| V-47463bb6 | D1 | main.VALUE_DESCRIPTION (Description) | NA | ERROR | 신규행 r0 VALUE_DESCRIPTION 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 |  |
| V-b9bee322 | D1 | main.VALUE_DESCRIPTION (Description) | NA | ERROR | 기존행 r0 VALUE_DESCRIPTION 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 |  |
| V-0e0d9300 | H2 | main.VALUE_DESCRIPTION (Description) | ERROR | PASS | VALUE_DESCRIPTION: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-3a5f1b26 | D1 | main.VALID_YN (Active) | NA | ERROR | 신규행 r0 VALID_YN 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정  |  |
| V-75559974 | D1 | main.VALID_YN (Active) | NA | ERROR | 기존행 r0 VALID_YN 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정  |  |
| V-52d17a80 | B3 | main.VALID_YN (Active) | NA | ERROR | [신규행(DIVISION_ID=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-b8af10af | B4 | main.VALID_YN (Active) | NA | ERROR | [신규행(DIVISION_ID=81)] AS-IS 원천 미발견(combo_src 에 이 대상 바인딩 없음) · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원 |  |
| V-2b93ad7c | A2 | main.VALID_YN (Active) | ERROR | PASS | VALID_YN: 원값 'Y' → 표시 'Y' (이름 'Y') · AS-IS 조회 시점 코드(TextCell · 콤보는 Insert/Edit 때만) |  |
| V-efa5ea78 | E5 | main.VALID_YN (Active) | ERROR | PASS | VALID_YN: 목록 밖 'ZZ_E2E_NOT_IN_LIST' 입력 → 값 'Y' |  |
| V-a5c6bdde | H2 | main.VALID_YN (Active) | ERROR | PASS | VALID_YN: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-b6102ea1 | D1 | main.CREATED_BY (Create By) | NA | ERROR | 신규행 r0 CREATED_BY 편집=false — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면  |  |
| V-0c714c96 | D1 | main.CREATED_BY (Create By) | NA | ERROR | 기존행 r0 CREATED_BY 편집=false — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면  |  |
| V-151ae92e | H2 | main.CREATED_BY (Create By) | ERROR | PASS | CREATED_BY: 기존행 편집=false 표시 일치 · 신규행 편집=false 표시 일치 |  |
| V-8102c501 | D1 | main.CREATION_DATE (Creation Date) | NA | ERROR | 신규행 r0 CREATION_DATE 편집=false — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼 |  |
| V-8fc890da | D1 | main.CREATION_DATE (Creation Date) | NA | ERROR | 기존행 r0 CREATION_DATE 편집=false — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼 |  |
| V-d5e273b4 | H2 | main.CREATION_DATE (Creation Date) | ERROR | PASS | CREATION_DATE: 기존행 편집=false 표시 일치 · 신규행 편집=false 표시 일치 |  |
| V-1dd3cd9f | D1 | main.LAST_UPDATED_BY (Last Update By) | NA | ERROR | 신규행 r0 LAST_UPDATED_BY 편집=false — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설  |  |
| V-b906f93a | D1 | main.LAST_UPDATED_BY (Last Update By) | NA | ERROR | 기존행 r0 LAST_UPDATED_BY 편집=false — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설  |  |
| V-598bc265 | H2 | main.LAST_UPDATED_BY (Last Update By) | ERROR | PASS | LAST_UPDATED_BY: 기존행 편집=false 표시 일치 · 신규행 편집=false 표시 일치 |  |
| V-65f8fe37 | D1 | main.LAST_UPDATE_DATE (Last Update Date) | NA | ERROR | 신규행 r0 LAST_UPDATE_DATE 편집=false — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 |  |
| V-6752ed2c | D1 | main.LAST_UPDATE_DATE (Last Update Date) | NA | ERROR | 기존행 r0 LAST_UPDATE_DATE 편집=false — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 |  |
| V-969ea6a6 | H2 | main.LAST_UPDATE_DATE (Last Update Date) | ERROR | PASS | LAST_UPDATE_DATE: 기존행 편집=false 표시 일치 · 신규행 편집=false 표시 일치 |  |
| V-a6a77b26 | G1 | SCP0127 텍스트 부분일치 Period | NA | ERROR |  ／ [미검증] 검사기(smoke 조회조건 동작·_verify)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(smoke 조회조건 동작 |  |
| V-c11e24ba | MS1 | MSG00046 | NA | ERROR | AS-IS MSG00046 '삭제할 데이터가 없습니다.' → 같은 문구의 TO-BE ID MSG01078 '삭제할 데이터가 없습니다.' — [AS-IS] MSG00046 '삭제할  |  |
| V-e86e5205 | M3 | new SCM0002_MaterialByDivisionPopup() | NA | PASS | AS-IS 팝업 문장 'new SCM0002_MaterialByDivisionPopup()' → 팝업 SCM0002_MaterialByDivisionPopup 의 규칙 M3 실측  |  |
| V-2bc86eaa | H6 | popItem.Form_Load(multiSelect, division, operation_group, sI | NA | PASS | 팝업 버튼 [Open, Search, OK, Close] · 첫 컬럼 'No' · 건수 Y |  |
| V-b3bdf91c | G5 | new SCM0002_MaterialByDivisionPopup() | ERROR | NA | 인자 없는 팝업 문장 — 팝업 인자 판정은 [V-866907ce] popItem.Form_Load(true, division, operation_group, sItemId,  에서 |  |
| V-9fe86da2 | M3 | new SCM0002_MaterialByDivisionPopup() | NA | PASS | AS-IS 팝업 문장 'new SCM0002_MaterialByDivisionPopup()' → 팝업 SCM0002_MaterialByDivisionPopup 의 규칙 M3 실측  |  |
| V-1cc95739 | H6 | popItem.Form_Load(true, division, operation_group, sItemId,  | NA | PASS | AS-IS 팝업 문장 'popItem.Form_Load(true, division, operation_group,' → 팝업 SCM0002_MaterialByDivisionPopu |  |
| V-92f4d8f8 | G5 | popItem.ShowDialog() | ERROR | NA | 인자 없는 팝업 문장 — 팝업 인자 판정은 [V-866907ce] popItem.Form_Load(true, division, operation_group, sItemId,  에서 |  |
| V-ebc6e753 | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-9c75a366 | H7 | Excel Download 양식(공통 모듈) | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['DELETE', 'INSERT', 'SAVE', 'SEARCH'] · plan.buttons ['Button1']) |  |
| V-9b14162b | B3 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | NA | ERROR | 규칙 B3 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-7b647e98] 조회조건 SCM Site: [화면 초기(선택 Div=81)]  · 원천 - · 표현  |  |
| V-188e25d6 | B4 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-7de7bac9 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | NA | ERROR | ctrl PASS: Ctrl+클릭 0행·2행(VALUE_TYPE) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함:  |  |
| V-52bb0a94 | G2 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | NA | ERROR | 규칙 G2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-1afe7a0b] 조회조건 Model/Nickname:  ／ [미검증] 검사기(_verify.spec( |  |
| V-8d9d831a | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/ | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-14fe6f24 | E6 | 텍스트 입력 컨트롤(TEXT BOX · FPText) 마우스 드래그 선택 후 Delete/Backspace | PASS | NA | 직접 실측 없음 — 같은 규칙 E6 의 다른 대상 2행 PASS 는 이 결함의 근거가 아님 · 참고 [V-15a977b0] SCP0127 화면 ／ [V-927fe2f4] SCP01 |  |
| V-f5495974 | C2 | [DMF0007 결함 유형] 그리드 End Customer→Sales Site cascade | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-e8a1fb05] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-91e52a82 | B4 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-8c28ecee | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-71dd161e | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY 대상 SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY 와 콤보 원천 1 |  |
| V-c1e07a3f | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-fa81f68b | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY 대상 SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY 와 콤보 원천 1 |  |
| V-950a8e36 | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-d1445042 | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY 대상 SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY 와 콤보 원천 1 |  |
| V-15b51abc | K3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | NA | ERROR | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,0, |  |
| V-1e52e336 | B4 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-b95ec724 | D1 | [DMF0020 결함 유형] Team·End Customer 컬럼 | PASS | ERROR | 규칙 D1 판정 6행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-607c293d] main.SCM_SITE_ID (SCM site*): 신규행 r0 SCM_SITE_I |  |
| V-c86b12bc | C3 | [DMF0020 결함 유형] Team·End Customer 컬럼 | NA | ERROR | 규칙 C3 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-97de7df0] ITEM_ID / Model: ITEM_ID 연쇄 원천 컬럼 해석 불가 — AS-IS |  |
| V-e4cf96fb | B4 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-2c1fff7b | C2 | [DMF0005 결함 일반화] 그리드 Sales Company→Sales Plant · Sales Site→ | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-e8a1fb05] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-4fd77e9c | C2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | NA | ERROR | 규칙 C2 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [T-8d7afd3c] OPMZ_PLAN_GR_ID / Plan Group: OPMZ_PLAN_GR_ID 연 |  |
| V-b81bef64 | C2 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Acti | NA | ERROR | 규칙 C2 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [T-8d7afd3c] OPMZ_PLAN_GR_ID / Plan Group: OPMZ_PLAN_GR_ID 연 |  |
| V-0de31edc | B4 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-069f320a | B5 | [DMF0003 결함 유형] Measure 콤보(입력 가능 Measure) | NA | ERROR | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-e3f52f93 | C2 | [DMF0003 결함 유형] Measure 콤보(입력 가능 Measure) | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-e8a1fb05] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-b461edff | C2 | [DMF0003 결함 유형] AS From Site 입력 후 W35~W38 수량 | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-e8a1fb05] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-5a218dae | G5 | [DMF0003 결함 유형] Model 팝업(sMdmActive_Sw) | PASS | ERROR | 규칙 G5 판정 6행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-5d949b97] 조회조건 Model/Nickname:  ／ [미검증] 검사기(popup_args_ch |  |
| V-ce7a91fe | B5 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | NA | ERROR | 규칙 B5 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-90b3b8c9 | A2 | [DMF0082 결함 유형] Cell Prod Site 셀 | ERROR | PASS | 규칙 A2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-bc61f9e7] main.SCM_SITE_ID (SCM site*): SCM_SITE_ID: 원값 ' |  |
| V-049c5d30 | A5 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST A | NA | ERROR | 규칙 A5 판정 28행 중 FAIL 0 · 판정필요 0 · 미검증 26 — [AD-acdc5606] SCP0127 SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY |  |
| V-fbbe13f2 | B4 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-9b9062ca | G2 | [DMF0042 결함 일반화] 조회조건 Item Type | NA | ERROR | 규칙 G2 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-1afe7a0b] 조회조건 Model/Nickname:  ／ [미검증] 검사기(_verify.spec( |  |
| V-1505650f | G7 | [DMF0042 결함 일반화] 조회조건 Item Type | NA | ERROR | 규칙 G7 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-c763c3ef] 조회조건 Type:  ／ [미검증] 검사기(combo_oracle.py(W1) G7  |  |
| V-1fd605eb | G4 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | PASS | NA | 규칙 G4 대상 일치 1행이 모두 NA — [V-01a989f3] 조회조건 Plan Group: 조회조건 순서는 판정 대상 제외(CR-098 · 사용자 지시 2026-11-09 — |  |
| V-0a61c96f | H6 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회 | NA | PASS | 규칙 H6 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2bc86eaa] popItem.Form_Load(multiSelect, division, operat |  |
| V-d41a2d96 | D1 | [DMF0049 결함 유형] Cell Model·Cell Model Info 컬럼 | PASS | ERROR | 규칙 D1 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-27d0af67] main.ITEM_ID (Model*): 신규행 r0 ITEM_ID 편집=true — |  |
| V-30f7f3c8 | G1 | [DMF0020 결함 유형] Biz.Type 조회조건 | ERROR | PASS | 규칙 G1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-340d0fd8] 조회조건 Type: [단일선택 Type] 'ALL' → 534행 ／ 'MIN' → 1 |  |
| V-ada28564 | K3 | [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | NA | ERROR | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,0, |  |
| V-61323271 | E6 | [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | NA | ERROR | ime NA: 신규행 VALUE_DESCRIPTION 선택(편집기 닫힘·포커스 DIV.wj-cell wj-align-left cell-cha) → IME 조합 '한글' → 편집기  |  |
| V-890a2fbd | H7 | [DMF0074 결함 유형] Excel Form 양식 헤더 | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['DELETE', 'INSERT', 'SAVE', 'SEARCH'] · plan.buttons ['Button1']) |  |
| V-77939f46 | D5 | [SYS0003 결함 유형] Menu Type·Auth Unit 컬럼 | ERROR | PASS | 규칙 D5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-cd226197] main.TYPE_APPLY_DAY (Day*): TYPE_APPLY_DAY: AS- |  |
| V-3e4b790b | C2 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-e8a1fb05] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-98f94d1e | D1 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | NA | ERROR | 규칙 D1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-607c293d] main.SCM_SITE_ID (SCM site*): 신규행 r0 SCM_SITE_I |  |
| V-313988ef | B5 | [DMF0003 결함 유형] 신규 행 Measure 후보 | NA | ERROR | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-b6647401 | C2 | [DMF0003 결함 유형] 신규 행 Measure 후보 | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-e8a1fb05] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-906369d9 | B5 | [DMF0003 결함 유형] FCST Type 후보 | NA | ERROR | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-b9748b80] 조회조건 Type: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불가 —  |  |
| V-4cd6a7ca | B4 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-7fc81a50 | G1 | [DMF0053 결함 유형] Project·Owner 조회조건(Model/Nickname 정상) | PASS | ERROR | 규칙 G1 판정 6행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-6bf8b7d8] SCP0127 팝업 SCM0002_MaterialByDivisionPopup CON |  |
| V-ff1559fc | B5 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit | NA | ERROR | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-f3ed6407 | B4 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-54546708 | C2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-e8a1fb05] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-94112679 | B5 | [DMF0082 결함 유형] FCST Type 후보 | NA | ERROR | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-b9748b80] 조회조건 Type: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불가 —  |  |
| V-3b9de87c | B4 | [DMF0082 결함 유형] FCST Type 후보 | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-b9748b80] 조회조건 Type: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불가 —  |  |
| V-fe4e4cc2 | H7 | [DMF0021 결함 일반화] Excel Download(TEAM·FCST Type·Measure·Proje | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['DELETE', 'INSERT', 'SAVE', 'SEARCH'] · plan.buttons ['Button1']) |  |
| V-b937f65a | A2 | [DMF0021 결함 일반화] Excel Download(TEAM·FCST Type·Measure·Proje | ERROR | PASS | 규칙 A2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-d1f8bb33] main.VALUE_TYPE (Type*): VALUE_TYPE: 원값 'MAX' → |  |
| V-eb14dd46 | D1 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | NA | ERROR | 규칙 D1 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-607c293d] main.SCM_SITE_ID (SCM site*): 신규행 r0 SCM_SITE_I |  |
| V-316984fd | C3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | NA | ERROR | 규칙 C3 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-97de7df0] ITEM_ID / Model: ITEM_ID 연쇄 원천 컬럼 해석 불가 — AS-IS |  |
| V-ae6e180d | B5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | NA | ERROR | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-03629fa9 | C2 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | NA | ERROR | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-e8a1fb05] SCM_SITE_ID / SCM site: SCM_SITE_ID 연쇄 원천 해석 불가 |  |
| V-134f32b6 | B4 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-9239da3b | B5 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | NA | ERROR | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3e960c1b] 조회조건 SCM Site: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불 |  |
| V-382c4912 | B7 | [DMF0005 결함 유형] Team 조회조건 후보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY 대상 SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY 와 콤보 원천 1 |  |
| V-e5cf7fbd | G4 | [DMF0035 결함 유형] Plan Type 조회조건 위치 | PASS | NA | 규칙 G4 대상 일치 2행이 모두 NA — [V-01a989f3] 조회조건 Plan Group: 조회조건 순서는 판정 대상 제외(CR-098 · 사용자 지시 2026-11-09 — |  |
| V-ffd1bdd8 | H6 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | NA | PASS | 규칙 H6 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-0bd48c8a] SCP0127 스냅샷 팝업 Model/Nickname: [재실측 스냅샷 팝업] 기준  |  |
| V-350c78f4 | B4 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-18ab60a9] 조회조건 Active: [화면 초기(선택 Div=81)] AS-IS 원천 미발견(co |  |
| V-0165f099 | G1 | [DMF0005 결함 일반화] 텍스트 조회조건 Like 검색(Owner 팝업 User Name/EN) | ERROR | PASS | 규칙 G1 판정 5행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-1776df35] 조회조건 Model/Nickname: Model/Nickname 콤보 아님(popup |  |
| V-335036ae | D1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | NA | ERROR | 규칙 D1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-3a5f1b26] main.VALID_YN (Active): 신규행 r0 VALID_YN 편집=true |  |
| V-2c5aff82 | B4 | [SYS0006 결함 유형] API Type 조회조건 | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-b9748b80] 조회조건 Type: [화면 초기(선택 Div=81)] AS-IS 원천 실행 불가 —  |  |
| V-5d37b1fc | B4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회 | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-18ab60a9] 조회조건 Active: [화면 초기(선택 Div=81)] AS-IS 원천 미발견(co |  |
| V-85a2b1a2 | H6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회 | NA | PASS | 규칙 H6 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2bc86eaa] popItem.Form_Load(multiSelect, division, operat |  |
| V-f725b81d | G5 | [DMF0005 결함 유형] Model 팝업 조회 | PASS | ERROR | 규칙 G5 판정 6행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-5d949b97] 조회조건 Model/Nickname:  ／ [미검증] 검사기(popup_args_ch |  |
| V-3561adc5 | B5 | [SYS0012 결함 유형] 권한 신청 가능 Group 목록 | NA | ERROR | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-1b55d6cd] 조회조건 Plan Group: [화면 초기(선택 Div=81)] AS-IS 원천 실행 |  |
| V-2b7808a2 | A5 | [DMF0082 결함 유형] Project Name 컬럼 | NA | ERROR | 규칙 A5 판정 26행 중 FAIL 0 · 판정필요 0 · 미검증 26 — [AD-acdc5606] SCP0127 SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY |  |
| V-a251b403 | A5 | [DMF0082 결함 유형] BIZ PLAN 제외 컬럼(Cust Group Dtl 등 7개) | NA | ERROR | 규칙 A5 판정 26행 중 FAIL 0 · 판정필요 0 · 미검증 26 — [AD-acdc5606] SCP0127 SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY |  |
| V-d1dab4f1 | H2 | [SCP0006 결함 유형] Main Grid 배경색 | ERROR | PASS | 규칙 H2 판정 15행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-adb7652c] main.VALUE_TYPE (Type*): VALUE_TYPE: 기존행 편집=tr |  |
