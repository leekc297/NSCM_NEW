# 작업 원장 — SCP0028 · 2026-11-02 15:14

> 검사 인스턴스 393건 중 PASS·NA 290건 외 **103건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_FE** — FE 항목은 적용 대상. 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 38 | 재판정 PASS |
| W5 | 검사기 연결 | 9 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 4 | 실행 → PASS |
| W7 | 기대값 확정 | 38 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 14 | 원인 해소 → 재판정 |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 38 · 화면 FE 30 · 하네스·환경 14 · 하네스 9 · DB 객체 6 · E2E 4 · 공통 컴포넌트 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A1 | GEN |  |  |  |  |  |  | 21 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| M4 | POPUP |  |  |  |  |  |  | 7 |  | 5 | 팝업 선택값 반영 |
| G4 | DESIGN |  |  | 8 |  | 3 |  |  |  |  | 조회조건 표시·라벨·활성 |
| G1 | GEN |  |  | 9 |  |  |  |  |  | 1 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| X-ROW | GEN |  |  | 5 |  |  |  | 2 |  | 3 | 대조표 행이 서술한 동작을 화면에서 재현 |
| G5 | POPUP |  |  | 7 |  | 3 |  |  |  |  | 팝업 조건 연동(인자) |
| A6 | GEN |  |  |  |  |  |  | 4 |  | 2 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| F4 | DB |  |  | 5 |  |  |  |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| H6 | POPUP |  |  |  |  | 1 | 3 |  |  |  | 팝업 표준·열림 |
| X-LOC | GEN |  |  |  |  |  |  | 4 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| J2 | AUTH |  |  | 1 |  |  |  |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  | 1 |  |  |  |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  | 1 |  |  |  |  |  |  | 버튼 구성·조건별 노출 |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| DB-SYN | DB |  |  |  |  | 1 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |

