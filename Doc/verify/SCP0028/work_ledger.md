# 작업 원장 — SCP0028 · 2026-11-20 09:47

> 검사 인스턴스 393건 중 PASS·NA 277건 외 **116건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 7 | 재판정 PASS |
| W5 | 검사기 연결 | 7 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 2 | 실행 → PASS |
| W7 | 기대값 확정 | 28 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 72 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 72 · 사람 판정 / AS-IS 원문 확인 → 재판정 28 · 하네스 7 · 화면 FE 6 · E2E 2 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A1 | GEN |  |  |  |  |  |  | 19 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| H6 | POPUP |  |  |  |  | 1 | 2 | 1 |  | 13 | 팝업 표준·열림 |
| G5 | POPUP |  |  |  |  | 3 |  |  |  | 10 | 팝업 조건 연동(인자) |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 13 | 배경·글자색 규칙 |
| M4 | POPUP |  |  |  |  |  |  | 7 |  | 5 | 팝업 선택값 반영 |
| X-ROW | GEN |  |  | 3 |  |  |  |  |  | 8 | 대조표 행이 서술한 동작을 화면에서 재현 |
| G1 | GEN |  |  |  |  |  |  |  |  | 10 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| F4 | DB |  |  |  |  |  |  |  |  | 6 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  | 2 |  | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| E1 | EDIT |  |  | 2 |  |  |  |  |  |  | 숫자 소수자리·정수·부호·범위 |
| G4 | DESIGN |  |  |  |  |  |  |  |  | 2 | 조회조건 표시·라벨·활성 |
| E4 | EDIT |  |  |  |  |  |  |  |  | 2 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| M3 | POPUP |  |  |  |  |  |  |  |  | 2 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| J2 | AUTH |  |  | 1 |  |  |  |  |  |  | 권한별 버튼·기능 |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| DB-SYN | DB |  |  |  |  | 1 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0001 | J2 | SCP0028 화면 | DB(🛠️/🧯 적용 가능) | J2 FAIL 수정 — SCP0028 화면: 원장 V-9576f1ee RULE_SCREEN / 원장 V-77b7dac5 DEFECT / 원장 V-2cac90a6 GENERAL / 원장 V-d1efd124 GENERAL / 원장 V-c |  | 80 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0002 | F5 | SCP0028 화면 | 화면 FE(범위 밖(가이드만)) | F5 FAIL 수정 — SCP0028 화면: 원장 V-be29b7a4 RULE_SCREEN / 원장 V-564a1ac4 RULE_SCREEN / 원장 V-4b34e536 RULE_SCREEN / 원장 V-e1f702d7 DEFECT  |  | 16 (Delete() 신규행만 (cs:213~224, #3) **SAVE SP) |
| WK-SCP0028-0003 | E1 | INCREMENT / Increment | 화면 FE(범위 밖(가이드만)) | E1 FAIL 수정 — INCREMENT / Increment: 원장 V-597f4433 COLUMN / 실측[T-593d0c8b]: Insert 무동작 = AS-IS 파리티(실행 문장 없음) — 신규 행 없음이 정상 (FX-SCP0 |  | 1 (SetReNumerCellType(LOT_SIZE/INCREMENT,0)) |
| WK-SCP0028-0004 | E1 | LOT_SIZE / Lot Size | 화면 FE(범위 밖(가이드만)) | E1 FAIL 수정 — LOT_SIZE / Lot Size: 원장 V-6259d313 COLUMN / 실측[T-e7ce5e82]: Insert 무동작 = AS-IS 파리티(실행 문장 없음) — 신규 행 없음이 정상 (FX-SCP002 |  | 1 (SetReNumerCellType(LOT_SIZE/INCREMENT,0)) |
| WK-SCP0028-0005 | X-ROW | SCP0028_Shipment_Lot_Size.btnDelete_Clic | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.btnDelete_Click: 진입점 집계 9검사 — ERROR:5 · NA:2 · FAIL:1 · PASS:1 (FX-SCP0028-031) |  | 5 (ACT:SCP0028_Shipment_Lot_Size.btnDelete_) |
| WK-SCP0028-0006 | X-ROW | SCP0028_Shipment_Lot_Size.btnInput_Click | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.btnInput_Click: 진입점 집계 9검사 — ERROR:5 · NA:2 · FAIL:1 · PASS:1 (FX-SCP0028-032) |  | 5 (ACT:SCP0028_Shipment_Lot_Size.btnInput_C) |
| WK-SCP0028-0007 | X-ROW | SCP0028_Shipment_Lot_Size.btnItemId_Clic | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.btnItemId_Click: 진입점 집계 9검사 — PASS:5 · NA:3 · FAIL:1 (FX-SCP0028-033) |  | 5 (ACT:SCP0028_Shipment_Lot_Size.btnItemId_) |

## W5 검사기 연결 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0008 | DB-SYN | PR_GET_MNU_BTN_AUTH | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PR_GET_MNU_BTN_AUTH | 없음(PROC_M 대응 없음) | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0009 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 A6(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE ) → 대상 SP PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | 있음(PROC_M) | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0010 | A6 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DI | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 A6(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE ) → 대상 SP PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION | 있음(PROC_M) | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0011 | G5 | TRANS_MODE_CODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL TRANS_MODE_CODE / Trans Mode | 있음(SHEET_COLUMNS) | 1 (`FindDelete` `p_transport_mode="X"` (cs:) |
| WK-SCP0028-0012 | G5 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 2 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0013 | G5 | clbToSite / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbToSite / To Site | 있음(FE 소스) | 1 (팝업 `clbFromSite`/`clbToSite` CheckedList) |
| WK-SCP0028-0014 | H6 | TRANS_MODE_CODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TRANS_MODE_CODE / Trans Mode | 있음(SHEET_COLUMNS) | 1 (`FindDelete` `p_transport_mode="X"` (cs:) |

## W6 검증 실행 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0015 | H6 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbFromSite / From Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0016 | H6 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbToSite / To Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (팝업 `clbFromSite`/`clbToSite` CheckedList) |

## W7 기대값 확정 (28)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0017 | A1 | **toolbar DeleteButton remove-new (cs:21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **toolbar DeleteButton remove-new (cs:213~224, R4): 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** '` |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0018 | A1 | **팝업 Find — From Site 필수** (SCM0002 팝업 c | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **팝업 Find — From Site 필수** (SCM0002 팝업 cs:261~266): 행 집계 — 대조표 **팝업 Find — From Site 필수** (SCM0002 팝업 cs:261~266) '`Sh |  | 1 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0019 | A1 | FindButton (cs) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton (cs): 행 집계 — 대조표 FindButton (cs) '`hotkeyConfig.search` → handleSearch' 의 A1 6요소: REVIEW:4 · PASS:2 · FAIL  |  | 1 (FindButton (cs)) |
| WK-SCP0028-0020 | A1 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0021 | A1 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION — 팝업·보조 SP |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0022 | A1 | PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0028/SCP0028_GET_S |  | 2 (P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT AC) |
| WK-SCP0028-0023 | A1 | PR_GET_MNU_BTN_AUTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PR_GET_MNU_BTN_AUTH: 골든 비교 케이스 없음(PR_GET_MNU_BTN_AUTH — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0024 | A1 | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — 대조표 Query(ds) FindData (cs:368) '`useTabProcQuery` o_rc1 바인딩' 의 A1 6요소: REVIEW:4 · |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0025 | A1 | SetDivisionAuthCheck (cs:131~132, R1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SetDivisionAuthCheck (cs:131~132, R1): 행 집계 — 대조표 SetDivisionAuthCheck (cs:131~132, R1) 'Form `noAuth` 시 조회영역 disable  |  | 1 (SetDivisionAuthCheck (cs:131~132, R1)) |
| WK-SCP0028-0026 | A1 | `SetChangedControl` cascade (cs:158~171) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `SetChangedControl` cascade (cs:158~171): 행 집계 — 대조표 `SetChangedControl` cascade (cs:158~171) 'Division 변경 → From/To S |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0027 | A1 | btnInput "Input" 일괄입력 팝업 (cs:260~286, R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnInput "Input" 일괄입력 팝업 (cs:260~286, R5): 행 집계 — 대조표 btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) 'BtnArea 커스텀 버튼(SubTit |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0028 | A1 | cboDivision `Data_SCP.Common(Type.Divisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision `Data_SCP.Common(Type.Division)` + Get: 행 집계 — 대조표 cboDivision `Data_SCP.Common(Type.Division)` + GetDivis |  | 1 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0029 | A1 | cboOperationGroup `LookupCommon("OPERATI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboOperationGroup `LookupCommon("OPERATION_GROUP"): 행 집계 — 대조표 cboOperationGroup `LookupCommon("OPERATION_GROUP")` (cs |  | 1 (cboOperationGroup `LookupCommon("OPERATI) |
| WK-SCP0028-0030 | A1 | cboValid `DataBind(Type.YesOrNo,true)` ( | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboValid `DataBind(Type.YesOrNo,true)` (cs:135): 행 집계 — 대조표 cboValid `DataBind(Type.YesOrNo,true)` (cs:135) 'Valid sel |  | 1 (cboValid `DataBind(Type.YesOrNo,true)` () |
| WK-SCP0028-0031 | A1 | clbFromSite `FromSiteByDivision` (cs:166 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbFromSite `FromSiteByDivision` (cs:166): 행 집계 — 대조표 clbFromSite `FromSiteByDivision` (cs:166) 'From Site multi(+ALL) |  | 1 (clbFromSite `FromSiteByDivision` (cs:166) |
| WK-SCP0028-0032 | A1 | clbToSite `ToSiteByDivision` (cs:169) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbToSite `ToSiteByDivision` (cs:169): 행 집계 — 대조표 clbToSite `ToSiteByDivision` (cs:169) 'To Site multi(+ALL)' 의 A1 6요소 |  | 1 (clbToSite `ToSiteByDivision` (cs:169)) |
| WK-SCP0028-0033 | A1 | clbTransMode `LookupCommon("TRANSPORT_MO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbTransMode `LookupCommon("TRANSPORT_MODE_CODE")`: 행 집계 — 대조표 clbTransMode `LookupCommon("TRANSPORT_MODE_CODE")` (cs: |  | 1 (clbTransMode `LookupCommon("TRANSPORT_MO) |
| WK-SCP0028-0034 | A1 | 팝업 Form_Load `//FindData();` (cs:146) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없 |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0035 | A1 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** =  |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0036 | A6 | PR_GET_MNU_BTN_AUTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PR_GET_MNU_BTN_AUTH: 검증 엔진이 실행됐으나 이 대상(SP PR_GET_MNU_BTN_AUTH)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드· |  | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0037 | H6 | txtItemId / Model / Item Id | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — txtItemId / Model / Item Id: E2E smoke cond popup |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0038 | M4 | TRANS_MODE_CODE / Trans Mode | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — TRANS_MODE_CODE / Trans Mode: 검증 엔진이 실행됐으나 이 대상(COL TRANS_MODE_CODE)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (`FindDelete` `p_transport_mode="X"` (cs:) |
| WK-SCP0028-0039 | M4 | btnDelete | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnDelete: 검증 엔진이 실행됐으나 이 대상(BTN btnDelete)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (btnDelete "Delete" 일괄삭제 팝업 (cs:288~314, ) |
| WK-SCP0028-0040 | M4 | btnInput | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnInput: 검증 엔진이 실행됐으나 이 대상(BTN btnInput)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0041 | M4 | btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnItemId: 검증 엔진이 실행됐으나 이 대상(BTN btnItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0042 | M4 | clbFromSite / From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbFromSite / From Site: 검증 엔진이 실행됐으나 이 대상(COND clbFromSite)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0043 | M4 | clbToSite / To Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbToSite / To Site: 검증 엔진이 실행됐으나 이 대상(COND clbToSite)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (팝업 `clbFromSite`/`clbToSite` CheckedList) |
| WK-SCP0028-0044 | M4 | txtItemId / Model / Item Id | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtItemId / Model / Item Id: 검증 엔진이 실행됐으나 이 대상(COND txtItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |

## W9 도구 오류 (72)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0045 | F4 | **팝업 OK `SaveData` (cs:308~369)** | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 **팝업 OK `SaveData` (cs:308~369)** '`handleConfirm` — 그리드 0행→`MSG01091` / 체크 0건→`MSG00' 의 F4 7요소: PASS:5 · ER |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0046 | F4 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 하네스·환경 | F4 도구 오류 — 실측[T-fad117f6]: PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: SCM0002/ModelPopup/SEARCH, SCP0033/popup/SEARCH, SSP0 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0047 | F4 | PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_S | 하네스·환경 | F4 도구 오류 — 실측[T-6b9a8ce8]: [측정 경로 없음] PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT: 이번 Save 는 main/SAVE 로 저장(정상 호출) — 이 SP 경로 |  | 4 (P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT AC) |
| WK-SCP0028-0048 | F4 | Query(ds) FindData (cs:368) | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 Query(ds) FindData (cs:368) '`useTabProcQuery` o_rc1 바인딩' 의 F4 7요소: PASS:5 · ERROR:2 |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0049 | F4 | SaveButton SaveData (cs:574~) | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 SaveButton SaveData (cs:574~) '`hotkeyConfig.save` → handleSave' 의 F4 7요소: PASS:5 · ERROR:2 |  | 1 (SaveButton SaveData (cs:574~)) |
| WK-SCP0028-0050 | F4 | 팝업 Form_Load `//FindData();` (cs:146) | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 F4 7요소: PASS:5 · ER |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0051 | G4 | `SetChangedControl` cascade (cs:158~171) | 하네스·환경 | G4 도구 오류 — 행 집계 — 대조표 `SetChangedControl` cascade (cs:158~171) 'Division 변경 → From/To Site 재조회(divisionId 키) + res' 의 G4 10요소: PAS |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0052 | G4 | btnDelete | 하네스·환경 | G4 도구 오류 — 실측[T-d6ad4a4e]: [측정 경로 없음] AS-IS btnDelete 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인) |  | 2 (ACT:SCP0028_Shipment_Lot_Size.InitEvent ) |
| WK-SCP0028-0053 | H2 | **팝업 OK `SaveData` (cs:308~369)** | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 **팝업 OK `SaveData` (cs:308~369)** '`handleConfirm` — 그리드 0행→`MSG01091` / 체크 0건→`MSG00' 의 H2 5요소: PASS:3 · ER |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0054 | H2 | Delete() 신규행만 (cs:213~224, #3) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 Delete() 신규행만 (cs:213~224, #3) '(아래 §3 버튼 consolidation 참조)' 의 H2 5요소: PASS:3 · ERROR:2 |  | 1 (Delete() 신규행만 (cs:213~224, #3)) |
| WK-SCP0028-0055 | H2 | LOT_SIZE / Lot Size | 하네스·환경 | H2 도구 오류 — 원장 V-c5219535 COLUMN / 원장 V-a99ddb18 ASIS / 실측[T-d233d70c]: Insert 무동작 = AS-IS 파리티(실행 문장 없음) — 신규 행 없음이 정상 |  | 5 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0056 | H2 | LockColumn(DIV..TRANS,234)/(audit,235)/( | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 LockColumn(DIV..TRANS,234)/(audit,235)/(0..max,369) '`canEdit && isLotSizeCellEditable(binding)` beginn' 의 H |  | 1 (LockColumn(DIV..TRANS,234)/(audit,235)/() |
| WK-SCP0028-0057 | H2 | Query(ds) FindData (cs:368) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 Query(ds) FindData (cs:368) '`useTabProcQuery` o_rc1 바인딩' 의 H2 5요소: PASS:3 · ERROR:2 |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0058 | H2 | SCP0028_Shipment_Lot_Size.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0028_Shipment_Lot_Size.CreateSpread 의 H2 5요소: PASS:3 · ERROR:2 |  | 4 (ACT:SCP0028_Shipment_Lot_Size.CreateSpre) |
| WK-SCP0028-0059 | H2 | SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594, | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,595, #13/#14) '`isDefaultRevertRow` — handleSave 에서 M 제외' 의 H2 5요소:  |  | 1 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0060 | H2 | SmartColMerge (cs:371,438,721, #9/#12/#1 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 SmartColMerge (cs:371,438,721, #9/#12/#15) '`CustomMergeManager` allowMerging Cells, MERGE_COL' 의 H2 5요소: PA |  | 1 (SmartColMerge (cs:371,438,721, #9/#12/#1) |
| WK-SCP0028-0061 | H2 | SwitchLock (cs:232, gridSignals#4) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 SwitchLock (cs:232, gridSignals#4) '**미이식(NSCM 상시편집 표준)** — Edit 토글 state 없음. 편집권한 `ca' 의 H2 5요소: PASS:3 · E |  | 1 (SwitchLock (cs:232, gridSignals#4)) |
| WK-SCP0028-0062 | H2 | checkRequiredOfSpread | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 checkRequiredOfSpread "`useSaveWithValidation`(메타 INPUT_TP_CD='M')" 의 H2 5요소: PASS:3 · ERROR:2 |  | 1 (checkRequiredOfSpread) |
| WK-SCP0028-0063 | H2 | checkValidSize LOT<INC / 0값 (cs:762~773) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 checkValidSize LOT<INC / 0값 (cs:762~773) '`useShipmentLotSizeValidation`' 의 H2 5요소: PASS:3 · ERROR:2 |  | 1 (checkValidSize LOT<INC / 0값 (cs:762~773)) |
| WK-SCP0028-0064 | H2 | siMain.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-a99ddb18 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.SaveData:5) |
| WK-SCP0028-0065 | H2 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = 한 줄 3칸)' 의 H2 5요소: PASS:3 · ERROR |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0066 | I1 | SCP0028 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-cf28ca72 RULE_SCREEN / 원장 V-2aef119a RULE_SCREEN / 원장 V-ca2072cf RULE_SCREEN / 원장 V-ccb4dcdd DEFECT / 원장 V-14603c8 |  | 9 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0067 | E4 | MSG00031 | 하네스·환경 | E4 도구 오류 — 실측[T-0caf6c62]: MSG00031 — FindDelete 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(FindDelete)에서 판정 → 기계 판정 불가 —  |  | 1 (ACT:SCP0028_Shipment_Lot_Size.FindDelete) |
| WK-SCP0028-0068 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 실측[T-4677b9e5]: MSG00284 — FindDelete 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(FindDelete)에서 판정 → 기계 판정 불가 —  |  | 1 (ACT:SCP0028_Shipment_Lot_Size.FindDelete) |
| WK-SCP0028-0069 | G1 | **toolbar DeleteButton remove-new (cs:21 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** '`hotkeyConfig.delete = () => undefined` (버튼 노출+무동작' 의  |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0070 | G1 | FindButton (cs) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FindButton (cs) '`hotkeyConfig.search` → handleSearch' 의 G1 9요소: PASS:6 · ERROR:3 |  | 1 (FindButton (cs)) |
| WK-SCP0028-0071 | G1 | MSG00031 | 하네스·환경 | G1 도구 오류 — 원장 V-86e7f1e2 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.FindDelete) |
| WK-SCP0028-0072 | G1 | MSG00284 | 하네스·환경 | G1 도구 오류 — 원장 V-a89007be |  | 1 (ACT:SCP0028_Shipment_Lot_Size.FindDelete) |
| WK-SCP0028-0073 | G1 | SetDivisionAuthCheck (cs:131~132, R1) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SetDivisionAuthCheck (cs:131~132, R1) 'Form `noAuth` 시 조회영역 disable + 안내, handleSearch Di' 의 G1 9요소: PASS:6  |  | 1 (SetDivisionAuthCheck (cs:131~132, R1)) |
| WK-SCP0028-0074 | G1 | `SetChangedControl` cascade (cs:158~171) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 `SetChangedControl` cascade (cs:158~171) 'Division 변경 → From/To Site 재조회(divisionId 키) + res' 의 G1 9요소: PASS |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0075 | G1 | btnInput "Input" 일괄입력 팝업 (cs:260~286, R5 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) 'BtnArea 커스텀 버튼(SubTitle `customButtons`) → 팝업 → GE' 의 G1 9요소: PAS |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0076 | G1 | clbFromSite / From Site | 하네스·환경 | G1 도구 오류 — 원장 V-dd4f9db4 SEARCH / E2E smoke cond combo |  | 4 (clbFromSite `FromSiteByDivision` (cs:166) |
| WK-SCP0028-0077 | G1 | 팝업 Form_Load `//FindData();` (cs:146) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 G1 9요소: PASS:6 · ER |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0078 | G1 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = 한 줄 3칸)' 의 G1 9요소: PASS:6 · ERROR |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0079 | X-ROW | SCP0028_Shipment_Lot_Size.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — PASS:3 · ERROR:1 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.CreateSpre) |
| WK-SCP0028-0080 | X-ROW | SCP0028_Shipment_Lot_Size.FindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — PASS:11 · NA:2 · ERROR:1 |  | 7 (ACT:SCP0028_Shipment_Lot_Size.FindData:3) |
| WK-SCP0028-0081 | X-ROW | SCP0028_Shipment_Lot_Size.FindDelete | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:5 · PASS:5 |  | 61 (ACT:SCP0028_Shipment_Lot_Size.FindDelete) |
| WK-SCP0028-0082 | X-ROW | SCP0028_Shipment_Lot_Size.FindInput | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — PASS:2 · NA:2 · REVIEW:1 · ERROR:1 |  | 31 (ACT:SCP0028_Shipment_Lot_Size.FindInput ) |
| WK-SCP0028-0083 | X-ROW | SCP0028_Shipment_Lot_Size.InitEvent | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — PASS:2 · NA:1 · ERROR:1 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.InitEvent) |
| WK-SCP0028-0084 | X-ROW | SCP0028_Shipment_Lot_Size.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:8 · ERROR:1 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.InitSpread) |
| WK-SCP0028-0085 | X-ROW | SCP0028_Shipment_Lot_Size.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 17검사 — PASS:12 · NA:3 · ERROR:2 |  | 3 (ACT:SCP0028_Shipment_Lot_Size.SaveData:5) |
| WK-SCP0028-0086 | X-ROW | SCP0028_Shipment_Lot_Size.checkValidSize | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NA:5 · ERROR:1 |  | 13 (ACT:SCP0028_Shipment_Lot_Size.checkValid) |
| WK-SCP0028-0087 | G5 | **toolbar DeleteButton remove-new (cs:21 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** '`hotkeyConfig.delete = () => undefined` (버튼 노출+무동작' 의  |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0088 | G5 | **팝업 OK `SaveData` (cs:308~369)** | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 **팝업 OK `SaveData` (cs:308~369)** '`handleConfirm` — 그리드 0행→`MSG01091` / 체크 0건→`MSG00' 의 G5 16요소: NA:8 · ERR |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0089 | G5 | P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP '6 (division/opGroup/from/to/item/actionFlag)' 의 G5 16요소: NA:8 · ERROR |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0090 | G5 | btnDelete | 하네스·환경 | G5 도구 오류 — 원장 V-99c509aa ASIS / 원장 V-480372c9 ASIS / 원장 V-b9f0504a ASIS |  | 1 (btnDelete "Delete" 일괄삭제 팝업 (cs:288~314, ) |
| WK-SCP0028-0091 | G5 | btnInput | 하네스·환경 | G5 도구 오류 — 원장 V-4ad19f40 ASIS / 원장 V-86b2f489 ASIS / 원장 V-e06826aa ASIS |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0092 | G5 | popItem.Form_Load("D", sDivision_id.ToSt | 하네스·환경 | G5 도구 오류 — 원장 V-480372c9 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnDelete_) |
| WK-SCP0028-0093 | G5 | popItem.Form_Load("I", sDivision_id.ToSt | 하네스·환경 | G5 도구 오류 — 원장 V-86b2f489 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnInput_C) |
| WK-SCP0028-0094 | G5 | txtItemId / Model / Item Id | 하네스·환경 | G5 도구 오류 — 원장 V-99331be4 SEARCH / 정적 팝업 인자 대조 SCP0028_Shipment_Lot_Size.cs:248 SCP0028_Shipment_Lot_Size.b _ItemID: AS-IS txtItemI |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0095 | G5 | 팝업 Form_Load `//FindData();` (cs:146) | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 G5 16요소: NA:8 · ERR |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0096 | G5 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = 한 줄 3칸)' 의 G5 16요소: NA:8 · ERROR: |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0097 | H6 | **toolbar DeleteButton remove-new (cs:21 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** '`hotkeyConfig.delete = () => undefined` (버튼 노출+무동작' 의  |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0098 | H6 | **팝업 OK `SaveData` (cs:308~369)** | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 **팝업 OK `SaveData` (cs:308~369)** '`handleConfirm` — 그리드 0행→`MSG01091` / 체크 0건→`MSG00' 의 H6 16요소: ERROR:8 ·  |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0099 | H6 | P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP '6 (division/opGroup/from/to/item/actionFlag)' 의 H6 16요소: ERROR:8 · PA |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0100 | H6 | btnDelete | 하네스·환경 | H6 도구 오류 — 원장 V-aa6bec9e ASIS / 원장 V-6cb6bfa8 ASIS / 원장 V-d816896f ASIS |  | 1 (btnDelete "Delete" 일괄삭제 팝업 (cs:288~314, ) |
| WK-SCP0028-0101 | H6 | btnInput | 하네스·환경 | H6 도구 오류 — 원장 V-c2d97238 ASIS / 원장 V-d41bec0d ASIS / 원장 V-5123358d ASIS |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0102 | H6 | new SCM0002_ShipmentLotSizePopup() | 하네스·환경 | H6 도구 오류 — 원장 V-aa6bec9e |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnDelete_) |
| WK-SCP0028-0103 | H6 | new SCM0002_ShipmentLotSizePopup() | 하네스·환경 | H6 도구 오류 — 원장 V-c2d97238 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnInput_C) |
| WK-SCP0028-0104 | H6 | popItem.Form_Load("D", sDivision_id.ToSt | 하네스·환경 | H6 도구 오류 — 원장 V-6cb6bfa8 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnDelete_) |
| WK-SCP0028-0105 | H6 | popItem.Form_Load("I", sDivision_id.ToSt | 하네스·환경 | H6 도구 오류 — 원장 V-d41bec0d |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnInput_C) |
| WK-SCP0028-0106 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-d816896f |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnDelete_) |
| WK-SCP0028-0107 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-5123358d |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnInput_C) |
| WK-SCP0028-0108 | H6 | 팝업 Form_Load `//FindData();` (cs:146) | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 H6 16요소: ERROR:8 ·  |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0109 | H6 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = 한 줄 3칸)' 의 H6 16요소: ERROR:8 · PAS |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0110 | M3 | new SCM0002_ShipmentLotSizePopup() | 하네스·환경 | M3 도구 오류 — 원장 V-180ef854 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnDelete_) |
| WK-SCP0028-0111 | M3 | new SCM0002_ShipmentLotSizePopup() | 하네스·환경 | M3 도구 오류 — 원장 V-b2d03a00 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnInput_C) |
| WK-SCP0028-0112 | M4 | **toolbar DeleteButton remove-new (cs:21 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** '`hotkeyConfig.delete = () => undefined` (버튼 노출+무동작' 의  |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0113 | M4 | **팝업 OK `SaveData` (cs:308~369)** | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 **팝업 OK `SaveData` (cs:308~369)** '`handleConfirm` — 그리드 0행→`MSG01091` / 체크 0건→`MSG00' 의 M4 7요소: NOT_RUN:7 ( |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0114 | M4 | P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP '6 (division/opGroup/from/to/item/actionFlag)' 의 M4 7요소: NOT_RUN:7 (미실 |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0115 | M4 | 팝업 Form_Load `//FindData();` (cs:146) | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 M4 7요소: NOT_RUN:7 ( |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0116 | M4 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = 한 줄 3칸)' 의 M4 7요소: NOT_RUN:7 (미실행 |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
