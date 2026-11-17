# 작업 원장 — SCP0037 · 2026-11-14 12:22

> 검사 인스턴스 335건 중 PASS·NA 199건 외 **136건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 7 | 재판정 PASS |
| W5 | 검사기 연결 | 7 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 14 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 108 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 108 · 사람 판정 / AS-IS 원문 확인 → 재판정 14 · 하네스 7 · 화면 FE 6 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| C2 | CASCADE |  |  |  |  |  |  |  |  | 17 | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 17 | 무변경 편집 종료 시 연쇄 미발동 |
| X-ROW | GEN |  |  | 2 |  |  |  | 1 |  | 11 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 13 | 연쇄 자동 채움 |
| X-LOC | GEN |  |  |  |  |  |  | 11 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 9 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G1 | GEN |  |  |  |  |  |  |  |  | 9 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| E4 | EDIT |  |  |  |  |  |  |  |  | 7 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| H6 | POPUP |  |  |  |  | 1 |  |  |  | 5 | 팝업 표준·열림 |
| D1 | EDIT |  |  | 3 |  |  |  |  |  | 2 | 컬럼 편집 가능 여부(신규행·기존행) |
| D4 | EDIT |  |  |  |  |  |  |  |  | 5 | 신규행 기본값·자동세팅·Insert 전제 |
| B4 | COMBO |  |  |  |  | 1 |  |  |  | 3 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| D5 | EDIT |  |  |  |  |  |  |  |  | 3 | 셀 에디터 유형 |
| M4 | POPUP |  |  |  |  |  |  | 1 |  | 1 | 팝업 선택값 반영 |
| F3 | CRUD |  |  |  |  |  |  |  |  | 2 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| A6 | GEN |  |  | 1 |  |  |  |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B1 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 중복 없음 |
| G4 | DESIGN |  |  |  |  | 1 |  |  |  |  | 조회조건 표시·라벨·활성 |
| E5 | EDIT |  |  |  |  | 1 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| G5 | POPUP |  |  |  |  | 1 |  |  |  |  | 팝업 조건 연동(인자) |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |
| M3 | POPUP |  |  |  |  |  |  |  |  | 1 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |

