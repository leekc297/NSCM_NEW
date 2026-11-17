# 작업 원장 — SCP0131 · 2026-11-14 19:46

> 검사 인스턴스 365건 중 PASS·NA 279건 외 **86건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 2 | 재판정 PASS |
| W5 | 검사기 연결 | 3 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 12 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 68 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 68 · 사람 판정 / AS-IS 원문 확인 → 재판정 12 · 하네스 3 · 화면 FE 2 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 1 |  |  |  |  |  | 12 | 대조표 행이 서술한 동작을 화면에서 재현 |
| F4 | DB |  |  |  |  |  |  |  |  | 13 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| X-LOC | GEN |  |  |  |  |  |  | 11 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G1 | GEN |  |  |  |  |  |  |  |  | 8 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 7 | 연쇄 자동 채움 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 5 | 그리드 셀 cascade 후보 |
| H6 | POPUP |  |  |  |  |  | 1 |  |  | 3 | 팝업 표준·열림 |
| D4 | EDIT |  |  |  |  |  |  |  |  | 4 | 신규행 기본값·자동세팅·Insert 전제 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 3 | 무변경 편집 종료 시 연쇄 미발동 |
| E4 | EDIT |  |  |  |  |  |  |  |  | 3 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| M4 | POPUP |  |  |  |  |  |  | 1 |  | 1 | 팝업 선택값 반영 |
| F2 | CRUD |  |  | 1 |  |  |  |  |  |  | 1회 저장(변경 감지) |
| G4 | DESIGN |  |  |  |  | 1 |  |  |  |  | 조회조건 표시·라벨·활성 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G5 | POPUP |  |  |  |  | 1 |  |  |  |  | 팝업 조건 연동(인자) |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| C1 | CASCADE |  |  |  |  |  |  |  |  | 1 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  |  |  |  | 1 | CRUD Status 표시 정합 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0001 | F2 | SCP0131 화면 | 화면 FE(범위 밖(가이드만)) | F2 FAIL 수정 — SCP0131 화면: 원장 V-ef6e0fe0 RULE_SCREEN / 원장 V-11d9fee9 RULE_SCREEN / 원장 V-9c901d28 RULE_SCREEN / 원장 V-a713c0b0 GENERAL |  | 165 (7 8 11 ACT:SCP0131_SalesSitePriority.Sav) |
| WK-SCP0131-0002 | X-ROW | SCP0131_SalesSitePriority.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0131_SalesSitePriority.SaveData: 진입점 집계 27검사 — NA:14 · PASS:8 · ERROR:4 · FAIL:1 (FX-SCP0131-029) |  | 5 (ACT:SCP0131_SalesSitePriority.SaveData:7) |

## W5 검사기 연결 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0003 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SCP0131_SalesSitePriority.InitEvent ) |
| WK-SCP0131-0004 | G03-WIRE | SCP0131 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0131 화면 | 판단불가(대상 단위 SCREEN) | 10 (ACT:SCP0131_SalesSitePriority..ctor ACT:) |
| WK-SCP0131-0005 | G5 | cboDivision / Division / Div / Div. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboDivision / Division / Div / Div. | 있음(FE 소스) | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0006 | H6 | cboDivision / Division / Div / Div. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division / Div / Div. · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |

## W7 기대값 확정 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0007 | X-LOC | - | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — -: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (-) |
| WK-SCP0131-0008 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0131-0009 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0131-0010 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0131-0011 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-SCP0131-0012 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0131-0013 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0131-0014 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0131-0015 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0131-0016 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0131-0017 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0131-0018 | M4 | cboDivision / Division / Div / Div. | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboDivision / Division / Div / Div.: 검증 엔진이 실행됐으나 이 대상(COND cboDivision)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |

