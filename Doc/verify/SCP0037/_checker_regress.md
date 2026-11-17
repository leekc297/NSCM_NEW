# 검사기 회귀 대조 SCP0037 — 기준 2026-11-07 15:13 (1762행) ↔ 현재 2026-11-14 12:22 (1757행)

- 악화(기준 비FAIL → 현재 FAIL): **9** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 1 · 그 외 변경: 237 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 22 · 새 행 17
- 승격 대기(received): Doc\verify\_checker_golden\SCP0037.received.csv — 확인 뒤 `checker_regress.py SCP0037 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-85ec81e0 | F5 | SCP0037 화면 | PASS | FAIL | Insert → 신규행 CRUD_TYPE='I' · 기존행 LT_DAY 편집 → CRUD_TYPE='' · 신규행 Delete → 신규행 1→0 · 기존행 Delete → 변화 없 |  |
| V-686bd02b | K3 | SCP0037 화면 | PASS | FAIL | copy PASS: 선택 0,0,0,0 · 0행 DIVISION_ID 표시값 '81' · Ctrl+C 클립보드 '81'(일치) · 우클릭 Copy '81'(일치) ／ ctrl PA |  |
| V-40b09280 | D1 | Operation LT.LT_DAY (LT(Day)*) | PASS | FAIL | [화면 오류] 신규행 r0 LT_DAY 셀 편집 시작 시 편집기 생성 오류 — LT_DAY: ** Assertion failed in Wijmo: Number expected. E |  |
| V-494dc9ad | G1 | SCP0037 텍스트 부분일치 Material | ERROR | FAIL | Material · 'PCAN0506'(값 'APCAN0506B' 일부) 이 조회 요청 본문에 실렸는데 0행 — 텍스트 조건 부분일치(Like) 안 됨 · 기대 근거 요건 EG24 |  |
| V-d814cf98 | K3 | [DMF0020 결함 일반화] 결과 그리드 Sort/Filter(동적 주차 컬럼 W37-0817 등) | NA | FAIL | hide FAIL: 헤더(DIVISION_ID) 우클릭 → Hide Column → 컬럼 여전히 표시 · Unhide All 복원 · 미포함: Sort/Filter·정렬 후 동작( |  |
| V-fbc20535 | K3 | [DMF0020 결함 유형] Exchange Rate 그리드 Copy·Header Hide Column | NA | FAIL | copy PASS: 선택 0,0,0,0 · 0행 DIVISION_ID 표시값 '81' · Ctrl+C 클립보드 '81'(일치) · 우클릭 Copy '81'(일치) ／ hide FA |  |
| T-ea497b53 | F5 | SCP0037 화면 | PASS | FAIL | Insert → 신규행 CRUD_TYPE='I' · 기존행 LT_DAY 편집 → CRUD_TYPE='' · 신규행 Delete → 신규행 1→0 · 기존행 Delete → 변화 없 |  |
| T-0b703554 | D1 | 13 · SpdMain_ClipboardPasted | PASS | FAIL | 행 집계 — 대조표 13 'SpdMain_ClipboardPasted' 의 D1 14요소: PASS:8 · ERROR:4 · FAIL:1 · NA:1 · FAIL 요소: LT_DA |  |
| T-2e5f6d9a | D1 | 3,9 · lock | PASS | FAIL | 행 집계 — 대조표 3,9 'lock' 의 D1 14요소: PASS:8 · ERROR:4 · FAIL:1 · NA:1 · FAIL 요소: LT_DAY / LT(Day — 원장 V- |  |

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-eed95e79 | E1 | Operation LT.LT_DAY (LT(Day)*) | FAIL | ERROR | [입력 경로 실패] LT_DAY r0: 유효값 '1' 이 편집기·키보드 모두 들어가지 않음 — 규칙 밖 값 거부를 판정할 수 없음(입력 안 됨(''→'5' · 더블클릭 뒤 포커스  |  |

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-5ad7c26d | F8 | SCP0037 저장 감사 필드 | NA | ERROR |  ／ [미검증] 검사기(tools/Harness/verify/save_audit.py(정리 백업 루트 행 감사 컬럼 = 저장 계정·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-c403d7eb | F7 | SCP0037 저장 연계 테이블 | NA | ERROR |  ／ [미검증] 검사기(tools/Harness/verify/save_audit.py(CRUD 실제 저장 정리 백업 ↔ AS-IS )가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-0ba1cc9a | F5 | SCP0037 원값 복원 상태 해제 | PASS | ERROR | [측정 경로 없음] LT_DAY 값 변경이 안 됨('5') |  |
| V-50589bf0 | I1 | SCP0037 시나리오 [자동] KO 언어 · 변경 없이 저장 → KO 수정사항 없음 알림 | PASS | ERROR | [측정 경로 없음] [자동] KO 언어 · 변경 없이 저장 → KO 수정사항 없음 알림: [측정 경로 없음] 다른 화면 E2E 동시 실행(SCP0033) — 계정 언어 전환 생략( |  |
| V-6d30ddef | F6 | SCP0037 빈값 저장 | NA | ERROR | LT_DAY r1 '5'→빈값 [사유 불명] 저장 요청 없음 · 원복 OK · 입력 경로 실패: 입력 안 됨('5'→'5' · 더블클릭 뒤 포커스 셀 위치 없음) |  |
| V-0853bec7 | F4 | SCP0037 경계값 저장 | PASS | ERROR | LT_DAY r1 원값 '5' · [업무 검증 차단] 경계값 '100' 저장 요청 없음 · 입력 경로 실패: 입력 안 됨('5'→'5' · 더블클릭 뒤 포커스 셀 위치 없음) ·  |  |
| V-e656c6ef | L1 | SCP0037 저장 응답 시간 | NA | PASS | 저장 4회 소요 102·100·111·107ms · 최소 100ms · 기준 3000ms |  |
| V-a7d94ca1 | F1 | SCP0037 2행 동시 저장 | NA | PASS | LT_DAY 저장 1회 — r1 '5'→'6' 재조회 '6' OK · r2 '5'→'6' 재조회 '6' OK · 원복 '5' OK · 원복 '5' OK |  |
| V-179f4c67 | A7 | SCP0037_GET_OPERATION_LT | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-b32d9831 | B3 | 조회조건 Div | NA | ERROR | [화면 초기(선택 Div=81)] 원문 ORDER BY 있음·정렬 키 해석 불가 — AS-IS 반환 순서와 다름: TO-BE ['40', '81', '81_HD', '81_HG', |  |
| V-589c1045 | B7 | 조회조건 Div | NA | ERROR | 판정필요: (a) 저장 SP SCP0037_SAVE_OPERATION_LT 대상 SCP_MST_OPERATION_LT, SCP_MST_OPERATION_LT_H 와 콤보 원천 10 |  |
| V-8ad187cc | B3 | 조회조건 Operation | NA | ERROR | [화면 초기(선택 Div=81)] ORDER BY ['DISPLAY_SEQ'] 키 기준 2번째 역전: 키 [50.0]→[30.0] (사내 값 기준) — TO-BE 는 표시명 오름차 |  |
| V-b4e39c1c | B7 | 조회조건 Operation | NA | ERROR | 판정필요: (a) 저장 SP SCP0037_SAVE_OPERATION_LT 대상 SCP_MST_OPERATION_LT, SCP_MST_OPERATION_LT_H 와 콤보 원천 10 |  |
| V-edb492b0 | B1 | 조회조건 Plant Site | NA | ERROR | 'Plant Site' 항목에 콤보 없음(텍스트/팝업형 — 가장 가까운 콤보가 다른 항목 소속 8개) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-ec1baad0 | B2 | 조회조건 Plant Site | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_verify.spec( |  |
| V-7d76cf27 | B3 | 조회조건 Plant Site | NA | ERROR |  ／ [미검증] 검사기(combo_oracle order_check — AS-IS ORDER BY 키(사내 값 재검사)·CODE 정)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-14732525 | B4 | 조회조건 Plant Site | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(combo_oracle.py |  |
| V-2a6266e9 | B6 | 조회조건 Plant Site | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_verify.spec( |  |
| V-92afb0fd | B7 | 조회조건 Plant Site | NA | ERROR | 판정필요: (a) 저장 SP SCP0037_SAVE_OPERATION_LT 대상 SCP_MST_OPERATION_LT, SCP_MST_OPERATION_LT_H 와 콤보 원천 10 |  |
| V-62364943 | G7 | 조회조건 Plant Site | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1) G7 — AS-IS 컨트롤 표시 열(CControl.setListBox·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-723fbd3d | G2 | 조회조건 Material | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_verify.spec( |  |
| V-85e4ccdc | B4 | 조회조건 Active | 판정필요 | ERROR | [화면 초기(선택 Div=81)] [CR-059 확정 규칙 대상 — Active 로 관리되는 마스터 기반 조회조건은 Active Y/N 과 무관하게 전체 데이터를 후보로 표시한다( |  |
| V-043a4079 | B7 | 조회조건 Active | NA | ERROR | 판정필요: (a) 저장 SP SCP0037_SAVE_OPERATION_LT 대상 SCP_MST_OPERATION_LT, SCP_MST_OPERATION_LT_H 와 콤보 원천 10 |  |
| V-c3a3e825 | G7 | 조회조건 Active | NA | ERROR | [화면 초기(선택 Div=81)] CODE≠NAME 후보 8건이 TO-BE 표시 문구와 한 건도 안 맞음(데이터 차이 또는 다른 형식) · AS-IS 표시 NAME · 원천 UP_ |  |
| V-e157f811 | B4 | Operation LT.SCM_SITE_ID (Plant Site*) | 판정필요 | ERROR | [신규행(DIVISION_ID=81)] AS-IS 83건 vs TO-BE 7건 · 마스터(SCM_MST_SITE) 행으로 설명 안 되는 차이 60건: AZ00-A: 조건 차이 의심 |  |
| V-ff48f9b2 | B4 | Operation LT.LT_OPERATION (LT Operation) | NA | ERROR | [신규행(DIVISION_ID=81)] AS-IS 0건 vs TO-BE 4건 · 차이 4건 설명 불가: SLITTING: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할  |  |
| V-538d39e3 | B1 | Operation LT.INV_FLAG (Inv Flag) | NA | ERROR | INV_FLAG 셀 콤보(dataMap) 없음 — 에디터 유형 확인(D5) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-17151791 | B2 | Operation LT.INV_FLAG (Inv Flag) | NA | ERROR | INV_FLAG 셀 콤보(dataMap) 없음 — 에디터 유형 확인(D5) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-ea05071d | B3 | Operation LT.INV_FLAG (Inv Flag) | NA | ERROR |  ／ [미검증] 검사기(combo_oracle order_check — AS-IS ORDER BY 키(사내 값 재검사)·CODE 정)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-94faf551 | B4 | Operation LT.INV_FLAG (Inv Flag) | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(combo_oracle.py |  |
| V-da65b711 | A2 | Operation LT.INV_FLAG (Inv Flag) | NA | ERROR | INV_FLAG dataMap 없음 — 에디터 유형(D5) 행 참고 · 표시 '' → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-b8b5792d | D1 | siMain.SwitchLock | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect))가 이 대상을 실행하지 못함 — 검증 엔진 확장  |  |
| V-377e14ec | E4 | MSG00093 | NA | ERROR | MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain_CellClick)에서 |  |
| V-7190eeb3 | C2 | siMain.SetCellTypeCombo | NA | ERROR | 원천/대상 해석 불가 — 조건 'if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetCo |  |
| V-4acebdd4 | C2 | siMain.SetCellTypeCombo | NA | ERROR | 원천/대상 해석 불가 — 조건 'if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetCo |  |
| V-c142b42e | C2 | siMain.SetCellTypeCombo | NA | ERROR | 원천/대상 해석 불가 — 조건 'if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetCo |  |
| V-4ada50f4 | C2 | siMain.SetCellTypeCombo | NA | ERROR | 원천/대상 해석 불가 — 조건 'if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetCo |  |
| V-9f6ae677 | C2 | DIVISION_ID | NA | ERROR | 원천/대상 해석 불가 — 조건 'if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetCo |  |
| V-05394fc0 | E4 | MSG00093 | NA | ERROR | MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain_CellClick)에서 |  |
| V-e2267fc9 | E4 | MSG00093 | NA | ERROR | MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain_CellClick)에서 |  |
| V-b25ddfb6 | H6 | new SCM0002_ItembyPlantSitePopup() | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_ |  |
| V-b8be05b3 | M3 | new SCM0002_ItembyPlantSitePopup() | NA | ERROR | AS-IS 팝업 문장 'new SCM0002_ItembyPlantSitePopup()' → 팝업 SCM0002_ItembyPlantSitePopup 의 규칙 M3 실측 1행을 이어 |  |
| V-fb8ba7b5 | H6 | popItem.Form_Load(false, "N", division, sScmSite, sItemId) | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_ |  |
| V-1b077988 | H6 | popItem.ShowDialog() | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_ |  |
| V-56418b46 | C6 | SCM_SITE_ID | NA | ERROR | 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 40행 모두) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상 |  |
| V-5bd925f6 | C6 | PLANT_SITE_ID | NA | ERROR | 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 40행 모두) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상 |  |
| V-6db681bf | C3 | SCM_SITE_ID | NA | ERROR | 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 40행 모두) — 연쇄 프로브 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님 |  |
| V-330ac7a0 | C6 | SCM_SITE_ID | NA | ERROR | 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 40행 모두) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상 |  |
| V-eb20ee4b | C3 | PLANT_SITE_ID | NA | ERROR | 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 40행 모두) — 연쇄 프로브 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님 |  |
| V-0268fc25 | C6 | PLANT_SITE_ID | NA | ERROR | 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 40행 모두) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상 |  |
| V-3299618b | C2 | SCM_SITE_ID | NA | ERROR | 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 40행 모두) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상 |  |
| V-64ed804a | F3 | SCM_SITE_ID | NA | ERROR | 붙여넣기 프로브 전제 부족(기존행 true · 신규행 false) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-3e69ded9 | C3 | SCM_SITE_ID | NA | ERROR | 원천 컬럼 분기 해석 불가 — 조건 'for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.C |  |
| V-dd17c93b | C6 | NICK_NAME | NA | ERROR | 원천 ITEM_ID 신규행 편집 불가(신규행·기존행·앞 40행 모두) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업  |  |
| V-68ba811e | C6 | SCM_SITE_ID | NA | ERROR | 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 40행 모두) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상 |  |
| V-d2ccc99d | C6 | ITEM_ID | NA | ERROR | 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 40행 모두) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상 |  |
| V-fcc521b2 | C6 | NICK_NAME | NA | ERROR | 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 40행 모두) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상 |  |
| V-92864f4a | C6 | PLANT_SITE_ID | NA | ERROR | 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 40행 모두) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상 |  |
| V-e70d39e9 | H6 | new SCM0002_MaterialByDivisionPopup() | NA | PASS | AS-IS 팝업 문장 'new SCM0002_MaterialByDivisionPopup()' → 팝업 SCM0002_MaterialByDivisionPopup 의 규칙 H6 실측  |  |
| V-228dcbad | M3 | new SCM0002_MaterialByDivisionPopup() | NA | PASS | AS-IS 팝업 문장 'new SCM0002_MaterialByDivisionPopup()' → 팝업 SCM0002_MaterialByDivisionPopup 의 규칙 M3 실측  |  |
| V-f713ebba | H6 | pop.Form_Load(true, division, "", sItemId, this.Name.Substri | NA | PASS | AS-IS 팝업 문장 'pop.Form_Load(true, division, "", sItemId, this.Na' → 팝업 SCM0002_MaterialByDivisionPopu |  |
| V-31846a65 | H6 | pop.ShowDialog() | NA | PASS | AS-IS 팝업 문장 'pop.ShowDialog()' → 팝업 SCM0002_MaterialByDivisionPopup 의 규칙 H6 실측 6행을 이어받음 — [EG-b47726 |  |
| V-76575543 | C2 | siMain.SetCellTypeCombo | NA | ERROR | 원천/대상 해석 불가 — 조건 'if (null != pdivision && "" != pdivision) ▸ if (pltopration == "SLITTING" ／／ pltop |  |
| V-156ea5fa | C2 | siMain.SetCellTypeCombo | NA | ERROR | 원천/대상 해석 불가 — 조건 'if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" ／／  |  |
| V-709da79e | C2 | siMain.SetCellTypeCombo | NA | ERROR | 원천/대상 해석 불가 — 조건 'if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" ／／  |  |
| V-19e696b1 | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-8403d04a | C1 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | PASS | ERROR | 규칙 C1 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-f823dc1f] SCP0037 연쇄 후보 Plant Site: [CR-002 확정 규칙 대상 — T |  |
| V-fcb0c09c | K3 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | NA | ERROR | f5 ERROR: 실행 실패: Error: 셀 좌표 확인 실패(0행 · DIVISION_ID): DIV · 미포함: 팝업 그리드(이 시험은 메인 그리드만), Sort/Filter· |  |
| V-7c1dbf96 | B2 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | PASS | ERROR | 규칙 B2 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-ec1baad0] 조회조건 Plant Site:  ／ [미검증] 검사기(_verify.spec(@ver |  |
| V-0f369fd7 | B3 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | PASS | ERROR | 규칙 B3 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-7d76cf27] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle orde |  |
| V-5ecd3f66 | B4 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-be48d473 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | NA | ERROR | ctrl PASS: Ctrl+클릭 0행·2행(DIVISION_ID) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함: |  |
| V-2e5126a2 | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/ | PASS | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 3 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-228e2bbd | E6 | 텍스트 입력 컨트롤(TEXT BOX · FPText) 마우스 드래그 선택 후 Delete/Backspace | PASS | NA | 직접 실측 없음 — 같은 규칙 E6 의 다른 대상 2행 PASS 는 이 결함의 근거가 아님 · 참고 [V-e7904f5b] SCP0037 화면 ／ [V-b8c05831] SCP00 |  |
| V-09b71c1e | M4 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | NA | ERROR | 규칙 M4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-e0cc811f] ITEM_ID / Material: 실측[T-e0cc811f]: 검사기 있음(_tra |  |
| V-02da65c9 | B4 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-4b1f80bc | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-3fd7c124 | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0037_SAVE_OPERATION_LT 대상 SCP_MST_OPERATION_LT, SCP_MST_OPERATION_LT_H 와 콤보 원천 10 |  |
| V-fdd693c5 | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-44c40e6c | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0037_SAVE_OPERATION_LT 대상 SCP_MST_OPERATION_LT, SCP_MST_OPERATION_LT_H 와 콤보 원천 10 |  |
| V-bf62042f | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-7dd39e7e | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0037_SAVE_OPERATION_LT 대상 SCP_MST_OPERATION_LT, SCP_MST_OPERATION_LT_H 와 콤보 원천 10 |  |
| V-9297df2c | K3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | NA | ERROR | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,0, |  |
| V-e0ef6fb0 | B4 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-10d91691 | C1 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site | PASS | ERROR | 규칙 C1 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-f823dc1f] SCP0037 연쇄 후보 Plant Site: [CR-002 확정 규칙 대상 — T |  |
| V-4b49bce0 | B2 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site | PASS | ERROR | 규칙 B2 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-ec1baad0] 조회조건 Plant Site:  ／ [미검증] 검사기(_verify.spec(@ver |  |
| V-ccf2940d | D1 | [DMF0020 결함 유형] Team·End Customer 컬럼 | PASS | ERROR | 규칙 D1 판정 15행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-40aa5ae4] SCP0037 팝업 (TO-BE 메타 팝업) CELL:ITEM_ID CELL_PA |  |
| V-22a3110a | C3 | [DMF0020 결함 유형] Team·End Customer 컬럼 | PASS | ERROR | 규칙 C3 판정 8행 중 FAIL 0 · 판정필요 0 · 미검증 6 — [V-6db681bf] SCM_SITE_ID: 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 |  |
| V-4bb1b822 | B4 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-8e17e96c | B2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | PASS | ERROR | 규칙 B2 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-ec1baad0] 조회조건 Plant Site:  ／ [미검증] 검사기(_verify.spec(@ver |  |
| V-4159d179 | E4 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Acti | PASS | ERROR | 규칙 E4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-3c2be75d] SCM_SITE_ID / Plant Site: MSG00093 — SpdMain_Ce |  |
| V-57b6308d | B4 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-df9d76d2 | C1 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | PASS | ERROR | 규칙 C1 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-f823dc1f] SCP0037 연쇄 후보 Plant Site: [CR-002 확정 규칙 대상 — T |  |
| V-6e7be61d | B5 | [DMF0003 결함 유형] Measure 콤보(입력 가능 Measure) | PASS | ERROR | 규칙 B5 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-d13f6501 | B5 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | PASS | ERROR | 규칙 B5 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-4b144f6c | A5 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST A | NA | PASS | 규칙 A5 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-2d98a351] SCM_SITE_ID / Plant Site: SCM_SITE_ID: AS-IS(Di |  |
| V-d84cb816 | B4 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-7b368270 | C3 | [DMF0005 결함 일반화] Sales Company·Sales Plant 셀 | PASS | ERROR | 규칙 C3 판정 5행 중 FAIL 0 · 판정필요 0 · 미검증 3 — [V-eb20ee4b] PLANT_SITE_ID: 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행 |  |
| V-ceb976de | E4 | [DMF0005 결함 일반화] Sales Company·Sales Plant 셀 | PASS | ERROR | 규칙 E4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-3c2be75d] SCM_SITE_ID / Plant Site: MSG00093 — SpdMain_Ce |  |
| V-a8970d68 | E4 | [DMF0044 결함 유형] Cell Prod Site 검증 · Application Gr·Country N | PASS | ERROR | 규칙 E4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-3c2be75d] SCM_SITE_ID / Plant Site: MSG00093 — SpdMain_Ce |  |
| V-faf90952 | D1 | [DMF0049 결함 유형] Cell Model·Cell Model Info 컬럼 | NA | ERROR | 규칙 D1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-40aa5ae4] SCP0037 팝업 (TO-BE 메타 팝업) CELL:ITEM_ID CELL_PAS |  |
| V-44b43ac2 | K3 | [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | NA | ERROR | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,0, |  |
| V-92f9385a | E6 | [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | NA | ERROR | ime NA: 신규행에 직접 입력하는 문자 컬럼 없음 ／ auto PASS: 신규행 SCM_SITE_ID 에 'OC' 입력 → 편집기 'OC_2 Auto Elec-Electrode |  |
| V-90b7d62d | C3 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | PASS | ERROR | 규칙 C3 판정 7행 중 FAIL 0 · 판정필요 0 · 미검증 5 — [V-6db681bf] SCM_SITE_ID: 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 |  |
| V-2bdec4c5 | B5 | [DMF0003 결함 유형] 신규 행 Measure 후보 | PASS | ERROR | 규칙 B5 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-e4738629 | B4 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-4276048d | B5 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit | PASS | ERROR | 규칙 B5 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-69a9cffc | B4 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-82c90a72 | E4 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site I | PASS | ERROR | 규칙 E4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-3c2be75d] SCM_SITE_ID / Plant Site: MSG00093 — SpdMain_Ce |  |
| V-591add62 | C3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | PASS | ERROR | 규칙 C3 판정 7행 중 FAIL 0 · 판정필요 0 · 미검증 5 — [V-6db681bf] SCM_SITE_ID: 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 |  |
| V-58a21bf6 | B5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | PASS | ERROR | 규칙 B5 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-235de567 | B4 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-71594e51 | B5 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | PASS | ERROR | 규칙 B5 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-9740052f | B7 | [DMF0005 결함 유형] Team 조회조건 후보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0037_SAVE_OPERATION_LT 대상 SCP_MST_OPERATION_LT, SCP_MST_OPERATION_LT_H 와 콤보 원천 10 |  |
| V-5ddcb122 | E4 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | PASS | ERROR | 규칙 E4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-3c2be75d] SCM_SITE_ID / Plant Site: MSG00093 — SpdMain_Ce |  |
| V-f160f928 | H6 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | NA | ERROR | 규칙 H6 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-4f9b7e94] NICK_NAME / Nick Name: 실측[T-4f9b7e94]: 검사기(_ver |  |
| V-5452a949 | B4 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | NA | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-c7bc69e8 | C3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | NA | ERROR | 규칙 C3 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-c653f122] NICK_NAME / Nick Name: NICK_NAME: 원천 ITEM_ID/DI |  |
| V-3209c1f9 | E4 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | PASS | ERROR | 규칙 E4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-0e962d80] DIVISION_ID / Division: MSG00093 — SpdMain_Cell |  |
| V-4ca4ec2f | B4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회 | NA | ERROR | 규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-85e4ccdc] 조회조건 Active: [화면 초기(선택 Div=81)] [CR-059 확정 규칙 대 |  |
| V-fdb86140 | B4 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | NA | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-97aa7727 | K3 | [DMF0035 결함 유형] F5 단축키 | PASS | ERROR | f5 ERROR: 실행 실패: Error: 셀 좌표 확인 실패(0행 · DIVISION_ID): DIV |  |
| V-8bfbc778 | A5 | [DMF0082 결함 유형] BIZ PLAN 제외 컬럼(Cust Group Dtl 등 7개) | NA | PASS | 규칙 A5 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-2d98a351] SCM_SITE_ID / Plant Site: SCM_SITE_ID: AS-IS(Di |  |
| V-f6eb7715 | K3 | [DMF0035 결함 유형] 조회 버튼 단축키 | PASS | ERROR | f5 ERROR: 실행 실패: Error: 셀 좌표 확인 실패(0행 · DIVISION_ID): DIV |  |
| V-351b8092 | B4 | [SCP0007 결함 유형] To Site 조회조건 콤보 | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-dc951cb2 | B4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-7568159d | C3 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | PASS | ERROR | 규칙 C3 판정 7행 중 FAIL 0 · 판정필요 0 · 미검증 5 — [V-6db681bf] SCM_SITE_ID: 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 |  |
| V-c9e7c1da | C3 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME | PASS | ERROR | 규칙 C3 판정 8행 중 FAIL 0 · 판정필요 0 · 미검증 6 — [V-6db681bf] SCM_SITE_ID: 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행·앞 |  |
| V-5c473262 | M4 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME | NA | ERROR | 규칙 M4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-e0cc811f] ITEM_ID / Material: 실측[T-e0cc811f]: 검사기 있음(_tra |  |
| V-4919c6de | B4 | [DMF0004 결함 일반화] 조회조건 Sales Site 콤보(SCM_SITE_ID · SiteByEndC | PASS | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 3 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-f09b2c4c | B5 | [DMF0021 결함 일반화] Measure 설정 팝업(Measure Setting) 후보 · Column  | NA | ERROR | 규칙 B5 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-c07eab72] DIVISION_ID / Division: 실측[T-c07eab72]: 검사기(com |  |
| V-411978a2 | B3 | [DMF0048 결함 일반화] 조회조건 Team(DEPT_ID)·End Customer(END_CUSTOME | PASS | ERROR | 규칙 B3 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-7d76cf27] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle orde |  |
| V-0dec26dd | B4 | [DMF0053 결함 일반화] 조회조건 Filter 콤보 6종(FilterMyDivision·FilterTe | NA | ERROR | 규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-85e4ccdc] 조회조건 Active: [화면 초기(선택 Div=81)] [CR-059 확정 규칙 대 |  |
| V-b826c043 | I1 | [DMF0004 결함 일반화] 변경 없이 Save(F7) 시 안내 메시지 코드(MSG_NO_CHANGE 미등 | ERROR | NA | 규칙 I1 요소 판정에 FAIL 0 · 판정필요 0 · 미검증 1 있으나 이 결함 대상과 직접 일치하는 요소 없음 — 규칙 전반 상속으로 FAIL 을 만들지 않음(원천 행 참조:  |  |
| V-e193736e | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-1037dab4 | B2 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | PASS | ERROR | 규칙 B2 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-ec1baad0] 조회조건 Plant Site:  ／ [미검증] 검사기(_verify.spec(@ver |  |
| V-1ed055f4 | C3 | Sales Company·Sales Plant 셀 | PASS | ERROR | 규칙 C3 판정 5행 중 FAIL 0 · 판정필요 0 · 미검증 3 — [V-eb20ee4b] PLANT_SITE_ID: 원천 DIVISION_ID 신규행 편집 불가(신규행·기존행 |  |
| V-e23c2aca | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | NA | ERROR | ctrl PASS: Ctrl+클릭 0행·2행(DIVISION_ID) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함: |  |
| V-bc2e5f7a | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/ | PASS | ERROR | 규칙 B4 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 3 — [V-14732525] 조회조건 Plant Site:  ／ [미검증] 검사기(combo_oracle.py(W |  |
| V-c32b5b2a | G4 | SCP0037 스냅샷 조회조건 Div 40 | NA | ERROR | [재실측 스냅샷 조회조건] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0037\snap\received\조회조건_Div_40.aria.yml 를 sna |  |
| V-3b66581a | K4 | SCP0037 스냅샷 버튼 Div 40 | NA | ERROR | [재실측 스냅샷 버튼] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0037\snap\received\버튼_Div_40.aria.yml 를 snap_va |  |
| V-607d5006 | A5 | SCP0037 스냅샷 헤더 Operation LT | NA | ERROR | [재실측 스냅샷 헤더] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0037\snap\received\헤더_Operation_LT.txt 를 snap_v |  |
| V-0466e31c | H6 | SCP0037 스냅샷 팝업 Material | NA | ERROR | [재실측 스냅샷 팝업] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0037\snap\received\팝업_Material.aria.yml 를 snap_ |  |
| V-ecf2a9a9 | H4 | SCP0037 스냅샷 화면샷 1920 | NA | ERROR | [재실측 스냅샷 화면샷] 골든 없음(승인 전) · 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 일치(maxDiffPixelRatio 0.002) · snap_appro |  |
| V-ade3e311 | H4 | SCP0037 스냅샷 화면샷 1366 | NA | ERROR | [재실측 스냅샷 화면샷] 골든 없음(승인 전) · 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 일치(maxDiffPixelRatio 0.002) · snap_appro |  |
| AD-eb3043fa | A6 | SCP0037 SCP0037_GET_OPERATION_LT 공통·유일 행 상대 순서 | NA | ERROR | [ORDER] [차등 검증 #1] main/SEARCH AS-IS SCP0037_GET_OPERATION_LT ↔ TO-BE PKG_SCP0037.P_SCP0037_GET_OPER |  |
| AD-7e1e9a98 | A6 | SCP0037 SCP0037_GET_OPERATION_LT 공통·유일 행 상대 순서 | NA | ERROR | [ORDER] [차등 검증 #3] main/SEARCH AS-IS SCP0037_GET_OPERATION_LT ↔ TO-BE PKG_SCP0037.P_SCP0037_GET_OPER |  |
| AD-6c570bf4 | A7 | SCP0037 SCP0037_GET_OPERATION_LT 공통행 컬럼 값(공통 0행 · 불일치 셀 0) | NA | ERROR | [VALUES] [차등 검증 #4] main/SEARCH AS-IS SCP0037_GET_OPERATION_LT ↔ TO-BE PKG_SCP0037.P_SCP0037_GET_OPE |  |
| AD-ab023f3c | A6 | SCP0037 SCP0037_GET_OPERATION_LT 공통·유일 행 상대 순서 | NA | ERROR | [ORDER] [차등 검증 #5] main/SEARCH AS-IS SCP0037_GET_OPERATION_LT ↔ TO-BE PKG_SCP0037.P_SCP0037_GET_OPER |  |
| AD-7c20b05b | A7 | SCP0037 SCP0037_GET_OPERATION_LT 공통행 컬럼 값(공통 0행 · 불일치 셀 0) | NA | ERROR | [VALUES] [차등 검증 #6] main/SEARCH AS-IS SCP0037_GET_OPERATION_LT ↔ TO-BE PKG_SCP0037.P_SCP0037_GET_OPE |  |
| AD-3ab6a1f9 | A6 | SCP0037 SCP0037_GET_OPERATION_LT 공통·유일 행 상대 순서 | NA | ERROR | [ORDER] [차등 검증 #8] main/SEARCH AS-IS SCP0037_GET_OPERATION_LT ↔ TO-BE PKG_SCP0037.P_SCP0037_GET_OPER |  |
| AD-825346f9 | A7 | SCP0037 SCP0037_GET_OPERATION_LT 공통행 컬럼 값(공통 0행 · 불일치 셀 0) | NA | ERROR | [VALUES] [차등 검증 #9] main/SEARCH AS-IS SCP0037_GET_OPERATION_LT ↔ TO-BE PKG_SCP0037.P_SCP0037_GET_OPE |  |
| AD-55597710 | A7 | SCP0037 SCP0037_GET_OPERATION_LT 공통행 컬럼 값(공통 0행 · 불일치 셀 0) | NA | ERROR | [VALUES] [차등 검증 #10] main/SEARCH AS-IS SCP0037_GET_OPERATION_LT ↔ TO-BE PKG_SCP0037.P_SCP0037_GET_OP |  |
| AD-c9d1a7bb | A7 | SCP0037 SCP0037_GET_OPERATION_LT 공통행 컬럼 값(공통 0행 · 불일치 셀 0) | NA | ERROR | [VALUES] [차등 검증 #13] main/SEARCH AS-IS SCP0037_GET_OPERATION_LT ↔ TO-BE PKG_SCP0037.P_SCP0037_GET_OP |  |
| AD-24be7dc5 | A6 | SCP0037 SCP0037_GET_OPERATION_LT 공통·유일 행 상대 순서 | NA | ERROR | [ORDER] [차등 검증 #14] main/SEARCH AS-IS SCP0037_GET_OPERATION_LT ↔ TO-BE PKG_SCP0037.P_SCP0037_GET_OPE |  |
| AD-e6f9f563 | A7 | SCP0037 SCP0037_GET_OPERATION_LT 공통행 컬럼 값(공통 0행 · 불일치 셀 0) | NA | ERROR | [VALUES] [차등 검증 #15] main/SEARCH AS-IS SCP0037_GET_OPERATION_LT ↔ TO-BE PKG_SCP0037.P_SCP0037_GET_OP |  |
| T-b2a7c859 | E3 | 1 · cellType | PASS | ERROR | 행 집계 — 대조표 1 'cellType' 의 E3 4요소: PASS:2 · ERROR:2 |  |
| T-85e253f9 | X-LOC | 2 · cboDivision.SelectedIndexChanged | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-0065624f | E3 | 2 · cboDivision.SelectedIndexChanged | PASS | ERROR | 행 집계 — 대조표 2 'cboDivision.SelectedIndexChanged' 의 E3 4요소: PASS:2 · ERROR:2 |  |
| T-1d457945 | X-LOC | 3 · cboLTOperation.SelectedIndexChanged | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-a53a2b6c | E3 | 3 · cboLTOperation.SelectedIndexChanged | PASS | ERROR | 행 집계 — 대조표 3 'cboLTOperation.SelectedIndexChanged' 의 E3 4요소: PASS:2 · ERROR:2 |  |
| T-8af94649 | X-LOC | 4 · spdMain.CellClick | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-3c2be75d | E4 | SCM_SITE_ID / Plant Site | NA | ERROR | MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain_CellClick)에서 |  |
| T-6422d572 | E4 | MSG00093 | NA | ERROR | MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain_CellClick)에서 |  |
| T-11a89af0 | X-LOC | 5 · spdMain.ClipboardPasted | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-6db03fd4 | E4 | ITEM_ID / Material | NA | ERROR | MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain_CellClick)에서 |  |
| T-f0408cdf | X-LOC | 6 · spdMain.ComboSelChange | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-20517b7a | X-LOC | 7 · spdMain.KeyPress | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-4e4c4aeb | E3 | 7 · spdMain.KeyPress | PASS | ERROR | 행 집계 — 대조표 7 'spdMain.KeyPress' 의 E3 4요소: PASS:2 · ERROR:2 |  |
| T-7b41ee0b | A5 | 2 · cboDivision.SelectedIndexChanged | 판정필요 | ERROR | 행 집계 — 대조표 2 'cboDivision.SelectedIndexChanged' 의 A5 5요소: ERROR:3 · PASS:2 |  |
| T-e0cc811f | M4 | ITEM_ID / Material | NA | ERROR | 실측[T-e0cc811f]: 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace ／ [미검증] 검 |  |
| T-0662316e | X-LOC | 9 · SpdMain_ComboSelChange | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-acfa4892 | C3 | SCM_SITE_ID / Plant Site | NA | ERROR | SCM_SITE_ID: 원천 DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상 |  |
| T-c211493e | X-LOC | 10 · SpdMain_KeyPress | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-34f90402 | X-LOC | 11 · SpdMain_KeyPress | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-24ad6a47 | X-LOC | 12 · SpdMain_ClipboardPasted | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-d1c142e9 | C3 | 12 · SpdMain_ClipboardPasted | PASS | ERROR | 행 집계 — 대조표 12 'SpdMain_ClipboardPasted' 의 C3 12요소: ERROR:10 · NA:2 |  |
| T-f65d0482 | X-LOC | 13 · SpdMain_ClipboardPasted | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-88524230 | C3 | 13 · SpdMain_ClipboardPasted | PASS | ERROR | 행 집계 — 대조표 13 'SpdMain_ClipboardPasted' 의 C3 12요소: ERROR:10 · NA:2 |  |
| T-38f3981e | C3 | 5 · spdMain.ClipboardPasted | PASS | ERROR | 행 집계 — 대조표 5 'spdMain.ClipboardPasted' 의 C3 12요소: ERROR:10 · NA:2 |  |
| T-f3b52974 | C2 | PLANT_SITE_ID / Plant Site Code | NA | ERROR | 원천 DIVISION_ID 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) ／ [미검증] |  |
| T-999dbb95 | C3 | PLANT_SITE_ID / Plant Site Code | NA | ERROR | PLANT_SITE_ID: 원천 DIVISION_ID/SCM_SITE_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 |  |
| T-06533f7b | D4 | 10,6 · other | NA | ERROR | 행 집계 — 대조표 10,6 'other' 의 D4 2요소: ERROR:2 |  |
| T-2bca1c80 | D4 | DIVISION_ID / Division | NA | ERROR | 신규행 DIVISION_ID='81' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움: 의도 확인(연쇄 C3/팝업 M4 |  |
| T-9fac181c | D4 | LT_OPERATION / LT Operation | NA | ERROR | 신규행 LT_OPERATION='SLITTING' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움: 의도 확인(연쇄 C |  |
| T-7ccfb642 | B1 | DIVISION_ID / Division | NA | ERROR | 실측[T-7ccfb642]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger |  |
| T-b013b8d0 | B2 | DIVISION_ID / Division | NA | ERROR | 실측[T-b013b8d0]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger |  |
| T-c07eab72 | B4 | DIVISION_ID / Division | NA | ERROR | 실측[T-c07eab72]: 검사기(combo_oracle.py(W1))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.p |  |
| T-3d38ef12 | D5 | DIVISION_ID / Division | NA | ERROR | DIVISION_ID: AS-IS COMBO(AS-IS 문장) ↔ TO-BE dataType=1 dataMap=N — 편집 불가 칸이라 입력 방식 차이 없음 · 표시 표본 [81] |  |
| T-8400b42e | E5 | DIVISION_ID / Division | NA | ERROR | 실측[T-8400b42e]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger |  |
| T-4f9b7e94 | H6 | NICK_NAME / Nick Name | NA | ERROR | 실측[T-4f9b7e94]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@tra |  |
| T-ae06ca86 | G5 | NICK_NAME / Nick Name | NA | ERROR | 실측[T-ae06ca86]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진  |  |
| T-ee230b89 | A5 | 8 · dataSource | 판정필요 | ERROR | 행 집계 — 대조표 8 'dataSource' 의 A5 5요소: ERROR:3 · PASS:2 |  |
| T-9c2a1bfc | A5 | COMMON:UC-01 · 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 표시(keepRowV | 판정필요 | ERROR | 행 집계 — 대조표 COMMON:UC-01 '필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 표시(keepRowVisibl' 의 A5 5요소: ERROR:3 · PAS |  |
| T-c14e320c | D4 | COMMON:UC-01 · 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 표시(keepRowV | NA | ERROR | 행 집계 — 대조표 COMMON:UC-01 '필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 표시(keepRowVisibl' 의 D4 2요소: ERROR:2 |  |
| T-cdb5edb2 | A5 | COMMON:UC-02 · 데이터 수정 중 다른 데이터 조회 시 '수정 중...조회?' confirm(MSG | 판정필요 | ERROR | 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시 '수정 중...조회?' confirm(MSG00703" 의 A5 5요소: ERROR:3 · PAS |  |
| T-c59fb327 | D4 | COMMON:UC-03 · 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 Reset  | NA | ERROR | 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 Reset 후 재조회' 의 D4 2요소: ERROR:2 |  |
| T-b5227dfc | E3 | COMMON:UC-04 · CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 자동소멸 | PASS | ERROR | 행 집계 — 대조표 COMMON:UC-04 'CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 자동소멸' 의 E3 4요소: PASS:2 · ERROR:2 |  |
| T-6a63f281 | A5 | COMMON:UC-05 · Excel Download 시 콤보 컬럼 Code 아닌 Name 출력(dataMa | 판정필요 | ERROR | 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 Code 아닌 Name 출력(dataMap 승계)' 의 A5 5요소: ERROR:3 · PAS |  |
| T-1591cd8c | B1 | COMMON:UC-05 · Excel Download 시 콤보 컬럼 Code 아닌 Name 출력(dataMa | NA | ERROR | 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 Code 아닌 Name 출력(dataMap 승계)' 의 B1 3요소: PASS:2 · ERRO |  |
