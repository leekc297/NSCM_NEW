# 작업 원장 — SCP0100 · 2026-10-31 04:49

> 검사 인스턴스 574건 중 PASS·NA 362건 외 **212건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_FE** — FE 항목은 적용 대상. 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 6 | 재판정 PASS |
| W5 | 검사기 연결 | 36 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 6 | 실행 → PASS |
| W7 | 기대값 확정 | 85 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 79 | 원인 해소 → 재판정 |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 81 · 하네스·환경 79 · 하네스 36 · E2E 6 · 대조표 4 · 사람판정 2 · 화면 FE 2 · 공통 컴포넌트 1 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A1 | GEN |  |  |  |  |  |  | 32 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-ROW | GEN |  |  | 1 |  |  |  | 10 |  | 14 | 대조표 행이 서술한 동작을 화면에서 재현 |
| G5 | POPUP |  |  |  |  | 10 |  |  |  | 13 | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 4 | 6 | 1 |  | 12 | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  |  | 12 |  | 11 | 팝업 선택값 반영 |
| X-LOC | GEN |  |  |  |  |  |  | 21 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 12 | 배경·글자색 규칙 |
| B3 | COMBO |  |  |  |  | 9 |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 9 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 9 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| E4 | EDIT |  |  |  |  |  |  |  |  | 8 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A6 | GEN |  |  | 2 |  |  |  | 3 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G4 | DESIGN |  |  |  |  | 4 |  |  |  |  | 조회조건 표시·라벨·활성 |
| X-REASON | DESIGN |  |  |  |  |  |  | 4 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| SC1 | DESIGN |  |  | 1 |  |  |  |  |  |  | 조회조건 순서 = 기준표 |
| M3 | POPUP |  |  | 1 |  |  |  |  |  |  | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| I1 | DESIGN |  |  |  |  |  |  | 1 |  |  | LBL/MSG 언어별 등록 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |

