# 작업 원장 — SCP0033 · 2026-11-14 12:10

> 검사 인스턴스 445건 중 PASS·NA 363건 외 **82건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 6 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 31 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 44 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 44 · 사람 판정 / AS-IS 원문 확인 → 재판정 29 · 하네스 6 · 대조표 2 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A1 | GEN |  |  |  |  |  |  | 17 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| H6 | POPUP |  |  |  |  | 2 | 1 |  |  | 9 | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  |  | 10 |  |  | 팝업 선택값 반영 |
| D4 | EDIT |  |  |  |  |  |  |  |  | 10 | 신규행 기본값·자동세팅·Insert 전제 |
| X-ROW | GEN |  |  |  |  |  |  | 1 |  | 5 | 대조표 행이 서술한 동작을 화면에서 재현 |
| G5 | POPUP |  |  |  |  | 3 |  |  |  |  | 팝업 조건 연동(인자) |
| F4 | DB |  |  |  |  |  |  |  |  | 3 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E4 | EDIT |  |  |  |  |  |  |  |  | 3 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-REASON | DESIGN |  |  |  |  |  |  | 2 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A6 | GEN |  |  |  |  |  |  | 1 |  | 1 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 2 | 연쇄 자동 채움 |
| B4 | COMBO |  |  |  |  |  |  |  |  | 2 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| B3 | COMBO |  |  |  |  |  |  |  |  | 1 | 콤보 후보 정렬 = AS-IS |
| K-SA | COMMON |  |  |  |  |  |  |  |  | 1 | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  |  |  |  | 1 | CRUD Status 표시 정합 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| M3 | POPUP |  |  |  |  |  |  |  |  | 1 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |

## W5 검사기 연결 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0033-0001 | G03-WIRE | SCP0033 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0033 화면 | 판단불가(대상 단위 SCREEN) | 7 (ACT:SCP0033_Shipment_semi_dept_day..ctor) |
| WK-SCP0033-0002 | G5 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 2 (D00-2-001 GetAllDivisionCheckedElectrode) |
| WK-SCP0033-0003 | G5 | NICK_NAME / Nick Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL NICK_NAME / Nick Name | 있음(SHEET_COLUMNS) | 3 (D00-3-017 MODAL:ModelByDivisionPopup 16,) |
| WK-SCP0033-0004 | G5 | clbDivision / Division / Div / Div. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbDivision / Division / Div / Div. | 있음(FE 소스) | 1 (GetAllDivisionCheckedElectrode(clbDivisi) |
| WK-SCP0033-0005 | H6 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 2 (D00-2-001 GetAllDivisionCheckedElectrode) |
| WK-SCP0033-0006 | H6 | NICK_NAME / Nick Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME / Nick Name | 있음(SHEET_COLUMNS) | 3 (D00-3-017 MODAL:ModelByDivisionPopup 16,) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0033-0007 | H6 | clbDivision / Division / Div / Div. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivision / Division / Div / Div. · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (GetAllDivisionCheckedElectrode(clbDivisi) |

## W7 기대값 확정 (31)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0033-0008 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)  이 화면의 유일한 key-in 조회조건은 Model(ITEM_ID)인데 GET SP 계약이 단일  |  | 1 (COMMON:UC-06) |
| WK-SCP0033-0009 | X-REASON | D00-3-003 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-003 §3 VisibleTab / (true)  FpSpread 시트 탭 가시성 API. TO-BE 는 시트 탭 개념이 없는 단일 공용 DataGrid 라 대응 호출이 성립하지 않는다(그 |  | 1 (D00-3-003) |
| WK-SCP0033-0010 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — 대조표 1 'GMessageBoxForException' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: EDIT_SET — 골든 비교 케이스 없음(EDIT_SET — 팝업 |  | 1 (1) |
| WK-SCP0033-0011 | A1 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 15: 행 집계 — 대조표 15 'LockColumn(0, max, true) 조회 후 전잠금' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: EDIT_SET — 골든 비교 케이스 없음(E |  | 1 (15) |
| WK-SCP0033-0012 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — 대조표 2 'MSG00059' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: EDIT_SET — 골든 비교 케이스 없음(EDIT_SET — 팝업·보조 SP 는 golden |  | 1 (2) |
| WK-SCP0033-0013 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A1 3요소: REVIEW:2 · PASS:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0033-0014 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 3요소: REVIEW:2 · PASS:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0033-0015 | A1 | D00-1-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-002: 행 집계 — 대조표 D00-1-002 '§1 txtItemId / TextBox' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: EDIT_SET — 골든 비교 케이스 없 |  | 1 (D00-1-002) |
| WK-SCP0033-0016 | A1 | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-011: 행 집계 — 대조표 D00-1-011 '§1 usrLayoutControl2 / UsrLayoutControl' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: EDIT_ |  | 1 (D00-1-011) |
| WK-SCP0033-0017 | A1 | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-014: 행 집계 — 대조표 D00-3-014 '§3 Query / (ds) 조회결과 바인딩' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: EDIT_SET — 골든 비교 케이스 |  | 1 (D00-3-014) |
| WK-SCP0033-0018 | A1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-001: 행 집계 — 대조표 D00-4b-001 '§4b BLUtils.GetDivision / (false) / dtMyDivision' 의 A1 3요소: REVIEW:2 · PASS:1 · FAI |  | 1 (D00-4b-001) |
| WK-SCP0033-0019 | A1 | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-003: 행 집계 — 대조표 D00-4b-003 '§4b Data.Common / YesOrNo / dtYesOrNo' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: EDIT_ |  | 1 (D00-4b-003) |
| WK-SCP0033-0020 | A1 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4e-001: 행 집계 — 대조표 D00-4e-001 '§4e GMessageBoxForException / (FindData_Main catch' 의 A1 3요소: REVIEW:2 · PASS:1 · F |  | 1 (D00-4e-001) |
| WK-SCP0033-0021 | A1 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4e-002: 행 집계 — 대조표 D00-4e-002 '§4e MSG00059 / `RowCount <= 0`' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: EDIT_SET — 골 |  | 1 (D00-4e-002) |
| WK-SCP0033-0022 | A1 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4e-003: 행 집계 — 대조표 D00-4e-003 '§4e MSG00004 / `Rows[0][0]=="S"`' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: EDIT_SET — |  | 1 (D00-4e-003) |
| WK-SCP0033-0023 | A1 | EDIT_SET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — EDIT_SET: 골든 비교 케이스 없음(EDIT_SET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D00-3-012) |
| WK-SCP0033-0024 | A1 | FindButton/SaveButton/DeleteButton/Inser | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton/SaveButton/DeleteButton/InsertButton: 행 집계 — 대조표 FindButton/SaveButton/DeleteButton/InsertButton 'hotkeyCon |  | 1 (FindButton/SaveButton/DeleteButton/Inser) |
| WK-SCP0033-0025 | A1 | MODAL:MaterialByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MODAL:MaterialByDivisionModal: 행 집계 — 대조표 MODAL:MaterialByDivisionModal '조회조건 Model 팝업 (COM0013 — AS-IS 에 없는 TO-BE 추가) |  | 1 (MODAL:MaterialByDivisionModal) |
| WK-SCP0033-0026 | A1 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 2 (MODAL:ModelByDivisionPopup SCM0002_Itemb) |
| WK-SCP0033-0027 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 검증 엔진이 실행됐으나 이 대상(SP PKG_SCM0002.P_SCM0002_GET_ITEM)을 판정하지 못함 — 결과 행 |  | 2 (MODAL:ModelByDivisionPopup SCM0002_Itemb) |
| WK-SCP0033-0028 | X-ROW | SCP0033_Shipment_semi_dept_day.SpdMain_K | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.SpdMain_KeyPress: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/RETURN/UI_PROP, 연결된 요소 |  | 5 (ACT:SCP0033_Shipment_semi_dept_day.SpdMa) |
| WK-SCP0033-0029 | M4 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-005: 행 집계 — 대조표 D00-4d-005 '§4d SpdMain_CellClick / (CellClick)' 의 M4 5요소: REVIEW:3 · NOT_RUN:2 · FAIL 요소: DIVI |  | 1 (D00-4d-005) |
| WK-SCP0033-0030 | M4 | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-007: 행 집계 — 대조표 D00-4d-007 '§4d SpdMain_CellClick / (CellClick)' 의 M4 5요소: REVIEW:3 · NOT_RUN:2 · FAIL 요소: DIVI |  | 1 (D00-4d-007) |
| WK-SCP0033-0031 | M4 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-008: 행 집계 — 대조표 D00-4d-008 '§4d SpdMain_CellClick / (CellClick)' 의 M4 5요소: REVIEW:3 · NOT_RUN:2 · FAIL 요소: DIVI |  | 1 (D00-4d-008) |
| WK-SCP0033-0032 | M4 | DIVISION_ID / Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DIVISION_ID / Division: 실측[T-8968351c]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] ITEM_ID 더블클릭 → Di |  | 2 (D00-2-001 GetAllDivisionCheckedElectrode) |
| WK-SCP0033-0033 | M4 | ITEM_ID / Model | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ITEM_ID / Model: 실측[T-a0be1b20]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] ITEM_ID: ITEM_ID 더블클릭 →  |  | 7 (D00-2-002 D00-3-016 D00-4d-003 MODAL:Mod) |
| WK-SCP0033-0034 | M4 | NICK_NAME / Nick Name | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — NICK_NAME / Nick Name: 실측[T-d56e9d9f]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] NICK_NAME: ITEM_ID |  | 3 (D00-3-017 MODAL:ModelByDivisionPopup 16,) |
| WK-SCP0033-0035 | M4 | SCM0002_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCM0002_ItembyDivisionPopup: 행 집계 — 대조표 SCM0002_ItembyDivisionPopup '공용 ModelByDivisionPopup (SHEETS.POPUP) -> PKG_SCM |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0033-0036 | M4 | clbDivision / Division / Div / Div. | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbDivision / Division / Div / Div.: 검증 엔진이 실행됐으나 이 대상(COND clbDivision)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (GetAllDivisionCheckedElectrode(clbDivisi) |
| WK-SCP0033-0037 | M4 | prg (ProgressForm) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — prg (ProgressForm): 행 집계 — 대조표 prg (ProgressForm) '공용 로딩(useTabProcQuery isFetching / ProgressIndicat' 의 M4 5요소: REVIE |  | 1 (prg (ProgressForm)) |
| WK-SCP0033-0038 | M4 | txtItemId / Model / Item Id / Model/Nick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtItemId / Model / Item Id / Model/Nickname / Nic: 검증 엔진이 실행됐으나 이 대상(COND txtItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인  |  | 2 (D00-1-002 txtItemId (TextBox, "Model")) |

## W9 도구 오류 (44)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0033-0039 | J2 | SCP0033 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-a211142c RULE_SCREEN / 원장 V-5e3332b7 DEFECT / 원장 V-a4c5f716 GENERAL / 원장 V-9f1f9955 GENERAL / 원장 V-7b6ecab9 GENERA |  | 39 (D00-1-002 D00-1-011 D00-2-002 D00-3-004 ) |
| WK-SCP0033-0040 | C3 | ITEM_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-88bbfcba]: ITEM_ID 연쇄 원천 컬럼 해석 불가 — AS-IS SpdMain_CellClick:487 siMain.SetValue(e.Row, siMain.GetColumnIndex(DefCo |  | 3 (D00-3-016 ACT:SCP0033_Shipment_semi_dept) |
| WK-SCP0033-0041 | C3 | NICK_NAME / Nick Name | 하네스·환경 | C3 도구 오류 — 실측[T-03acca5b]: NICK_NAME: 원천 ITEM_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7 |  | 2 (D00-3-017 ACT:SCP0033_Shipment_semi_dept) |
| WK-SCP0033-0042 | B3 | DIVISION_ID / Division | 하네스·환경 | B3 도구 오류 — 원장 V-4c0a9b39 COLUMN |  | 1 (D00-4b-001) |
| WK-SCP0033-0043 | B4 | DEPARTURE_DAY / Departure day | 하네스·환경 | B4 도구 오류 — 원장 V-5360185f COLUMN |  | 2 (D00-4b-002 COMMON:UC-05) |
| WK-SCP0033-0044 | B4 | OPERATION_GROUP / Operation Group | 하네스·환경 | B4 도구 오류 — 원장 V-b29aa9f5 COLUMN |  | 1 (COMMON:UC-05) |
| WK-SCP0033-0045 | K-SA | SCP0033 화면 | 하네스·환경 | K-SA 도구 오류 — E2E smoke common Search Area 조회영역 토글 |  | 3 (D00-1-004 COMMON:UC-02 usrConditionPanel) |
| WK-SCP0033-0046 | K4 | SCP0033 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-764125f0 GENERAL / 원장 V-7474c8df GENERAL / 원장 V-cd9cc329 GENERAL / 원장 V-10a43ee0 GENERAL / 원장 V-f4827e1b GENERAL / |  | 5 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0033-0047 | F1 | SCP0033 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-3f2d5e3d RULE_SCREEN / 원장 V-5cb058a3 RULE_SCREEN / 원장 V-64cb0621 RULE_SCREEN / 원장 V-702e31ac RULE_SCREEN / 원장 V-69 |  | 90 (D00-3-004 D00-3-005 D00-4d-001 D00-4e-00) |
| WK-SCP0033-0048 | F5 | SCP0033 화면 | 하네스·환경 | F5 도구 오류 — 원장 V-5aafccaa RULE_SCREEN / 원장 V-72f03c8e RULE_SCREEN / 원장 V-fb9f134d RULE_SCREEN / 원장 V-e38b57ce DEFECT / 원장 V-0cbe0ce |  | 9 (D00-3-004 D00-4d-001 SCP0033_SAVE_SHIPME) |
| WK-SCP0033-0049 | F6 | SCP0033 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-523e02e6 RULE_SCREEN / 원장 V-f35dab49 RULE_SCREEN / 원장 V-1be46155 RULE_SCREEN / 원장 V-04ac2d34 RULE_SCREEN / 원장 V-63 |  | 71 (D00-4e-005 SCP0033_SAVE_SHIPMENT_SEMI_DE) |
| WK-SCP0033-0050 | F4 | D00-4e-001 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 D00-4e-001 '§4e GMessageBoxForException / (FindData_Main catch' 의 F4 3요소: PASS:2 · ERROR:1 |  | 1 (D00-4e-001) |
| WK-SCP0033-0051 | F4 | D00-4e-005 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 D00-4e-005 '§4e GMessageBoxForException / (SaveData_Main catch' 의 F4 3요소: PASS:2 · ERROR:1 |  | 1 (D00-4e-005) |
| WK-SCP0033-0052 | F4 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 하네스·환경 | F4 도구 오류 — 실측[T-18b73288]: PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: SCM0002/ModelPopup/SEARCH, SCP0033/popup/SEARCH, SSP0 |  | 2 (MODAL:ModelByDivisionPopup SCM0002_Itemb) |
| WK-SCP0033-0053 | H4 | SCP0033 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-11ddb94b RULE_SCREEN / 원장 V-4694fba8 RULE_SCREEN / 원장 V-9d289e96 RULE_SCREEN / 원장 V-ea3cf446 RULE_SCREEN / 원장 V-26 |  | 7 (D00-2-003 D00-3-001 1,2 ACT:SCP0033_Ship) |
| WK-SCP0033-0054 | D4 | 2 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 2 'MSG00059' 의 D4 12요소: PASS:10 · ERROR:2 |  | 1 (2) |
| WK-SCP0033-0055 | D4 | 5 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 5 'GMessageBoxForException' 의 D4 12요소: PASS:10 · ERROR:2 |  | 0 () |
| WK-SCP0033-0056 | D4 | COMMON:UC-01 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (ke' 의 D4 12요소: PASS:10 · ERROR:2 |  | 1 (COMMON:UC-01) |
| WK-SCP0033-0057 | D4 | D00-1-002 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 D00-1-002 '§1 txtItemId / TextBox' 의 D4 12요소: PASS:10 · ERROR:2 |  | 1 (D00-1-002) |
| WK-SCP0033-0058 | D4 | D00-4e-002 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 D00-4e-002 '§4e MSG00059 / `RowCount <= 0`' 의 D4 12요소: PASS:10 · ERROR:2 |  | 1 (D00-4e-002) |
| WK-SCP0033-0059 | D4 | D00-4e-004 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 D00-4e-004 '§4e MSG00006 / else(비"S")' 의 D4 12요소: PASS:10 · ERROR:2 |  | 1 (D00-4e-004) |
| WK-SCP0033-0060 | D4 | FindButton/SaveButton/DeleteButton/Inser | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 FindButton/SaveButton/DeleteButton/InsertButton 'hotkeyConfig + hasButton' 의 D4 12요소: PASS:10 · ERROR:2 |  | 1 (FindButton/SaveButton/DeleteButton/Inser) |
| WK-SCP0033-0061 | D4 | VALID_YN / Valid | 하네스·환경 | D4 도구 오류 — 실측[T-dc9387dc]: 신규행 VALID_YN='Y' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움: 의도 확인(연쇄 C3/팝업 M4 결과일 수  |  | 4 (D00-3-005 D00-3-007 ACT:SCP0033_Shipment) |
| WK-SCP0033-0062 | D4 | siMain.SetValue | 하네스·환경 | D4 도구 오류 — 원장 V-ecc9555c |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.Inser) |
| WK-SCP0033-0063 | D4 | txtItemId (TextBox, "Model") | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 txtItemId (TextBox, "Model") 'Form Model `InputField`(prefix) + Material 팝업 버튼(C' 의 D4 12요소: PASS:10 · ERROR |  | 1 (txtItemId (TextBox, "Model")) |
| WK-SCP0033-0064 | E4 | ITEM_ID / Model | 하네스·환경 | E4 도구 오류 — 원장 V-0c8f3043 ASIS / 실측[T-1c355151]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Sp |  | 4 (D00-4e-007 6 — ACT:SCP0033_Shipment_semi) |
| WK-SCP0033-0065 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-0c8f3043 ASIS / 실측[T-2d6f3bd2]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Sp |  | 3 (D00-4e-006 6 ACT:SCP0033_Shipment_semi_d) |
| WK-SCP0033-0066 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-0c8f3043 / 실측[T-575ed269]: MSG00093 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.SpdMa) |
| WK-SCP0033-0067 | A6 | D00-4e-001 | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 D00-4e-001 '§4e GMessageBoxForException / (FindData_Main catch' 의 A6 2요소: NOT_RUN:1 · PASS:1 (미실행 요소가 남아 판정필 |  | 1 (D00-4e-001) |
| WK-SCP0033-0068 | X-ROW | SCP0033_Shipment_semi_dept_day.CreateSpr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.Creat) |
| WK-SCP0033-0069 | X-ROW | SCP0033_Shipment_semi_dept_day.InsertBut | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 24검사 — PASS:18 · NA:4 · ERROR:2 |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.Inser) |
| WK-SCP0033-0070 | X-ROW | SCP0033_Shipment_semi_dept_day.SaveData_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 17검사 — PASS:12 · NA:3 · ERROR:2 |  | 2 (ACT:SCP0033_Shipment_semi_dept_day.SaveD) |
| WK-SCP0033-0071 | X-ROW | SCP0033_Shipment_semi_dept_day.SpdMain_C | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — ERROR:10 · PASS:4 · NA:2 |  | 22 (ACT:SCP0033_Shipment_semi_dept_day.SpdMa) |
| WK-SCP0033-0072 | X-ROW | SCP0033_Shipment_semi_dept_day.SpdMain_T | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SCP0033_Shipment_semi_dept_day.SpdMa) |
| WK-SCP0033-0073 | H6 | D00-4d-005 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4d-005 '§4d SpdMain_CellClick / (CellClick)' 의 H6 8요소: ERROR:4 · NOPATH:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-4d-005) |
| WK-SCP0033-0074 | H6 | D00-4d-007 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4d-007 '§4d SpdMain_CellClick / (CellClick)' 의 H6 8요소: ERROR:4 · NOPATH:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-4d-007) |
| WK-SCP0033-0075 | H6 | D00-4d-008 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4d-008 '§4d SpdMain_CellClick / (CellClick)' 의 H6 8요소: ERROR:4 · NOPATH:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-4d-008) |
| WK-SCP0033-0076 | H6 | ITEM_ID / Model | 하네스·환경 | H6 도구 오류 — 원장 V-0e316d0e ASIS / 원장 V-83f3f141 ASIS / 원장 V-b4395b79 ASIS |  | 10 (D00-2-002 D00-3-016 D00-4d-003 MODAL:Mod) |
| WK-SCP0033-0077 | H6 | SCM0002_ItembyDivisionPopup | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 SCM0002_ItembyDivisionPopup '공용 ModelByDivisionPopup (SHEETS.POPUP) -> PKG_SCM0' 의 H6 8요소: ERROR:4 · NOPATH: |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0033-0078 | H6 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-0e316d0e |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.SpdMa) |
| WK-SCP0033-0079 | H6 | popItem.Form_Load(false, division, sScmS | 하네스·환경 | H6 도구 오류 — 원장 V-83f3f141 |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.SpdMa) |
| WK-SCP0033-0080 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-b4395b79 |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.SpdMa) |
| WK-SCP0033-0081 | H6 | prg (ProgressForm) | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 prg (ProgressForm) '공용 로딩(useTabProcQuery isFetching / ProgressIndicat' 의 H6 8요소: ERROR:4 · NOPATH:2 · PASS: |  | 1 (prg (ProgressForm)) |
| WK-SCP0033-0082 | M3 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-4454cc67 |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.SpdMa) |
