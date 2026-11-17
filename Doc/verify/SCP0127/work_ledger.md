# 작업 원장 — SCP0127 · 2026-11-14 19:21

> 검사 인스턴스 169건 중 PASS·NA 124건 외 **45건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 4 | 재판정 PASS |
| W5 | 검사기 연결 | 3 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 1 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 36 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 36 · 화면 FE 3 · 하네스 3 · FE 1 · E2E 1 · 사람 판정 / AS-IS 원문 확인 → 재판정 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 2 |  |  |  |  |  | 11 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 6 | 그리드 셀 cascade 후보 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 6 | 연쇄 자동 채움 |
| D1 | EDIT |  |  |  |  |  |  |  |  | 4 | 컬럼 편집 가능 여부(신규행·기존행) |
| M4 | POPUP |  |  |  |  |  |  | 1 |  | 1 | 팝업 선택값 반영 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 2 | 무변경 편집 종료 시 연쇄 미발동 |
| F2 | CRUD |  |  | 1 |  |  |  |  |  |  | 1회 저장(변경 감지) |
| H4 | DESIGN |  |  | 1 |  |  |  |  |  |  | 레이아웃·스크롤·크기 |
| G4 | DESIGN |  |  |  |  | 1 |  |  |  |  | 조회조건 표시·라벨·활성 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G5 | POPUP |  |  |  |  | 1 |  |  |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 표준·열림 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| C1 | CASCADE |  |  |  |  |  |  |  |  | 1 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |
| G1 | GEN |  |  |  |  |  |  |  |  | 1 | 조회조건 값 변경 → 조회 인자·결과 반영 |

## W3 동작 수정 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0001 | F2 | SCP0127 화면 | 화면 FE(범위 밖(가이드만)) | F2 FAIL 수정 — SCP0127 화면: 원장 V-db98db04 RULE_SCREEN / 원장 V-b2ba2199 RULE_SCREEN / 원장 V-0d28d9be RULE_SCREEN / 원장 V-02f21913 GENERAL |  | 181 (ACT:SCP0127_PrecedeSafetyStockDay.SaveBu) |
| WK-SCP0127-0002 | H4 | SCP0127 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H4 FAIL 수정 — SCP0127 화면: 원장 V-072a6835 RULE_SCREEN / 원장 V-ae313949 RULE_SCREEN / 원장 V-2b8fd1c5 RULE_SCREEN / 원장 V-b5743aa7 RULE_SC |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0003 | X-ROW | SCP0127_PrecedeSafetyStockDay.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0127_PrecedeSafetyStockDay.SaveData: 진입점 집계 27검사 — NA:14 · PASS:10 · ERROR:2 · FAIL:1 (FX-SCP0127-037) |  | 5 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |
| WK-SCP0127-0004 | X-ROW | SCP0127_PrecedeSafetyStockDay.SpdMain_To | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0127_PrecedeSafetyStockDay.SpdMain_TopChange: 진입점 집계 1검사 — FAIL:1 (FX-SCP0127-039) |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |

## W5 검사기 연결 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0005 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0127_PrecedeSafetyStockDay.InitEv) |
| WK-SCP0127-0006 | G03-WIRE | SCP0127 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0127 화면 | 판단불가(대상 단위 SCREEN) | 10 (ACT:SCP0127_PrecedeSafetyStockDay..ctor ) |
| WK-SCP0127-0007 | G5 | cboDivision / Division / Div / Div. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboDivision / Division / Div / Div. | 있음(FE 소스) | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0008 | H6 | cboDivision / Division / Div / Div. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division / Div / Div. · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |

## W7 기대값 확정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0009 | M4 | cboDivision / Division / Div / Div. | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboDivision / Division / Div / Div.: 검증 엔진이 실행됐으나 이 대상(COND cboDivision)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |

## W9 도구 오류 (36)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0010 | J2 | SCP0127 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-91b718b7 RULE_SCREEN / 원장 V-09a40d57 DEFECT / 원장 V-0fffc2c5 GENERAL / 원장 V-610e6165 GENERAL / 원장 V-9cbb12bc GENERA |  | 12 (ACT:SCP0127_PrecedeSafetyStockDay.btnIte) |
| WK-SCP0127-0011 | C1 | cboDivision / Division / Div / Div. | 하네스·환경 | C1 도구 오류 — 원장 V-9f87b220 SEARCH / 실측[T-c478530d]: 'Div' → '40 Mobility & IT Battery' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 ClbDivis |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.InitCo) |
| WK-SCP0127-0012 | C2 | OPMZ_PLAN_GR_ID / Plan Group | 하네스·환경 | C2 도구 오류 — 실측[T-8d7afd3c]: OPMZ_PLAN_GR_ID 연쇄 원천 해석 불가 — AS-IS spdMain_CellClick:935 SheetUtils.SetComboDataRow(siMain, e.Row, Def |  | 5 (ACT:SCP0127_PrecedeSafetyStockDay.spdMai) |
| WK-SCP0127-0013 | C2 | SCM_SITE_ID / SCM site | 하네스·환경 | C2 도구 오류 — 실측[T-e8a1fb05]: SCM_SITE_ID 연쇄 원천 해석 불가 — AS-IS spdMain_CellClick:940 SheetUtils.SetComboDataRow(siMain, e.Row, DefColu |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.spdMai) |
| WK-SCP0127-0014 | C2 | SCP0127_PrecedeSafetyStockDay.ClbDivisio | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0127_PrecedeSafetyStockDay.ClbDivision_SelectedIndexChanged 의 C2 5요소: ERROR:5 |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.ClbDiv) |
| WK-SCP0127-0015 | C2 | STAGE / Stage | 하네스·환경 | C2 도구 오류 — 실측[T-785e578c]: STAGE 연쇄 원천 해석 불가 — AS-IS spdMain_CellClick:944 SheetUtils.SetComboDataRow(siMain, e.Row, DefColumns.ST |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.spdMai) |
| WK-SCP0127-0016 | C2 | VALID_YN / Valid | 하네스·환경 | C2 도구 오류 — 실측[T-f2a7af07]: VALID_YN 연쇄 원천 해석 불가 — AS-IS spdMain_CellClick:952 SheetUtils.SetComboDataRow(siMain, e.Row, DefColumns |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.spdMai) |
| WK-SCP0127-0017 | C2 | VALUE_TYPE / Type | 하네스·환경 | C2 도구 오류 — 실측[T-cd29f3c8]: VALUE_TYPE 연쇄 원천 해석 불가 — AS-IS spdMain_CellClick:948 SheetUtils.SetComboDataRow(siMain, e.Row, DefColum |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.spdMai) |
| WK-SCP0127-0018 | C3 | ITEM_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-97de7df0]: ITEM_ID 연쇄 원천 컬럼 해석 불가 — AS-IS SpdMain_CellDoubleClick:991 siMain.SetText(e.Row, siMain.GetColumnIndex( |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0019 | C3 | OPMZ_PLAN_GR_ID | 하네스·환경 | C3 도구 오류 — 원장 V-d86eb140 |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0020 | C3 | OPMZ_PLAN_GR_ID / Plan Group | 하네스·환경 | C3 도구 오류 — 원장 V-d86eb140 ASIS / 실측[T-5325ef33]: OPMZ_PLAN_GR_ID 연쇄 원천 컬럼 해석 불가 — AS-IS SpdMain_ClipboardPasted:1106 if (siMain.Act |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0021 | C3 | SCP0127_PrecedeSafetyStockDay.ClbDivisio | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0127_PrecedeSafetyStockDay.ClbDivision_SelectedIndexChanged 의 C3 6요소: NA:3 · ERROR:3 |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.ClbDiv) |
| WK-SCP0127-0022 | C3 | SCP0127_PrecedeSafetyStockDay.SetChanged | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0127_PrecedeSafetyStockDay.SetChangedControl 의 C3 6요소: NA:3 · ERROR:3 |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.SetCha) |
| WK-SCP0127-0023 | C3 | SCP0127_PrecedeSafetyStockDay.setPeriod | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0127_PrecedeSafetyStockDay.setPeriod 의 C3 6요소: NA:3 · ERROR:3 |  | 5 (ACT:SCP0127_PrecedeSafetyStockDay.setPer) |
| WK-SCP0127-0024 | C6 | OPMZ_PLAN_GR_ID | 하네스·환경 | C6 도구 오류 — 원장 V-ae0399a0 |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0025 | C6 | SCP0127_PrecedeSafetyStockDay.ClbDivisio | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SCP0127_PrecedeSafetyStockDay.ClbDivision_SelectedIndexChanged 의 C6 1요소: ERROR:1 |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.ClbDiv) |
| WK-SCP0127-0026 | F3 | SCP0127 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-667c2393 RULE_SCREEN / 원장 V-a6f67e63 RULE_SCREEN / 원장 V-71f30c1a RULE_SCREEN / 원장 V-e8d98e0d RULE_SCREEN / 원장 V-d5 |  | 11 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0027 | F6 | SCP0127 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-5a6cd9ce RULE_SCREEN / 원장 V-d6ece6ac RULE_SCREEN / 원장 V-8a5762d8 RULE_SCREEN / 원장 V-66a4274e RULE_SCREEN / 원장 V-61 |  | 181 (ACT:SCP0127_PrecedeSafetyStockDay.SaveBu) |
| WK-SCP0127-0028 | I1 | SCP0127 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-b2267fbf RULE_SCREEN / 원장 V-8ddbb6e1 RULE_SCREEN / 원장 V-af8df719 RULE_SCREEN / 원장 V-4d0b3f9e DEFECT / 원장 V-084d9c2 |  | 13 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |
| WK-SCP0127-0029 | D1 | CREATED_BY / Create By | 하네스·환경 | D1 도구 오류 — 원장 V-b6102ea1 COLUMN / 원장 V-0c714c96 COLUMN / 실측[T-032d9011]: 기존행 r0 CREATED_BY 편집=false (AS-IS 잠금) / 신규행 r0 CREATED_BY |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.EditBu) |
| WK-SCP0127-0030 | D1 | DIVISION_ID / Division | 하네스·환경 | D1 도구 오류 — 원장 V-3145b171 COLUMN / 원장 V-cc4e0c1d COLUMN / 실측[T-00d6ccb6]: 기존행 r0 DIVISION_ID 편집=false (AS-IS 잠금) / 신규행 r0 DIVISION_ |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.EditBu) |
| WK-SCP0127-0031 | D1 | LAST_UPDATE_DATE / Last Update Date | 하네스·환경 | D1 도구 오류 — 원장 V-65f8fe37 COLUMN / 원장 V-6752ed2c COLUMN / 실측[T-5902f0e4]: 기존행 r0 LAST_UPDATE_DATE 편집=false (AS-IS 잠금) / 신규행 r0 LAST |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.Insert) |
| WK-SCP0127-0032 | D1 | SCP0127_PrecedeSafetyStockDay.EditButton | 하네스·환경 | D1 도구 오류 — 진입점 집계 — 대조표 SCP0127_PrecedeSafetyStockDay.EditButton 의 D1 3요소: ERROR:2 · NA:1 |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.EditBu) |
| WK-SCP0127-0033 | G1 | clbPlanGroup / Plan Group | 하네스·환경 | G1 도구 오류 — 원장 V-a6593ee3 SEARCH / E2E smoke cond combo |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.FindDa) |
| WK-SCP0127-0034 | X-ROW | SCP0127_PrecedeSafetyStockDay.ClbDivisio | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.ClbDiv) |
| WK-SCP0127-0035 | X-ROW | SCP0127_PrecedeSafetyStockDay.CreateSpre | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.Create) |
| WK-SCP0127-0036 | X-ROW | SCP0127_PrecedeSafetyStockDay.FindData_M | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — PASS:10 · NA:3 · ERROR:1 |  | 7 (ACT:SCP0127_PrecedeSafetyStockDay.FindDa) |
| WK-SCP0127-0037 | X-ROW | SCP0127_PrecedeSafetyStockDay.InitContro | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — PASS:10 · ERROR:1 |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.InitCo) |
| WK-SCP0127-0038 | X-ROW | SCP0127_PrecedeSafetyStockDay.Insert_Row | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — PASS:5 · ERROR:3 |  | 10 (ACT:SCP0127_PrecedeSafetyStockDay.Insert) |
| WK-SCP0127-0039 | X-ROW | SCP0127_PrecedeSafetyStockDay.SetChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SetCha) |
| WK-SCP0127-0040 | X-ROW | SCP0127_PrecedeSafetyStockDay.SpdMain_Ce | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — PASS:8 · NA:6 · NOT_RUN:2 · ERROR:2 · NOPATH:1 |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0041 | X-ROW | SCP0127_PrecedeSafetyStockDay.SpdMain_Cl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:4 · NA:3 |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0042 | X-ROW | SCP0127_PrecedeSafetyStockDay.btnItemId_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:5 · NA:3 · ERROR:1 |  | 5 (ACT:SCP0127_PrecedeSafetyStockDay.btnIte) |
| WK-SCP0127-0043 | X-ROW | SCP0127_PrecedeSafetyStockDay.setPeriod | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.setPer) |
| WK-SCP0127-0044 | X-ROW | SCP0127_PrecedeSafetyStockDay.spdMain_Ce | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:5 |  | 20 (ACT:SCP0127_PrecedeSafetyStockDay.spdMai) |
| WK-SCP0127-0045 | M4 | SCP0127_PrecedeSafetyStockDay.SpdMain_Ce | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 SCP0127_PrecedeSafetyStockDay.SpdMain_CellDoubleClick 의 M4 3요소: NOT_RUN:1 · PASS:1 · NA:1 (미실행 요소가 남아 판정필요 |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