## W9 도구 오류 (68)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0019 | J2 | SCP0131 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-5ec8ab30 RULE_SCREEN / 원장 V-6d86a577 DEFECT / 원장 V-41917e10 GENERAL / 원장 V-6da63458 GENERAL / 원장 V-b90f6f01 GENERA |  | 31 (7 8 10 11 12 - Delete(365) SwitchLock(37) |
| WK-SCP0131-0020 | C1 | cboDivision / Division / Div / Div. | 하네스·환경 | C1 도구 오류 — 원장 V-a6a338c0 SEARCH / 실측[T-c4fa5910]: 'Div' → '40 Mobility & IT Battery' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 ClbDivis |  | 2 (2 ACT:SCP0131_SalesSitePriority.InitCont) |
| WK-SCP0131-0021 | C2 | OPMZ_PLAN_GR_ID / Plan Group | 하네스·환경 | C2 도구 오류 — 실측[T-3bb0947d]: OPMZ_PLAN_GR_ID 연쇄 원천 해석 불가 — AS-IS spdMain_CellClick:892 SheetUtils.SetComboDataRow(siMain, e.Row, Def |  | 3 (ACT:SCP0131_SalesSitePriority.spdMain_Ce) |
| WK-SCP0131-0022 | C2 | SCM_SITE_ID / SCM site | 하네스·환경 | C2 도구 오류 — 실측[T-8f99cd9f]: SCM_SITE_ID 연쇄 원천 해석 불가 — AS-IS spdMain_CellClick:897 SheetUtils.SetComboDataRow(siMain, e.Row, DefColu |  | 2 (ACT:SCP0131_SalesSitePriority.spdMain_Ce) |
| WK-SCP0131-0023 | C2 | SCP0131_SalesSitePriority.ClbDivision_Se | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0131_SalesSitePriority.ClbDivision_SelectedIndexChanged 의 C2 4요소: ERROR:4 |  | 1 (ACT:SCP0131_SalesSitePriority.ClbDivisio) |
| WK-SCP0131-0024 | C2 | TO_YYYYMMDD / Valid To | 하네스·환경 | C2 도구 오류 — 실측[T-846bf895]: TO_YYYYMMDD 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) /  |  | 1 (11) |
| WK-SCP0131-0025 | C2 | VALID_YN / Valid | 하네스·환경 | C2 도구 오류 — 실측[T-042f72b0]: VALID_YN 연쇄 원천 해석 불가 — AS-IS spdMain_CellClick:909 SheetUtils.SetComboDataRow(siMain, e.Row, DefColumns |  | 1 (ACT:SCP0131_SalesSitePriority.spdMain_Ce) |
| WK-SCP0131-0026 | C3 | ITEM_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-b4328f57]: ITEM_ID 연쇄 원천 컬럼 해석 불가 — AS-IS SpdMain_CellDoubleClick:945 siMain.SetText(e.Row, siMain.GetColumnIndex( |  | 1 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
| WK-SCP0131-0027 | C3 | OPMZ_PLAN_GR_ID | 하네스·환경 | C3 도구 오류 — 원장 V-f8fbc16a |  | 1 (ACT:SCP0131_SalesSitePriority.SpdMain_Cl) |
| WK-SCP0131-0028 | C3 | OPMZ_PLAN_GR_ID / Plan Group | 하네스·환경 | C3 도구 오류 — 원장 V-f8fbc16a ASIS / 실측[T-63c1fc4f]: OPMZ_PLAN_GR_ID 연쇄 원천 컬럼 해석 불가 — AS-IS SpdMain_ClipboardPasted:1058 if (siMain.Act |  | 6 (5 SetValue(1064) ACT:SCP0131_SalesSitePr) |
| WK-SCP0131-0029 | C3 | SCP0131_SalesSitePriority.ClbDivision_Se | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0131_SalesSitePriority.ClbDivision_SelectedIndexChanged 의 C3 5요소: ERROR:4 · NA:1 |  | 1 (ACT:SCP0131_SalesSitePriority.ClbDivisio) |
| WK-SCP0131-0030 | C3 | SCP0131_SalesSitePriority.SetChangedCont | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0131_SalesSitePriority.SetChangedControl 의 C3 5요소: ERROR:4 · NA:1 |  | 4 (ACT:SCP0131_SalesSitePriority.SetChanged) |
| WK-SCP0131-0031 | C3 | SCP0131_SalesSitePriority.setPeriod | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0131_SalesSitePriority.setPeriod 의 C3 5요소: ERROR:4 · NA:1 |  | 5 (ACT:SCP0131_SalesSitePriority.setPeriod:) |
| WK-SCP0131-0032 | C3 | TO_YYYYMMDD / Valid To | 하네스·환경 | C3 도구 오류 — 실측[T-2ca7a123]: TO_YYYYMMDD 연쇄 원천 컬럼 해석 불가 — AS-IS SpdMain_EditChange:1004 siMain.SetValue(e.Row, siMain.GetColumnIndex |  | 3 (10 11 ACT:SCP0131_SalesSitePriority.SpdM) |
| WK-SCP0131-0033 | C6 | OPMZ_PLAN_GR_ID | 하네스·환경 | C6 도구 오류 — 원장 V-b6b0a1a8 |  | 1 (ACT:SCP0131_SalesSitePriority.SpdMain_Cl) |
| WK-SCP0131-0034 | C6 | SCP0131_SalesSitePriority.ClbDivision_Se | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SCP0131_SalesSitePriority.ClbDivision_SelectedIndexChanged 의 C6 2요소: ERROR:2 |  | 1 (ACT:SCP0131_SalesSitePriority.ClbDivisio) |
| WK-SCP0131-0035 | C6 | TO_YYYYMMDD / Valid To | 하네스·환경 | C6 도구 오류 — 실측[T-df84665b]: TO_YYYYMMDD 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기 |  | 1 (11) |
| WK-SCP0131-0036 | K4 | SCP0131 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-a884020f GENERAL / 원장 V-e623a047 GENERAL / 원장 V-096cf2fd GENERAL / 원장 V-38a76395 GENERAL / 원장 V-09e1ccde GENERAL / |  | 19 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0131-0037 | F1 | SCP0131 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-3a29440b RULE_SCREEN / 원장 V-b4a22450 RULE_SCREEN / 원장 V-c98b11b3 RULE_SCREEN / 원장 V-6232615f RULE_SCREEN / 원장 V-a0 |  | 171 (7 8 11 Delete(365) ACT:SCP0131_SalesSite) |
| WK-SCP0131-0038 | F3 | SCP0131 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-a1c3cbee RULE_SCREEN / 원장 V-9dd3e016 RULE_SCREEN / 원장 V-16211007 RULE_SCREEN / 원장 V-61b13b94 RULE_SCREEN / 원장 V-91 |  | 12 (5 10 SetValue(1064) ACT:SCP0131_SalesSit) |
| WK-SCP0131-0039 | F5 | SCP0131 화면 | 하네스·환경 | F5 도구 오류 — 원장 V-10ebb742 RULE_SCREEN / 원장 V-22ad4421 RULE_SCREEN / 원장 V-96f1e525 RULE_SCREEN / 원장 V-763a348f DEFECT / 원장 V-4162078 |  | 6 (Delete(365) ACT:SCP0131_SalesSitePriorit) |
| WK-SCP0131-0040 | F6 | SCP0131 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-1986aabd RULE_SCREEN / 원장 V-b407164c RULE_SCREEN / 원장 V-d3a39193 RULE_SCREEN / 원장 V-0ff9c901 RULE_SCREEN / 원장 V-b4 |  | 162 (ACT:SCP0131_SalesSitePriority.SaveButton) |
| WK-SCP0131-0041 | F4 | 1 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 1 'btnItemId.Click' 의 F4 3요소: PASS:2 · ERROR:1 |  | 0 () |
| WK-SCP0131-0042 | F4 | 10 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 10 'MSG00049' 의 F4 3요소: PASS:2 · ERROR:1 |  | 1 (10) |
| WK-SCP0131-0043 | F4 | 11 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 11 'MSG00219' 의 F4 3요소: PASS:2 · ERROR:1 |  | 1 (11) |
| WK-SCP0131-0044 | F4 | 12 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 12 'MSG00049' 의 F4 3요소: PASS:2 · ERROR:1 |  | 1 (12) |
| WK-SCP0131-0045 | F4 | 2 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 2 'cboDivision.SelectedIndexChanged' 의 F4 3요소: PASS:2 · ERROR:1 |  | 0 () |
| WK-SCP0131-0046 | F4 | 3 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 3 'spdMain.CellClick' 의 F4 3요소: PASS:2 · ERROR:1 |  | 0 () |
| WK-SCP0131-0047 | F4 | 4 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 4 'spdMain.CellDoubleClick' 의 F4 3요소: PASS:2 · ERROR:1 |  | 0 () |
| WK-SCP0131-0048 | F4 | 5 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 5 'spdMain.ClipboardPasted' 의 F4 3요소: PASS:2 · ERROR:1 |  | 0 () |
| WK-SCP0131-0049 | F4 | 6 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 6 'spdMain.TopChange' 의 F4 3요소: PASS:2 · ERROR:1 |  | 0 () |
| WK-SCP0131-0050 | F4 | 7 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 7 'MSG00004' 의 F4 3요소: PASS:2 · ERROR:1 |  | 1 (7) |
| WK-SCP0131-0051 | F4 | 8 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 8 '(없음)' 의 F4 3요소: PASS:2 · ERROR:1 |  | 1 (8) |
| WK-SCP0131-0052 | F4 | 9 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 9 '(없음, GMessageBoxForException)' 의 F4 3요소: PASS:2 · ERROR:1 |  | 1 (9) |
| WK-SCP0131-0053 | F4 | PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO | 하네스·환경 | F4 도구 오류 — 실측[T-0499b65b]: PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO: SCP0128/init/SEARCH, SCP0129/init/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤 |  | 163 (ACT:SCP0131_SalesSitePriority.GetSearchI) |
| WK-SCP0131-0054 | H4 | SCP0131 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-fc6fb436 RULE_SCREEN / 원장 V-5ed4e59b RULE_SCREEN / 원장 V-9acfdf3d RULE_SCREEN / 원장 V-4460fe60 RULE_SCREEN / 원장 V-c4 |  | 6 (6 SmartColMerge(854) ACT:SCP0131_SalesSi) |
| WK-SCP0131-0055 | I1 | SCP0131 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-5645cb8f RULE_SCREEN / 원장 V-c97ad313 RULE_SCREEN / 원장 V-748656b4 RULE_SCREEN / 원장 V-fec12d8c DEFECT / 원장 V-f03325d |  | 19 (7 8 9 10 11 12 Insert(507) ACT:SCP0131_S) |
| WK-SCP0131-0056 | D4 | COMMON:UC-01 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태 신규행 Insert 시 필터 유지' 의 D4 7요소: PASS:5 · ERROR:2 |  | 1 (COMMON:UC-01) |
| WK-SCP0131-0057 | D4 | DIVISION_ID / Division | 하네스·환경 | D4 도구 오류 — 실측[T-e0b41a51]: 신규행 DIVISION_ID='81' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움: 의도 확인(연쇄 C3/팝업 M4 결과 |  | 2 (- SetValue(512,516)) |
| WK-SCP0131-0058 | D4 | Insert(507) | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 Insert(507) 'other' 의 D4 7요소: PASS:5 · ERROR:2 |  | 1 (Insert(507)) |
| WK-SCP0131-0059 | D4 | VALID_YN / Valid | 하네스·환경 | D4 도구 오류 — 실측[T-35cbed20]: 신규행 VALID_YN='Y' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움: 의도 확인(연쇄 C3/팝업 M4 결과일 수  |  | 2 (- SetValue(512,516)) |
| WK-SCP0131-0060 | E4 | FROM_YYYYMMDD / Valid From | 하네스·환경 | E4 도구 오류 — 실측[T-c7d5c219]: MSG00049 — SpdMain_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain_EditChange)에서  |  | 2 (12 ACT:SCP0131_SalesSitePriority.SpdMain) |
| WK-SCP0131-0061 | E4 | MSG00049 | 하네스·환경 | E4 도구 오류 — 실측[T-5cc952a8]: MSG00049 — SpdMain_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain_EditChange)에서  |  | 4 (10 12 ACT:SCP0131_SalesSitePriority.SpdM) |
| WK-SCP0131-0062 | E4 | TO_YYYYMMDD / Valid To | 하네스·환경 | E4 도구 오류 — 실측[T-199ef21e]: MSG00049 — SpdMain_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain_EditChange)에서  |  | 5 (10 11 SetValue(1004) ACT:SCP0131_SalesSi) |
| WK-SCP0131-0063 | G1 | - | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 - 'InsertButton override 본문' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (-) |
| WK-SCP0131-0064 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 '수정 중 다른 데이터 조회 시 confirm' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0131-0065 | G1 | COMMON:UC-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 설정 적용 시 재조회 유도' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-03) |
| WK-SCP0131-0066 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 '콤마 다중 조회조건 전건 조회' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-06) |
| WK-SCP0131-0067 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회 시 필터 유지' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0131-0068 | G1 | Insert(507) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Insert(507) 'other' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (Insert(507)) |
| WK-SCP0131-0069 | G1 | LockColumn(462) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 LockColumn(462) 'lock' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (LockColumn(462)) |
| WK-SCP0131-0070 | G1 | clbPlanGroup / Plan Group | 하네스·환경 | G1 도구 오류 — 원장 V-54e6f257 SEARCH / E2E smoke cond combo |  | 2 (ACT:SCP0131_SalesSitePriority.FindData_M) |
| WK-SCP0131-0071 | X-ROW | SCP0131_SalesSitePriority.ClbDivision_Se | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.ClbDivisio) |
| WK-SCP0131-0072 | X-ROW | SCP0131_SalesSitePriority.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CreateSpre) |
| WK-SCP0131-0073 | X-ROW | SCP0131_SalesSitePriority.FindData_Main | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — PASS:8 · NA:3 · ERROR:1 |  | 7 (ACT:SCP0131_SalesSitePriority.FindData_M) |
| WK-SCP0131-0074 | X-ROW | SCP0131_SalesSitePriority.GetSearchInfo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOPATH:2 · PASS:2 · ERROR:1 |  | 2 (ACT:SCP0131_SalesSitePriority.GetSearchI) |
| WK-SCP0131-0075 | X-ROW | SCP0131_SalesSitePriority.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — PASS:7 · ERROR:1 |  | 3 (ACT:SCP0131_SalesSitePriority.InitContro) |
| WK-SCP0131-0076 | X-ROW | SCP0131_SalesSitePriority.SetChangedCont | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.SetChanged) |
| WK-SCP0131-0077 | X-ROW | SCP0131_SalesSitePriority.SpdMain_CellDo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — PASS:8 · NA:6 · ERROR:2 · NOT_RUN:2 · NOPATH:1 |  | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
| WK-SCP0131-0078 | X-ROW | SCP0131_SalesSitePriority.SpdMain_Clipbo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:4 · NA:1 |  | 1 (ACT:SCP0131_SalesSitePriority.SpdMain_Cl) |
| WK-SCP0131-0079 | X-ROW | SCP0131_SalesSitePriority.SpdMain_TopCha | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_To) |
| WK-SCP0131-0080 | X-ROW | SCP0131_SalesSitePriority.btnItemId_Clic | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:4 · NA:3 · ERROR:2 |  | 5 (ACT:SCP0131_SalesSitePriority.btnItemId_) |
| WK-SCP0131-0081 | X-ROW | SCP0131_SalesSitePriority.setPeriod | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0131_SalesSitePriority.setPeriod ) |
| WK-SCP0131-0082 | X-ROW | SCP0131_SalesSitePriority.spdMain_CellCl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 17 (ACT:SCP0131_SalesSitePriority.spdMain_Ce) |
| WK-SCP0131-0083 | H6 | 3 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 3 'spdMain.CellClick' 의 H6 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0084 | H6 | 4 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 4 'spdMain.CellDoubleClick' 의 H6 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0085 | H6 | 5 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 5 'spdMain.ClipboardPasted' 의 H6 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0086 | M4 | SCP0131_SalesSitePriority.SpdMain_CellDo | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 SCP0131_SalesSitePriority.SpdMain_CellDoubleClick 의 M4 3요소: NA:1 · NOT_RUN:1 · PASS:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