## W3 동작 수정 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0001 | F5 | SCP0037 화면 | 화면 FE(범위 밖(가이드만)) | F5 FAIL 수정 — SCP0037 화면: 원장 V-85ec81e0 RULE_SCREEN / 원장 V-e324b261 RULE_SCREEN / 원장 V-0ba1cc9a RULE_SCREEN / 원장 V-4e286458 DEFECT  |  | 10 (10,6 ACT:SCP0037_OperationLT.DeleteButto) |
| WK-SCP0037-0002 | D1 | 13 | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — 13: 행 집계 — 대조표 13 'SpdMain_ClipboardPasted' 의 D1 14요소: PASS:10 · NA:2 · FAIL:1 · ERROR:1 · FAIL 요소: LT_DAY / LT(Day — |  | 1 (13) |
| WK-SCP0037-0003 | D1 | 3,9 | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — 3,9: 행 집계 — 대조표 3,9 'lock' 의 D1 14요소: PASS:10 · NA:2 · FAIL:1 · ERROR:1 · FAIL 요소: LT_DAY / LT(Day — 원장 V-40b09280 CO |  | 1 (3,9) |
| WK-SCP0037-0004 | D1 | LT_DAY / LT(Day | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — LT_DAY / LT(Day: 원장 V-40b09280 COLUMN / 원장 V-47609c73 COLUMN / 실측[T-866ff99b]: 기존행 r0 LT_DAY 편집=true (AS-IS 편집 가능) /  |  | 2 (4,5 12,13,14,15) |
| WK-SCP0037-0005 | A6 | PKG_SCP0037.P_SCP0037_GET_OPERATION_LT | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — PKG_SCP0037.P_SCP0037_GET_OPERATION_LT: 원장 V-bc411a83 SP / 정렬대조 PASS AS-IS 에 없던 ORDER BY 를 TO-BE 가 추가 — 결정적 순서(TO-BE  |  | 37 (ACT:SCP0037_OperationLT.FindButton ACT:S) |
| WK-SCP0037-0006 | X-ROW | SCP0037_OperationLT.FindButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0037_OperationLT.FindButton: 진입점 집계 3검사 — PASS:2 · FAIL:1 (FX-SCP0037-016) |  | 1 (ACT:SCP0037_OperationLT.FindButton) |
| WK-SCP0037-0007 | X-ROW | SCP0037_OperationLT.FindData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0037_OperationLT.FindData: 진입점 집계 13검사 — PASS:7 · NA:4 · FAIL:1 · ERROR:1 (FX-SCP0037-017) |  | 7 (ACT:SCP0037_OperationLT.FindData:313:1 A) |

## W5 검사기 연결 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0008 | B1 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 3 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0009 | B2 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 3 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0010 | B4 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 3 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0011 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SCP0037_OperationLT.InitEvent ACT:SC) |
| WK-SCP0037-0012 | E5 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0013 | G5 | NICK_NAME / Nick Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL NICK_NAME / Nick Name | 있음(SHEET_COLUMNS) | 1 (22,23) |
| WK-SCP0037-0014 | H6 | NICK_NAME / Nick Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME / Nick Name | 있음(SHEET_COLUMNS) | 1 (22,23) |

## W7 기대값 확정 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0015 | G03-WIRE | SCP0037 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0037 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 / 게이트 G03 As-is 이벤트 cboDivision.SelectedIndexChang  |  | 11 (ACT:SCP0037_OperationLT..ctor ACT:SCP003) |
| WK-SCP0037-0016 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0037-0017 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0037-0018 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-SCP0037-0019 | X-LOC | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (13) |
| WK-SCP0037-0020 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0037-0021 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0037-0022 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0037-0023 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0037-0024 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0037-0025 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0037-0026 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0037-0027 | X-ROW | SCP0037_OperationLT.SpdMain_KeyPress | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.SpdMain_KeyPress: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/RETURN/UI_PROP, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0037_OperationLT.SpdMain_KeyPress) |
| WK-SCP0037-0028 | M4 | ITEM_ID / Material | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ITEM_ID / Material: 검증 엔진이 실행됐으나 이 대상(COL ITEM_ID)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 3 (4 11 22,23) |

## W9 도구 오류 (108)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0029 | C2 | DIVISION_ID | 하네스·환경 | C2 도구 오류 — 원장 V-9f6ae677 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0030 | C2 | DIVISION_ID / Division | 하네스·환경 | C2 도구 오류 — 원장 V-9f6ae677 ASIS / 원장 V-3299618b ASIS |  | 11 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0031 | C2 | INV_FLAG / Inv Flag | 하네스·환경 | C2 도구 오류 — 실측[T-f47f0bc6]: INV_FLAG 연쇄 원천 해석 불가 — AS-IS ClbDivision_SelectedIndexChanged:851 if (siMain.ActiveSheet != null) { if  |  | 4 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0032 | C2 | ITEM_ID / Material | 하네스·환경 | C2 도구 오류 — 실측[T-1440b56b]: 원천 DIVISION_ID 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사 |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0033 | C2 | NICK_NAME / Nick Name | 하네스·환경 | C2 도구 오류 — 실측[T-8cb2f576]: 원천 DIVISION_ID 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사 |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0034 | C2 | PLANT_SITE_ID / Plant Site Code | 하네스·환경 | C2 도구 오류 — 실측[T-f3b52974]: 원천 DIVISION_ID 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사 |  | 4 (6 ACT:SCP0037_OperationLT.SpdMain_ComboS) |
| WK-SCP0037-0035 | C2 | SCM_SITE_ID | 하네스·환경 | C2 도구 오류 — 원장 V-3299618b |  | 1 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0036 | C2 | SCM_SITE_ID / Plant Site | 하네스·환경 | C2 도구 오류 — 원장 V-7190eeb3 ASIS / 원장 V-4acebdd4 ASIS / 원장 V-c142b42e ASIS / 원장 V-4ada50f4 ASIS / 원장 V-9f6ae677 ASIS / 원장 V-3299618b  |  | 7 (6 9 ACT:SCP0037_OperationLT.SpdMain_Comb) |
| WK-SCP0037-0037 | C2 | SCP0037_OperationLT.ClbDivision_Selected | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0037_OperationLT.ClbDivision_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 2 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0038 | C2 | SCP0037_OperationLT.SpdMain_ComboSelChan | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0037_OperationLT.SpdMain_ComboSelChange 의 C2 5요소: ERROR:5 |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0039 | C2 | siMain.SetCellTypeCombo | 하네스·환경 | C2 도구 오류 — 원장 V-7190eeb3 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0040 | C2 | siMain.SetCellTypeCombo | 하네스·환경 | C2 도구 오류 — 원장 V-4acebdd4 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0041 | C2 | siMain.SetCellTypeCombo | 하네스·환경 | C2 도구 오류 — 원장 V-c142b42e |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0042 | C2 | siMain.SetCellTypeCombo | 하네스·환경 | C2 도구 오류 — 원장 V-4ada50f4 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0043 | C2 | siMain.SetCellTypeCombo | 하네스·환경 | C2 도구 오류 — 원장 V-76575543 |  | 1 (ACT:SCP0037_OperationLT.setScmSiteId:893) |
| WK-SCP0037-0044 | C2 | siMain.SetCellTypeCombo | 하네스·환경 | C2 도구 오류 — 원장 V-156ea5fa |  | 1 (ACT:SCP0037_OperationLT.setScmSiteId:913) |
| WK-SCP0037-0045 | C2 | siMain.SetCellTypeCombo | 하네스·환경 | C2 도구 오류 — 원장 V-709da79e |  | 1 (ACT:SCP0037_OperationLT.setScmSiteId:931) |
| WK-SCP0037-0046 | C3 | 12 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 12 'SpdMain_ClipboardPasted' 의 C3 12요소: ERROR:8 · NA:2 · PASS:2 |  | 1 (12) |
| WK-SCP0037-0047 | C3 | 13 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 13 'SpdMain_ClipboardPasted' 의 C3 12요소: ERROR:8 · NA:2 · PASS:2 |  | 1 (13) |
| WK-SCP0037-0048 | C3 | 5 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 5 'spdMain.ClipboardPasted' 의 C3 12요소: ERROR:8 · NA:2 · PASS:2 |  | 1 (5) |
| WK-SCP0037-0049 | C3 | DIVISION_ID / Division | 하네스·환경 | C3 도구 오류 — 원장 V-6db681bf ASIS / 원장 V-eb20ee4b ASIS / 원장 V-3e69ded9 ASIS / 원장 V-6cd040b5 ASIS / 원장 V-67029d65 ASIS / 실측[T-78e868b6] |  | 49 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0050 | C3 | ITEM_ID / Material | 하네스·환경 | C3 도구 오류 — 실측[T-045c4eb6]: ITEM_ID: 원천 DIVISION_ID/SCM_SITE_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동  |  | 7 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0051 | C3 | NICK_NAME / Nick Name | 하네스·환경 | C3 도구 오류 — 실측[T-c653f122]: NICK_NAME: 원천 ITEM_ID/DIVISION_ID/SCM_SITE_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판 |  | 6 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0052 | C3 | PLANT_SITE_ID | 하네스·환경 | C3 도구 오류 — 원장 V-eb20ee4b |  | 1 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0053 | C3 | PLANT_SITE_ID / Plant Site Code | 하네스·환경 | C3 도구 오류 — 원장 V-eb20ee4b ASIS / 원장 V-6cd040b5 ASIS / 원장 V-67029d65 ASIS / 실측[T-999dbb95]: PLANT_SITE_ID: 원천 DIVISION_ID/SCM_SITE_I |  | 12 (6 31~40 ACT:SCP0037_OperationLT.SpdMain_) |
| WK-SCP0037-0054 | C3 | SCM_SITE_ID | 하네스·환경 | C3 도구 오류 — 원장 V-6db681bf |  | 1 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0055 | C3 | SCM_SITE_ID | 하네스·환경 | C3 도구 오류 — 원장 V-3e69ded9 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0056 | C3 | SCM_SITE_ID / Plant Site | 하네스·환경 | C3 도구 오류 — 원장 V-6db681bf ASIS / 원장 V-3e69ded9 ASIS / 원장 V-6cd040b5 ASIS / 원장 V-67029d65 ASIS / 실측[T-acfa4892]: SCM_SITE_ID: 원천 DIV |  | 25 (6 9 31~40 ACT:SCP0037_OperationLT.SpdMai) |
| WK-SCP0037-0057 | C3 | SCP0037_OperationLT.SetChangedControl | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0037_OperationLT.SetChangedControl 의 C3 1요소: ERROR:1 |  | 1 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0058 | C3 | SCP0037_OperationLT.setScmSiteId | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0037_OperationLT.setScmSiteId 의 C3 1요소: ERROR:1 |  | 29 (ACT:SCP0037_OperationLT.setScmSiteId:869) |
| WK-SCP0037-0059 | C6 | DIVISION_ID / Division | 하네스·환경 | C6 도구 오류 — 원장 V-56418b46 ASIS / 원장 V-5bd925f6 ASIS / 원장 V-330ac7a0 ASIS / 원장 V-0268fc25 ASIS / 원장 V-f8291a42 ASIS / 원장 V-23c33660  |  | 11 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0060 | C6 | INV_FLAG / Inv Flag | 하네스·환경 | C6 도구 오류 — 실측[T-c742f130]: INV_FLAG 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_v |  | 4 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0061 | C6 | ITEM_ID | 하네스·환경 | C6 도구 오류 — 원장 V-d2ccc99d |  | 1 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0062 | C6 | ITEM_ID / Material | 하네스·환경 | C6 도구 오류 — 원장 V-dd17c93b ASIS / 원장 V-d2ccc99d ASIS / 원장 V-8ab62d21 ASIS |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0063 | C6 | NICK_NAME | 하네스·환경 | C6 도구 오류 — 원장 V-dd17c93b |  | 1 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0064 | C6 | NICK_NAME | 하네스·환경 | C6 도구 오류 — 원장 V-fcc521b2 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0065 | C6 | NICK_NAME / Nick Name | 하네스·환경 | C6 도구 오류 — 원장 V-dd17c93b ASIS / 원장 V-fcc521b2 ASIS / 원장 V-591ac3fc ASIS |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0066 | C6 | PLANT_SITE_ID | 하네스·환경 | C6 도구 오류 — 원장 V-5bd925f6 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0067 | C6 | PLANT_SITE_ID | 하네스·환경 | C6 도구 오류 — 원장 V-0268fc25 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0068 | C6 | PLANT_SITE_ID | 하네스·환경 | C6 도구 오류 — 원장 V-92864f4a |  | 1 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0069 | C6 | PLANT_SITE_ID / Plant Site Code | 하네스·환경 | C6 도구 오류 — 원장 V-5bd925f6 ASIS / 원장 V-0268fc25 ASIS / 원장 V-f8291a42 ASIS / 원장 V-dd39650f ASIS / 원장 V-92864f4a ASIS / 원장 V-445898a4  |  | 4 (6 ACT:SCP0037_OperationLT.SpdMain_ComboS) |
| WK-SCP0037-0070 | C6 | SCM_SITE_ID | 하네스·환경 | C6 도구 오류 — 원장 V-56418b46 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0071 | C6 | SCM_SITE_ID | 하네스·환경 | C6 도구 오류 — 원장 V-330ac7a0 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0072 | C6 | SCM_SITE_ID | 하네스·환경 | C6 도구 오류 — 원장 V-68ba811e |  | 1 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0073 | C6 | SCM_SITE_ID / Plant Site | 하네스·환경 | C6 도구 오류 — 원장 V-56418b46 ASIS / 원장 V-330ac7a0 ASIS / 원장 V-f8291a42 ASIS / 원장 V-23c33660 ASIS / 원장 V-dd39650f ASIS / 원장 V-8341c601  |  | 7 (6 9 ACT:SCP0037_OperationLT.SpdMain_Comb) |
| WK-SCP0037-0074 | C6 | SCP0037_OperationLT.ClbDivision_Selected | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SCP0037_OperationLT.ClbDivision_SelectedIndexChanged 의 C6 1요소: ERROR:1 |  | 2 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0075 | C6 | SCP0037_OperationLT.SpdMain_ComboSelChan | 하네스·환경 | C6 도구 오류 — 원장 V-68ba811e ASIS / 원장 V-d2ccc99d ASIS / 원장 V-fcc521b2 ASIS / 원장 V-92864f4a ASIS / 원장 V-8ab62d21 ASIS / 원장 V-591ac3fc  |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0076 | B4 | COMMON:UC-05 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 Code 아닌 Name 출력(dataMap 승계)' 의 B4 3요소: ERROR:2 · NOPATH:1 |  | 1 (COMMON:UC-05) |
| WK-SCP0037-0077 | B4 | LT_OPERATION / LT Operation | 하네스·환경 | B4 도구 오류 — 원장 V-ff48f9b2 COLUMN |  | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0078 | B4 | SCM_SITE_ID / Plant Site | 하네스·환경 | B4 도구 오류 — 원장 V-e157f811 COLUMN |  | 7 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0079 | K4 | SCP0037 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-0dd5c48b GENERAL / 원장 V-9f382e10 GENERAL / 원장 V-ab827348 GENERAL / 원장 V-d4566913 GENERAL / 원장 V-055fa770 GENERAL / |  | 20 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0037-0080 | F3 | SCM_SITE_ID | 하네스·환경 | F3 도구 오류 — 원장 V-64ed804a / 실측[T-db7a2b6b]: 붙여넣기 프로브 전제 부족(기존행 true · 신규행 false) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0081 | F3 | SCP0037 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-f2e01a78 RULE_SCREEN / 원장 V-d488067a RULE_SCREEN / 원장 V-29e26416 RULE_SCREEN / 원장 V-1816310a RULE_SCREEN / 원장 V-43 |  | 37 (5 12 13 31~40 ACT:SCP0037_OperationLT.Sp) |
| WK-SCP0037-0082 | F6 | SCP0037 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-a2f16f7c RULE_SCREEN / 원장 V-85e2e594 RULE_SCREEN / 원장 V-3ed5cc00 RULE_SCREEN / 원장 V-6d30ddef RULE_SCREEN / 원장 V-00 |  | 66 (ACT:SCP0037_OperationLT.SaveButton ACT:S) |
| WK-SCP0037-0083 | A5 | 2 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 2 'cboDivision.SelectedIndexChanged' 의 A5 5요소: ERROR:3 · PASS:2 |  | 0 () |
| WK-SCP0037-0084 | A5 | 8 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 8 'dataSource' 의 A5 5요소: ERROR:3 · PASS:2 |  | 1 (8) |
| WK-SCP0037-0085 | A5 | COMMON:UC-01 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 표시(keepRowVisibl' 의 A5 5요소: ERROR:3 · PASS:2 |  | 1 (COMMON:UC-01) |
| WK-SCP0037-0086 | A5 | COMMON:UC-02 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시 '수정 중...조회?' confirm(MSG00703" 의 A5 5요소: ERROR:3 · PASS:2 |  | 1 (COMMON:UC-02) |
| WK-SCP0037-0087 | A5 | COMMON:UC-05 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 Code 아닌 Name 출력(dataMap 승계)' 의 A5 5요소: ERROR:3 · PASS:2 |  | 1 (COMMON:UC-05) |
| WK-SCP0037-0088 | A5 | COMMON:UC-07 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회 시 조회+필터 유지(rebindFilterColumns)' 의 A5 5요소: ERROR:3 · PASS:2 |  | 1 (COMMON:UC-07) |
| WK-SCP0037-0089 | A5 | INV_FLAG | 하네스·환경 | A5 도구 오류 — 원장 V-8889d2dd |  | 1 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0090 | A5 | INV_FLAG | 하네스·환경 | A5 도구 오류 — 원장 V-19e26ff9 |  | 1 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0091 | A5 | INV_FLAG / Inv Flag | 하네스·환경 | A5 도구 오류 — 원장 V-8889d2dd ASIS / 원장 V-19e26ff9 ASIS / E2E smoke columns / 실측[T-7127b90c]: INV_FLAG: AS-IS(Div 81) '기본 →숨김 →표시? →표시? |  | 2 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0092 | I1 | SCP0037 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-fb9d8ff6 RULE_SCREEN / 원장 V-50589bf0 RULE_SCREEN / 원장 V-04376111 RULE_SCREEN / 원장 V-4a203145 DEFECT / 원장 V-5fa1a25 |  | 8 (COMMON:UC-02 ACT:SCP0037_OperationLT.Sav) |
| WK-SCP0037-0093 | D1 | SCP0037_OperationLT.EditButton | 하네스·환경 | D1 도구 오류 — 원장 V-b8b5792d ASIS / 원장 V-8fdb2062 ASIS / 원장 V-cb3685e0 ASIS |  | 1 (ACT:SCP0037_OperationLT.EditButton:277:1) |
| WK-SCP0037-0094 | D1 | siMain.SwitchLock | 하네스·환경 | D1 도구 오류 — 원장 V-b8b5792d |  | 1 (ACT:SCP0037_OperationLT.EditButton:278:2) |
| WK-SCP0037-0095 | D4 | 10,6 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 10,6 'other' 의 D4 2요소: ERROR:2 |  | 1 (10,6) |
| WK-SCP0037-0096 | D4 | COMMON:UC-01 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 표시(keepRowVisibl' 의 D4 2요소: ERROR:2 |  | 1 (COMMON:UC-01) |
| WK-SCP0037-0097 | D4 | COMMON:UC-03 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 Reset 후 재조회' 의 D4 2요소: ERROR:2 |  | 1 (COMMON:UC-03) |
| WK-SCP0037-0098 | D4 | DIVISION_ID / Division | 하네스·환경 | D4 도구 오류 — 실측[T-2bca1c80]: 신규행 DIVISION_ID='81' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움: 의도 확인(연쇄 C3/팝업 M4 결과 |  | 1 (11,21) |
| WK-SCP0037-0099 | D4 | LT_OPERATION / LT Operation | 하네스·환경 | D4 도구 오류 — 실측[T-9fac181c]: 신규행 LT_OPERATION='SLITTING' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움: 의도 확인(연쇄 C3/팝 |  | 1 (11,21) |
| WK-SCP0037-0100 | D5 | COMMON:UC-05 | 하네스·환경 | D5 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 Code 아닌 Name 출력(dataMap 승계)' 의 D5 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-05) |
| WK-SCP0037-0101 | D5 | DIVISION_ID / Division | 하네스·환경 | D5 도구 오류 — 실측[T-3d38ef12]: DIVISION_ID: AS-IS COMBO(AS-IS 문장) ↔ TO-BE dataType=1 dataMap=N — 편집 불가 칸이라 입력 방식 차이 없음 · 표시 표본 [81] 을  |  | 3 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0102 | D5 | SCP0037_OperationLT.CreateSpread | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 SCP0037_OperationLT.CreateSpread 의 D5 5요소: PASS:3 · ERROR:1 · NA:1 |  | 4 (ACT:SCP0037_OperationLT.CreateSpread:230) |
| WK-SCP0037-0103 | E4 | DIVISION_ID / Division | 하네스·환경 | E4 도구 오류 — 원장 V-05394fc0 ASIS / 원장 V-e2267fc9 ASIS / 실측[T-0e962d80]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿 |  | 14 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0104 | E4 | ITEM_ID / Material | 하네스·환경 | E4 도구 오류 — 원장 V-05394fc0 ASIS / 원장 V-e2267fc9 ASIS / 실측[T-6db03fd4]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿 |  | 0 () |
| WK-SCP0037-0105 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-377e14ec ASIS / 원장 V-05394fc0 ASIS / 원장 V-e2267fc9 ASIS / 실측[T-6422d572]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 |  | 3 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0106 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-377e14ec / 실측[T-687b80fd]: [사용자판정] PASS — 6번 저장 실패 처리(같은 실측 묶음 16건) — 사용자 확인 오류 아님(검사기 원인 조사·보완 대상) (사용자(대화) 2026- |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0107 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-05394fc0 / 실측[T-b51be921]: [사용자판정] PASS — 6번 저장 실패 처리(같은 실측 묶음 16건) — 사용자 확인 오류 아님(검사기 원인 조사·보완 대상) (사용자(대화) 2026- |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0108 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-e2267fc9 / 실측[T-0dc5f559]: [사용자판정] PASS — 6번 저장 실패 처리(같은 실측 묶음 16건) — 사용자 확인 오류 아님(검사기 원인 조사·보완 대상) (사용자(대화) 2026- |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0109 | E4 | SCM_SITE_ID / Plant Site | 하네스·환경 | E4 도구 오류 — 원장 V-377e14ec ASIS / 원장 V-05394fc0 ASIS / 원장 V-e2267fc9 ASIS / 실측[T-3c2be75d]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 |  | 3 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0110 | G1 | 1 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 1 'cellType' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 0 () |
| WK-SCP0037-0111 | G1 | 20 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 20 'cellType' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (20) |
| WK-SCP0037-0112 | G1 | 3,9 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 3,9 'lock' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (3,9) |
| WK-SCP0037-0113 | G1 | 8 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 8 'dataSource' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (8) |
| WK-SCP0037-0114 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시 '수정 중...조회?' confirm(MSG00703" 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0037-0115 | G1 | COMMON:UC-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 Reset 후 재조회' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-03) |
| WK-SCP0037-0116 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 콤마 다중 입력 시 전건 조회' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-06) |
| WK-SCP0037-0117 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회 시 조회+필터 유지(rebindFilterColumns)' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0037-0118 | G1 | clbPlantSite / Plant Site | 하네스·환경 | G1 도구 오류 — 원장 V-bef622ab SEARCH / E2E smoke cond combo |  | 2 (ACT:SCP0037_OperationLT.FindData ACT:SCP) |
| WK-SCP0037-0119 | X-ROW | SCP0037_OperationLT.ClbDivision_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:6 · NA:2 |  | 2 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0120 | X-ROW | SCP0037_OperationLT.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0037_OperationLT.CreateSpread) |
| WK-SCP0037-0121 | X-ROW | SCP0037_OperationLT.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — PASS:5 · NA:4 · ERROR:1 |  | 3 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0122 | X-ROW | SCP0037_OperationLT.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — PASS:11 · ERROR:2 · NA:2 |  | 2 (ACT:SCP0037_OperationLT.SaveData:422:5 A) |
| WK-SCP0037-0123 | X-ROW | SCP0037_OperationLT.SetChangedControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:5 · ERROR:2 · NOT_RUN:1 · NA:1 |  | 5 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0124 | X-ROW | SCP0037_OperationLT.SpdMain_CellClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 33검사 — ERROR:22 · PASS:6 · NOPATH:3 · NA:2 |  | 82 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0125 | X-ROW | SCP0037_OperationLT.SpdMain_ClipboardPas | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 36검사 — ERROR:18 · PASS:8 · NA:7 · NOPATH:3 |  | 9 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0126 | X-ROW | SCP0037_OperationLT.SpdMain_ComboSelChan | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 26검사 — ERROR:21 · PASS:5 |  | 7 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0127 | X-ROW | SCP0037_OperationLT.btnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:6 · NA:2 · ERROR:1 |  | 5 (ACT:SCP0037_OperationLT.btnItemId_Click:) |
| WK-SCP0037-0128 | X-ROW | SCP0037_OperationLT.checkValidN1 | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:1 · NA:1 · PASS:1 |  | 15 (ACT:SCP0037_OperationLT.checkValidN1 ACT) |
| WK-SCP0037-0129 | X-ROW | SCP0037_OperationLT.setScmSiteId | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:6 · NA:1 |  | 3 (ACT:SCP0037_OperationLT.setScmSiteId:893) |
| WK-SCP0037-0130 | H6 | ITEM_ID / Material | 하네스·환경 | H6 도구 오류 — 원장 V-b25ddfb6 ASIS / 원장 V-fb8ba7b5 ASIS / 원장 V-1b077988 ASIS |  | 3 (4 11 22,23) |
| WK-SCP0037-0131 | H6 | SCM_SITE_ID / Plant Site | 하네스·환경 | H6 도구 오류 — 원장 V-b25ddfb6 ASIS / 원장 V-fb8ba7b5 ASIS / 원장 V-1b077988 ASIS |  | 3 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0132 | H6 | new SCM0002_ItembyPlantSitePopup() | 하네스·환경 | H6 도구 오류 — 원장 V-b25ddfb6 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0133 | H6 | popItem.Form_Load(false, "N", division,  | 하네스·환경 | H6 도구 오류 — 원장 V-fb8ba7b5 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0134 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-1b077988 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0135 | M3 | new SCM0002_ItembyPlantSitePopup() | 하네스·환경 | M3 도구 오류 — 원장 V-b8be05b3 |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0136 | M4 | NICK_NAME / Nick Name | 하네스·환경 | M4 도구 오류 — 실측[T-af09997b]: [검사기 미검증] NICK_NAME: ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) · 시도 행 r0, r164, r327 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (22,23) |
