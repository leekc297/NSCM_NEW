# 작업 원장 — SSP0024 · 2026-11-15 04:02

> 검사 인스턴스 783건 중 PASS·NA 536건 외 **247건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 2 | 재판정 PASS |
| W5 | 검사기 연결 | 19 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 29 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 196 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 196 · 사람 판정 / AS-IS 원문 확인 → 재판정 29 · 하네스 19 · FE 1 · 화면 FE 1 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 1 |  |  |  | 3 |  | 26 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 27 | 연쇄 자동 채움 |
| G1 | GEN |  |  |  |  |  | 1 |  |  | 23 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 24 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 23 | 그리드 셀 cascade 후보 |
| D1 | EDIT |  |  |  |  |  |  |  |  | 18 | 컬럼 편집 가능 여부(신규행·기존행) |
| B4 | COMBO |  |  |  |  |  |  |  |  | 13 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 9 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 9 | 배경·글자색 규칙 |
| G5 | POPUP |  |  |  |  | 8 |  |  |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 8 |  |  |  |  | 팝업 표준·열림 |
| H5 | DESIGN |  |  |  |  |  |  |  |  | 8 | 라벨 명칭 |
| B3 | COMBO |  |  |  |  |  |  |  |  | 7 | 콤보 후보 정렬 = AS-IS |
| E4 | EDIT |  |  |  |  |  |  |  |  | 6 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| D4 | EDIT |  |  |  |  |  |  |  |  | 5 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | EDIT |  |  |  |  |  |  |  |  | 4 | 셀 에디터 유형 |
| M3 | POPUP |  |  |  |  |  |  |  |  | 4 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| F4 | DB |  |  |  |  |  |  |  |  | 3 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G6 | GEN |  |  |  |  |  |  |  |  | 3 | 조회조건 초기 기본값 = AS-IS Form_Load |
| G4 | DESIGN |  |  |  |  | 2 |  |  |  |  | 조회조건 표시·라벨·활성 |
| A6 | GEN |  |  |  |  |  |  | 1 |  | 1 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| C1 | CASCADE |  |  |  |  |  |  |  |  | 2 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F3 | CRUD |  |  |  |  |  |  |  |  | 2 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F2 | CRUD |  |  | 1 |  |  |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| M4 | POPUP |  |  |  |  |  |  | 1 |  |  | 팝업 선택값 반영 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |

## W3 동작 수정 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0001 | F2 | SSP0024 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F2 FAIL 수정 — SSP0024 화면: 원장 V-5e35aff2 RULE_SCREEN / 원장 V-95b573aa RULE_SCREEN / 원장 V-8e986a5b RULE_SCREEN / 원장 V-fdd9071a GENERAL |  | 90 (D00-4a-002 D00-4e-002 D00-4e-003 D00-4e-) |
| WK-SSP0024-0002 | X-ROW | SSP0024_ShipmentMasterElectrode.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0024_ShipmentMasterElectrode.SaveData: 진입점 집계 15검사 — PASS:8 · NA:4 · ERROR:2 · FAIL:1 (FX-SSP0024-049) |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.Save) |