## W3 동작 수정 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0100-0001 | H10 | SCP0100 화면 | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H10 FAIL 수정 — SCP0100 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: components/GlobalPsiReportForm.tsx (FX-SCP0100-025) |  | 4 (COMMON:UC-03 COMMON:UC-05 COMMON:UC-06 C) |
| WK-SCP0100-0002 | SC1 | SCP0100 화면 | DB(🛠️/🧯 적용 가능) | SC1 FAIL 수정 — SCP0100 화면: E2E smoke cond order / 실측[T-e7b4759f]: [사용자판정] 판정 오류 - SELECT ALL 은 TO-BE에서 추가된 항목이고 나머지는 동일 하게 나옴 — 실측: |  | 20 (CB-108 COMMON:UC-06 cboDivision dtpFrom ) |
| WK-SCP0100-0003 | A6 | PKG_SCP0100.P_SCP0100_GET_SITE | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SCP0100.P_SCP0100_GET_SITE: 원장 V-baf1c917 SP / 원장 V-fd80b9f9 SP / 원장 V-0dfb777d SP / 원장 V-ca05f66d SP / 정렬대조 FAIL |  | 2 (cboFromSite cboToSite) |
| WK-SCP0100-0004 | A6 | cboBucket | 사람판정(사람판정 대기) | A6 FAIL 수정 — cboBucket: 행 집계 — 대조표 cboBucket '`bucket`' 의 A6 5요소: NOT_RUN:3 · PASS:1 · FAIL:1 · FAIL 요소: PKG_SCP0100.P_SCP0100_GET |  | 1 (cboBucket) |
| WK-SCP0100-0005 | X-ROW | SCP0100_Global_PSI_Report.btnMeasure_Cli | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0100_Global_PSI_Report.btnMeasure_Click: 진입점 집계 7검사 — NA:4 · PASS:2 · FAIL:1 (FX-SCP0100-060) |  | 5 (ACT:SCP0100_Global_PSI_Report.btnMeasure) |
| WK-SCP0100-0006 | M3 | new SCM0002_TitleSetForm_Popup("SCP0100" | 화면 FE(적용 예정) | M3 FAIL 수정 — new SCM0002_TitleSetForm_Popup("SCP0100", measure, false): 원장 V-79e8ee99 (FX-SCP0100-007) |  | 1 (ACT:SCP0100_Global_PSI_Report.btnMeasure) |

## W5 검사기 연결 (36)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0100-0007 | B3 | CELL_GROUP / Cell Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL CELL_GROUP / Cell Group | 있음(SHEET_COLUMNS) | 1 (cboSearchLevel) |
| WK-SCP0100-0008 | B3 | DIVISION_ID / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL DIVISION_ID / Div | 있음(SHEET_COLUMNS) | 1 (CB-106) |
| WK-SCP0100-0009 | B3 | PLAN_TYPE / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL PLAN_TYPE / Plan Type | 있음(SHEET_COLUMNS) | 2 (CB-106 cboPlanType) |
| WK-SCP0100-0010 | B3 | cboDisplay / Display | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND cboDisplay / Display | 있음(FE 소스) | 1 (cboDisplay) |
| WK-SCP0100-0011 | B3 | chkAS / A/S / AS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND chkAS / A/S / AS | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getAS ACT:) |
| WK-SCP0100-0012 | B3 | chkCellQty / Cell Qty | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND chkCellQty / Cell Qty | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getCellQty) |
| WK-SCP0100-0013 | B3 | txtCellGroup / Cell Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND txtCellGroup / Cell Group | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getCellGro) |
| WK-SCP0100-0014 | B3 | txtItemId / Model / Nick Name / Item Id  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND txtItemId / Model / Nick Name / Item Id / Model/Ni | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getItemId ) |
| WK-SCP0100-0015 | B3 | txtProject / Project / PJT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND txtProject / Project / PJT | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getProject) |
| WK-SCP0100-0016 | B4 | CELL_GROUP / Cell Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CELL_GROUP / Cell Group | 있음(SHEET_COLUMNS) | 1 (cboSearchLevel) |
| WK-SCP0100-0017 | B4 | DIVISION_ID / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID / Div | 있음(SHEET_COLUMNS) | 1 (CB-106) |
| WK-SCP0100-0018 | B4 | PLAN_TYPE / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLAN_TYPE / Plan Type | 있음(SHEET_COLUMNS) | 2 (CB-106 cboPlanType) |
| WK-SCP0100-0019 | B4 | cboDisplay / Display | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDisplay / Display | 있음(FE 소스) | 1 (cboDisplay) |
| WK-SCP0100-0020 | B4 | chkAS / A/S / AS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND chkAS / A/S / AS | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getAS ACT:) |
| WK-SCP0100-0021 | B4 | chkCellQty / Cell Qty | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND chkCellQty / Cell Qty | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getCellQty) |
| WK-SCP0100-0022 | B4 | txtCellGroup / Cell Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtCellGroup / Cell Group | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getCellGro) |
| WK-SCP0100-0023 | B4 | txtItemId / Model / Nick Name / Item Id  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtItemId / Model / Nick Name / Item Id / Model/Ni | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getItemId ) |
| WK-SCP0100-0024 | B4 | txtProject / Project / PJT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtProject / Project / PJT | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getProject) |
| WK-SCP0100-0025 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.InitEvent ) |
| WK-SCP0100-0026 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 3 (txtItemId ACT:SCP0100_Global_PSI_Report.) |
| WK-SCP0100-0027 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.InitEvent ) |
| WK-SCP0100-0028 | G4 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProject | 있음(FE 소스) | 3 (txtProject ACT:SCP0100_Global_PSI_Report) |
| WK-SCP0100-0029 | G5 | CELL_GROUP / Cell Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL CELL_GROUP / Cell Group | 있음(SHEET_COLUMNS) | 2 (cboSearchLevel (CELL_GROUP)) |
| WK-SCP0100-0030 | G5 | PLAN_TYPE / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL PLAN_TYPE / Plan Type | 있음(SHEET_COLUMNS) | 1 (cboPlanType) |
| WK-SCP0100-0031 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (MODAL:ItemByDivisionModal txtItemId) |
| WK-SCP0100-0032 | G5 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnProject | 있음(FE 소스) | 2 (MODAL:ProjectByDivisionModal txtProject) |
| WK-SCP0100-0033 | G5 | cboDisplay / Display | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboDisplay / Display | 있음(FE 소스) | 1 (cboDisplay) |
| WK-SCP0100-0034 | G5 | cboPlanDate / Plan date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboPlanDate / Plan date / Plan Date | 있음(FE 소스) | 1 (cboPlanDate) |
| WK-SCP0100-0035 | G5 | cboPlanType / Plan-type / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 1 (cboPlanType) |
| WK-SCP0100-0036 | G5 | cboSearchLevel / Search Level | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboSearchLevel / Search Level | 있음(FE 소스) | 1 (cboSearchLevel) |
| WK-SCP0100-0037 | G5 | chkAS / A/S / AS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND chkAS / A/S / AS | 있음(FE 소스) | 1 (chkAS) |
| WK-SCP0100-0038 | G5 | chkCellQty / Cell Qty | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND chkCellQty / Cell Qty | 있음(FE 소스) | 1 (chkCellQty) |
| WK-SCP0100-0039 | H6 | CELL_GROUP / Cell Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CELL_GROUP / Cell Group | 있음(SHEET_COLUMNS) | 2 (cboSearchLevel (CELL_GROUP)) |
| WK-SCP0100-0040 | H6 | PLAN_TYPE / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PLAN_TYPE / Plan Type | 있음(SHEET_COLUMNS) | 1 (cboPlanType) |
| WK-SCP0100-0041 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (MODAL:ItemByDivisionModal txtItemId) |
| WK-SCP0100-0042 | H6 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProject | 있음(FE 소스) | 2 (MODAL:ProjectByDivisionModal txtProject) |

## W6 검증 실행 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0100-0043 | H6 | cboDisplay / Display | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDisplay / Display · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (cboDisplay) |
| WK-SCP0100-0044 | H6 | cboPlanDate / Plan date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboPlanDate / Plan date / Plan Date · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (cboPlanDate) |
| WK-SCP0100-0045 | H6 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (cboPlanType) |
| WK-SCP0100-0046 | H6 | cboSearchLevel / Search Level | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboSearchLevel / Search Level · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (cboSearchLevel) |
| WK-SCP0100-0047 | H6 | chkAS / A/S / AS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — chkAS / A/S / AS · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (chkAS) |
| WK-SCP0100-0048 | H6 | chkCellQty / Cell Qty | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — chkCellQty / Cell Qty · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (chkCellQty) |

