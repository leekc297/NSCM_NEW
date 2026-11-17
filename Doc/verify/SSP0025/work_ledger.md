# 작업 원장 — SSP0025 · 2026-11-15 06:05

> 검사 인스턴스 517건 중 PASS·NA 339건 외 **178건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 5 | 재판정 PASS |
| W5 | 검사기 연결 | 9 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 4 | 실행 → PASS |
| W7 | 기대값 확정 | 12 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 148 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 148 · 사람 판정 / AS-IS 원문 확인 → 재판정 12 · 하네스 9 · DB 메타 4 · E2E 4 · 화면 FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 1 |  |  |  | 1 |  | 27 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 20 | 연쇄 자동 채움 |
| G5 | POPUP |  |  |  |  | 4 |  |  |  | 12 | 팝업 조건 연동(인자) |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 15 | 그리드 셀 cascade 후보 |
| A5 | DESIGN |  |  | 4 |  |  |  |  |  | 6 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G1 | GEN |  |  |  |  |  | 2 |  |  | 7 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 9 | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  |  |  |  | 9 | 라벨 명칭 |
| A1 | GEN |  |  |  |  |  |  | 8 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| D5 | EDIT |  |  |  |  |  |  |  |  | 6 | 셀 에디터 유형 |
| F4 | DB |  |  |  |  |  |  |  |  | 5 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E4 | EDIT |  |  |  |  |  |  |  |  | 5 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| H6 | POPUP |  |  |  |  | 2 | 2 |  |  |  | 팝업 표준·열림 |
| C1 | CASCADE |  |  |  |  |  |  |  |  | 4 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| B4 | COMBO |  |  |  |  |  |  |  |  | 4 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G6 | GEN |  |  |  |  |  |  |  |  | 4 | 조회조건 초기 기본값 = AS-IS Form_Load |
| M3 | POPUP |  |  |  |  |  |  |  |  | 4 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | POPUP |  |  |  |  |  |  | 3 |  |  | 팝업 선택값 반영 |
| G4 | DESIGN |  |  |  |  | 2 |  |  |  |  | 조회조건 표시·라벨·활성 |
| D4 | EDIT |  |  |  |  |  |  |  |  | 2 | 신규행 기본값·자동세팅·Insert 전제 |
| A6 | GEN |  |  |  |  |  |  |  |  | 2 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  |  |  |  | 1 | CRUD Status 표시 정합 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0001 | A5 | CELL_TYPE / Cell Type | DB 메타(적용 예정) | A5 FAIL 수정 — CELL_TYPE / Cell Type: 원장 V-7ca6abae COLUMN / E2E smoke columns / 실측[T-397c31cb]: CELL_TYPE: AS-IS(Div 81) '기본' ↔ TO- |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0002 | A5 | COMMON:UC-02 | DB 메타(적용 예정) | A5 FAIL 수정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A5 14요소: PASS:8 · ERROR: |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0003 | A5 | COMMON:UC-07 | DB 메타(적용 예정) | A5 FAIL 수정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A5 14요소: PASS:8 · ERROR: |  | 1 (COMMON:UC-07) |
| WK-SSP0025-0004 | A5 | spdMain(FpSpread) | DB 메타(적용 예정) | A5 FAIL 수정 — spdMain(FpSpread): 행 집계 — 대조표 spdMain(FpSpread) 'designer:539' 의 A5 14요소: PASS:8 · ERROR:5 · FAIL:1 · FAIL 요소: CELL_T |  | 1 (spdMain(FpSpread)) |
| WK-SSP0025-0005 | X-ROW | SSP0025_ItembyDivisionPopup.InitSpread | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0025_ItembyDivisionPopup.InitSpread: 진입점 집계 46검사 — ERROR:21 · PASS:20 · NA:4 · FAIL:1 (FX-SSP0025-033) |  | 14 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |

## W5 검사기 연결 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0006 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitEve) |
| WK-SSP0025-0007 | G4 | btnModelId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnModelId | 있음(FE 소스) | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitEve) |
| WK-SSP0025-0008 | G03-WIRE | SSP0025 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0025 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:SSP0025_ItembyDivisionPopup..ctor AC) |
| WK-SSP0025-0009 | G5 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 1 (셀 DIVISION_ID) |
| WK-SSP0025-0010 | G5 | VALID_YN / Valid | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL VALID_YN / Valid | 있음(SHEET_COLUMNS) | 1 (셀 VALID_YN) |
| WK-SSP0025-0011 | G5 | cboDivision / Div / Division / Div. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboDivision / Div / Division / Div. | 있음(FE 소스) | 2 (cboDivision 셀 DIVISION_ID) |
| WK-SSP0025-0012 | G5 | clbFromSite / Plant Site / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbFromSite / Plant Site / From Site | 있음(FE 소스) | 1 (clbFromSite) |
| WK-SSP0025-0013 | H6 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 1 (셀 DIVISION_ID) |
| WK-SSP0025-0014 | H6 | VALID_YN / Valid | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL VALID_YN / Valid | 있음(SHEET_COLUMNS) | 1 (셀 VALID_YN) |