## W5 검사기 연결 (19)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0003 | G4 | btnMaterialId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMaterialId | 있음(FE 소스) | 3 (D00-2-002 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0004 | G4 | btnModelId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnModelId | 있음(FE 소스) | 3 (D00-2-003 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0005 | G03-WIRE | SSP0024 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0024 화면 | 판단불가(대상 단위 SCREEN) | 14 (ACT:SSP0024_ItembyDivisionPopup..ctor AC) |
| WK-SSP0024-0006 | G5 | CELL_TYPE / Cell Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL CELL_TYPE / Cell Type | 있음(SHEET_COLUMNS) | 1 (D00-3-025) |
| WK-SSP0024-0007 | G5 | DIVISION_ID / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL DIVISION_ID / Div | 있음(SHEET_COLUMNS) | 1 (D00-3-020) |
| WK-SSP0024-0008 | G5 | ELECTRODE_TYPE / Electrode Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL ELECTRODE_TYPE / Electrode Type | 있음(SHEET_COLUMNS) | 1 (D00-3-027) |
| WK-SSP0024-0009 | G5 | ITEM_UOM / UOM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL ITEM_UOM / UOM | 있음(SHEET_COLUMNS) | 1 (D00-3-028) |
| WK-SSP0024-0010 | G5 | MODEL_ID / Model | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL MODEL_ID / Model | 있음(SHEET_COLUMNS) | 1 (D00-3-024) |
| WK-SSP0024-0011 | G5 | NICK_NAME / Nick Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL NICK_NAME / Nick Name | 있음(SHEET_COLUMNS) | 1 (D00-3-026) |
| WK-SSP0024-0012 | G5 | PLANT_SITE_CODE / Plant Site Code | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL PLANT_SITE_CODE / Plant Site Code | 있음(SHEET_COLUMNS) | 2 (D00-3-021 D00-3-022) |
| WK-SSP0024-0013 | G5 | UOM_CONVERT_IN_TACT_TIME / Pancake (m/ce | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL UOM_CONVERT_IN_TACT_TIME / Pancake (m/cell | 있음(SHEET_COLUMNS) | 1 (D00-3-029) |
| WK-SSP0024-0014 | H6 | CELL_TYPE / Cell Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CELL_TYPE / Cell Type | 있음(SHEET_COLUMNS) | 1 (D00-3-025) |
| WK-SSP0024-0015 | H6 | DIVISION_ID / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL DIVISION_ID / Div | 있음(SHEET_COLUMNS) | 1 (D00-3-020) |
| WK-SSP0024-0016 | H6 | ELECTRODE_TYPE / Electrode Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ELECTRODE_TYPE / Electrode Type | 있음(SHEET_COLUMNS) | 1 (D00-3-027) |
| WK-SSP0024-0017 | H6 | ITEM_UOM / UOM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_UOM / UOM | 있음(SHEET_COLUMNS) | 1 (D00-3-028) |
| WK-SSP0024-0018 | H6 | MODEL_ID / Model | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL MODEL_ID / Model | 있음(SHEET_COLUMNS) | 1 (D00-3-024) |
| WK-SSP0024-0019 | H6 | NICK_NAME / Nick Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME / Nick Name | 있음(SHEET_COLUMNS) | 1 (D00-3-026) |
| WK-SSP0024-0020 | H6 | PLANT_SITE_CODE / Plant Site Code | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PLANT_SITE_CODE / Plant Site Code | 있음(SHEET_COLUMNS) | 2 (D00-3-021 D00-3-022) |
| WK-SSP0024-0021 | H6 | UOM_CONVERT_IN_TACT_TIME / Pancake (m/ce | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL UOM_CONVERT_IN_TACT_TIME / Pancake (m/cell | 있음(SHEET_COLUMNS) | 1 (D00-3-029) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0022 | G1 | clbDivisionId / Division / Division Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivisionId / Division / Division Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0024_ItembyDivisionPopup.FindData) |

## W7 기대값 확정 (29)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0023 | A1 | BtnMaterialId_Click (cs:730) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — BtnMaterialId_Click (cs:730): 행 집계 — 대조표 BtnMaterialId_Click (cs:730) '팝업' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SS |  | 1 (BtnMaterialId_Click (cs:730)) |
| WK-SSP0024-0024 | A1 | BtnModelId_Click (cs:750) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — BtnModelId_Click (cs:750): 행 집계 — 대조표 BtnModelId_Click (cs:750) '팝업' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024. |  | 1 (BtnModelId_Click (cs:750)) |
| WK-SSP0024-0025 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A1 5요소: REVIEW:4 · NA:1 · |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0026 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 A1 5요소: REVIEW:4 · NA:1 · |  | 1 (COMMON:UC-03) |
| WK-SSP0024-0027 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소 |  | 1 (COMMON:UC-06) |
| WK-SSP0024-0028 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 5요소: REVIEW:4 · NA:1 · |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0029 | A1 | ClbDivision_SelectedIndexChanged (cs:771 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ClbDivision_SelectedIndexChanged (cs:771): 행 집계 — 대조표 ClbDivision_SelectedIndexChanged (cs:771) 'cascade' 의 A1 5요소: RE |  | 1 (ClbDivision_SelectedIndexChanged (cs:771) |
| WK-SSP0024-0030 | A1 | D00-1-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-017: 행 집계 — 대조표 D00-1-017 '§1 btnMaterialId / UsrButton' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024.P_SSP0 |  | 1 (D00-1-017) |
| WK-SSP0024-0031 | A1 | D00-1-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-020: 행 집계 — 대조표 D00-1-020 '§1 btnModelId / UsrButton' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024.P_SSP0024 |  | 1 (D00-1-020) |
| WK-SSP0024-0032 | A1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-001: 행 집계 — 대조표 D00-2-001 '§2 cboDivision / SelectedIndexChanged' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP00 |  | 1 (D00-2-001) |
| WK-SSP0024-0033 | A1 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-002: 행 집계 — 대조표 D00-2-002 '§2 btnMaterialId / Click' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024.P_SSP0024_ |  | 1 (D00-2-002) |
| WK-SSP0024-0034 | A1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-003: 행 집계 — 대조표 D00-2-003 '§2 btnModelId / Click' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024.P_SSP0024_GET |  | 1 (D00-2-003) |
| WK-SSP0024-0035 | A1 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-007: 행 집계 — 대조표 D00-3-007 '§3 333 / Query(ds) — 조회결과 바인딩' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024.P_SSP |  | 1 (D00-3-007) |
| WK-SSP0024-0036 | A1 | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-008: 행 집계 — 대조표 D00-3-008 '§3 334 / 0..MaxColumnIndex 전체 lock(조회직후)' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SS |  | 1 (D00-3-008) |
| WK-SSP0024-0037 | A1 | D00-3-052 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-052: 행 집계 — 대조표 D00-3-052 '§3 852 / (nRow,nCol) ← dtRstDataTable(동적 셀 콤보)' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소:  |  | 1 (D00-3-052) |
| WK-SSP0024-0038 | A1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-001: 행 집계 — 대조표 D00-4b-001 '§4b Data.Common / MyDivision / dtMyDivision' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: P |  | 1 (D00-4b-001) |
| WK-SSP0024-0039 | A1 | D00-4f-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-001: 행 집계 — 대조표 D00-4f-001 '§4f ProgressForm / Show' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024.P_SSP0024 |  | 1 (D00-4f-001) |
| WK-SSP0024-0040 | A1 | D00-4f-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-002: 행 집계 — 대조표 D00-4f-002 '§4f SSP0024_ItembyDivisionPopup / ShowDialog' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소:  |  | 1 (D00-4f-002) |
| WK-SSP0024-0041 | A1 | D00-4f-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-003: 행 집계 — 대조표 D00-4f-003 '§4f SSP0024_ItembyDivisionPopup / ShowDialog' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소:  |  | 1 (D00-4f-003) |
| WK-SSP0024-0042 | A1 | D00-4f-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-004: 행 집계 — 대조표 D00-4f-004 '§4f SSP0024_ItembyDivisionPopup / ShowDialog' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소:  |  | 1 (D00-4f-004) |
| WK-SSP0024-0043 | A1 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0024/SSP0002_GET_USER_INFO_ |  | 1 (D00-4a-003) |
| WK-SSP0024-0044 | A1 | PKG_SSP0020.P_USER_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0020.P_USER_CHECK: 골든 비교 케이스 없음(PKG_SSP0020.P_USER_CHECK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 1 (D00-4a-003) |
| WK-SSP0024-0045 | A1 | PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 30 (ACT:SSP0024_ItembyDivisionPopup.FindButt) |
| WK-SSP0024-0046 | A1 | PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER: golden DIFF AS-IS 515행 ↔ TO-BE 515행: Doc/golden/SSP0024/SSP0024_GET_SHIP_MASTER |  | 37 (D00-4a-001 FindButton (cs:230) ACT:SSP00) |
| WK-SSP0024-0047 | A6 | PKG_SSP0020.P_USER_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SSP0020.P_USER_CHECK: 검증 엔진이 실행됐으나 이 대상(SP PKG_SSP0020.P_USER_CHECK)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER |  | 1 (D00-4a-003) |
| WK-SSP0024-0048 | X-ROW | SSP0024_ShipmentMasterElectrode.FindButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.FindButton: 진입점 집계 3검사 — PASS:2 · REVIEW:1 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Find) |
| WK-SSP0024-0049 | X-ROW | SSP0024_ShipmentMasterElectrode.Re_Desig | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.Re_Design: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR/LIST_REBIND, 연결된 요소 검사 없음 |  | 5 (ACT:SSP0024_ShipmentMasterElectrode.Re_D) |
| WK-SSP0024-0050 | X-ROW | SSP0024_ShipmentMasterElectrode.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.SpdMain_KeyPress: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/RETURN/UI_PROP, 연결된 요 |  | 5 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0051 | M4 | SSP0024_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0024_ItembyDivisionPopup: 검증 엔진이 실행됐으나 이 대상(POPUP SSP0024_ItembyDivisionPopup)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔 |  | 5 (D00-4f-002 D00-4f-003 D00-4f-004 MODAL:S) |

## W9 도구 오류 (196)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0052 | C1 | clbDivisionId / Division / Division Id | 하네스·환경 | C1 도구 오류 — 실측[T-6bb122d7]: 공용 팝업 내부 조건(clbDivisionId) — 팝업 안 연쇄는 M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0053 | C1 | clbPlantSiteId / Plant Site / Plant Site | 하네스·환경 | C1 도구 오류 — 실측[T-56338988]: 공용 팝업 내부 조건(clbPlantSiteId) — 팝업 안 연쇄는 M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0054 | C2 | 11 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 11 'SpdMain_ComboSelChange' 의 C2 18요소: ERROR:17 · PASS:1 |  | 1 (11) |
| WK-SSP0024-0055 | C2 | BUILDING | 하네스·환경 | C2 도구 오류 — 원장 V-6b4897bb |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0056 | C2 | BUILDING / Building | 하네스·환경 | C2 도구 오류 — 원장 V-6b4897bb ASIS |  | 13 (D00-3-030 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0057 | C2 | BUILDING_DESC / Building Desc. | 하네스·환경 | C2 도구 오류 — 실측[T-d264aaf7]: BUILDING_DESC 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (D00-3-030 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0058 | C2 | CELL_TYPE / Cell Type | 하네스·환경 | C2 도구 오류 — 실측[T-a84f175d]: CELL_TYPE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0059 | C2 | D00-2-005 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 C2 18요소: ERROR:17 · PASS:1 |  | 1 (D00-2-005) |
| WK-SSP0024-0060 | C2 | D00-4d-011 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-4d-011 '§4d SpdMain_ComboSelChange / -' 의 C2 18요소: ERROR:17 · PASS:1 |  | 1 (D00-4d-011) |
| WK-SSP0024-0061 | C2 | DIVISION_ID | 하네스·환경 | C2 도구 오류 — 원장 V-2e18c266 / 실측[T-084fade1]: 신규행 DIVISION_ID 후보 8 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0062 | C2 | DIVISION_ID / Div | 하네스·환경 | C2 도구 오류 — 원장 V-2e18c266 ASIS / 원장 V-df4d72c6 ASIS / 실측[T-2990cde0]: 신규행 DIVISION_ID 후보 8 |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0063 | C2 | ELECTRODE_TYPE / Electrode Type | 하네스·환경 | C2 도구 오류 — 실측[T-12ce5868]: ELECTRODE_TYPE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0064 | C2 | MATERIAL_ID / Material | 하네스·환경 | C2 도구 오류 — 실측[T-a9101f60]: MATERIAL_ID 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0065 | C2 | MODEL_ID / Model | 하네스·환경 | C2 도구 오류 — 실측[T-60bb07d6]: MODEL_ID 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0066 | C2 | NICK_NAME / Nick Name | 하네스·환경 | C2 도구 오류 — 실측[T-95de8687]: NICK_NAME 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0067 | C2 | PLANT_SITE_CODE / Plant Site Code | 하네스·환경 | C2 도구 오류 — 실측[T-af9b1325]: PLANT_SITE_CODE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0068 | C2 | PLANT_SITE_ID | 하네스·환경 | C2 도구 오류 — 원장 V-874e4756 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0069 | C2 | PLANT_SITE_ID / Plant Site | 하네스·환경 | C2 도구 오류 — 원장 V-874e4756 ASIS / 원장 V-df4d72c6 ASIS / 실측[T-deaa834c]: DIVISION_ID='81' → PLANT_SITE_ID 후보 7건 · DIVISION_ID='81_UC'  |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0070 | C2 | POST_OPER | 하네스·환경 | C2 도구 오류 — 원장 V-c414b7a5 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0071 | C2 | POST_OPER / Post Oper. | 하네스·환경 | C2 도구 오류 — 원장 V-c414b7a5 ASIS |  | 10 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0072 | C2 | POST_OPER_LT / Post Oper.LT(Day | 하네스·환경 | C2 도구 오류 — 실측[T-59270174]: POST_OPER_LT 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0073 | C2 | SSP0024_ShipmentMasterElectrode.ClbDivis | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.ClbDivision_SelectedIndexChanged 의 C2 18요소: ERROR:17 · PASS:1 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.ClbD) |
| WK-SSP0024-0074 | C2 | SSP0024_ShipmentMasterElectrode.SpdMain_ | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.SpdMain_ComboSelChange 의 C2 12요소: ERROR:12 |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0075 | C2 | SpdMain_ComboSelChange (cs:596) | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 SpdMain_ComboSelChange (cs:596) '파생' 의 C2 18요소: ERROR:17 · PASS:1 |  | 1 (SpdMain_ComboSelChange (cs:596)) |
| WK-SSP0024-0076 | C2 | siMain.SetCellTypeCombo | 하네스·환경 | C2 도구 오류 — 원장 V-12c61132 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0077 | C3 | 11 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 11 'SpdMain_ComboSelChange' 의 C3 20요소: ERROR:14 · PASS:6 |  | 1 (11) |
| WK-SSP0024-0078 | C3 | 14 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 14 'SpdMain_ClipboardPasted' 의 C3 20요소: ERROR:14 · PASS:6 |  | 1 (14) |
| WK-SSP0024-0079 | C3 | 15 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 15 'SpdMain_ClipboardPasted' 의 C3 20요소: ERROR:14 · PASS:6 |  | 1 (15) |
| WK-SSP0024-0080 | C3 | BUILDING / Building | 하네스·환경 | C3 도구 오류 — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-51aa299a]: BUILDING 연쇄 원천 컬럼 해석 불가 — AS-IS SpdMain_ComboSelChange:603 si |  | 13 (D00-3-030 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0081 | C3 | BUILDING_DESC / Building Desc. | 하네스·환경 | C3 도구 오류 — 원장 V-87a7dad2 ASIS / 실측[T-ea2d43bb]: BUILDING_DESC: 원천 BUILDING 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 |  | 3 (D00-3-030 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0082 | C3 | CELL_TYPE / Cell Type | 하네스·환경 | C3 도구 오류 — 실측[T-6bfd787c]: CELL_TYPE: 원천 MATERIAL_ID/DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수 |  | 10 (D00-3-044 ACT:SSP0024_ItembyDivisionPopu) |
| WK-SSP0024-0083 | C3 | D00-2-005 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 C3 20요소: ERROR:14 · PASS:6 |  | 1 (D00-2-005) |
| WK-SSP0024-0084 | C3 | D00-2-007 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-007 '§2 spdMain / ClipboardPasted' 의 C3 20요소: ERROR:14 · PASS:6 |  | 1 (D00-2-007) |
| WK-SSP0024-0085 | C3 | D00-4d-011 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-011 '§4d SpdMain_ComboSelChange / -' 의 C3 20요소: ERROR:14 · PASS:6 |  | 1 (D00-4d-011) |
| WK-SSP0024-0086 | C3 | D00-4d-014 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-014 '§4d SpdMain_ClipboardPasted / -' 의 C3 20요소: ERROR:14 · PASS:6 |  | 1 (D00-4d-014) |
| WK-SSP0024-0087 | C3 | D00-4d-015 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-015 '§4d SpdMain_ClipboardPasted / -' 의 C3 20요소: ERROR:14 · PASS:6 |  | 1 (D00-4d-015) |
| WK-SSP0024-0088 | C3 | DIVISION_ID / Div | 하네스·환경 | C3 도구 오류 — 원장 V-6c348025 ASIS / 원장 V-86f49ec4 ASIS / 원장 V-6c37b933 ASIS / 원장 V-b69f3426 ASIS / 실측[T-76e0d7aa]: DIVISION_ID: 원천 MAT |  | 38 (ACT:SSP0024_ItembyDivisionPopup.SetMater) |
| WK-SSP0024-0089 | C3 | ELECTRODE_TYPE / Electrode Type | 하네스·환경 | C3 도구 오류 — 실측[T-536b21af]: ELECTRODE_TYPE: 원천 MATERIAL_ID/DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불 |  | 10 (D00-3-046 ACT:SSP0024_ItembyDivisionPopu) |
| WK-SSP0024-0090 | C3 | ITEM_UOM / UOM | 하네스·환경 | C3 도구 오류 — 실측[T-bb0db5bd]: ITEM_UOM: 원천 MATERIAL_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 |  | 5 (ACT:SSP0024_ItembyDivisionPopup.SetMater) |
| WK-SSP0024-0091 | C3 | MODEL_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-a1e738e0]: MODEL_ID: 원천 MATERIAL_ID/DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 |  | 10 (D00-3-043 ACT:SSP0024_ItembyDivisionPopu) |
| WK-SSP0024-0092 | C3 | NICK_NAME / Nick Name | 하네스·환경 | C3 도구 오류 — 실측[T-be416d9b]: NICK_NAME: 원천 MATERIAL_ID/DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수 |  | 10 (D00-3-045 ACT:SSP0024_ItembyDivisionPopu) |
| WK-SSP0024-0093 | C3 | PLANT_SITE_CODE / Plant Site Code | 하네스·환경 | C3 도구 오류 — 원장 V-6c348025 ASIS / 원장 V-b69f3426 ASIS / 실측[T-14174822]: PLANT_SITE_CODE: 원천 MATERIAL_ID/DIVISION_ID/PLANT_SITE_ID 이 팝 |  | 17 (D00-3-040 D00-3-049 ACT:SSP0024_ItembyDi) |
| WK-SSP0024-0094 | C3 | PLANT_SITE_ID | 하네스·환경 | C3 도구 오류 — 원장 V-86f49ec4 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0095 | C3 | PLANT_SITE_ID | 하네스·환경 | C3 도구 오류 — 원장 V-6c37b933 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0096 | C3 | PLANT_SITE_ID / Plant Site | 하네스·환경 | C3 도구 오류 — 원장 V-6c348025 ASIS / 원장 V-86f49ec4 ASIS / 원장 V-6c37b933 ASIS / 원장 V-b69f3426 ASIS / 실측[T-d66153e8]: PLANT_SITE_ID: 원천 M |  | 22 (D00-3-041 D00-3-049 ACT:SSP0024_ItembyDi) |
| WK-SSP0024-0097 | C3 | POST_OPER_LT / Post Oper.LT(Day | 하네스·환경 | C3 도구 오류 — 원장 V-a4d95037 ASIS / 실측[T-3586562e]: POST_OPER_LT: 원천 POST_OPER 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 |  | 3 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0098 | C3 | SSP0024_ShipmentMasterElectrode.ClbDivis | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.ClbDivision_SelectedIndexChanged 의 C3 20요소: ERROR:14 · PASS:6 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.ClbD) |
| WK-SSP0024-0099 | C3 | SSP0024_ShipmentMasterElectrode.SetCellC | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.SetCellCombo 의 C3 1요소: ERROR:1 |  | 15 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0100 | C3 | SSP0024_ShipmentMasterElectrode.SetChang | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.SetChangedControl 의 C3 20요소: ERROR:14 · PASS:6 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0101 | C3 | SpdMain_ClipboardPasted (cs:659) | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 SpdMain_ClipboardPasted (cs:659) '붙여넣기' 의 C3 20요소: ERROR:14 · PASS:6 |  | 1 (SpdMain_ClipboardPasted (cs:659)) |
| WK-SSP0024-0102 | C3 | SpdMain_ComboSelChange (cs:596) | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 SpdMain_ComboSelChange (cs:596) '파생' 의 C3 20요소: ERROR:14 · PASS:6 |  | 1 (SpdMain_ComboSelChange (cs:596)) |
| WK-SSP0024-0103 | C3 | UOM_CONVERT_IN_TACT_TIME / Pancake (m/ce | 하네스·환경 | C3 도구 오류 — 실측[T-2347f261]: UOM_CONVERT_IN_TACT_TIME: 원천 MATERIAL_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가  |  | 5 (ACT:SSP0024_ItembyDivisionPopup.SetMater) |
| WK-SSP0024-0104 | B3 | D00-4b-004 | 하네스·환경 | B3 도구 오류 — 행 집계 — 대조표 D00-4b-004 '§4b Data.Common / DomExpTypeCode / dtDomExpTypeCod' 의 B3 4요소: NA:2 · PASS:1 · ERROR:1 |  | 1 (D00-4b-004) |
| WK-SSP0024-0105 | B3 | D00-4b-005 | 하네스·환경 | B3 도구 오류 — 행 집계 — 대조표 D00-4b-005 '§4b Data.Common / BuildingForShipMasterElec / dtBu' 의 B3 4요소: NA:2 · PASS:1 · ERROR:1 |  | 1 (D00-4b-005) |
| WK-SSP0024-0106 | B3 | D00-4b-006 | 하네스·환경 | B3 도구 오류 — 행 집계 — 대조표 D00-4b-006 '§4b Data.Common / ElectrodePackageType / dtElectro' 의 B3 4요소: NA:2 · PASS:1 · ERROR:1 |  | 1 (D00-4b-006) |
| WK-SSP0024-0107 | B3 | D00-4b-007 | 하네스·환경 | B3 도구 오류 — 행 집계 — 대조표 D00-4b-007 '§4b Data.Common / PlantSiteByFactoryEEOperation / ' 의 B3 4요소: NA:2 · PASS:1 · ERROR:1 |  | 1 (D00-4b-007) |
| WK-SSP0024-0108 | B3 | DIVISION_ID / Div | 하네스·환경 | B3 도구 오류 — 원장 V-ffa67f77 COLUMN |  | 2 (D00-4b-002 D00-4b-003) |
| WK-SSP0024-0109 | B3 | SSP0024_ShipmentMasterElectrode.GetSSPUs | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.GetSSPUserCheck 의 B3 4요소: NA:2 · PASS:1 · ERROR:1 |  | 9 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0110 | B3 | SSP0024_ShipmentMasterElectrode.GetSelec | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.GetSelectedListName 의 B3 4요소: NA:2 · PASS:1 · ERROR:1 |  | 9 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0111 | B4 | BUILDING / Building | 하네스·환경 | B4 도구 오류 — 원장 V-77441f72 COLUMN |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0112 | B4 | COMMON:UC-05 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 B4 7요소: ERROR:5 · PASS:1 · NA:1 |  | 1 (COMMON:UC-05) |
| WK-SSP0024-0113 | B4 | D00-3-052 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 D00-3-052 '§3 852 / (nRow,nCol) ← dtRstDataTable(동적 셀 콤보)' 의 B4 7요소: ERROR:5 · PASS:1 · NA:1 |  | 1 (D00-3-052) |
| WK-SSP0024-0114 | B4 | D00-4b-004 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 D00-4b-004 '§4b Data.Common / DomExpTypeCode / dtDomExpTypeCod' 의 B4 7요소: ERROR:5 · PASS:1 · NA:1 |  | 1 (D00-4b-004) |
| WK-SSP0024-0115 | B4 | D00-4b-005 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 D00-4b-005 '§4b Data.Common / BuildingForShipMasterElec / dtBu' 의 B4 7요소: ERROR:5 · PASS:1 · NA:1 |  | 1 (D00-4b-005) |
| WK-SSP0024-0116 | B4 | D00-4b-006 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 D00-4b-006 '§4b Data.Common / ElectrodePackageType / dtElectro' 의 B4 7요소: ERROR:5 · PASS:1 · NA:1 |  | 1 (D00-4b-006) |
| WK-SSP0024-0117 | B4 | D00-4b-007 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 D00-4b-007 '§4b Data.Common / PlantSiteByFactoryEEOperation / ' 의 B4 7요소: ERROR:5 · PASS:1 · NA:1 |  | 1 (D00-4b-007) |
| WK-SSP0024-0118 | B4 | DIVISION_ID / Div | 하네스·환경 | B4 도구 오류 — 원장 V-41721d96 COLUMN |  | 4 (D00-4b-002 D00-4b-003 ACT:SSP0024_Shipme) |
| WK-SSP0024-0119 | B4 | PLANT_SITE_ID / Plant Site | 하네스·환경 | B4 도구 오류 — 원장 V-55977de5 COLUMN |  | 3 (D00-3-050 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0120 | B4 | POST_OPER / Post Oper. | 하네스·환경 | B4 도구 오류 — 원장 V-a5efee46 COLUMN |  | 2 (D00-3-031 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0121 | B4 | SSP0024_ShipmentMasterElectrode.GetSSPUs | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.GetSSPUserCheck 의 B4 7요소: ERROR:5 · PASS:1 · NA:1 |  | 9 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0122 | B4 | SSP0024_ShipmentMasterElectrode.GetSelec | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.GetSelectedListName 의 B4 7요소: ERROR:5 · PASS:1 · NA:1 |  | 9 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0123 | B4 | cboPlantSite / Plant Site | 하네스·환경 | B4 도구 오류 — 원장 V-440a83fc SEARCH |  | 1 (D00-1-015) |
| WK-SSP0024-0124 | K4 | SSP0024 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-03c9b6b7 GENERAL / 원장 V-4ddb6f55 GENERAL / 원장 V-9748f6f3 GENERAL / 원장 V-cba71536 GENERAL / 원장 V-700dad20 GENERAL / |  | 39 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SSP0024-0125 | F1 | SSP0024 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-02168149 RULE_SCREEN / 원장 V-93964b50 RULE_SCREEN / 원장 V-6187bd29 RULE_SCREEN / 원장 V-633bf419 RULE_SCREEN / 원장 V-c9 |  | 106 (D00-3-006 D00-4a-002 D00-4d-002 D00-4d-0) |
| WK-SSP0024-0126 | F3 | PLANT_SITE_ID | 하네스·환경 | F3 도구 오류 — 원장 V-ed5479e3 / 실측[T-3a904711]: 붙여넣기 프로브 전제 부족(기존행 true · 신규행 false) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0127 | F3 | SSP0024 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-9573db76 RULE_SCREEN / 원장 V-f0d9887f RULE_SCREEN / 원장 V-1362e622 RULE_SCREEN / 원장 V-94cba1b9 RULE_SCREEN / 원장 V-cc |  | 46 (D00-2-007 D00-3-040 D00-3-041 D00-3-042 ) |
| WK-SSP0024-0128 | F6 | SSP0024 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-38f078d9 RULE_SCREEN / 원장 V-ed6866f7 RULE_SCREEN / 원장 V-d90abc4b RULE_SCREEN / 원장 V-ba677002 RULE_SCREEN / 원장 V-41 |  | 86 (D00-4a-002 ACT:SSP0024_ShipmentMasterEle) |
| WK-SSP0024-0129 | F4 | PKG_SSP0020.P_USER_CHECK | 하네스·환경 | F4 도구 오류 — 실측[T-39468f12]: PKG_SSP0020.P_USER_CHECK: SSP0020/Delegate/USER_CHECK — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리오에서 판정) |  | 1 (D00-4a-003) |
| WK-SSP0024-0130 | F4 | PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISI | 하네스·환경 | F4 도구 오류 — 실측[T-ae6d9869]: PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP: SSP0024/popup/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경 |  | 30 (ACT:SSP0024_ItembyDivisionPopup.FindButt) |
| WK-SSP0024-0131 | F4 | SCM0001_GET_DIVISION | 하네스·환경 | F4 도구 오류 — 실측[T-d68e9643]: SCM0001_GET_DIVISION: DMF0008/division/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리오에서 판정) → 기계 판정 |  | 2 (ACT:SSP0024_ItembyDivisionPopup.GetDivis) |
| WK-SSP0024-0132 | A5 | 3 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 3 'DeleteButton' 의 A5 15요소: PASS:14 · ERROR:1 |  | 1 (3) |
| WK-SSP0024-0133 | A5 | COMMON:UC-07 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A5 15요소: PASS:14 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0134 | A5 | D00-1-014 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-014 '§1 usrConditionPanel1 / UsrConditionPanel' 의 A5 15요소: PASS:14 · ERROR:1 |  | 1 (D00-1-014) |
| WK-SSP0024-0135 | A5 | D00-1-021 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-021 '§1 spdMain / FpSpread' 의 A5 15요소: PASS:14 · ERROR:1 |  | 1 (D00-1-021) |
| WK-SSP0024-0136 | A5 | D00-1-022 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-022 '§1 spdMain_Sheet1 / SheetView' 의 A5 15요소: PASS:14 · ERROR:1 |  | 1 (D00-1-022) |
| WK-SSP0024-0137 | A5 | D00-2-004 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-2-004 '§2 spdMain / CellClick' 의 A5 15요소: PASS:14 · ERROR:1 |  | 1 (D00-2-004) |
| WK-SSP0024-0138 | A5 | D00-3-007 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-007 '§3 333 / Query(ds) — 조회결과 바인딩' 의 A5 15요소: PASS:14 · ERROR:1 |  | 1 (D00-3-007) |
| WK-SSP0024-0139 | A5 | D00-4b-001 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-4b-001 '§4b Data.Common / MyDivision / dtMyDivision' 의 A5 15요소: PASS:14 · ERROR:1 |  | 1 (D00-4b-001) |
| WK-SSP0024-0140 | A5 | DIVISION_NAME | 하네스·환경 | A5 도구 오류 — 실측[T-fd916725]: [검사기 미검증] BUILDING 더블클릭 → 팝업 열림 감지 실패(H6) |  | 3 (ACT:SSP0024_ItembyDivisionPopup.InitSpre) |
| WK-SSP0024-0141 | H2 | 3 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 3 'DeleteButton' 의 H2 15요소: PASS:14 · ERROR:1 |  | 1 (3) |
| WK-SSP0024-0142 | H2 | COMMON:UC-07 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H2 15요소: PASS:14 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0143 | H2 | D00-1-021 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-021 '§1 spdMain / FpSpread' 의 H2 15요소: PASS:14 · ERROR:1 |  | 1 (D00-1-021) |
| WK-SSP0024-0144 | H2 | D00-1-022 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-022 '§1 spdMain_Sheet1 / SheetView' 의 H2 15요소: PASS:14 · ERROR:1 |  | 1 (D00-1-022) |
| WK-SSP0024-0145 | H2 | D00-2-004 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-2-004 '§2 spdMain / CellClick' 의 H2 15요소: PASS:14 · ERROR:1 |  | 1 (D00-2-004) |
| WK-SSP0024-0146 | H2 | D00-3-007 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-3-007 '§3 333 / Query(ds) — 조회결과 바인딩' 의 H2 15요소: PASS:14 · ERROR:1 |  | 1 (D00-3-007) |
| WK-SSP0024-0147 | H2 | D00-4b-001 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-4b-001 '§4b Data.Common / MyDivision / dtMyDivision' 의 H2 15요소: PASS:14 · ERROR:1 |  | 1 (D00-4b-001) |
| WK-SSP0024-0148 | H2 | DIVISION_NAME | 하네스·환경 | H2 도구 오류 — 실측[T-dfec92aa]: [검사기 미검증] BUILDING 더블클릭 → 팝업 열림 감지 실패(H6) |  | 3 (ACT:SSP0024_ItembyDivisionPopup.InitSpre) |
| WK-SSP0024-0149 | H2 | SSP0024_ShipmentMasterElectrode.CreateSp | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.CreateSpread 의 H2 15요소: PASS:14 · ERROR:1 |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0150 | H5 | 3 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 3 'DeleteButton' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (3) |
| WK-SSP0024-0151 | H5 | COMMON:UC-07 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0152 | H5 | D00-1-021 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-021 '§1 spdMain / FpSpread' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (D00-1-021) |
| WK-SSP0024-0153 | H5 | D00-1-022 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-022 '§1 spdMain_Sheet1 / SheetView' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (D00-1-022) |
| WK-SSP0024-0154 | H5 | D00-2-004 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-2-004 '§2 spdMain / CellClick' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (D00-2-004) |
| WK-SSP0024-0155 | H5 | D00-3-007 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-3-007 '§3 333 / Query(ds) — 조회결과 바인딩' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (D00-3-007) |
| WK-SSP0024-0156 | H5 | DIVISION_NAME | 하네스·환경 | H5 도구 오류 — 실측[T-db336b2c]: [검사기 미검증] BUILDING 더블클릭 → 팝업 열림 감지 실패(H6) |  | 3 (ACT:SSP0024_ItembyDivisionPopup.InitSpre) |
| WK-SSP0024-0157 | H5 | SSP0024_ShipmentMasterElectrode.CreateSp | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.CreateSpread 의 H5 16요소: PASS:15 · ERROR:1 |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0158 | D1 | 1 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 1 'EditButton' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (1) |
| WK-SSP0024-0159 | D1 | 12 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 12 'SpdMain_KeyPress' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (12) |
| WK-SSP0024-0160 | D1 | 15 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 15 'SpdMain_ClipboardPasted' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (15) |
| WK-SSP0024-0161 | D1 | 5 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 5 'SpdMain_CellClick' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 0 () |
| WK-SSP0024-0162 | D1 | 6 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 6 'SpdMain_CellClick' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (6) |
| WK-SSP0024-0163 | D1 | 7 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 7 'SpdMain_CellClick' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (7) |
| WK-SSP0024-0164 | D1 | D00-1-018 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-1-018 '§1 txtNickName / TextEdit' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (D00-1-018) |
| WK-SSP0024-0165 | D1 | D00-3-001 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-3-001 '§3 253 / () — Edit 모드 전체 잠금 토글' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (D00-3-001) |
| WK-SSP0024-0166 | D1 | D00-3-008 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-3-008 '§3 334 / 0..MaxColumnIndex 전체 lock(조회직후)' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (D00-3-008) |
| WK-SSP0024-0167 | D1 | D00-4d-001 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-001 '§4d EditButton / Edit' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (D00-4d-001) |
| WK-SSP0024-0168 | D1 | D00-4d-006 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-006 '§4d SpdMain_CellClick / -' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (D00-4d-006) |
| WK-SSP0024-0169 | D1 | D00-4d-012 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-012 '§4d SpdMain_KeyPress / -' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (D00-4d-012) |
| WK-SSP0024-0170 | D1 | D00-4e-001 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4e-001 '§4e MSG00251 / isOK == false' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (D00-4e-001) |
| WK-SSP0024-0171 | D1 | EditButton (cs:240) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 EditButton (cs:240) 'Edit' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (EditButton (cs:240)) |
| WK-SSP0024-0172 | D1 | InsertButton (cs:235) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 InsertButton (cs:235) 'Insert' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (InsertButton (cs:235)) |
| WK-SSP0024-0173 | D1 | SSP0024_ShipmentMasterElectrode.EditButt | 하네스·환경 | D1 도구 오류 — 원장 V-5c2c21f2 ASIS / 원장 V-8babf10f ASIS / 원장 V-d62a1f71 ASIS / 원장 V-a9c87e97 ASIS / 원장 V-9cb1ec68 ASIS |  | 5 (ACT:SSP0024_ShipmentMasterElectrode.Edit) |
| WK-SSP0024-0174 | D1 | SaveButton (cs:280) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 SaveButton (cs:280) 'Save' 의 D1 17요소: PASS:14 · NA:2 · ERROR:1 |  | 1 (SaveButton (cs:280)) |
| WK-SSP0024-0175 | D1 | siMain.SwitchLock | 하네스·환경 | D1 도구 오류 — 원장 V-5c2c21f2 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Edit) |
| WK-SSP0024-0176 | D4 | COMMON:UC-01 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (ke' 의 D4 1요소: ERROR:1 |  | 1 (COMMON:UC-01) |
| WK-SSP0024-0177 | D4 | COMMON:UC-03 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 D4 1요소: ERROR:1 |  | 1 (COMMON:UC-03) |
| WK-SSP0024-0178 | D4 | D00-3-009 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 D00-3-009 '§3 370 / 신규행 삽입' 의 D4 1요소: ERROR:1 |  | 1 (D00-3-009) |
| WK-SSP0024-0179 | D4 | DIVISION_ID / Div | 하네스·환경 | D4 도구 오류 — 실측[T-6c2e9074]: 신규행 DIVISION_ID='81' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움: 의도 확인(연쇄 C3/팝업 M4 결과 |  | 1 (D00-3-014) |
| WK-SSP0024-0180 | D4 | InsertButton (cs:235) | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 InsertButton (cs:235) 'Insert' 의 D4 1요소: ERROR:1 |  | 1 (InsertButton (cs:235)) |
| WK-SSP0024-0181 | D5 | COMMON:UC-05 | 하네스·환경 | D5 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 D5 13요소: PASS:12 · ERROR:1 |  | 1 (COMMON:UC-05) |
| WK-SSP0024-0182 | D5 | D00-3-052 | 하네스·환경 | D5 도구 오류 — 행 집계 — 대조표 D00-3-052 '§3 852 / (nRow,nCol) ← dtRstDataTable(동적 셀 콤보)' 의 D5 13요소: PASS:12 · ERROR:1 |  | 1 (D00-3-052) |
| WK-SSP0024-0183 | D5 | DIVISION_NAME | 하네스·환경 | D5 도구 오류 — 실측[T-c8c2d71b]: [검사기 미검증] BUILDING 더블클릭 → 팝업 열림 감지 실패(H6) |  | 3 (ACT:SSP0024_ItembyDivisionPopup.InitSpre) |
| WK-SSP0024-0184 | D5 | SSP0024_ShipmentMasterElectrode.CreateSp | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.CreateSpread 의 D5 13요소: PASS:12 · ERROR:1 |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0185 | E4 | DIVISION_ID / Div | 하네스·환경 | E4 도구 오류 — 원장 V-493f4064 ASIS / 실측[T-ab78900c]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Sp |  | 14 (D00-4d-007 D00-4e-005 ACT:SSP0024_Itemby) |
| WK-SSP0024-0186 | E4 | MATERIAL_ID / Material | 하네스·환경 | E4 도구 오류 — 원장 V-3c2a6208 ASIS / 실측[T-a7a626c5]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Sp |  | 4 (ACT:SSP0024_ItembyDivisionPopup.SetMater) |
| WK-SSP0024-0187 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-493f4064 ASIS / 원장 V-3c2a6208 ASIS / 실측[T-8beafcdc]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿 |  | 4 (D00-4e-005 D00-4e-006 ACT:SSP0024_Shipme) |
| WK-SSP0024-0188 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-493f4064 / 실측[T-7dd4a73f]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0189 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-3c2a6208 / 실측[T-0e306795]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0190 | E4 | PLANT_SITE_ID / Plant Site | 하네스·환경 | E4 도구 오류 — 원장 V-3c2a6208 ASIS / 실측[T-b9d7f06f]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Sp |  | 4 (ACT:SSP0024_ItembyDivisionPopup.SetMater) |
| WK-SSP0024-0191 | A6 | PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISI | 하네스·환경 | A6 도구 오류 — 원장 V-d7b352eb SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-11ad13e2]: PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP: 화면 진입·조회 경로 |  | 30 (ACT:SSP0024_ItembyDivisionPopup.FindButt) |
| WK-SSP0024-0192 | G1 | BtnMaterialId_Click (cs:730) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 BtnMaterialId_Click (cs:730) '팝업' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (BtnMaterialId_Click (cs:730)) |
| WK-SSP0024-0193 | G1 | BtnModelId_Click (cs:750) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 BtnModelId_Click (cs:750) '팝업' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (BtnModelId_Click (cs:750)) |
| WK-SSP0024-0194 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RU |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0195 | G1 | COMMON:UC-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RU |  | 1 (COMMON:UC-03) |
| WK-SSP0024-0196 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (COMMON:UC-06) |
| WK-SSP0024-0197 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RU |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0198 | G1 | ClbDivision_SelectedIndexChanged (cs:771 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 ClbDivision_SelectedIndexChanged (cs:771) 'cascade' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (ClbDivision_SelectedIndexChanged (cs:771) |
| WK-SSP0024-0199 | G1 | D00-1-012 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-012 '§1 usrLayoutControl2 / UsrLayoutControl' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-1-012) |
| WK-SSP0024-0200 | G1 | D00-1-014 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-014 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-1-014) |
| WK-SSP0024-0201 | G1 | D00-1-017 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-017 '§1 btnMaterialId / UsrButton' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-1-017) |
| WK-SSP0024-0202 | G1 | D00-1-020 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-020 '§1 btnModelId / UsrButton' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-1-020) |
| WK-SSP0024-0203 | G1 | D00-2-002 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-002 '§2 btnMaterialId / Click' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-2-002) |
| WK-SSP0024-0204 | G1 | D00-2-003 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-003 '§2 btnModelId / Click' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-2-003) |
| WK-SSP0024-0205 | G1 | D00-3-007 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-007 '§3 333 / Query(ds) — 조회결과 바인딩' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-3-007) |
| WK-SSP0024-0206 | G1 | D00-3-008 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-008 '§3 334 / 0..MaxColumnIndex 전체 lock(조회직후)' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-3-008) |
| WK-SSP0024-0207 | G1 | D00-3-052 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-052 '§3 852 / (nRow,nCol) ← dtRstDataTable(동적 셀 콤보)' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-3-052) |
| WK-SSP0024-0208 | G1 | D00-4f-001 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-4f-001 '§4f ProgressForm / Show' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-4f-001) |
| WK-SSP0024-0209 | G1 | D00-4f-002 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-4f-002 '§4f SSP0024_ItembyDivisionPopup / ShowDialog' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-4f-002) |
| WK-SSP0024-0210 | G1 | D00-4f-003 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-4f-003 '§4f SSP0024_ItembyDivisionPopup / ShowDialog' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-4f-003) |
| WK-SSP0024-0211 | G1 | D00-4f-004 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-4f-004 '§4f SSP0024_ItembyDivisionPopup / ShowDialog' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-4f-004) |
| WK-SSP0024-0212 | G1 | FindButton (cs:230) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FindButton (cs:230) 'Search' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (FindButton (cs:230)) |
| WK-SSP0024-0213 | G1 | cboPlantSite / Plant Site | 하네스·환경 | G1 도구 오류 — 원장 V-9312020d SEARCH / E2E smoke cond combo |  | 3 (D00-1-015 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0214 | G1 | clbPlantSiteId / Plant Site / Plant Site | 하네스·환경 | G1 도구 오류 — 원장 V-9312020d SEARCH / E2E smoke cond combo |  | 2 (ACT:SSP0024_ItembyDivisionPopup.FindData) |
| WK-SSP0024-0215 | G6 | clbDivisionId / Division / Division Id | 하네스·환경 | G6 도구 오류 — 실측[T-b8809090]: 공용 팝업 내부 조건(clbDivisionId) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0216 | G6 | clbPlantSiteId / Plant Site / Plant Site | 하네스·환경 | G6 도구 오류 — 실측[T-3d2f5f31]: 공용 팝업 내부 조건(clbPlantSiteId) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0217 | G6 | txtMaterialId / Material / Material Id | 하네스·환경 | G6 도구 오류 — 실측[T-72493bd0]: 공용 팝업 내부 조건(txtMaterialId) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (D00-1-016 ACT:SSP0024_ItembyDivisionPopu) |
| WK-SSP0024-0218 | X-ROW | SSP0024_ItembyDivisionPopup..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:1 · NOPATH:1 |  | 2 (ACT:SSP0024_ItembyDivisionPopup..ctor:15) |
| WK-SSP0024-0219 | X-ROW | SSP0024_ItembyDivisionPopup.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:SSP0024_ItembyDivisionPopup.CreateSp) |
| WK-SSP0024-0220 | X-ROW | SSP0024_ItembyDivisionPopup.DefineProper | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 2 (ACT:SSP0024_ItembyDivisionPopup.DefinePr) |
| WK-SSP0024-0221 | X-ROW | SSP0024_ItembyDivisionPopup.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:SSP0024_ItembyDivisionPopup.Dispose:) |
| WK-SSP0024-0222 | X-ROW | SSP0024_ItembyDivisionPopup.FindButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:3 · REVIEW:1 |  | 2 (ACT:SSP0024_ItembyDivisionPopup.FindButt) |
| WK-SSP0024-0223 | X-ROW | SSP0024_ItembyDivisionPopup.FindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:4 · NA:2 · PASS:2 · REVIEW:1 · NOT_RUN:1 |  | 27 (ACT:SSP0024_ItembyDivisionPopup.FindData) |
| WK-SSP0024-0224 | X-ROW | SSP0024_ItembyDivisionPopup.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 11 (ACT:SSP0024_ItembyDivisionPopup.Form_Loa) |
| WK-SSP0024-0225 | X-ROW | SSP0024_ItembyDivisionPopup.GetDivision | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — PASS:2 · ERROR:2 |  | 6 (ACT:SSP0024_ItembyDivisionPopup.GetDivis) |
| WK-SSP0024-0226 | X-ROW | SSP0024_ItembyDivisionPopup.GetDivisionb | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 4 (ACT:SSP0024_ItembyDivisionPopup.GetDivis) |
| WK-SSP0024-0227 | X-ROW | SSP0024_ItembyDivisionPopup.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:6 · PASS:4 |  | 9 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0228 | X-ROW | SSP0024_ItembyDivisionPopup.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 46검사 — PASS:41 · ERROR:5 |  | 14 (ACT:SSP0024_ItembyDivisionPopup.InitSpre) |
| WK-SSP0024-0229 | X-ROW | SSP0024_ItembyDivisionPopup.SetMaterial | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 21검사 — ERROR:13 · NA:7 · PASS:1 |  | 39 (ACT:SSP0024_ItembyDivisionPopup.SetMater) |
| WK-SSP0024-0230 | X-ROW | SSP0024_ItembyDivisionPopup.btnButtonLis | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:2 · PASS:1 |  | 8 (ACT:SSP0024_ItembyDivisionPopup.btnButto) |
| WK-SSP0024-0231 | X-ROW | SSP0024_ItembyDivisionPopup.clbDivision_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 3 (ACT:SSP0024_ItembyDivisionPopup.clbDivis) |
| WK-SSP0024-0232 | X-ROW | SSP0024_ItembyDivisionPopup.spdMain_Cell | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — PASS:1 · ERROR:1 · NOT_RUN:1 · NA:1 |  | 2 (ACT:SSP0024_ItembyDivisionPopup.spdMain_) |
| WK-SSP0024-0233 | X-ROW | SSP0024_ShipmentMasterElectrode.BtnMater | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — PASS:6 · NA:3 · ERROR:2 |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.BtnM) |
| WK-SSP0024-0234 | X-ROW | SSP0024_ShipmentMasterElectrode.BtnModel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — PASS:6 · NA:3 · ERROR:2 |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.BtnM) |
| WK-SSP0024-0235 | X-ROW | SSP0024_ShipmentMasterElectrode.ClbDivis | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.ClbD) |
| WK-SSP0024-0236 | X-ROW | SSP0024_ShipmentMasterElectrode.CreateSp | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0237 | X-ROW | SSP0024_ShipmentMasterElectrode.FindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — PASS:5 · NA:5 · REVIEW:1 · ERROR:1 |  | 6 (ACT:SSP0024_ShipmentMasterElectrode.Find) |
| WK-SSP0024-0238 | X-ROW | SSP0024_ShipmentMasterElectrode.InsertRo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 41검사 — PASS:33 · ERROR:8 |  | 17 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0239 | X-ROW | SSP0024_ShipmentMasterElectrode.SetCellC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:4 · NA:1 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0240 | X-ROW | SSP0024_ShipmentMasterElectrode.SetChang | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — NA:5 · PASS:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0241 | X-ROW | SSP0024_ShipmentMasterElectrode.SpdMain_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 24검사 — ERROR:14 · PASS:7 · NA:3 |  | 37 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0242 | X-ROW | SSP0024_ShipmentMasterElectrode.SpdMain_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 41검사 — PASS:20 · ERROR:13 · NA:8 |  | 11 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0243 | X-ROW | SSP0024_ShipmentMasterElectrode.SpdMain_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 52검사 — PASS:29 · ERROR:23 |  | 10 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0244 | M3 | SSP0024_ItembyDivisionPopup | 하네스·환경 | M3 도구 오류 — 원장 V-560b013f ASIS / 원장 V-8652710c ASIS / 원장 V-3e0254f2 ASIS / 실측[T-32106b12]: 팝업을 여는 트리거 셀을 화면 메타에서 찾지 못함 — 팝업 내부 기능 검 |  | 19 (D00-4f-002 D00-4f-003 D00-4f-004 MODAL:S) |
| WK-SSP0024-0245 | M3 | new SSP0024_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-560b013f |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.BtnM) |
| WK-SSP0024-0246 | M3 | new SSP0024_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-8652710c |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.BtnM) |
| WK-SSP0024-0247 | M3 | new SSP0024_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-3e0254f2 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
