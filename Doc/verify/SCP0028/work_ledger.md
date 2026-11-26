# 작업 원장 — SCP0028 · 2026-11-25 02:10

> 검사 인스턴스 393건 중 PASS·NA 323건 외 **70건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 43 | 재판정 PASS |
| W5 | 검사기 연결 | 1 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 19 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 7 | 원인 해소 → 재판정 |

- 담당: 화면 FE 31 · 사람 판정 / AS-IS 원문 확인 → 재판정 19 · 공통 컴포넌트 9 · 하네스·환경 7 · DB 2 · DB 객체 1 · 하네스 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A1 | GEN |  |  |  |  |  |  | 18 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| H2 | DESIGN |  |  | 13 |  |  |  |  |  |  | 배경·글자색 규칙 |
| H6 | POPUP |  |  | 10 |  |  |  |  |  |  | 팝업 표준·열림 |
| G1 | GEN |  |  | 8 |  |  |  |  |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| X-ROW | GEN |  |  | 7 |  |  |  |  |  | 1 | 대조표 행이 서술한 동작을 화면에서 재현 |
| F4 | DB |  |  |  |  |  |  |  |  | 5 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E1 | EDIT |  |  | 2 |  |  |  |  |  |  | 숫자 소수자리·정수·부호·범위 |
| A6 | GEN |  |  |  |  | 1 |  | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| J2 | AUTH |  |  | 1 |  |  |  |  |  |  | 권한별 버튼·기능 |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| E4 | EDIT |  |  | 1 |  |  |  |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (43)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0001 | J2 | SCP0028 화면 | DB(🛠️/🧯 적용 가능) | J2 FAIL 수정 — SCP0028 화면: 원장 V-9576f1ee RULE_SCREEN / 원장 V-77b7dac5 DEFECT / 원장 V-2cac90a6 GENERAL / 원장 V-d1efd124 GENERAL / 원장 V-c |  | 80 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0002 | F5 | SCP0028 화면 | 화면 FE(범위 밖(가이드만)) | F5 FAIL 수정 — SCP0028 화면: 원장 V-be29b7a4 RULE_SCREEN / 원장 V-564a1ac4 RULE_SCREEN / 원장 V-4b34e536 RULE_SCREEN / 원장 V-e1f702d7 DEFECT  |  | 16 (Delete() 신규행만 (cs:213~224, #3) **SAVE SP) |
| WK-SCP0028-0003 | H2 | **팝업 OK `SaveData` (cs:308~369)** | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — **팝업 OK `SaveData` (cs:308~369)**: 행 집계 — 대조표 **팝업 OK `SaveData` (cs:308~369)** '`handleConfirm` — 그리드 0행→`MSG01091`  |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0004 | H2 | Delete() 신규행만 (cs:213~224, #3) | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — Delete() 신규행만 (cs:213~224, #3): 행 집계 — 대조표 Delete() 신규행만 (cs:213~224, #3) '(아래 §3 버튼 consolidation 참조)' 의 H2 5요소: PAS |  | 1 (Delete() 신규행만 (cs:213~224, #3)) |
| WK-SCP0028-0005 | H2 | LOT_SIZE / Lot Size | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — LOT_SIZE / Lot Size: 원장 V-c5219535 COLUMN / 원장 V-a99ddb18 ASIS / 실측[T-d233d70c]: Insert 무동작 = AS-IS 파리티(실행 문장 없음) — 신 |  | 5 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0006 | H2 | LockColumn(DIV..TRANS,234)/(audit,235)/( | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — LockColumn(DIV..TRANS,234)/(audit,235)/(0..max,369): 행 집계 — 대조표 LockColumn(DIV..TRANS,234)/(audit,235)/(0..max,369) ' |  | 1 (LockColumn(DIV..TRANS,234)/(audit,235)/() |
| WK-SCP0028-0007 | H2 | Query(ds) FindData (cs:368) | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — Query(ds) FindData (cs:368): 행 집계 — 대조표 Query(ds) FindData (cs:368) '`useTabProcQuery` o_rc1 바인딩' 의 H2 5요소: PASS:3 ·  |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0008 | H2 | SCP0028_Shipment_Lot_Size.CreateSpread | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — SCP0028_Shipment_Lot_Size.CreateSpread: 진입점 집계 — 대조표 SCP0028_Shipment_Lot_Size.CreateSpread 의 H2 5요소: PASS:3 · FAIL:2 |  | 4 (ACT:SCP0028_Shipment_Lot_Size.CreateSpre) |
| WK-SCP0028-0009 | H2 | SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594, | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,595, #13/#14): 행 집계 — 대조표 SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,595, #13/#1 |  | 1 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0010 | H2 | SmartColMerge (cs:371,438,721, #9/#12/#1 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — SmartColMerge (cs:371,438,721, #9/#12/#15): 행 집계 — 대조표 SmartColMerge (cs:371,438,721, #9/#12/#15) '`CustomMergeManage |  | 1 (SmartColMerge (cs:371,438,721, #9/#12/#1) |
| WK-SCP0028-0011 | H2 | SwitchLock (cs:232, gridSignals#4) | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — SwitchLock (cs:232, gridSignals#4): 행 집계 — 대조표 SwitchLock (cs:232, gridSignals#4) '**미이식(NSCM 상시편집 표준)** — Edit 토글 st |  | 1 (SwitchLock (cs:232, gridSignals#4)) |
| WK-SCP0028-0012 | H2 | checkRequiredOfSpread | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — checkRequiredOfSpread: 행 집계 — 대조표 checkRequiredOfSpread "`useSaveWithValidation`(메타 INPUT_TP_CD='M')" 의 H2 5요소: PASS: |  | 1 (checkRequiredOfSpread) |
| WK-SCP0028-0013 | H2 | checkValidSize LOT<INC / 0값 (cs:762~773) | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — checkValidSize LOT<INC / 0값 (cs:762~773): 행 집계 — 대조표 checkValidSize LOT<INC / 0값 (cs:762~773) '`useShipmentLotSizeVal |  | 1 (checkValidSize LOT<INC / 0값 (cs:762~773)) |
| WK-SCP0028-0014 | H2 | siMain.SetBGColor | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — siMain.SetBGColor: 원장 V-a99ddb18 (FX-SCP0028-009) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.SaveData:5) |
| WK-SCP0028-0015 | H2 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0016 | E1 | INCREMENT / Increment | 화면 FE(범위 밖(가이드만)) | E1 FAIL 수정 — INCREMENT / Increment: 원장 V-597f4433 COLUMN (FX-SCP0028-007) |  | 1 (SetReNumerCellType(LOT_SIZE/INCREMENT,0)) |
| WK-SCP0028-0017 | E1 | LOT_SIZE / Lot Size | 화면 FE(범위 밖(가이드만)) | E1 FAIL 수정 — LOT_SIZE / Lot Size: 원장 V-6259d313 COLUMN (FX-SCP0028-006) |  | 1 (SetReNumerCellType(LOT_SIZE/INCREMENT,0)) |
| WK-SCP0028-0018 | E4 | MSG00284 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00284: 실측[T-4677b9e5]: MSG00284 · 화면 '삭제되었습니다.' · 기대 '실행중 에러가 발생했습니다.'(오류) 와 의미 다름 · [가짜 응답 · 서버 미전송] AS-IS btnDel |  | 1 (ACT:SCP0028_Shipment_Lot_Size.FindDelete) |
| WK-SCP0028-0019 | G1 | **toolbar DeleteButton remove-new (cs:21 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — **toolbar DeleteButton remove-new (cs:213~224, R4)**: 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0020 | G1 | FindButton (cs) | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — FindButton (cs): 행 집계 — 대조표 FindButton (cs) '`hotkeyConfig.search` → handleSearch' 의 G1 9요소: PASS:8 · FAIL:1 · FAIL 요 |  | 1 (FindButton (cs)) |
| WK-SCP0028-0021 | G1 | MSG00284 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — MSG00284: 원장 V-a89007be (FX-SCP0028-008) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.FindDelete) |
| WK-SCP0028-0022 | G1 | SetDivisionAuthCheck (cs:131~132, R1) | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — SetDivisionAuthCheck (cs:131~132, R1): 행 집계 — 대조표 SetDivisionAuthCheck (cs:131~132, R1) 'Form `noAuth` 시 조회영역 disable |  | 1 (SetDivisionAuthCheck (cs:131~132, R1)) |
| WK-SCP0028-0023 | G1 | `SetChangedControl` cascade (cs:158~171) | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — `SetChangedControl` cascade (cs:158~171): 행 집계 — 대조표 `SetChangedControl` cascade (cs:158~171) 'Division 변경 → From/To  |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0024 | G1 | btnInput "Input" 일괄입력 팝업 (cs:260~286, R5 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — btnInput "Input" 일괄입력 팝업 (cs:260~286, R5): 행 집계 — 대조표 btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) 'BtnArea 커스텀 버튼(SubTi |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0025 | G1 | 팝업 Form_Load `//FindData();` (cs:146) | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회  |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0026 | G1 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0027 | X-ROW | SCP0028_Shipment_Lot_Size.CreateSpread | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.CreateSpread: 진입점 집계 4검사 — PASS:3 · FAIL:1 (FX-SCP0028-066) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.CreateSpre) |
| WK-SCP0028-0028 | X-ROW | SCP0028_Shipment_Lot_Size.FindDelete | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.FindDelete: 진입점 집계 10검사 — PASS:7 · FAIL:2 · ERROR:1 (FX-SCP0028-068) |  | 61 (ACT:SCP0028_Shipment_Lot_Size.FindDelete) |
| WK-SCP0028-0029 | X-ROW | SCP0028_Shipment_Lot_Size.InitSpread | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.InitSpread: 진입점 집계 9검사 — PASS:8 · FAIL:1 (FX-SCP0028-070) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.InitSpread) |
| WK-SCP0028-0030 | X-ROW | SCP0028_Shipment_Lot_Size.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.SaveData: 진입점 집계 17검사 — PASS:12 · NA:3 · ERROR:1 · FAIL:1 (FX-SCP0028-071) |  | 3 (ACT:SCP0028_Shipment_Lot_Size.SaveData:5) |
| WK-SCP0028-0031 | X-ROW | SCP0028_Shipment_Lot_Size.btnDelete_Clic | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.btnDelete_Click: 진입점 집계 9검사 — PASS:6 · NA:2 · FAIL:1 (FX-SCP0028-072) |  | 5 (ACT:SCP0028_Shipment_Lot_Size.btnDelete_) |
| WK-SCP0028-0032 | X-ROW | SCP0028_Shipment_Lot_Size.btnInput_Click | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.btnInput_Click: 진입점 집계 9검사 — PASS:6 · NA:2 · FAIL:1 (FX-SCP0028-073) |  | 5 (ACT:SCP0028_Shipment_Lot_Size.btnInput_C) |
| WK-SCP0028-0033 | X-ROW | SCP0028_Shipment_Lot_Size.btnItemId_Clic | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0028_Shipment_Lot_Size.btnItemId_Click: 진입점 집계 9검사 — FAIL:4 · NA:3 · PASS:2 (FX-SCP0028-074) |  | 5 (ACT:SCP0028_Shipment_Lot_Size.btnItemId_) |
| WK-SCP0028-0034 | H6 | **toolbar DeleteButton remove-new (cs:21 | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — **toolbar DeleteButton remove-new (cs:213~224, R4)**: 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0035 | H6 | **팝업 OK `SaveData` (cs:308~369)** | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — **팝업 OK `SaveData` (cs:308~369)**: 행 집계 — 대조표 **팝업 OK `SaveData` (cs:308~369)** '`handleConfirm` — 그리드 0행→`MSG01091`  |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0036 | H6 | P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP: 행 집계 — 대조표 P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP '6 (division/opGroup/from/to/ |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0037 | H6 | btnItemId | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — btnItemId: 원장 V-97b0fc4e ASIS / 원장 V-a9485a6a ASIS / 원장 V-c4a9dc2c ASIS / 원장 EG-2644dff3 팝업 실측 SCM0002_ItembyDivision |  | 2 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0038 | H6 | new SCM0002_ItembyDivisionPopup() | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — new SCM0002_ItembyDivisionPopup(): 원장 V-97b0fc4e (FX-SCP0028-010) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnItemId_) |
| WK-SCP0028-0039 | H6 | popItem.Form_Load(true, division, sScmSi | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — popItem.Form_Load(true, division, sScmSite, sProject, sItemI: 원장 V-a9485a6a (FX-SCP0028-011) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnItemId_) |
| WK-SCP0028-0040 | H6 | popItem.ShowDialog() | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-c4a9dc2c (FX-SCP0028-012) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.btnItemId_) |
| WK-SCP0028-0041 | H6 | txtItemId / Model / Item Id | DB(🛠️/🧯 적용 가능) | H6 FAIL 수정 — txtItemId / Model / Item Id: 원장 EG-2644dff3 팝업 실측 SCM0002_ItembyDivisionPopup COND:Model BTN_ORDER / 원장 EG-b0d10a90 팝 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0042 | H6 | 팝업 Form_Load `//FindData();` (cs:146) | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회  |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0043 | H6 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |

## W5 검사기 연결 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0044 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 A6(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE ) → 대상 SP PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | 있음(PROC_M) | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |

## W7 기대값 확정 (19)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0045 | A1 | **toolbar DeleteButton remove-new (cs:21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **toolbar DeleteButton remove-new (cs:213~224, R4): 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** '` |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0046 | A1 | **팝업 Find — From Site 필수** (SCM0002 팝업 c | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **팝업 Find — From Site 필수** (SCM0002 팝업 cs:261~266): 행 집계 — 대조표 **팝업 Find — From Site 필수** (SCM0002 팝업 cs:261~266) '`Sh |  | 1 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0047 | A1 | FindButton (cs) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton (cs): 행 집계 — 대조표 FindButton (cs) '`hotkeyConfig.search` → handleSearch' 의 A1 6요소: REVIEW:3 · PASS:2 · NA:1  |  | 1 (FindButton (cs)) |
| WK-SCP0028-0048 | A1 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0049 | A1 | PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP: 골든 비교 케이스 없음(PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP — 팝업 |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0050 | A1 | PR_GET_MNU_BTN_AUTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PR_GET_MNU_BTN_AUTH: 골든 비교 케이스 없음(PR_GET_MNU_BTN_AUTH — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0051 | A1 | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — 대조표 Query(ds) FindData (cs:368) '`useTabProcQuery` o_rc1 바인딩' 의 A1 6요소: REVIEW:3 · |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0052 | A1 | SetDivisionAuthCheck (cs:131~132, R1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SetDivisionAuthCheck (cs:131~132, R1): 행 집계 — 대조표 SetDivisionAuthCheck (cs:131~132, R1) 'Form `noAuth` 시 조회영역 disable  |  | 1 (SetDivisionAuthCheck (cs:131~132, R1)) |
| WK-SCP0028-0053 | A1 | `SetChangedControl` cascade (cs:158~171) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `SetChangedControl` cascade (cs:158~171): 행 집계 — 대조표 `SetChangedControl` cascade (cs:158~171) 'Division 변경 → From/To S |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0054 | A1 | btnInput "Input" 일괄입력 팝업 (cs:260~286, R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnInput "Input" 일괄입력 팝업 (cs:260~286, R5): 행 집계 — 대조표 btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) 'BtnArea 커스텀 버튼(SubTit |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0055 | A1 | cboDivision `Data_SCP.Common(Type.Divisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision `Data_SCP.Common(Type.Division)` + Get: 행 집계 — 대조표 cboDivision `Data_SCP.Common(Type.Division)` + GetDivis |  | 1 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0056 | A1 | cboOperationGroup `LookupCommon("OPERATI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboOperationGroup `LookupCommon("OPERATION_GROUP"): 행 집계 — 대조표 cboOperationGroup `LookupCommon("OPERATION_GROUP")` (cs |  | 1 (cboOperationGroup `LookupCommon("OPERATI) |
| WK-SCP0028-0057 | A1 | cboValid `DataBind(Type.YesOrNo,true)` ( | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboValid `DataBind(Type.YesOrNo,true)` (cs:135): 행 집계 — 대조표 cboValid `DataBind(Type.YesOrNo,true)` (cs:135) 'Valid sel |  | 1 (cboValid `DataBind(Type.YesOrNo,true)` () |
| WK-SCP0028-0058 | A1 | clbFromSite `FromSiteByDivision` (cs:166 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbFromSite `FromSiteByDivision` (cs:166): 행 집계 — 대조표 clbFromSite `FromSiteByDivision` (cs:166) 'From Site multi(+ALL) |  | 1 (clbFromSite `FromSiteByDivision` (cs:166) |
| WK-SCP0028-0059 | A1 | clbToSite `ToSiteByDivision` (cs:169) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbToSite `ToSiteByDivision` (cs:169): 행 집계 — 대조표 clbToSite `ToSiteByDivision` (cs:169) 'To Site multi(+ALL)' 의 A1 6요소 |  | 1 (clbToSite `ToSiteByDivision` (cs:169)) |
| WK-SCP0028-0060 | A1 | clbTransMode `LookupCommon("TRANSPORT_MO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbTransMode `LookupCommon("TRANSPORT_MODE_CODE")`: 행 집계 — 대조표 clbTransMode `LookupCommon("TRANSPORT_MODE_CODE")` (cs: |  | 1 (clbTransMode `LookupCommon("TRANSPORT_MO) |
| WK-SCP0028-0061 | A1 | 팝업 Form_Load `//FindData();` (cs:146) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없 |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0062 | A1 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** =  |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0063 | A6 | PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP: 검증 엔진이 실행됐으나 이 대상(SP PKG_SCP0028.P_SCM0002_GET_SHIP)을 판정하지 못함 — 결과  |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |

## W9 도구 오류 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0064 | F4 | **팝업 OK `SaveData` (cs:308~369)** | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 **팝업 OK `SaveData` (cs:308~369)** '`handleConfirm` — 그리드 0행→`MSG01091` / 체크 0건→`MSG00' 의 F4 7요소: PASS:6 · ER |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0065 | F4 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 하네스·환경 | F4 도구 오류 — 실측[T-fad117f6]: PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: SCM0002/ModelPopup/SEARCH, SCP0033/popup/SEARCH, SSP0 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0066 | F4 | Query(ds) FindData (cs:368) | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 Query(ds) FindData (cs:368) '`useTabProcQuery` o_rc1 바인딩' 의 F4 7요소: PASS:6 · ERROR:1 |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0067 | F4 | SaveButton SaveData (cs:574~) | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 SaveButton SaveData (cs:574~) '`hotkeyConfig.save` → handleSave' 의 F4 7요소: PASS:6 · ERROR:1 |  | 1 (SaveButton SaveData (cs:574~)) |
| WK-SCP0028-0068 | F4 | 팝업 Form_Load `//FindData();` (cs:146) | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 F4 7요소: PASS:6 · ER |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0069 | I1 | SCP0028 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-cf28ca72 RULE_SCREEN / 원장 V-2aef119a RULE_SCREEN / 원장 V-ca2072cf RULE_SCREEN / 원장 V-ccb4dcdd DEFECT / 원장 V-14603c8 |  | 9 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0070 | X-ROW | SCP0028_Shipment_Lot_Size.checkValidSize | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NA:5 · ERROR:1 |  | 13 (ACT:SCP0028_Shipment_Lot_Size.checkValid) |