## W6 검증 실행 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0015 | G1 | clbDivisionId / Division / Division Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivisionId / Division / Division Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0025_ItembyDivisionPopup.FindData) |
| WK-SSP0025-0016 | G1 | clbFromSiteId / From Site / From Site Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSiteId / From Site / From Site Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0025_ItembyDivisionPopup.FindData) |
| WK-SSP0025-0017 | H6 | cboDivision / Div / Division / Div. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Div / Division / Div. · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (cboDivision 셀 DIVISION_ID) |
| WK-SSP0025-0018 | H6 | clbFromSite / Plant Site / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbFromSite / Plant Site / From Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (clbFromSite) |

## W7 기대값 확정 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0019 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A1 2요소: REVIEW:1 · PASS:1 |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0020 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL  |  | 1 (COMMON:UC-06) |
| WK-SSP0025-0021 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 2요소: REVIEW:1 · PASS:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0025-0022 | A1 | CboDivision_SelectedIndexChanged → SetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CboDivision_SelectedIndexChanged → SetChangedContr: 행 집계 — 대조표 CboDivision_SelectedIndexChanged → SetChangedControl 'c |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SSP0025-0023 | A1 | FindButton → FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton → FindData_Main: 행 집계 — 대조표 FindButton → FindData_Main 'cs:185,249~284' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL  |  | 1 (FindButton → FindData_Main) |
| WK-SSP0025-0024 | A1 | PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 35 (ACT:SSP0025_ItembyDivisionPopup.FindButt) |
| WK-SSP0025-0025 | A1 | R11 신규행 SITE 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R11 신규행 SITE 재조회: 행 집계 — 대조표 R11 신규행 SITE 재조회 'cs:637~641' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SSP0025.P_SSP002 |  | 1 (R11 신규행 SITE 재조회) |
| WK-SSP0025-0026 | A1 | checkRequiredOfSearch(Division 필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — checkRequiredOfSearch(Division 필수): 행 집계 — 대조표 checkRequiredOfSearch(Division 필수) 'cs:249' 의 A1 2요소: REVIEW:1 · PASS:1 |  | 1 (checkRequiredOfSearch(Division 필수)) |
| WK-SSP0025-0027 | X-ROW | SSP0025_ShipmentRequestorPIC.Delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.Delete: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/DATA_OP/ENTRY/EXPR/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:SSP0025_ShipmentRequestorPIC.Delete ) |
| WK-SSP0025-0028 | M4 | SSP0025_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0025_ItembyDivisionPopup: 검증 엔진이 실행됐으나 이 대상(POPUP SSP0025_ItembyDivisionPopup)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔 |  | 2 (SSP0025_ItembyDivisionPopup ACT:SSP0025_) |
| WK-SSP0025-0029 | M4 | cboDivision / Div / Division / Div. | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboDivision / Div / Division / Div.: 검증 엔진이 실행됐으나 이 대상(COND cboDivision)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (cboDivision 셀 DIVISION_ID) |
| WK-SSP0025-0030 | M4 | clbFromSite / Plant Site / From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbFromSite / Plant Site / From Site: 검증 엔진이 실행됐으나 이 대상(COND clbFromSite)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (clbFromSite) |

