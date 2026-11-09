# 검사기 회귀 대조 SCP0127 — 기준 2026-11-06 19:43 (1620행) ↔ 현재 2026-11-08 21:12 (1629행)

- 악화(기준 비FAIL → 현재 FAIL): **1** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 7 · 그 외 변경: 66 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 26 · 새 행 35
- 승격 대기(received): Doc\verify\_checker_golden\SCP0127.received.csv — 확인 뒤 `checker_regress.py SCP0127 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-b2ba2199 | F2 | SCP0127 시나리오 [자동] 기존행 수정 + 신규행 동시 Save 1회 → 요청에 M·I | ERROR | FAIL | [자동] 기존행 수정 + 신규행 동시 Save 1회 → 요청에 M·I: 저장 요청 없음 · 저장 요청 없음 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1 |  |

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-a6593ee3 | G1 | 조회조건 Plan Group | FAIL | ERROR | [멀티선택 Plan Group] 선택할 옵션 없음(후보 1) — 후보가 1개 이하라 선택 변경 검사 불가(콤보 원천 오류·데이터 없음: B1/B4·DB-SYN 참조) | 사용자(대화) |
| V-65334b39 | K3 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | FAIL | NA | f5 PASS: F5 → 조회 호출 1건(SEARCH) · 페이지 이동 0회 · 미포함: 팝업 그리드(이 시험은 메인 그리드만), Sort/Filter·정렬 후 동작(K1 smok |  |
| V-694ecd88 | L1 | 조회조건 텍스트 입력 중 그리드 | FAIL | PASS | 조회(Division ALL) 응답 226ms(요청~응답 226ms · 벽시계 879ms) · 534행 — 기준 10초(화면 규칙 L1: 조회·저장·키 이동 응답 기준 이내) |  |
| V-d0ab9be3 | K3 | [DMF0035 결함 유형] F5 단축키 | FAIL | PASS | f5 PASS: F5 → 조회 호출 1건(SEARCH) · 페이지 이동 0회 |  |
| V-025c2690 | K3 | [DMF0035 결함 유형] 조회 버튼 단축키 | FAIL | PASS | f5 PASS: F5 → 조회 호출 1건(SEARCH) · 페이지 이동 0회 |  |
| T-77e04cec | X-ROW | SCP0127_PrecedeSafetyStockDay.SpdMain_CellDoubleClick | FAIL | PASS | 진입점 집계 19검사 — NA:11 · PASS:8 |  |
| T-2091ecef | X-ROW | SCP0127_PrecedeSafetyStockDay.btnItemId_Click | FAIL | PASS | 진입점 집계 9검사 — NA:5 · PASS:4 |  |

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-d6ece6ac | F6 | SCP0127 저장 행 수 불변 | ERROR | PASS | 수정 저장 1회 DB 전후 대조 — SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY(키 DIVISION_ID,SCM_SITE_ID,OPMZ_PLAN_GR_ID,STAG |  |
| V-34580e4e | F8 | SCP0127 수정 감사 컬럼 | ERROR | PASS | 변경 행 1 감사 컬럼 대조: Created 불변 · Updated 갱신 · 수정자=저장 계정 |  |
| V-8a5762d8 | F6 | SCP0127 다른 셀 편집 값 유지 | ERROR | PASS | VALUE_TYPE 편집 뒤 TYPE_APPLY_DAY '7' 유지 |  |
| V-01a989f3 | G4 | 조회조건 Plan Group | PASS | NA | 정적 순서 판정은 SC1(E2E smoke 기준표 순서 · Excel 조회조건 정리 List 시트 기준 · 2026-11-06 사용자 지시) 행으로 일원화 · 원 판정: 조회조건  |  |
| V-d1f8bb33 | A2 | main.VALUE_TYPE (Type*) | ERROR | PASS | VALUE_TYPE: 원값 'MAX' → 표시 'MAX' (이름 'MAX') · AS-IS 조회 시점 코드(TextCell · 콤보는 Insert/Edit 때만) |  |
| V-63594f20 | E5 | main.VALUE_TYPE (Type*) | ERROR | PASS | VALUE_TYPE: 목록 밖 'ZZ_E2E_NOT_IN_LIST' 입력 → 값 'MIN' |  |
| V-adb7652c | H2 | main.VALUE_TYPE (Type*) | ERROR | PASS | VALUE_TYPE: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-b63ede6c | H2 | main.DIVISION_ID (Div*) | ERROR | PASS | DIVISION_ID: 기존행 편집=false 표시 일치 · 신규행 편집=false 표시 일치 |  |
| V-2b94640a | A2 | main.OPMZ_PLAN_GR_ID (Plan Group*) | ERROR | PASS | OPMZ_PLAN_GR_ID: 원값 'PG0001' → 표시 'E129A_E128A' (이름 'E129A_E128A') · AS-IS 조회 시점 코드(TextCell · 콤보는 I |  |
| V-a4f7deea | E5 | main.OPMZ_PLAN_GR_ID (Plan Group*) | ERROR | PASS | OPMZ_PLAN_GR_ID: 목록 밖 'ZZ_E2E_NOT_IN_LIST' 입력 → 값 'PG0001' |  |
| V-8fe0942a | D5 | main.OPMZ_PLAN_GR_ID (Plan Group*) | ERROR | PASS | OPMZ_PLAN_GR_ID: AS-IS COMBO ↔ TO-BE dataType=String · dataMap=Y |  |
| V-2c16ab6c | H2 | main.OPMZ_PLAN_GR_ID (Plan Group*) | ERROR | PASS | OPMZ_PLAN_GR_ID: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-bc61f9e7 | A2 | main.SCM_SITE_ID (SCM site*) | ERROR | PASS | SCM_SITE_ID: 원값 'WA00-A' → 표시 'WA00-A' (이름 'WA00-A') · AS-IS 조회 시점 코드(TextCell · 콤보는 Insert/Edit 때만) |  |
| V-b675cc28 | E5 | main.SCM_SITE_ID (SCM site*) | ERROR | PASS | SCM_SITE_ID: 목록 밖 'ZZ_E2E_NOT_IN_LIST' 입력 → 값 'AC00-A' |  |
| V-7f23c498 | H2 | main.SCM_SITE_ID (SCM site*) | ERROR | PASS | SCM_SITE_ID: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-15592311 | H2 | main.ITEM_ID (Model*) | ERROR | PASS | ITEM_ID: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-52eb466c | A2 | main.STAGE (Stage*) | ERROR | PASS | STAGE: 원값 'ASSY' → 표시 'ASSY' (이름 'ASSY') · AS-IS 조회 시점 코드(TextCell · 콤보는 Insert/Edit 때만) |  |
| V-3225e5f6 | E5 | main.STAGE (Stage*) | ERROR | PASS | STAGE: 목록 밖 'ZZ_E2E_NOT_IN_LIST' 입력 → 값 'ASSY' |  |
| V-0026c117 | H2 | main.STAGE (Stage*) | ERROR | PASS | STAGE: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-e6b6c2ee | D1 | main.FROM_YYYYMMDD (Valid From*) | 판정필요 | NA | 신규행 r0 FROM_YYYYMMDD 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이 |  |
| V-99a5021d | D5 | main.FROM_YYYYMMDD (Valid From*) | ERROR | PASS | FROM_YYYYMMDD: AS-IS DATE ↔ TO-BE dataType=Date · dataMap=N · editor · format=yyyy-MM-dd |  |
| V-9bc03409 | E2 | main.FROM_YYYYMMDD (Valid From*) | ERROR | PASS | 신규행 r0 FROM_YYYYMMDD: '2026-10-33' 입력 → 값 '2099-12-30T15:00:00.000Z' (입력 전 '2099-12-30T15:00:00.000Z |  |
| V-c1df84df | H2 | main.FROM_YYYYMMDD (Valid From*) | ERROR | PASS | FROM_YYYYMMDD: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-7afa3bc4 | D1 | main.TO_YYYYMMDD (Valid To*) | 판정필요 | NA | 신규행 r0 TO_YYYYMMDD 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면  |  |
| V-11d266ea | D5 | main.TO_YYYYMMDD (Valid To*) | ERROR | PASS | TO_YYYYMMDD: AS-IS DATE ↔ TO-BE dataType=Date · dataMap=N · editor · format=yyyy-MM-dd |  |
| V-c0756d5a | E2 | main.TO_YYYYMMDD (Valid To*) | ERROR | PASS | 신규행 r0 TO_YYYYMMDD: '2026-10-33' 입력 → 값 '2099-12-30T15:00:00.000Z' (입력 전 '2099-12-30T15:00:00.000Z') |  |
| V-cb18f5c9 | H2 | main.TO_YYYYMMDD (Valid To*) | ERROR | PASS | TO_YYYYMMDD: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-cd226197 | D5 | main.TYPE_APPLY_DAY (Day*) | ERROR | PASS | TYPE_APPLY_DAY: AS-IS NUMBER ↔ TO-BE dataType=Number · dataMap=N · editor |  |
| V-0904a747 | H2 | main.TYPE_APPLY_DAY (Day*) | ERROR | PASS | TYPE_APPLY_DAY: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-0e0d9300 | H2 | main.VALUE_DESCRIPTION (Description) | ERROR | PASS | VALUE_DESCRIPTION: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-2b93ad7c | A2 | main.VALID_YN (Active) | ERROR | PASS | VALID_YN: 원값 'Y' → 표시 'Y' (이름 'Y') · AS-IS 조회 시점 코드(TextCell · 콤보는 Insert/Edit 때만) |  |
| V-efa5ea78 | E5 | main.VALID_YN (Active) | ERROR | PASS | VALID_YN: 목록 밖 'ZZ_E2E_NOT_IN_LIST' 입력 → 값 'Y' |  |
| V-a5c6bdde | H2 | main.VALID_YN (Active) | ERROR | PASS | VALID_YN: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  |
| V-151ae92e | H2 | main.CREATED_BY (Create By) | ERROR | PASS | CREATED_BY: 기존행 편집=false 표시 일치 · 신규행 편집=false 표시 일치 |  |
| V-d5e273b4 | H2 | main.CREATION_DATE (Creation Date) | ERROR | PASS | CREATION_DATE: 기존행 편집=false 표시 일치 · 신규행 편집=false 표시 일치 |  |
| V-598bc265 | H2 | main.LAST_UPDATED_BY (Last Update By) | ERROR | PASS | LAST_UPDATED_BY: 기존행 편집=false 표시 일치 · 신규행 편집=false 표시 일치 |  |
| V-969ea6a6 | H2 | main.LAST_UPDATE_DATE (Last Update Date) | ERROR | PASS | LAST_UPDATE_DATE: 기존행 편집=false 표시 일치 · 신규행 편집=false 표시 일치 |  |
| V-39c3a144 | E4 | (동적 메시지) | NA | PASS | (동적 메시지): 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 PASS: 저장 후 재조회에 수정값 반영 — DB 반영 확인 · 원복 저장·복원 확인(정리 |  |
| V-2bc86eaa | H6 | popItem.Form_Load(multiSelect, division, operation_group, sI | NA | PASS | 팝업 버튼 [Open, Search, OK, Close] · 첫 컬럼 'No' · 건수 Y |  |
| V-d86eb140 | C3 | OPMZ_PLAN_GR_ID | ERROR | NA | 원천 컬럼 분기 해석 불가 — 조건 'if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e |  |
| V-ae0399a0 | C6 | OPMZ_PLAN_GR_ID | ERROR | NA | OPMZ_PLAN_GR_ID='PG0001' 더블클릭+Esc(값 변경 없음) →  — 대상 값을 채우지 못해 판정 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-b3bdf91c | G5 | new SCM0002_MaterialByDivisionPopup() | ERROR | NA | 인자 없는 팝업 문장 — 팝업 인자 판정은 [V-866907ce] popItem.Form_Load(true, division, operation_group, sItemId,  에서 |  |
| V-92f4d8f8 | G5 | popItem.ShowDialog() | ERROR | NA | 인자 없는 팝업 문장 — 팝업 인자 판정은 [V-866907ce] popItem.Form_Load(true, division, operation_group, sItemId,  에서 |  |
| V-bfb37300 | H9 | Main Grid 컬럼 폭 | PASS | NA | 메타 COLUMN_WIDTH 없음 |  |
| V-9c75a366 | H7 | Excel Download 양식(공통 모듈) | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['DELETE', 'INSERT', 'SAVE', 'SEARCH'] · plan.buttons ['Button1']) |  |
| V-90b3b8c9 | A2 | [DMF0082 결함 유형] Cell Prod Site 셀 | ERROR | PASS | 규칙 A2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-bc61f9e7] main.SCM_SITE_ID (SCM site*): SCM_SITE_ID: 원값 ' |  |
| V-1fd605eb | G4 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | PASS | NA | 규칙 G4 대상 일치 1행이 모두 NA — [V-01a989f3] 조회조건 Plan Group: 정적 순서 판정은 SC1(E2E smoke 기준표 순서 · Excel 조회조건 정리 |  |
| V-0a61c96f | H6 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회 | NA | PASS | 규칙 H6 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2bc86eaa] popItem.Form_Load(multiSelect, division, operat |  |
| V-890a2fbd | H7 | [DMF0074 결함 유형] Excel Form 양식 헤더 | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['DELETE', 'INSERT', 'SAVE', 'SEARCH'] · plan.buttons ['Button1']) |  |
| V-77939f46 | D5 | [SYS0003 결함 유형] Menu Type·Auth Unit 컬럼 | ERROR | PASS | 규칙 D5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-cd226197] main.TYPE_APPLY_DAY (Day*): TYPE_APPLY_DAY: AS- |  |
| V-fe4e4cc2 | H7 | [DMF0021 결함 일반화] Excel Download(TEAM·FCST Type·Measure·Proje | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['DELETE', 'INSERT', 'SAVE', 'SEARCH'] · plan.buttons ['Button1']) |  |
| V-b937f65a | A2 | [DMF0021 결함 일반화] Excel Download(TEAM·FCST Type·Measure·Proje | ERROR | PASS | 규칙 A2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-d1f8bb33] main.VALUE_TYPE (Type*): VALUE_TYPE: 원값 'MAX' → |  |
| V-e5cf7fbd | G4 | [DMF0035 결함 유형] Plan Type 조회조건 위치 | PASS | NA | 규칙 G4 대상 일치 2행이 모두 NA — [V-01a989f3] 조회조건 Plan Group: 정적 순서 판정은 SC1(E2E smoke 기준표 순서 · Excel 조회조건 정리 |  |
| V-ffd1bdd8 | H6 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | NA | PASS | 규칙 H6 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-0bd48c8a] SCP0127 스냅샷 팝업 Model/Nickname: [재실측 스냅샷 팝업] 기준  |  |
| V-85a2b1a2 | H6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회 | NA | PASS | 규칙 H6 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-2bc86eaa] popItem.Form_Load(multiSelect, division, operat |  |
| V-d1dab4f1 | H2 | [SCP0006 결함 유형] Main Grid 배경색 | ERROR | PASS | 규칙 H2 판정 15행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-adb7652c] main.VALUE_TYPE (Type*): VALUE_TYPE: 기존행 편집=tr |  |
| V-b010be98 | H7 | [DMF0049 결함 일반화] Excel Download 월 칸 서식(#,##0.000;[Red]-#,##0 | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['DELETE', 'INSERT', 'SAVE', 'SEARCH'] · plan.buttons ['Button1']) |  |
| V-b1ab29ec | H7 | Excel Download 양식(공통 모듈) | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['DELETE', 'INSERT', 'SAVE', 'SEARCH'] · plan.buttons ['Button1']) |  |
| V-3c4dcc39 | H7 | Excel Download(TEAM·FCST Type·Measure·Project) | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['DELETE', 'INSERT', 'SAVE', 'SEARCH'] · plan.buttons ['Button1']) |  |
| T-653a732c | C3 | SCP0127_PrecedeSafetyStockDay.ClbDivision_SelectedIndexChang | ERROR | NA | 진입점 집계 — 대조표 SCP0127_PrecedeSafetyStockDay.ClbDivision_SelectedIndexChanged 의 C3 6요소: NA:6 |  |
| T-99c253e9 | C6 | SCP0127_PrecedeSafetyStockDay.ClbDivision_SelectedIndexChang | ERROR | NA | 진입점 집계 — 대조표 SCP0127_PrecedeSafetyStockDay.ClbDivision_SelectedIndexChanged 의 C6 1요소: NA:1 |  |
| T-a002e319 | F4 | PKG_SCP0127.P_SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY | NA | PASS | PKG_SCP0127.P_SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY: 저장 호출 2회 HTTP 200 · SQL 오류 없음 · main/SAVE:200 응 |  |
| T-d5378f8d | C3 | SCP0127_PrecedeSafetyStockDay.SetChangedControl | ERROR | NA | 진입점 집계 — 대조표 SCP0127_PrecedeSafetyStockDay.SetChangedControl 의 C3 6요소: NA:6 |  |
| T-04849c3b | X-ROW | SCP0127_PrecedeSafetyStockDay.SpdMain_ClipboardPasted | ERROR | PASS | 진입점 집계 7검사 — NA:6 · PASS:1 |  |
| T-6cc2c77b | C3 | SCP0127_PrecedeSafetyStockDay.setPeriod | ERROR | NA | 진입점 집계 — 대조표 SCP0127_PrecedeSafetyStockDay.setPeriod 의 C3 6요소: NA:6 |  |
| EG-0f797f5f | H4 | SCP0127 팝업 SCM0002_MaterialByDivisionPopup COND:Model RESIZE | PASS | NA | 기대 축소 → 조건·버튼 간섭 없음 · 실제 리사이즈 핸들 없음 · 근거  |  |