## W3 동작 수정 (38)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0001 | J2 | SCP0028 화면 | DB 객체(PKG/SP)(적용 예정) | J2 FAIL 수정 — SCP0028 화면: 원장 V-687c9313 RULE_SCREEN / 원장 V-77b7dac5 DEFECT / 원장 V-2cac90a6 GENERAL / 원장 V-d1efd124 GENERAL / 원장 V-c |  | 80 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0002 | G3 | SCP0028 화면 | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | G3 FAIL 수정 — SCP0028 화면: 원장 V-563f3c40 RULE_SCREEN / 원장 V-a16e9f46 GENERAL / 원장 V-a45615d2 GENERAL / 원장 V-01f050ba GENERAL / 원장 V- |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0003 | K4 | SCP0028 화면 | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | K4 FAIL 수정 — SCP0028 화면: 원장 V-cb2a5f1a GENERAL / 원장 V-56001821 GENERAL / 원장 V-82de05d7 GENERAL / 원장 V-3a78a613 GENERAL / 원장 V-d354 |  | 44 (ACT:SCP0028_Shipment_Lot_Size.btnDelete_) |
| WK-SCP0028-0004 | F5 | SCP0028 화면 | 화면 FE(적용 예정) | F5 FAIL 수정 — SCP0028 화면: 원장 V-e50f03fc RULE_SCREEN / 원장 V-564a1ac4 RULE_SCREEN / 원장 V-4b34e536 RULE_SCREEN / 원장 V-e1f702d7 DEFECT  |  | 16 (Delete() 신규행만 (cs:213~224, #3) **SAVE SP) |
| WK-SCP0028-0005 | F4 | **팝업 OK `SaveData` (cs:308~369)** | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — **팝업 OK `SaveData` (cs:308~369)**: 행 집계 — 대조표 **팝업 OK `SaveData` (cs:308~369)** '`handleConfirm` — 그리드 0행→`MSG01091`  |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0006 | F4 | PR_GET_MNU_BTN_AUTH | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — PR_GET_MNU_BTN_AUTH: 실측[T-c770299c]: PR_GET_MNU_BTN_AUTH: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배선 확인) — 화면 진입·조회 중 |  | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0007 | F4 | Query(ds) FindData (cs:368) | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — Query(ds) FindData (cs:368): 행 집계 — 대조표 Query(ds) FindData (cs:368) '`useTabProcQuery` o_rc1 바인딩' 의 F4 7요소: NA:5 · FA |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0008 | F4 | SaveButton SaveData (cs:574~) | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SaveButton SaveData (cs:574~): 행 집계 — 대조표 SaveButton SaveData (cs:574~) '`hotkeyConfig.save` → handleSave' 의 F4 7요소:  |  | 1 (SaveButton SaveData (cs:574~)) |
| WK-SCP0028-0009 | F4 | 팝업 Form_Load `//FindData();` (cs:146) | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회  |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0010 | G4 | `SetChangedControl` cascade (cs:158~171) | 화면 FE(적용 예정) | G4 FAIL 수정 — `SetChangedControl` cascade (cs:158~171): 행 집계 — 대조표 `SetChangedControl` cascade (cs:158~171) 'Division 변경 → From/To  |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0011 | G4 | cboDivision / Division / Div. | 화면 FE(적용 예정) | G4 FAIL 수정 — cboDivision / Division / Div.: E2E smoke labels (FX-SCP0028-046) |  | 4 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0012 | G4 | cboOperationGroup / Operation Group / Op | 화면 FE(적용 예정) | G4 FAIL 수정 — cboOperationGroup / Operation Group / Operation group: E2E smoke labels (FX-SCP0028-048) |  | 3 (cboOperationGroup `LookupCommon("OPERATI) |
| WK-SCP0028-0013 | G4 | cboValid / Valid / Active | 화면 FE(적용 예정) | G4 FAIL 수정 — cboValid / Valid / Active: E2E smoke labels (FX-SCP0028-050) |  | 3 (cboValid `DataBind(Type.YesOrNo,true)` () |
| WK-SCP0028-0014 | G4 | clbFromSite / From Site | 화면 FE(적용 예정) | G4 FAIL 수정 — clbFromSite / From Site: E2E smoke labels (FX-SCP0028-054) |  | 1 (clbFromSite `FromSiteByDivision` (cs:166) |
| WK-SCP0028-0015 | G4 | clbToSite / To Site | 화면 FE(적용 예정) | G4 FAIL 수정 — clbToSite / To Site: E2E smoke labels (FX-SCP0028-056) |  | 1 (clbToSite `ToSiteByDivision` (cs:169)) |
| WK-SCP0028-0016 | G4 | clbTransMode / Trans Mode | 화면 FE(적용 예정) | G4 FAIL 수정 — clbTransMode / Trans Mode: E2E smoke labels (FX-SCP0028-052) |  | 3 (clbTransMode `LookupCommon("TRANSPORT_MO) |
| WK-SCP0028-0017 | G4 | txtItemId / Model / Item Id | 화면 FE(적용 예정) | G4 FAIL 수정 — txtItemId / Model / Item Id: E2E smoke labels (FX-SCP0028-058) |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0018 | G1 | **toolbar DeleteButton remove-new (cs:21 | 화면 FE(적용 예정) | G1 FAIL 수정 — **toolbar DeleteButton remove-new (cs:213~224, R4)**: 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0019 | G1 | FindButton (cs) | 화면 FE(적용 예정) | G1 FAIL 수정 — FindButton (cs): 행 집계 — 대조표 FindButton (cs) '`hotkeyConfig.search` → handleSearch' 의 G1 9요소: PASS:4 · FAIL:2 · NA:2 · |  | 1 (FindButton (cs)) |
| WK-SCP0028-0020 | G1 | SetDivisionAuthCheck (cs:131~132, R1) | 화면 FE(적용 예정) | G1 FAIL 수정 — SetDivisionAuthCheck (cs:131~132, R1): 행 집계 — 대조표 SetDivisionAuthCheck (cs:131~132, R1) 'Form `noAuth` 시 조회영역 disable |  | 1 (SetDivisionAuthCheck (cs:131~132, R1)) |
| WK-SCP0028-0021 | G1 | `SetChangedControl` cascade (cs:158~171) | 화면 FE(적용 예정) | G1 FAIL 수정 — `SetChangedControl` cascade (cs:158~171): 행 집계 — 대조표 `SetChangedControl` cascade (cs:158~171) 'Division 변경 → From/To  |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0022 | G1 | btnInput "Input" 일괄입력 팝업 (cs:260~286, R5 | 화면 FE(적용 예정) | G1 FAIL 수정 — btnInput "Input" 일괄입력 팝업 (cs:260~286, R5): 행 집계 — 대조표 btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) 'BtnArea 커스텀 버튼(SubTi |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0023 | G1 | cboValid / Valid / Active | 화면 FE(적용 예정) | G1 FAIL 수정 — cboValid / Valid / Active: 원장 V-602d9026 SEARCH / E2E smoke cond combo (FX-SCP0028-010) |  | 3 (cboValid `DataBind(Type.YesOrNo,true)` () |
| WK-SCP0028-0024 | G1 | txtItemId / Model / Item Id | 화면 FE(적용 예정) | G1 FAIL 수정 — txtItemId / Model / Item Id: 원장 V-9e2b9258 SEARCH / E2E smoke cond ItemField (FX-SCP0028-011) |  | 3 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0025 | G1 | 팝업 Form_Load `//FindData();` (cs:146) | 화면 FE(적용 예정) | G1 FAIL 수정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회  |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0026 | G1 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 화면 FE(적용 예정) | G1 FAIL 수정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0027 | X-ROW | SCP0028_Shipment_Lot_Size.FindData | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.FindData: 진입점 집계 14검사 — PASS:9 · FAIL:2 · REVIEW:1 · NA:1 · ERROR:1 (FX-SCP0028-094) |  | 7 (ACT:SCP0028_Shipment_Lot_Size.FindData:3) |
| WK-SCP0028-0028 | X-ROW | SCP0028_Shipment_Lot_Size.InitControls | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.InitControls: 진입점 집계 16검사 — PASS:10 · FAIL:4 · NOPATH:2 (FX-SCP0028-096) |  | 6 (ACT:SCP0028_Shipment_Lot_Size.InitContro) |
| WK-SCP0028-0029 | X-ROW | SCP0028_Shipment_Lot_Size.btnDelete_Clic | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.btnDelete_Click: 진입점 집계 9검사 — NA:6 · FAIL:2 · PASS:1 (FX-SCP0028-098) |  | 5 (ACT:SCP0028_Shipment_Lot_Size.btnDelete_) |
| WK-SCP0028-0030 | X-ROW | SCP0028_Shipment_Lot_Size.btnInput_Click | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.btnInput_Click: 진입점 집계 9검사 — NA:6 · FAIL:2 · PASS:1 (FX-SCP0028-099) |  | 5 (ACT:SCP0028_Shipment_Lot_Size.btnInput_C) |
| WK-SCP0028-0031 | X-ROW | SCP0028_Shipment_Lot_Size.btnItemId_Clic | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.btnItemId_Click: 진입점 집계 9검사 — NA:6 · FAIL:3 (FX-SCP0028-100) |  | 5 (ACT:SCP0028_Shipment_Lot_Size.btnItemId_) |
| WK-SCP0028-0032 | G5 | **toolbar DeleteButton remove-new (cs:21 | 화면 FE(적용 예정) | G5 FAIL 수정 — **toolbar DeleteButton remove-new (cs:213~224, R4)**: 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0033 | G5 | **팝업 OK `SaveData` (cs:308~369)** | 화면 FE(적용 예정) | G5 FAIL 수정 — **팝업 OK `SaveData` (cs:308~369)**: 행 집계 — 대조표 **팝업 OK `SaveData` (cs:308~369)** '`handleConfirm` — 그리드 0행→`MSG01091`  |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0034 | G5 | P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | 화면 FE(적용 예정) | G5 FAIL 수정 — P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP: 행 집계 — 대조표 P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP '6 (division/opGroup/from/to/ |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0035 | G5 | btnItemId | 화면 FE(적용 예정) | G5 FAIL 수정 — btnItemId: 원장 V-26b0134a ASIS / 원장 V-dc8f2fac ASIS / 원장 V-46f73ab8 ASIS (FX-SCP0028-017) |  | 2 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0036 | G5 | popItem.Form_Load(true, division, sScmSi | 화면 FE(적용 예정) | G5 FAIL 수정 — popItem.Form_Load(true, division, sScmSite, sProject, sItemI: 원장 V-dc8f2fac (FX-SCP0028-017) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnItemId_) |
| WK-SCP0028-0037 | G5 | 팝업 Form_Load `//FindData();` (cs:146) | 화면 FE(적용 예정) | G5 FAIL 수정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회  |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0038 | G5 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 화면 FE(적용 예정) | G5 FAIL 수정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |

## W5 검사기 연결 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0039 | DB-SYN | PR_GET_MNU_BTN_AUTH | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PR_GET_MNU_BTN_AUTH | 없음(PROC_M 대응 없음) | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0040 | G4 | btnDelete | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnDelete | 있음(FE 소스) | 2 (ACT:SCP0028_Shipment_Lot_Size.InitEvent ) |
| WK-SCP0028-0041 | G4 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnInput | 있음(FE 소스) | 2 (ACT:SCP0028_Shipment_Lot_Size.InitEvent ) |
| WK-SCP0028-0042 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 3 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0043 | G03-WIRE | SCP0028 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0028 화면 | 판단불가(대상 단위 SCREEN) | 11 (ACT:SCP0028_Shipment_Lot_Size..ctor ACT:) |
| WK-SCP0028-0044 | G5 | TRANS_MODE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL TRANS_MODE_CODE | 있음(SHEET_COLUMNS) | 1 (`FindDelete` `p_transport_mode="X"` (cs:) |
| WK-SCP0028-0045 | G5 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 2 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0046 | G5 | clbToSite / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbToSite / To Site | 있음(FE 소스) | 1 (팝업 `clbFromSite`/`clbToSite` CheckedList) |
| WK-SCP0028-0047 | H6 | TRANS_MODE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TRANS_MODE_CODE | 있음(SHEET_COLUMNS) | 1 (`FindDelete` `p_transport_mode="X"` (cs:) |

## W6 검증 실행 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0048 | SC1 | SCP0028 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0028 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 8 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0049 | H6 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbFromSite / From Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0050 | H6 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbToSite / To Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (팝업 `clbFromSite`/`clbToSite` CheckedList) |
| WK-SCP0028-0051 | H6 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Item Id · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |

## W7 기대값 확정 (38)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0052 | A1 | **toolbar DeleteButton remove-new (cs:21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **toolbar DeleteButton remove-new (cs:213~224, R4): 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** '` |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0053 | A1 | **팝업 Find — From Site 필수** (SCM0002 팝업 c | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **팝업 Find — From Site 필수** (SCM0002 팝업 cs:261~266): 행 집계 — 대조표 **팝업 Find — From Site 필수** (SCM0002 팝업 cs:261~266) '`Sh |  | 1 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0054 | A1 | FindButton (cs) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton (cs): 행 집계 — 대조표 FindButton (cs) '`hotkeyConfig.search` → handleSearch' 의 A1 6요소: REVIEW:6 · FAIL 요소: PKG_S |  | 1 (FindButton (cs)) |
| WK-SCP0028-0055 | A1 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0056 | A1 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION — 팝업·보조 SP |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0057 | A1 | PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP: 골든 비교 케이스 없음(PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP — 팝업 |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0058 | A1 | PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0028/SCP0028_GET_SHIPMEN |  | 41 (P_SCP0028_GET_SHIPMENT_LOT_SIZE ACT:SCP0) |
| WK-SCP0028-0059 | A1 | PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0028/SCP0028_GET_S |  | 2 (P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT AC) |
| WK-SCP0028-0060 | A1 | PR_GET_MNU_BTN_AUTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PR_GET_MNU_BTN_AUTH: 골든 비교 케이스 없음(PR_GET_MNU_BTN_AUTH — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0061 | A1 | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — 대조표 Query(ds) FindData (cs:368) '`useTabProcQuery` o_rc1 바인딩' 의 A1 6요소: REVIEW:6 · |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0062 | A1 | SetDivisionAuthCheck (cs:131~132, R1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SetDivisionAuthCheck (cs:131~132, R1): 행 집계 — 대조표 SetDivisionAuthCheck (cs:131~132, R1) 'Form `noAuth` 시 조회영역 disable  |  | 1 (SetDivisionAuthCheck (cs:131~132, R1)) |
| WK-SCP0028-0063 | A1 | `SetChangedControl` cascade (cs:158~171) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `SetChangedControl` cascade (cs:158~171): 행 집계 — 대조표 `SetChangedControl` cascade (cs:158~171) 'Division 변경 → From/To S |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0064 | A1 | btnInput "Input" 일괄입력 팝업 (cs:260~286, R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnInput "Input" 일괄입력 팝업 (cs:260~286, R5): 행 집계 — 대조표 btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) 'BtnArea 커스텀 버튼(SubTit |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0065 | A1 | cboDivision `Data_SCP.Common(Type.Divisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision `Data_SCP.Common(Type.Division)` + Get: 행 집계 — 대조표 cboDivision `Data_SCP.Common(Type.Division)` + GetDivis |  | 1 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0066 | A1 | cboOperationGroup `LookupCommon("OPERATI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboOperationGroup `LookupCommon("OPERATION_GROUP"): 행 집계 — 대조표 cboOperationGroup `LookupCommon("OPERATION_GROUP")` (cs |  | 1 (cboOperationGroup `LookupCommon("OPERATI) |
| WK-SCP0028-0067 | A1 | cboValid `DataBind(Type.YesOrNo,true)` ( | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboValid `DataBind(Type.YesOrNo,true)` (cs:135): 행 집계 — 대조표 cboValid `DataBind(Type.YesOrNo,true)` (cs:135) 'Valid sel |  | 1 (cboValid `DataBind(Type.YesOrNo,true)` () |
| WK-SCP0028-0068 | A1 | clbFromSite `FromSiteByDivision` (cs:166 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbFromSite `FromSiteByDivision` (cs:166): 행 집계 — 대조표 clbFromSite `FromSiteByDivision` (cs:166) 'From Site multi(+ALL) |  | 1 (clbFromSite `FromSiteByDivision` (cs:166) |
| WK-SCP0028-0069 | A1 | clbToSite `ToSiteByDivision` (cs:169) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbToSite `ToSiteByDivision` (cs:169): 행 집계 — 대조표 clbToSite `ToSiteByDivision` (cs:169) 'To Site multi(+ALL)' 의 A1 6요소 |  | 1 (clbToSite `ToSiteByDivision` (cs:169)) |
| WK-SCP0028-0070 | A1 | clbTransMode `LookupCommon("TRANSPORT_MO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbTransMode `LookupCommon("TRANSPORT_MODE_CODE")`: 행 집계 — 대조표 clbTransMode `LookupCommon("TRANSPORT_MODE_CODE")` (cs: |  | 1 (clbTransMode `LookupCommon("TRANSPORT_MO) |
| WK-SCP0028-0071 | A1 | 팝업 Form_Load `//FindData();` (cs:146) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없 |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0072 | A1 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** =  |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0073 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 검증 엔진이 실행됐으나 이 대상(SP PKG_SCM0002.P_SCM0002_GET_ITEM)을 판정하지 못함 — 결과 행 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0074 | A6 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION: 검증 엔진이 실행됐으나 이 대상(SP PKG_SCM0002.P_SCM0002_GET_MATE)을 판정하지 못함 — 결과 행 정 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0075 | A6 | PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP: 검증 엔진이 실행됐으나 이 대상(SP PKG_SCP0028.P_SCM0002_GET_SHIP)을 판정하지 못함 — 결과  |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0076 | A6 | PR_GET_MNU_BTN_AUTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PR_GET_MNU_BTN_AUTH: 검증 엔진이 실행됐으나 이 대상(SP PR_GET_MNU_BTN_AUTH)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드· |  | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0077 | X-LOC | P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0078 | X-LOC | P_SCP0028_GET_SHIPMENT_LOT_SIZE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_SCP0028_GET_SHIPMENT_LOT_SIZE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_SCP0028_GET_SHIPMENT_LOT_SIZE) |
| WK-SCP0028-0079 | X-LOC | P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT) |
| WK-SCP0028-0080 | X-LOC | P_SCP0028_SAVE_SHIPMENT_LOT_SIZE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_SCP0028_SAVE_SHIPMENT_LOT_SIZE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_SCP0028_SAVE_SHIPMENT_LOT_SIZE) |
| WK-SCP0028-0081 | X-ROW | SCP0028_Shipment_Lot_Size.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.FindButton: 진입점 집계 3검사 — PASS:2 · REVIEW:1 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.FindButton) |
| WK-SCP0028-0082 | X-ROW | SCP0028_Shipment_Lot_Size.FindInput | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.FindInput: 진입점 집계 6검사 — PASS:3 · NA:2 · REVIEW:1 |  | 31 (ACT:SCP0028_Shipment_Lot_Size.FindInput ) |
| WK-SCP0028-0083 | M4 | TRANS_MODE_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — TRANS_MODE_CODE: 검증 엔진이 실행됐으나 이 대상(COL TRANS_MODE_CODE)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (`FindDelete` `p_transport_mode="X"` (cs:) |
| WK-SCP0028-0084 | M4 | btnDelete | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnDelete: 검증 엔진이 실행됐으나 이 대상(BTN btnDelete)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (btnDelete "Delete" 일괄삭제 팝업 (cs:288~314, ) |
| WK-SCP0028-0085 | M4 | btnInput | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnInput: 검증 엔진이 실행됐으나 이 대상(BTN btnInput)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0086 | M4 | btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnItemId: 검증 엔진이 실행됐으나 이 대상(BTN btnItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0087 | M4 | clbFromSite / From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbFromSite / From Site: 검증 엔진이 실행됐으나 이 대상(COND clbFromSite)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0088 | M4 | clbToSite / To Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbToSite / To Site: 검증 엔진이 실행됐으나 이 대상(COND clbToSite)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (팝업 `clbFromSite`/`clbToSite` CheckedList) |
| WK-SCP0028-0089 | M4 | txtItemId / Model / Item Id | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtItemId / Model / Item Id: 검증 엔진이 실행됐으나 이 대상(COND txtItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |

## W9 도구 오류 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0090 | F1 | SCP0028 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-2a38c0ec RULE_SCREEN / 원장 V-28f35ca2 RULE_SCREEN / 원장 V-76f53419 RULE_SCREEN / 원장 V-eef8848c RULE_SCREEN / 원장 V-20 |  | 98 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0091 | F2 | SCP0028 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-6cc4d697 RULE_SCREEN / 원장 V-e20fb714 RULE_SCREEN / 원장 V-a6653638 GENERAL / 원장 V-6b773210 GENERAL / 원장 V-34237405 G |  | 83 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0092 | F6 | SCP0028 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-c56a201c RULE_SCREEN / 원장 V-1b743800 RULE_SCREEN / 원장 V-c82c6754 RULE_SCREEN / 원장 V-83e14b5f RULE_SCREEN / 원장 V-f0 |  | 80 (SaveButton SaveData (cs:574~) **팝업 OK `S) |
| WK-SCP0028-0093 | A6 | Query(ds) FindData (cs:368) | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 Query(ds) FindData (cs:368) '`useTabProcQuery` o_rc1 바인딩' 의 A6 6요소: NOT_RUN:4 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0094 | A6 | 팝업 Form_Load `//FindData();` (cs:146) | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 A6 6요소: NOT_RUN:4 · |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0095 | G1 | clbFromSite / From Site | 하네스·환경 | G1 도구 오류 — 원장 V-dd4f9db4 SEARCH / E2E smoke cond combo |  | 4 (clbFromSite `FromSiteByDivision` (cs:166) |
| WK-SCP0028-0096 | X-ROW | SCP0028_Shipment_Lot_Size.ClbDivision_Se | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.ClbDivisio) |
| WK-SCP0028-0097 | X-ROW | SCP0028_Shipment_Lot_Size.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.CreateSpre) |
| WK-SCP0028-0098 | X-ROW | SCP0028_Shipment_Lot_Size.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 17검사 — PASS:9 · NA:5 · ERROR:3 |  | 3 (ACT:SCP0028_Shipment_Lot_Size.SaveData:5) |
| WK-SCP0028-0099 | M4 | **toolbar DeleteButton remove-new (cs:21 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** '`hotkeyConfig.delete = () => undefined` (버튼 노출+무동작' 의  |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0100 | M4 | **팝업 OK `SaveData` (cs:308~369)** | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 **팝업 OK `SaveData` (cs:308~369)** '`handleConfirm` — 그리드 0행→`MSG01091` / 체크 0건→`MSG00' 의 M4 7요소: NOT_RUN:7 ( |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0101 | M4 | P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP '6 (division/opGroup/from/to/item/actionFlag)' 의 M4 7요소: NOT_RUN:7 (미실 |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0102 | M4 | 팝업 Form_Load `//FindData();` (cs:146) | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 M4 7요소: NOT_RUN:7 ( |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0103 | M4 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = 한 줄 3칸)' 의 M4 7요소: NOT_RUN:7 (미실행 |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