## W7 기대값 확정 (85)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0100-0049 | I1 | SCP0100 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | I1 기대값 확정 — SCP0100 화면: 원장 V-9ffeb201 RULE_SCREEN / 원장 V-92144de7 DEFECT / 원장 V-d4a4eab4 DEFECT / 원장 V-21d4bc03 DEFECT / 원장 V-7efa |  | 1 (ACT:SCP0100_Global_PSI_Report.DCalendar_) |
| WK-SCP0100-0050 | X-REASON | CA-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-101 §1 [원문 무번호] AS-IS / TO-BE — 표 헤더 행(실제 항목 아님) 해당없음 |  | 1 (CA-101) |
| WK-SCP0100-0051 | X-REASON | CB-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CB-101 §2 [원문 무번호] AS-IS 컨트롤 / TO-BE searchCondition — 표 헤더 행(실제 항목 아님) 해당없음 |  | 1 (CB-101) |
| WK-SCP0100-0052 | X-REASON | CB-119 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CB-119 §2 [원문 무번호] CboGraphType / 미배선 — AS-IS 핸들러 본문 공백(NO-OP, screen-analysis.json events) + LBL 미등록(design 02 |  | 1 (CB-119) |
| WK-SCP0100-0053 | X-REASON | CC-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CC-101 §3 [원문 무번호] AS-IS FpSpread / TO-BE SHEETS — 표 헤더 행(실제 항목 아님) 해당없음 |  | 1 (CC-101) |
| WK-SCP0100-0054 | A1 | (CELL_GROUP) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — (CELL_GROUP): 행 집계 — 대조표 (CELL_GROUP) '`cellGroup`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_S |  | 1 ((CELL_GROUP)) |
| WK-SCP0100-0055 | A1 | (세션) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — (세션): 행 집계 — 대조표 (세션) '—' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_c |  | 1 ((세션)) |
| WK-SCP0100-0056 | A1 | CA-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CA-102: 행 집계 — 대조표 CA-102 '§1 [원문 무번호] FindButton / `hotkeyConfig.search = ha' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SE |  | 1 (CA-102) |
| WK-SCP0100-0057 | A1 | CB-108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CB-108: 행 집계 — 대조표 CB-108 '§2 [원문 무번호] cboDisplay / `display`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스  |  | 1 (CB-108) |
| WK-SCP0100-0058 | A1 | CB-112 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CB-112: 행 집계 — 대조표 CB-112 '§2 [원문 무번호] txtItemId / `itemId`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음 |  | 1 (CB-112) |
| WK-SCP0100-0059 | A1 | CB-114 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CB-114: 행 집계 — 대조표 CB-114 '§2 [원문 무번호] txtProject / `project`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스  |  | 1 (CB-114) |
| WK-SCP0100-0060 | A1 | COLUMN_SETUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COLUMN_SETUP: 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (MODAL:GlobalPsiReportModals) |
| WK-SCP0100-0061 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 A1 8요소: REVIEW:8 · FAIL 요 |  | 1 (COMMON:UC-03) |
| WK-SCP0100-0062 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUM |  | 1 (COMMON:UC-06) |
| WK-SCP0100-0063 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 8요소: REVIEW:8 · FAIL 요 |  | 1 (COMMON:UC-07) |
| WK-SCP0100-0064 | A1 | CboGraphType | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CboGraphType: 행 집계 — 대조표 CboGraphType '미배선' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝 |  | 1 (CboGraphType) |
| WK-SCP0100-0065 | A1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton: 행 집계 — 대조표 FindButton '`hotkeyConfig.search = handleSearch`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP —  |  | 1 (FindButton) |
| WK-SCP0100-0066 | A1 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0100-0067 | A1 | PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIV | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIVISION_POPU: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIVISION_POPUP — |  | 1 (MODAL:ProjectByDivisionModal) |
| WK-SCP0100-0068 | A1 | PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT: 골든 비교 케이스 없음(PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT — 팝업·보조 SP 는 gol |  | 35 (ACT:SCP0100_Global_PSI_Report.FindButton) |
| WK-SCP0100-0069 | A1 | PKG_SCP0100.P_SCP0100_GET_PLAN_DATE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0100.P_SCP0100_GET_PLAN_DATE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0100/SCP0100_GET_PLAN_DATE.md —  |  | 1 (cboPlanDate) |
| WK-SCP0100-0070 | A1 | PKG_SCP0100.P_SCP0100_GET_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0100.P_SCP0100_GET_SITE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0100/SCP0100_GET_SITE.md — 파라미터 미정 |  | 2 (cboFromSite cboToSite) |
| WK-SCP0100-0071 | A1 | P_CHK_AS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_CHK_AS: 골든 비교 케이스 없음(P_CHK_AS — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (chkAS) |
| WK-SCP0100-0072 | A1 | P_CHK_CELL_QTY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_CHK_CELL_QTY: 골든 비교 케이스 없음(P_CHK_CELL_QTY — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (chkCellQty) |
| WK-SCP0100-0073 | A1 | SCP0100_Global_PSI_Report.AfterFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0100_Global_PSI_Report.AfterFindData: 진입점 집계 — 대조표 SCP0100_Global_PSI_Report.AfterFindData 의 A1 8요소: REVIEW:8 · FAI |  | 1 (ACT:SCP0100_Global_PSI_Report.AfterFindD) |
| WK-SCP0100-0074 | A1 | cboBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboBucket: 행 집계 — 대조표 cboBucket '`bucket`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업 |  | 1 (cboBucket) |
| WK-SCP0100-0075 | A1 | cboDisplay | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDisplay: 행 집계 — 대조표 cboDisplay '`display`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — |  | 1 (cboDisplay) |
| WK-SCP0100-0076 | A1 | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision: 행 집계 — 대조표 cboDivision '`divisionId`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SE |  | 1 (cboDivision) |
| WK-SCP0100-0077 | A1 | cboPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboPlanType: 행 집계 — 대조표 cboPlanType '`planType`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETU |  | 1 (cboPlanType) |
| WK-SCP0100-0078 | A1 | cboSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboSearchLevel: 행 집계 — 대조표 cboSearchLevel '`searchLevel`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(CO |  | 1 (cboSearchLevel) |
| WK-SCP0100-0079 | A1 | dtpFrom | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — dtpFrom: 행 집계 — 대조표 dtpFrom '`fromYyyymmdd`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP —  |  | 1 (dtpFrom) |
| WK-SCP0100-0080 | A1 | dtpTo | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — dtpTo: 행 집계 — 대조표 dtpTo '`toYyyymmdd`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조  |  | 1 (dtpTo) |
| WK-SCP0100-0081 | A1 | spdSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — spdSearchLevel: 행 집계 — 대조표 spdSearchLevel 'SEARCH_LEVEL' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COL |  | 1 (spdSearchLevel) |
| WK-SCP0100-0082 | A1 | spdSearchLevelDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — spdSearchLevelDetail: 행 집계 — 대조표 spdSearchLevelDetail 'SEARCH_LEVEL_DETAIL' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP |  | 1 (spdSearchLevelDetail) |
| WK-SCP0100-0083 | A1 | txtItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtItemId: 행 집계 — 대조표 txtItemId '`itemId`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업 |  | 1 (txtItemId) |
| WK-SCP0100-0084 | A1 | txtProject | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtProject: 행 집계 — 대조표 txtProject '`project`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — |  | 1 (txtProject) |
| WK-SCP0100-0085 | A1 | ~~txtNickName~~ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ~~txtNickName~~: 행 집계 — 대조표 ~~txtNickName~~ '`nickName`(잔존)' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음 |  | 1 (~~txtNickName~~) |
| WK-SCP0100-0086 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 검증 엔진이 실행됐으나 이 대상(SP PKG_SCM0002.P_SCM0002_GET_ITEM)을 판정하지 못함 — 결과 행 |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0100-0087 | A6 | PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIV | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIVISION_POPU: 검증 엔진이 실행됐으나 이 대상(SP PKG_SCM0002.P_SCM0002_GET_PROJ)을 판정하지 못함 — 결과 |  | 1 (MODAL:ProjectByDivisionModal) |
| WK-SCP0100-0088 | A6 | PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT: 검증 엔진이 실행됐으나 이 대상(SP PKG_SCP0100.P_SCP0100_GET_GLOB)을 판정하지 못함 — 결과 행 정렬 순 |  | 35 (ACT:SCP0100_Global_PSI_Report.FindButton) |
| WK-SCP0100-0089 | G03-WIRE | SCP0100 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0100 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 / 게이트 G03 As-is 이벤트 this.Shown → SCP0100_Global_PS  |  | 21 (ACT:SCP0100_Global_PSI_Report..ctor ACT:) |
| WK-SCP0100-0090 | X-LOC | (CELL_GROUP) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — (CELL_GROUP): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ((CELL_GROUP)) |
| WK-SCP0100-0091 | X-LOC | (세션) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — (세션): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ((세션)) |
| WK-SCP0100-0092 | X-LOC | CboGraphType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CboGraphType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CboGraphType) |
| WK-SCP0100-0093 | X-LOC | cboBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboBucket: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboBucket) |
| WK-SCP0100-0094 | X-LOC | cboDisplay | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboDisplay: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboDisplay) |
| WK-SCP0100-0095 | X-LOC | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboDivision) |
| WK-SCP0100-0096 | X-LOC | cboFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboFromSite: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboFromSite) |
| WK-SCP0100-0097 | X-LOC | cboPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboPlanDate: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboPlanDate) |
| WK-SCP0100-0098 | X-LOC | cboPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboPlanType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboPlanType) |
| WK-SCP0100-0099 | X-LOC | cboSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboSearchLevel: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboSearchLevel) |
| WK-SCP0100-0100 | X-LOC | cboToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboToSite: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboToSite) |
| WK-SCP0100-0101 | X-LOC | chkAS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — chkAS: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (chkAS) |
| WK-SCP0100-0102 | X-LOC | chkCellQty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — chkCellQty: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (chkCellQty) |
| WK-SCP0100-0103 | X-LOC | dtpFrom | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — dtpFrom: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (dtpFrom) |
| WK-SCP0100-0104 | X-LOC | dtpTo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — dtpTo: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (dtpTo) |
| WK-SCP0100-0105 | X-LOC | spdDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdDetail: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdDetail) |
| WK-SCP0100-0106 | X-LOC | spdSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdSearchLevel: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdSearchLevel) |
| WK-SCP0100-0107 | X-LOC | spdSearchLevelDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdSearchLevelDetail: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdSearchLevelDetail) |
| WK-SCP0100-0108 | X-LOC | txtItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — txtItemId: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (txtItemId) |
| WK-SCP0100-0109 | X-LOC | txtProject | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — txtProject: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (txtProject) |
| WK-SCP0100-0110 | X-LOC | ~~txtNickName~~ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ~~txtNickName~~: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (~~txtNickName~~) |
| WK-SCP0100-0111 | X-ROW | SCP0100_Global_PSI_Report.BeforeFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.BeforeFindData: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0100_Global_PSI_Report.BeforeFind) |
| WK-SCP0100-0112 | X-ROW | SCP0100_Global_PSI_Report.DCalendar_Valu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.DCalendar_ValueChanged: 진입점 집계 5검사 — NA:4 · WARN:1 |  | 2 (ACT:SCP0100_Global_PSI_Report.DCalendar_) |
| WK-SCP0100-0113 | X-ROW | SCP0100_Global_PSI_Report.EnableSearchLe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.EnableSearchLevel: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/STATE, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0100_Global_PSI_Report.EnableSear) |
| WK-SCP0100-0114 | X-ROW | SCP0100_Global_PSI_Report.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연 |  | 16 (ACT:SCP0100_Global_PSI_Report.ExcelButto) |
| WK-SCP0100-0115 | X-ROW | SCP0100_Global_PSI_Report.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.FindButton: 진입점 집계 3검사 — REVIEW:1 · NOT_RUN:1 · PASS:1 |  | 1 (ACT:SCP0100_Global_PSI_Report.FindButton) |
| WK-SCP0100-0116 | X-ROW | SCP0100_Global_PSI_Report.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.FindData: 진입점 집계 3검사 — REVIEW:1 · NOT_RUN:1 · PASS:1 |  | 1 (ACT:SCP0100_Global_PSI_Report.FindData) |
| WK-SCP0100-0117 | X-ROW | SCP0100_Global_PSI_Report.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.FindDataMain: 진입점 집계 4검사 — PASS:2 · REVIEW:1 · NOT_RUN:1 |  | 5 (ACT:SCP0100_Global_PSI_Report.FindDataMa) |
| WK-SCP0100-0118 | X-ROW | SCP0100_Global_PSI_Report.RefreshPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.RefreshPlant: 진입점 동작 재현 시나리오 필요 — 문장 종류 COMBO_DATA/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0100_Global_PSI_Report.RefreshPla) |
| WK-SCP0100-0119 | X-ROW | SCP0100_Global_PSI_Report.SCP0100_Global | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.SCP0100_Global_PSI_Repor: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/FLAG, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0100_Global_PSI_Report.SCP0100_Gl) |
| WK-SCP0100-0120 | X-ROW | SCP0100_Global_PSI_Report.VisibleSheet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.VisibleSheet: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/STATE, 연결된 요소 검사 없음 |  | 11 (ACT:SCP0100_Global_PSI_Report.VisibleShe) |
| WK-SCP0100-0121 | H6 | txtProject / Project / PJT | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — txtProject / Project / PJT: E2E smoke cond popup / 실측[T-fba3ab11]: E2E smoke cond popup / 실측[T-fba3ab11]: E2E smoke co |  | 2 (CB-114 txtProject) |
| WK-SCP0100-0122 | M4 | CELL_GROUP / Cell Group | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — CELL_GROUP / Cell Group: 검증 엔진이 실행됐으나 이 대상(COL CELL_GROUP)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (cboSearchLevel (CELL_GROUP)) |
| WK-SCP0100-0123 | M4 | PLAN_TYPE / Plan Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — PLAN_TYPE / Plan Type: 검증 엔진이 실행됐으나 이 대상(COL PLAN_TYPE)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (cboPlanType) |
| WK-SCP0100-0124 | M4 | btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnItemId: 검증 엔진이 실행됐으나 이 대상(BTN btnItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (MODAL:ItemByDivisionModal txtItemId) |
| WK-SCP0100-0125 | M4 | btnProject | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnProject: 검증 엔진이 실행됐으나 이 대상(BTN btnProject)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (MODAL:ProjectByDivisionModal txtProject) |
| WK-SCP0100-0126 | M4 | cboDisplay / Display | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboDisplay / Display: 검증 엔진이 실행됐으나 이 대상(COND cboDisplay)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (cboDisplay) |
| WK-SCP0100-0127 | M4 | cboPlanDate / Plan date / Plan Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboPlanDate / Plan date / Plan Date: 검증 엔진이 실행됐으나 이 대상(COND cboPlanDate)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (cboPlanDate) |
| WK-SCP0100-0128 | M4 | cboPlanType / Plan-type / Plan Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboPlanType / Plan-type / Plan Type: 검증 엔진이 실행됐으나 이 대상(COND cboPlanType)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (cboPlanType) |
| WK-SCP0100-0129 | M4 | cboSearchLevel / Search Level | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboSearchLevel / Search Level: 검증 엔진이 실행됐으나 이 대상(COND cboSearchLevel)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (cboSearchLevel) |
| WK-SCP0100-0130 | M4 | chkAS / A/S / AS | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — chkAS / A/S / AS: 검증 엔진이 실행됐으나 이 대상(COND chkAS)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (chkAS) |
| WK-SCP0100-0131 | M4 | chkCellQty / Cell Qty | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — chkCellQty / Cell Qty: 검증 엔진이 실행됐으나 이 대상(COND chkCellQty)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (chkCellQty) |
| WK-SCP0100-0132 | M4 | txtItemId / Model / Nick Name / Item Id  | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtItemId / Model / Nick Name / Item Id / Model/Ni: 검증 엔진이 실행됐으나 이 대상(COND txtItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인  |  | 2 (CB-112 txtItemId) |
| WK-SCP0100-0133 | M4 | txtProject / Project / PJT | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtProject / Project / PJT: 검증 엔진이 실행됐으나 이 대상(COND txtProject)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (CB-114 txtProject) |

## W9 도구 오류 (79)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0100-0134 | A5 | CA-104 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 CA-104 '§1 [원문 무번호] SaveButton/InsertButton/DeleteButton/M' 의 A5 3요소: ERROR:3 |  | 1 (CA-104) |
| WK-SCP0100-0135 | A5 | CB-108 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 CB-108 '§2 [원문 무번호] cboDisplay / `display`' 의 A5 3요소: ERROR:3 |  | 1 (CB-108) |
| WK-SCP0100-0136 | A5 | COMMON:UC-07 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A5 3요소: ERROR:3 |  | 1 (COMMON:UC-07) |
| WK-SCP0100-0137 | A5 | PRODUCT_LEVEL1 / Product Level1 | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-cbfd4c10]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 a2a9af99 ≠ 현재 d5c2af2d) — 이전 판정 NA 보류: PR |  | 5 (ACT:SCP0100_Global_PSI_Report.SetLayout:) |
| WK-SCP0100-0138 | A5 | PRODUCT_LEVEL2 / Product Level2 | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-fc2a4f34]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 6f7c4b8a ≠ 현재 df31c3e8) — 이전 판정 NA 보류: PR |  | 5 (ACT:SCP0100_Global_PSI_Report.SetLayout:) |
| WK-SCP0100-0139 | A5 | PRODUCT_LEVEL3 / Product Level3 | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-f5950dc8]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 699b1c08 ≠ 현재 0575737f) — 이전 판정 NA 보류: PR |  | 5 (ACT:SCP0100_Global_PSI_Report.SetLayout:) |
| WK-SCP0100-0140 | A5 | spdDetail | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 spdDetail 'REPORT' 의 A5 3요소: ERROR:3 |  | 1 (spdDetail) |
| WK-SCP0100-0141 | A5 | spdSearchLevel | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 spdSearchLevel 'SEARCH_LEVEL' 의 A5 3요소: ERROR:3 |  | 1 (spdSearchLevel) |
| WK-SCP0100-0142 | A5 | spdSearchLevelDetail | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 spdSearchLevelDetail 'SEARCH_LEVEL_DETAIL' 의 A5 3요소: ERROR:3 |  | 1 (spdSearchLevelDetail) |
| WK-SCP0100-0143 | H2 | CELL_GROUP / Cell Group | 하네스·환경 | H2 도구 오류 — 원장 V-3c2bff86 COLUMN / 원장 V-8badac7e COLUMN / 원장 V-90187848 COLUMN / 실측[T-2219aa82]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측 |  | 2 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0144 | H2 | COMMON:UC-07 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H2 7요소: ERROR:5 · NA:2 |  | 1 (COMMON:UC-07) |
| WK-SCP0100-0145 | H2 | MEASURE_GROUP / Measure Group | 하네스·환경 | H2 도구 오류 — 원장 V-1da8565a COLUMN / 원장 V-89ae4f8c COLUMN / 원장 V-85779748 COLUMN / 실측[T-68913d3c]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측 |  | 2 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0146 | H2 | MEASURE_NAME / Measure Name | 하네스·환경 | H2 도구 오류 — 원장 V-182e5fdb COLUMN / 원장 V-39223b94 COLUMN / 원장 V-2fbc9c53 COLUMN / 실측[T-c065d5f2]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측 |  | 2 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0147 | H2 | MEASURE_UI / Measure | 하네스·환경 | H2 도구 오류 — 실측[T-ca6ddcc7]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 daa93783 ≠ 현재 b15db5cc) — 이전 판정 NA 보류: MEASURE_UI: 그리드 미표시 —  |  | 2 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0148 | H2 | SCP0100_Global_PSI_Report.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0100_Global_PSI_Report.CreateSpread 의 H2 7요소: ERROR:5 · NA:2 |  | 10 (ACT:SCP0100_Global_PSI_Report.CreateSpre) |
| WK-SCP0100-0149 | H2 | SCP0100_Global_PSI_Report.SetBackColor | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0100_Global_PSI_Report.SetBackColor 의 H2 7요소: ERROR:5 · NA:2 |  | 112 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0150 | H2 | SCP0100_Global_PSI_Report.SetSpreadColum | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0100_Global_PSI_Report.SetSpreadColumn 의 H2 7요소: ERROR:5 · NA:2 |  | 12 (ACT:SCP0100_Global_PSI_Report.SetSpreadC) |
| WK-SCP0100-0151 | H2 | VARIOUS_KEY / Trans Mode or Line or Proj | 하네스·환경 | H2 도구 오류 — 원장 V-33b93efd COLUMN / 실측[T-d7567c2b]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 8a29e481 ≠ 현재 f56f3eca) — 이전 판정 NA 보류: |  | 2 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0152 | H2 | spdDetail | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 spdDetail 'REPORT' 의 H2 7요소: ERROR:5 · NA:2 |  | 1 (spdDetail) |
| WK-SCP0100-0153 | H2 | spdSearchLevel | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 spdSearchLevel 'SEARCH_LEVEL' 의 H2 7요소: ERROR:5 · NA:2 |  | 1 (spdSearchLevel) |
| WK-SCP0100-0154 | H2 | spdSearchLevelDetail | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 spdSearchLevelDetail 'SEARCH_LEVEL_DETAIL' 의 H2 7요소: ERROR:5 · NA:2 |  | 1 (spdSearchLevelDetail) |
| WK-SCP0100-0155 | E4 | CELL_GROUP / Cell Group | 하네스·환경 | E4 도구 오류 — 실측[T-f93d14b7]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 9fe7a3f0 ≠ 현재 bf89f706) — 이전 판정 NA 보류: CELL_GROUP: 이 대상에 연결된  |  | 2 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0156 | E4 | MEASURE_GROUP / Measure Group | 하네스·환경 | E4 도구 오류 — 실측[T-74dbf6a1]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 a125615b ≠ 현재 a2b52c38) — 이전 판정 NA 보류: MEASURE_GROUP: 이 대상에 연 |  | 2 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0157 | E4 | MEASURE_NAME / Measure Name | 하네스·환경 | E4 도구 오류 — 실측[T-99c741ee]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 9c396acc ≠ 현재 a438e82f) — 이전 판정 NA 보류: MEASURE_NAME: 이 대상에 연결 |  | 6 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0158 | E4 | MEASURE_UI / Measure | 하네스·환경 | E4 도구 오류 — 실측[T-c309fb5a]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 4a38a19e ≠ 현재 bfc249bc) — 이전 판정 NA 보류: MEASURE_UI: 이 대상에 연결된  |  | 2 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0159 | E4 | PRODUCT_LEVEL1 / Product Level1 | 하네스·환경 | E4 도구 오류 — 실측[T-71e15d92]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 b10aaf1a ≠ 현재 c2f4f72d) — 이전 판정 NA 보류: PRODUCT_LEVEL1: 이 대상에  |  | 8 (ACT:SCP0100_Global_PSI_Report.SetLayout ) |
| WK-SCP0100-0160 | E4 | PRODUCT_LEVEL2 / Product Level2 | 하네스·환경 | E4 도구 오류 — 실측[T-4f1ba6cd]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 cc8eb3de ≠ 현재 7381860f) — 이전 판정 NA 보류: PRODUCT_LEVEL2: 이 대상에  |  | 7 (ACT:SCP0100_Global_PSI_Report.SetLayout ) |
| WK-SCP0100-0161 | E4 | PRODUCT_LEVEL3 / Product Level3 | 하네스·환경 | E4 도구 오류 — 실측[T-2ef8fbba]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 0dddf4ae ≠ 현재 2fcb61c9) — 이전 판정 NA 보류: PRODUCT_LEVEL3: 이 대상에  |  | 6 (ACT:SCP0100_Global_PSI_Report.SetLayout ) |
| WK-SCP0100-0162 | E4 | VARIOUS_KEY / Trans Mode or Line or Proj | 하네스·환경 | E4 도구 오류 — 실측[T-9d09620f]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 14442042 ≠ 현재 e69d10a3) — 이전 판정 NA 보류: VARIOUS_KEY: 이 대상에 연결된 |  | 2 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0163 | X-ROW | SCP0100_Global_PSI_Report.BtnProject_Cli | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — NA:4 · PASS:3 · ERROR:2 |  | 5 (ACT:SCP0100_Global_PSI_Report.BtnProject) |
| WK-SCP0100-0164 | X-ROW | SCP0100_Global_PSI_Report.CboBucketType_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.CboBucketT) |
| WK-SCP0100-0165 | X-ROW | SCP0100_Global_PSI_Report.CboDisplay_Sel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0100_Global_PSI_Report.CboDisplay) |
| WK-SCP0100-0166 | X-ROW | SCP0100_Global_PSI_Report.CboPlanDate_Se | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.CboPlanDat) |
| WK-SCP0100-0167 | X-ROW | SCP0100_Global_PSI_Report.CboSearchLevel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.CboSearchL) |
| WK-SCP0100-0168 | X-ROW | SCP0100_Global_PSI_Report.CboUnitQty_Sel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.CboUnitQty) |
| WK-SCP0100-0169 | X-ROW | SCP0100_Global_PSI_Report.ClbDivision_Se | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.ClbDivisio) |
| WK-SCP0100-0170 | X-ROW | SCP0100_Global_PSI_Report.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.CreateSpre) |
| WK-SCP0100-0171 | X-ROW | SCP0100_Global_PSI_Report.SetBackColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 26검사 — NA:12 · ERROR:10 · NOT_RUN:3 · NOPATH:1 |  | 22 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0172 | X-ROW | SCP0100_Global_PSI_Report.SetCalculating | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:4 · ERROR:1 |  | 1 (ACT:SCP0100_Global_PSI_Report.SetCalcula) |
| WK-SCP0100-0173 | X-ROW | SCP0100_Global_PSI_Report.SetCalendar | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.SetCalenda) |
| WK-SCP0100-0174 | X-ROW | SCP0100_Global_PSI_Report.SetGridClear | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:1 · NA:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.SetGridCle) |
| WK-SCP0100-0175 | X-ROW | SCP0100_Global_PSI_Report.SetSpreadColum | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:4 · NA:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0100_Global_PSI_Report.SetSpreadC) |
| WK-SCP0100-0176 | X-ROW | SCP0100_Global_PSI_Report.rgrpSearchLeve | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.rgrpSearch) |
| WK-SCP0100-0177 | G5 | (세션) | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 (세션) '—' 의 G5 22요소: NOPATH:10 · NA:7 · PASS:3 · ERROR:2 |  | 1 ((세션)) |
| WK-SCP0100-0178 | G5 | COMMON:UC-06 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G5 22요소: NOPATH:10 · NA:7 · PASS:3 · ERROR:2 |  | 1 (COMMON:UC-06) |
| WK-SCP0100-0179 | G5 | CboGraphType | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 CboGraphType '미배선' 의 G5 22요소: NOPATH:10 · NA:7 · PASS:3 · ERROR:2 |  | 1 (CboGraphType) |
| WK-SCP0100-0180 | G5 | MODAL:GlobalPsiReportModals | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 MODAL:GlobalPsiReportModals 'FE 실존 모달 (components/GlobalPsiReportModals.tsx) — ' 의 G5 22요소: NOPATH:10 · NA:7 |  | 1 (MODAL:GlobalPsiReportModals) |
| WK-SCP0100-0181 | G5 | cboBucket | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 cboBucket '`bucket`' 의 G5 22요소: NOPATH:10 · NA:7 · PASS:3 · ERROR:2 |  | 1 (cboBucket) |
| WK-SCP0100-0182 | G5 | cboDivision | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 cboDivision '`divisionId`' 의 G5 22요소: NOPATH:10 · NA:7 · PASS:3 · ERROR:2 |  | 1 (cboDivision) |
| WK-SCP0100-0183 | G5 | cboFromSite | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 cboFromSite '`fromSite`' 의 G5 22요소: NOPATH:10 · NA:7 · PASS:3 · ERROR:2 |  | 1 (cboFromSite) |
| WK-SCP0100-0184 | G5 | cboToSite | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 cboToSite '`toSite`' 의 G5 22요소: NOPATH:10 · NA:7 · PASS:3 · ERROR:2 |  | 1 (cboToSite) |
| WK-SCP0100-0185 | G5 | dtpFrom | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 dtpFrom '`fromYyyymmdd`' 의 G5 22요소: NOPATH:10 · NA:7 · PASS:3 · ERROR:2 |  | 1 (dtpFrom) |
| WK-SCP0100-0186 | G5 | dtpTo | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 dtpTo '`toYyyymmdd`' 의 G5 22요소: NOPATH:10 · NA:7 · PASS:3 · ERROR:2 |  | 1 (dtpTo) |
| WK-SCP0100-0187 | G5 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-65f355fd |  | 1 (ACT:SCP0100_Global_PSI_Report.BtnProject) |
| WK-SCP0100-0188 | G5 | popProject.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-5e429823 |  | 1 (ACT:SCP0100_Global_PSI_Report.BtnProject) |
| WK-SCP0100-0189 | G5 | ~~txtNickName~~ | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 ~~txtNickName~~ '`nickName`(잔존)' 의 G5 22요소: NOPATH:10 · NA:7 · PASS:3 · ERROR:2 |  | 1 (~~txtNickName~~) |
| WK-SCP0100-0190 | H6 | (세션) | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 (세션) '—' 의 H6 22요소: NA:10 · NOT_RUN:6 · NOPATH:4 · ERROR:1 · WARN:1 |  | 1 ((세션)) |
| WK-SCP0100-0191 | H6 | COMMON:UC-06 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 H6 22요소: NA:10 · NOT_RUN:6 · NOPATH:4 · ERROR:1  |  | 1 (COMMON:UC-06) |
| WK-SCP0100-0192 | H6 | CboGraphType | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 CboGraphType '미배선' 의 H6 22요소: NA:10 · NOT_RUN:6 · NOPATH:4 · ERROR:1 · WARN:1 |  | 1 (CboGraphType) |
| WK-SCP0100-0193 | H6 | MODAL:GlobalPsiReportModals | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 MODAL:GlobalPsiReportModals 'FE 실존 모달 (components/GlobalPsiReportModals.tsx) — ' 의 H6 22요소: NA:10 · NOT_RUN: |  | 1 (MODAL:GlobalPsiReportModals) |
| WK-SCP0100-0194 | H6 | cboBucket | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 cboBucket '`bucket`' 의 H6 22요소: NA:10 · NOT_RUN:6 · NOPATH:4 · ERROR:1 · WARN:1 |  | 1 (cboBucket) |
| WK-SCP0100-0195 | H6 | cboDivision | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 cboDivision '`divisionId`' 의 H6 22요소: NA:10 · NOT_RUN:6 · NOPATH:4 · ERROR:1 · WARN:1 |  | 1 (cboDivision) |
| WK-SCP0100-0196 | H6 | cboFromSite | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 cboFromSite '`fromSite`' 의 H6 22요소: NA:10 · NOT_RUN:6 · NOPATH:4 · ERROR:1 · WARN:1 |  | 1 (cboFromSite) |
| WK-SCP0100-0197 | H6 | cboToSite | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 cboToSite '`toSite`' 의 H6 22요소: NA:10 · NOT_RUN:6 · NOPATH:4 · ERROR:1 · WARN:1 |  | 1 (cboToSite) |
| WK-SCP0100-0198 | H6 | dtpFrom | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 dtpFrom '`fromYyyymmdd`' 의 H6 22요소: NA:10 · NOT_RUN:6 · NOPATH:4 · ERROR:1 · WARN:1 |  | 1 (dtpFrom) |
| WK-SCP0100-0199 | H6 | dtpTo | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 dtpTo '`toYyyymmdd`' 의 H6 22요소: NA:10 · NOT_RUN:6 · NOPATH:4 · ERROR:1 · WARN:1 |  | 1 (dtpTo) |
| WK-SCP0100-0200 | H6 | txtItemId / Model / Nick Name / Item Id  | 하네스·환경 | H6 도구 오류 — E2E smoke cond popup |  | 2 (CB-112 txtItemId) |
| WK-SCP0100-0201 | H6 | ~~txtNickName~~ | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 ~~txtNickName~~ '`nickName`(잔존)' 의 H6 22요소: NA:10 · NOT_RUN:6 · NOPATH:4 · ERROR:1 · WARN:1 |  | 1 (~~txtNickName~~) |
| WK-SCP0100-0202 | M4 | (세션) | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 (세션) '—' 의 M4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 ((세션)) |
| WK-SCP0100-0203 | M4 | COMMON:UC-06 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 M4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0100-0204 | M4 | CboGraphType | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 CboGraphType '미배선' 의 M4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (CboGraphType) |
| WK-SCP0100-0205 | M4 | MODAL:GlobalPsiReportModals | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 MODAL:GlobalPsiReportModals 'FE 실존 모달 (components/GlobalPsiReportModals.tsx) — ' 의 M4 12요소: NOT_RUN:12 (미실행  |  | 1 (MODAL:GlobalPsiReportModals) |
| WK-SCP0100-0206 | M4 | cboBucket | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 cboBucket '`bucket`' 의 M4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (cboBucket) |
| WK-SCP0100-0207 | M4 | cboDivision | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 cboDivision '`divisionId`' 의 M4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (cboDivision) |
| WK-SCP0100-0208 | M4 | cboFromSite | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 cboFromSite '`fromSite`' 의 M4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (cboFromSite) |
| WK-SCP0100-0209 | M4 | cboToSite | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 cboToSite '`toSite`' 의 M4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (cboToSite) |
| WK-SCP0100-0210 | M4 | dtpFrom | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 dtpFrom '`fromYyyymmdd`' 의 M4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (dtpFrom) |
| WK-SCP0100-0211 | M4 | dtpTo | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 dtpTo '`toYyyymmdd`' 의 M4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (dtpTo) |
| WK-SCP0100-0212 | M4 | ~~txtNickName~~ | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 ~~txtNickName~~ '`nickName`(잔존)' 의 M4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (~~txtNickName~~) |