## W9 도구 오류 (148)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0031 | C1 | CboDivision_SelectedIndexChanged → SetCh | 하네스·환경 | C1 도구 오류 — 실측[T-373e0eca]: 행 CboDivision_SelectedIndexChanged → SetChangedControl() = 조회조건 C1 실측 상속: 공용 팝업 내부 조건(clbDivisionId) —  |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SSP0025-0032 | C1 | cboDivision / Div / Division / Div. | 하네스·환경 | C1 도구 오류 — 원장 V-d4dde0fb SEARCH / 실측[T-9ea474d1]: 'Div' → '40 Mobility & IT Battery' 변경 · 콤보 재요청 4건 · 하위 clbFromSite(사전 선택 'HQ OC2 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InitCon) |
| WK-SSP0025-0033 | C1 | clbDivisionId / Division / Division Id | 하네스·환경 | C1 도구 오류 — 실측[T-4fe22faf]: 공용 팝업 내부 조건(clbDivisionId) — 팝업 안 연쇄는 M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0034 | C1 | clbFromSiteId / From Site / From Site Id | 하네스·환경 | C1 도구 오류 — 실측[T-abcb0729]: 공용 팝업 내부 조건(clbFromSiteId) — 팝업 안 연쇄는 M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0035 | C2 | CELL_TYPE / Cell Type | 하네스·환경 | C2 도구 오류 — 실측[T-9980ff70]: CELL_TYPE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0036 | C2 | CellClick 순수가드(619/674) | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 CellClick 순수가드(619/674) 'cs:619,674' 의 C2 11요소: ERROR:11 |  | 1 (CellClick 순수가드(619/674)) |
| WK-SSP0025-0037 | C2 | DIVISION_ID | 하네스·환경 | C2 도구 오류 — 원장 V-41aff69e / 실측[T-b623ae92]: 신규행 DIVISION_ID 후보 8 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InsertR) |
| WK-SSP0025-0038 | C2 | DIVISION_ID / Division | 하네스·환경 | C2 도구 오류 — 원장 V-41aff69e ASIS / 실측[T-f5175ac7]: 신규행 DIVISION_ID 후보 8 |  | 5 (R14 신규행 Division 변경 reset ACT:SSP0025_It) |
| WK-SSP0025-0039 | C2 | ELECTRODE_TYPE / Electrode Type | 하네스·환경 | C2 도구 오류 — 실측[T-85abe6d6]: ELECTRODE_TYPE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0040 | C2 | ITEM_ID / Material | 하네스·환경 | C2 도구 오류 — 실측[T-1afb3536]: ITEM_ID 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0041 | C2 | MODEL_ID / Model | 하네스·환경 | C2 도구 오류 — 실측[T-3e955b23]: MODEL_ID 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0042 | C2 | NICK_NAME / Nick Name | 하네스·환경 | C2 도구 오류 — 실측[T-56103c7a]: NICK_NAME 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0043 | C2 | R15 ComboSelChange 가드(행0) | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 R15 ComboSelChange 가드(행0) 'cs:674' 의 C2 11요소: ERROR:11 |  | 1 (R15 ComboSelChange 가드(행0)) |
| WK-SSP0025-0044 | C2 | SITE_DESCRIPTION | 하네스·환경 | C2 도구 오류 — 원장 V-bc71306a |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InsertR) |
| WK-SSP0025-0045 | C2 | SITE_DESCRIPTION | 하네스·환경 | C2 도구 오류 — 원장 V-1474d690 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0046 | C2 | SITE_DESCRIPTION / Plant Site | 하네스·환경 | C2 도구 오류 — 원장 V-bc71306a ASIS / 원장 V-1474d690 ASIS / 실측[T-7724e3cb]: DIVISION_ID='81 Automotive Battery' → SITE_DESCRIPTION 후보 9건  |  | 5 (R13 SITE→TO_SITE 파생 ACT:SSP0025_Shipment) |
| WK-SSP0025-0047 | C2 | SSP0025_ShipmentRequestorPIC.CboDivision | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0025_ShipmentRequestorPIC.CboDivision_SelectedIndexChanged 의 C2 11요소: ERROR:11 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.CboDivi) |
| WK-SSP0025-0048 | C2 | SSP0025_ShipmentRequestorPIC.SpdMain_Com | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0025_ShipmentRequestorPIC.SpdMain_ComboSelChange 의 C2 8요소: ERROR:8 |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0049 | C2 | TO_SITE / Plant Site Code | 하네스·환경 | C2 도구 오류 — 실측[T-41c88174]: TO_SITE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (R13 SITE→TO_SITE 파생 ACT:SSP0025_Shipment) |
| WK-SSP0025-0050 | C3 | CELL_TYPE / Cell Type | 하네스·환경 | C3 도구 오류 — 실측[T-d87fe211]: CELL_TYPE: 원천 ITEM_ID/DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 |  | 7 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0051 | C3 | CellClick 순수가드(619/674) | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 CellClick 순수가드(619/674) 'cs:619,674' 의 C3 19요소: ERROR:16 · PASS:3 |  | 1 (CellClick 순수가드(619/674)) |
| WK-SSP0025-0052 | C3 | DIVISION_ID / Division | 하네스·환경 | C3 도구 오류 — 실측[T-30e9c0fb]: DIVISION_ID: 원천 ITEM_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장  |  | 12 (R14 신규행 Division 변경 reset ACT:SSP0025_It) |
| WK-SSP0025-0053 | C3 | ELECTRODE_TYPE / Electrode Type | 하네스·환경 | C3 도구 오류 — 실측[T-ab86671e]: ELECTRODE_TYPE: 원천 ITEM_ID/DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 —  |  | 7 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0054 | C3 | FROM_SITE | 하네스·환경 | C3 도구 오류 — 실측[T-d8edf17c]: 팝업 내부 그리드 컬럼 FROM_SITE — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0055 | C3 | FROM_SITE_CODE | 하네스·환경 | C3 도구 오류 — 실측[T-8f7c2f69]: 팝업 내부 그리드 컬럼 FROM_SITE_CODE — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0056 | C3 | ITEM_UOM | 하네스·환경 | C3 도구 오류 — 실측[T-c3534e97]: 팝업 내부 그리드 컬럼 ITEM_UOM — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0057 | C3 | MODEL_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-d4d6430e]: MODEL_ID: 원천 ITEM_ID/DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수  |  | 7 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0058 | C3 | NICK_NAME / Nick Name | 하네스·환경 | C3 도구 오류 — 실측[T-2d8f0960]: NICK_NAME: 원천 ITEM_ID/DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 |  | 7 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0059 | C3 | PART_LEADER / Part Leader | 하네스·환경 | C3 도구 오류 — 실측[T-e99ff7f8]: PART_LEADER 연쇄 원천 컬럼 해석 불가 — AS-IS InitSpread:163 siMain.ActiveSheet.Columns[DefColumns.PART_LEADER].Ce |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0060 | C3 | R15 ComboSelChange 가드(행0) | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 R15 ComboSelChange 가드(행0) 'cs:674' 의 C3 19요소: ERROR:16 · PASS:3 |  | 1 (R15 ComboSelChange 가드(행0)) |
| WK-SSP0025-0061 | C3 | SSP0025_ShipmentRequestorPIC.CboDivision | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0025_ShipmentRequestorPIC.CboDivision_SelectedIndexChanged 의 C3 19요소: ERROR:16 · PASS:3 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.CboDivi) |
| WK-SSP0025-0062 | C3 | SSP0025_ShipmentRequestorPIC.SetChangedC | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0025_ShipmentRequestorPIC.SetChangedControl 의 C3 19요소: ERROR:16 · PASS:3 |  | 0 () |
| WK-SSP0025-0063 | C3 | TEAM_LEADER / Team Leader | 하네스·환경 | C3 도구 오류 — 실측[T-8a6cec2b]: TEAM_LEADER 연쇄 원천 컬럼 해석 불가 — AS-IS InitSpread:164 siMain.ActiveSheet.Columns[DefColumns.TEAM_LEADER].Ce |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0064 | C3 | TO_DIVISION_ID | 하네스·환경 | C3 도구 오류 — 실측[T-f87a7b09]: 팝업 내부 그리드 컬럼 TO_DIVISION_ID — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0065 | C3 | TO_SITE / Plant Site Code | 하네스·환경 | C3 도구 오류 — 원장 V-ecb624d9 ASIS / 실측[T-f359f383]: TO_SITE: 원천 SITE_DESCRIPTION/DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 |  | 8 (R13 SITE→TO_SITE 파생 ACT:SSP0025_ItembyDi) |
| WK-SSP0025-0066 | C3 | TO_SITE_CODE | 하네스·환경 | C3 도구 오류 — 실측[T-9ad7a48c]: 팝업 내부 그리드 컬럼 TO_SITE_CODE — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0067 | C3 | UOM_CONVERT_IN_TACT_TIME | 하네스·환경 | C3 도구 오류 — 실측[T-20fa3d5e]: 팝업 내부 그리드 컬럼 UOM_CONVERT_IN_TACT_TIME — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작 |  | 4 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0068 | C3 | USER_ID / User ID | 하네스·환경 | C3 도구 오류 — 실측[T-e0bf6c87]: USER_ID 연쇄 원천 컬럼 해석 불가 — AS-IS InitSpread:162 siMain.ActiveSheet.Columns[DefColumns.USER_ID].CellType = |  | 6 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0069 | C3 | VALID_YN / Valid | 하네스·환경 | C3 도구 오류 — 실측[T-dc3570a1]: VALID_YN 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRow:327 siMain.SetValue(insCell, siMain.GetColumnIndex(DefColumns |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InsertR) |
| WK-SSP0025-0070 | B4 | SITE_DESCRIPTION / Plant Site | 하네스·환경 | B4 도구 오류 — 원장 V-ae7a62f7 COLUMN |  | 4 (셀 SITE_DESCRIPTION COMMON:UC-05 ACT:SSP0) |
| WK-SSP0025-0071 | B4 | SSP0025_ItembyDivisionPopup | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 SSP0025_ItembyDivisionPopup 'ITEM/MODEL/CELL' 의 B4 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (SSP0025_ItembyDivisionPopup) |
| WK-SSP0025-0072 | B4 | SSP0025_ShipmentRequestorPIC.GetSSPUserC | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0025_ShipmentRequestorPIC.GetSSPUserCheck 의 B4 6요소: PASS:4 · ERROR:1 · NA:1 |  | 9 (ACT:SSP0025_ShipmentRequestorPIC.GetSSPU) |
| WK-SSP0025-0073 | B4 | UserInfoPopup(User/Part/Team) | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 UserInfoPopup(User/Part/Team) 'cs:543~609' 의 B4 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (UserInfoPopup(User/Part/Team)) |
| WK-SSP0025-0074 | K4 | SSP0025 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-9f3f7084 GENERAL / 원장 V-d9a44084 GENERAL / 원장 V-c21e581a GENERAL / 원장 V-e1dd31aa GENERAL / 원장 V-4a6c9369 GENERAL / |  | 35 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SSP0025-0075 | F1 | SSP0025 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-ba998255 RULE_SCREEN / 원장 V-b43554df RULE_SCREEN / 원장 V-9c07278c RULE_SCREEN / 원장 V-90ec46a6 RULE_SCREEN / 원장 V-96 |  | 69 (EditButton(SwitchLock) + GetSSPUserCheck) |
| WK-SSP0025-0076 | F5 | SSP0025 화면 | 하네스·환경 | F5 도구 오류 — 원장 V-73ae37f0 RULE_SCREEN / 원장 V-4e526a5c RULE_SCREEN / 원장 V-c336a170 RULE_SCREEN / 원장 V-5286bad7 DEFECT / 원장 V-23b367d |  | 5 (DeleteButton(action='I'만 제거) R19 삭제=신규행만) |
| WK-SSP0025-0077 | F6 | SSP0025 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-dd950e13 RULE_SCREEN / 원장 V-f3cc9d32 RULE_SCREEN / 원장 V-4c938596 RULE_SCREEN / 원장 V-540c3524 RULE_SCREEN / 원장 V-9c |  | 60 (SaveButton → SaveData ACT:SSP0025_Shipme) |
| WK-SSP0025-0078 | F4 | FindButton → FindData_Main | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 FindButton → FindData_Main 'cs:185,249~284' 의 F4 5요소: ERROR:3 · PASS:2 |  | 1 (FindButton → FindData_Main) |
| WK-SSP0025-0079 | F4 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | 하네스·환경 | F4 도구 오류 — 실측[T-bb1efc47]: PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST: SSP0015/main/USER_CHECK, SSP0021/main/USER_CHECK, SSP0022/mai |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.GetSSPU) |
| WK-SSP0025-0080 | F4 | PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISI | 하네스·환경 | F4 도구 오류 — 실측[T-af568c38]: PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP: SSP0025/popup/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경 |  | 35 (ACT:SSP0025_ItembyDivisionPopup.FindButt) |
| WK-SSP0025-0081 | F4 | PKG_SSP0025.P_SSP0025_GET_USER_ID_CHECK | 하네스·환경 | F4 도구 오류 — 실측[T-a5c0ca3b]: PKG_SSP0025.P_SSP0025_GET_USER_ID_CHECK: SSP0025/main/USER_CHECK — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 |  | 59 (ACT:SSP0025_ShipmentRequestorPIC.GetUser) |
| WK-SSP0025-0082 | F4 | SaveButton → SaveData | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 SaveButton → SaveData 'cs:382~422' 의 F4 5요소: ERROR:3 · PASS:2 |  | 1 (SaveButton → SaveData) |
| WK-SSP0025-0083 | A5 | DIVISION_NAME | 하네스·환경 | A5 도구 오류 — 실측[T-b3c921d5]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 3 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0084 | A5 | FROM_SITE | 하네스·환경 | A5 도구 오류 — 실측[T-7d9516c3]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0085 | A5 | FROM_SITE_CODE | 하네스·환경 | A5 도구 오류 — 실측[T-29a79bed]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0086 | A5 | ITEM_UOM | 하네스·환경 | A5 도구 오류 — 실측[T-df75dc7f]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0087 | A5 | SSP0025_ShipmentRequestorPIC.CreateSprea | 하네스·환경 | A5 도구 오류 — 실측[T-fa5a8c94]: AS-IS 기본 표시 컬럼 4 ⊆ TO-BE 그리드 18: 누락 CELL_TYPE (AS-IS 숨김·코드추가 helper 컬럼은 비교 제외: ELECTRODE_TYPE, ITEM_ID, |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.CreateS) |
| WK-SSP0025-0088 | A5 | UOM_CONVERT_IN_TACT_TIME | 하네스·환경 | A5 도구 오류 — 실측[T-ee2f3a05]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0089 | H10 | SSP0025 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 7 (GetUserIDChk(USER_ID_CHECK) COMMON:UC-01) |
| WK-SSP0025-0090 | H2 | COMMON:UC-02 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 H2 14요소: PASS:8 · ERROR:5 · NA:1 |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0091 | H2 | COMMON:UC-07 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H2 14요소: PASS:8 · ERROR:5 · NA:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0025-0092 | H2 | DIVISION_NAME | 하네스·환경 | H2 도구 오류 — 실측[T-daf110ec]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 3 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0093 | H2 | FROM_SITE | 하네스·환경 | H2 도구 오류 — 실측[T-356f23eb]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0094 | H2 | FROM_SITE_CODE | 하네스·환경 | H2 도구 오류 — 실측[T-d9bed674]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0095 | H2 | ITEM_UOM | 하네스·환경 | H2 도구 오류 — 실측[T-6873de91]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0096 | H2 | SSP0025_ShipmentRequestorPIC.CreateSprea | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SSP0025_ShipmentRequestorPIC.CreateSpread 의 H2 14요소: PASS:8 · ERROR:5 · NA:1 |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.CreateS) |
| WK-SSP0025-0097 | H2 | UOM_CONVERT_IN_TACT_TIME | 하네스·환경 | H2 도구 오류 — 실측[T-998419bc]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0098 | H2 | spdMain(FpSpread) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 spdMain(FpSpread) 'designer:539' 의 H2 14요소: PASS:8 · ERROR:5 · NA:1 |  | 1 (spdMain(FpSpread)) |
| WK-SSP0025-0099 | H4 | SSP0025 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-b01e8dcb RULE_SCREEN / 원장 V-a3d87de2 RULE_SCREEN / 원장 V-1df9d782 RULE_SCREEN / 원장 V-1aed9ee4 RULE_SCREEN / 원장 V-54 |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0100 | H5 | COMMON:UC-02 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 H5 14요소: PASS:8 · ERROR:5 · NA:1 |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0101 | H5 | COMMON:UC-07 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H5 14요소: PASS:8 · ERROR:5 · NA:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0025-0102 | H5 | DIVISION_NAME | 하네스·환경 | H5 도구 오류 — 실측[T-e3cb3185]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 3 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0103 | H5 | FROM_SITE | 하네스·환경 | H5 도구 오류 — 실측[T-af5a1c51]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0104 | H5 | FROM_SITE_CODE | 하네스·환경 | H5 도구 오류 — 실측[T-8f1d4fdf]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0105 | H5 | ITEM_UOM | 하네스·환경 | H5 도구 오류 — 실측[T-87880d1e]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0106 | H5 | SSP0025_ShipmentRequestorPIC.CreateSprea | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0025_ShipmentRequestorPIC.CreateSpread 의 H5 14요소: PASS:8 · ERROR:5 · NA:1 |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.CreateS) |
| WK-SSP0025-0107 | H5 | UOM_CONVERT_IN_TACT_TIME | 하네스·환경 | H5 도구 오류 — 실측[T-fdc5f194]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0108 | H5 | spdMain(FpSpread) | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 spdMain(FpSpread) 'designer:539' 의 H5 14요소: PASS:8 · ERROR:5 · NA:1 |  | 1 (spdMain(FpSpread)) |
| WK-SSP0025-0109 | I1 | SSP0025 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-3dc94623 RULE_SCREEN / 원장 V-839c3d56 RULE_SCREEN / 원장 V-257af710 RULE_SCREEN / 원장 V-386830bd DEFECT / 원장 V-167deba |  | 9 (GetUserIDChk(USER_ID_CHECK) COMMON:UC-02) |
| WK-SSP0025-0110 | D4 | COMMON:UC-01 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (ke' 의 D4 2요소: PASS:1 · ERROR:1 |  | 1 (COMMON:UC-01) |
| WK-SSP0025-0111 | D4 | VALID_YN / Valid | 하네스·환경 | D4 도구 오류 — 실측[T-5794b79e]: 신규행 VALID_YN='Y' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움: 의도 확인(연쇄 C3/팝업 M4 결과일 수  |  | 2 (InsertButton(IsLock=false 가드) R7 신규행 VAL) |
| WK-SSP0025-0112 | D5 | DIVISION_NAME | 하네스·환경 | D5 도구 오류 — 실측[T-3e56f5ca]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 3 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0113 | D5 | FROM_SITE | 하네스·환경 | D5 도구 오류 — 실측[T-ef58e396]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0114 | D5 | FROM_SITE_CODE | 하네스·환경 | D5 도구 오류 — 실측[T-e075e686]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0115 | D5 | ITEM_UOM | 하네스·환경 | D5 도구 오류 — 실측[T-b092ae27]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0116 | D5 | SSP0025_ShipmentRequestorPIC.CreateSprea | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 SSP0025_ShipmentRequestorPIC.CreateSpread 의 D5 16요소: PASS:9 · ERROR:5 · NA:2 |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.CreateS) |
| WK-SSP0025-0117 | D5 | UOM_CONVERT_IN_TACT_TIME | 하네스·환경 | D5 도구 오류 — 실측[T-646e890c]: [검사기 미검증] ITEM_ID 더블클릭 → 팝업 열림 감지 실패(H6) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0118 | E4 | DIVISION_ID / Division | 하네스·환경 | E4 도구 오류 — 원장 V-bab460f9 ASIS / 실측[T-922a5a83]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Sp |  | 7 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0119 | E4 | ITEM_ID / Material | 하네스·환경 | E4 도구 오류 — 원장 V-2eead347 ASIS / 실측[T-01446a71]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Sp |  | 4 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0120 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-bab460f9 / 실측[T-b3d05bd1]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0121 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-bab460f9 ASIS / 원장 V-2eead347 ASIS / 실측[T-4f8019e7]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿 |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0122 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-2eead347 / 실측[T-50d60adf]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0123 | A6 | FindButton → FindData_Main | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 FindButton → FindData_Main 'cs:185,249~284' 의 A6 2요소: ERROR:1 · PASS:1 |  | 1 (FindButton → FindData_Main) |
| WK-SSP0025-0124 | A6 | PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISI | 하네스·환경 | A6 도구 오류 — 원장 V-d4de13d9 SP / 정렬대조 PASS AS-IS 키 뒤에 동률 고정 키 추가 ['SEGMENT5', 'ATTRIBUTE1'] — / 실측[T-df3a1ffd]: PKG_SSP0025.P_SSP0025 |  | 35 (ACT:SSP0025_ItembyDivisionPopup.FindButt) |
| WK-SSP0025-0125 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS:2 (미실행 요 |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0126 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS:2 (미실행 요소가 남아 판정 |  | 1 (COMMON:UC-06) |
| WK-SSP0025-0127 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS:2 (미실행 요 |  | 1 (COMMON:UC-07) |
| WK-SSP0025-0128 | G1 | CboDivision_SelectedIndexChanged → SetCh | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 CboDivision_SelectedIndexChanged → SetChangedControl 'cs:699~702,137~142' 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS: |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SSP0025-0129 | G1 | FindButton → FindData_Main | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FindButton → FindData_Main 'cs:185,249~284' 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (FindButton → FindData_Main) |
| WK-SSP0025-0130 | G1 | R11 신규행 SITE 재조회 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 R11 신규행 SITE 재조회 'cs:637~641' 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (R11 신규행 SITE 재조회) |
| WK-SSP0025-0131 | G1 | checkRequiredOfSearch(Division 필수) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 checkRequiredOfSearch(Division 필수) 'cs:249' 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSearch(Division 필수)) |
| WK-SSP0025-0132 | G6 | clbDivisionId / Division / Division Id | 하네스·환경 | G6 도구 오류 — 실측[T-2b783bf5]: 공용 팝업 내부 조건(clbDivisionId) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0133 | G6 | clbFromSiteId / From Site / From Site Id | 하네스·환경 | G6 도구 오류 — 실측[T-e7dde00c]: 공용 팝업 내부 조건(clbFromSiteId) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0134 | G6 | txtItemId / Material / Item Id | 하네스·환경 | G6 도구 오류 — 실측[T-87b20f01]: 공용 팝업 내부 조건(txtItemId) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0135 | G6 | txtModelId / Model / Model Id / Model/Ni | 하네스·환경 | G6 도구 오류 — 실측[T-05065318]: 공용 팝업 내부 조건(txtModelId) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0136 | X-ROW | SSP0025_ItembyDivisionPopup..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOPATH:1 · ERROR:1 |  | 2 (ACT:SSP0025_ItembyDivisionPopup..ctor:16) |
| WK-SSP0025-0137 | X-ROW | SSP0025_ItembyDivisionPopup.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:SSP0025_ItembyDivisionPopup.CreateSp) |
| WK-SSP0025-0138 | X-ROW | SSP0025_ItembyDivisionPopup.DefineProper | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:1 · PASS:1 |  | 2 (ACT:SSP0025_ItembyDivisionPopup.DefinePr) |
| WK-SSP0025-0139 | X-ROW | SSP0025_ItembyDivisionPopup.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:SSP0025_ItembyDivisionPopup.Dispose:) |
| WK-SSP0025-0140 | X-ROW | SSP0025_ItembyDivisionPopup.FindButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:3 · REVIEW:1 |  | 2 (ACT:SSP0025_ItembyDivisionPopup.FindButt) |
| WK-SSP0025-0141 | X-ROW | SSP0025_ItembyDivisionPopup.FindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:3 · NA:3 · NOT_RUN:2 · PASS:2 · REVIEW:1 |  | 32 (ACT:SSP0025_ItembyDivisionPopup.FindData) |
| WK-SSP0025-0142 | X-ROW | SSP0025_ItembyDivisionPopup.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 13 (ACT:SSP0025_ItembyDivisionPopup.Form_Loa) |
| WK-SSP0025-0143 | X-ROW | SSP0025_ItembyDivisionPopup.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:7 · PASS:5 |  | 14 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0144 | X-ROW | SSP0025_ItembyDivisionPopup.SetMaterial | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 27검사 — ERROR:15 · NA:11 · PASS:1 |  | 49 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0145 | X-ROW | SSP0025_ItembyDivisionPopup.btnButtonLis | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:2 · PASS:1 |  | 8 (ACT:SSP0025_ItembyDivisionPopup.btnButto) |
| WK-SSP0025-0146 | X-ROW | SSP0025_ItembyDivisionPopup.clbDivision_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:4 · PASS:1 |  | 5 (ACT:SSP0025_ItembyDivisionPopup.clbDivis) |
| WK-SSP0025-0147 | X-ROW | SSP0025_ItembyDivisionPopup.spdMain_Cell | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — PASS:1 · NA:1 · NOT_RUN:1 · ERROR:1 |  | 2 (ACT:SSP0025_ItembyDivisionPopup.spdMain_) |
| WK-SSP0025-0148 | X-ROW | SSP0025_ShipmentRequestorPIC.CboDivision | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.CboDivi) |
| WK-SSP0025-0149 | X-ROW | SSP0025_ShipmentRequestorPIC.CreateSprea | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · ERROR:1 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.CreateS) |
| WK-SSP0025-0150 | X-ROW | SSP0025_ShipmentRequestorPIC.GetSSPUserC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOPATH:2 · PASS:2 · ERROR:1 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.GetSSPU) |
| WK-SSP0025-0151 | X-ROW | SSP0025_ShipmentRequestorPIC.InitControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — PASS:4 · ERROR:1 |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitCon) |
| WK-SSP0025-0152 | X-ROW | SSP0025_ShipmentRequestorPIC.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — PASS:13 · ERROR:3 |  | 5 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0153 | X-ROW | SSP0025_ShipmentRequestorPIC.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 33검사 — PASS:27 · ERROR:4 · NA:2 |  | 14 (ACT:SSP0025_ShipmentRequestorPIC.InsertR) |
| WK-SSP0025-0154 | X-ROW | SSP0025_ShipmentRequestorPIC.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — PASS:12 · ERROR:4 |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.SaveDat) |
| WK-SSP0025-0155 | X-ROW | SSP0025_ShipmentRequestorPIC.SetChangedC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:3 · NOT_RUN:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.SetChan) |
| WK-SSP0025-0156 | X-ROW | SSP0025_ShipmentRequestorPIC.SetImageCel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — PASS:4 · NA:1 · ERROR:1 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SetImag) |
| WK-SSP0025-0157 | X-ROW | SSP0025_ShipmentRequestorPIC.SpdMain_Cel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 25검사 — ERROR:13 · PASS:7 · NA:5 |  | 29 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0158 | X-ROW | SSP0025_ShipmentRequestorPIC.SpdMain_Cel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 33검사 — PASS:18 · ERROR:13 · NA:2 |  | 21 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0159 | X-ROW | SSP0025_ShipmentRequestorPIC.SpdMain_Com | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 36검사 — PASS:21 · ERROR:15 |  | 8 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0160 | X-ROW | SSP0025_ShipmentRequestorPIC.SpdMain_Top | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0161 | X-ROW | SSP0025_ShipmentRequestorPIC.btnItemId_C | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — PASS:5 · NA:4 · ERROR:2 |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.btnItem) |
| WK-SSP0025-0162 | X-ROW | SSP0025_ShipmentRequestorPIC.btnModelId_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — PASS:5 · NA:4 · ERROR:2 |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.btnMode) |
| WK-SSP0025-0163 | G5 | PART_LEADER / Part Leader | 하네스·환경 | G5 도구 오류 — 원장 V-e2351522 ASIS / 원장 V-08867d13 ASIS |  | 13 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0164 | G5 | R21 이미지셀 아이콘 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 R21 이미지셀 아이콘 'cs:162~164,347~353' 의 G5 25요소: NA:12 · ERROR:9 · NOPATH:4 |  | 1 (R21 이미지셀 아이콘) |
| WK-SSP0025-0165 | G5 | SSP0025_ShipmentRequestorPIC.SpdMain_Cel | 하네스·환경 | G5 도구 오류 — 원장 V-5c37ddd5 ASIS / 원장 V-461cb007 ASIS / 원장 V-e2351522 ASIS / 원장 V-08867d13 ASIS / 원장 V-af0e1aba ASIS / 원장 V-ef920f34  |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0166 | G5 | TEAM_LEADER / Team Leader | 하네스·환경 | G5 도구 오류 — 원장 V-af0e1aba ASIS / 원장 V-ef920f34 ASIS |  | 13 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0167 | G5 | USER_ID / User ID | 하네스·환경 | G5 도구 오류 — 원장 V-5c37ddd5 ASIS / 원장 V-461cb007 ASIS |  | 14 (R16 USER_ID 더블클릭 팝업 ACT:SSP0025_Shipment) |
| WK-SSP0025-0168 | G5 | UserInfoPopup(User/Part/Team) | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 UserInfoPopup(User/Part/Team) 'cs:543~609' 의 G5 25요소: NA:12 · ERROR:9 · NOPATH:4 |  | 1 (UserInfoPopup(User/Part/Team)) |
| WK-SSP0025-0169 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-5c37ddd5 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0170 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-e2351522 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0171 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-af0e1aba |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0172 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-461cb007 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0173 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-08867d13 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0174 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-ef920f34 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0175 | M3 | SSP0025_ItembyDivisionPopup | 하네스·환경 | M3 도구 오류 — 원장 V-8124024d ASIS / 원장 V-12729d68 ASIS / 원장 V-b1dad668 ASIS / 실측[T-e45b5051]: 팝업을 여는 트리거 셀을 화면 메타에서 찾지 못함 — 팝업 내부 기능 검 |  | 13 (ACT:SSP0025_ItembyDivisionPopup..ctor AC) |
| WK-SSP0025-0176 | M3 | new SSP0025_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-8124024d |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0177 | M3 | new SSP0025_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-12729d68 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.btnItem) |
| WK-SSP0025-0178 | M3 | new SSP0025_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-b1dad668 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.btnMode) |
